resource "aws_instance" "this" {
  ami                         = var.elasticsearch_ami_id
  instance_type               = var.elasticsearch_instance_type
  subnet_id                   = var.private_subnet_id
  associate_public_ip_address = false
  key_name                    = var.key_name

  vpc_security_group_ids = [
    aws_security_group.elasticsearch.id
  ]

  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  user_data = <<-EOF
    #!/bin/bash
    set -eux

    export DEBIAN_FRONTEND=noninteractive

    apt-get update
    apt-get install -y curl gnupg apt-transport-https

    # Elasticsearch repository
    install -d -m 0755 /etc/apt/keyrings

    curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch \
      | gpg --dearmor --yes -o /etc/apt/keyrings/elasticsearch.gpg

    echo "deb [signed-by=/etc/apt/keyrings/elasticsearch.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" \
      > /etc/apt/sources.list.d/elastic-8.x.list

    apt-get update

    # Install Elasticsearch
    apt-get install -y elasticsearch

    # Create a systemd service that prepares the data disk
    cat > /usr/local/bin/setup-elasticsearch-disk.sh <<'SCRIPT'
    #!/bin/bash
    set -e

    DATA_DEVICE=""

    for i in {1..60}; do
      DATA_DEVICE=$(lsblk -dpno NAME,TYPE | awk '$2=="disk" {print $1}' | while read disk; do
        if ! findmnt -S "$disk" >/dev/null 2>&1; then
          echo "$disk"
          break
        fi
      done)

      if [ -n "$DATA_DEVICE" ]; then
        break
      fi

      echo "Waiting for Elasticsearch EBS volume..."
      sleep 5
    done

    if [ -z "$DATA_DEVICE" ]; then
      echo "Elasticsearch data volume was not found"
      exit 1
    fi

    echo "Using data device: $DATA_DEVICE"

    # Format only if there is no filesystem
    if ! blkid "$DATA_DEVICE" >/dev/null 2>&1; then
      mkfs.ext4 -F "$DATA_DEVICE"
    fi

    mkdir -p /var/lib/elasticsearch

    UUID=$(blkid -s UUID -o value "$DATA_DEVICE")

    if ! grep -q "$UUID" /etc/fstab; then
      echo "UUID=$UUID /var/lib/elasticsearch ext4 defaults,nofail 0 2" >> /etc/fstab
    fi

    mountpoint -q /var/lib/elasticsearch || mount /var/lib/elasticsearch

    chown -R elasticsearch:elasticsearch /var/lib/elasticsearch
    SCRIPT

    chmod +x /usr/local/bin/setup-elasticsearch-disk.sh

    cat > /etc/systemd/system/elasticsearch-disk.service <<'SERVICE'
    [Unit]
    Description=Prepare Elasticsearch EBS data volume
    After=local-fs.target
    Before=elasticsearch.service

    [Service]
    Type=oneshot
    ExecStart=/usr/local/bin/setup-elasticsearch-disk.sh
    RemainAfterExit=yes

    [Install]
    WantedBy=multi-user.target
    SERVICE

    systemctl daemon-reload

    systemctl enable elasticsearch-disk.service
    systemctl start elasticsearch-disk.service

    # Elasticsearch configuration
    cat > /etc/elasticsearch/elasticsearch.yml <<'CONFIG'
    cluster.name: ncl-uat-elasticsearch
    node.name: ncl-uat-elasticsearch-01

    network.host: 0.0.0.0

    discovery.type: single-node

    path.data: /var/lib/elasticsearch
    CONFIG

    chown root:elasticsearch /etc/elasticsearch/elasticsearch.yml
    chmod 660 /etc/elasticsearch/elasticsearch.yml

    systemctl daemon-reload
    systemctl enable elasticsearch
    systemctl restart elasticsearch
  EOF

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-elasticsearch"
    }
  )
}
