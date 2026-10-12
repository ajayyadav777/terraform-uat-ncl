module "networking" {

  source = "../../modules/networking"

  project_name = var.project_name
  environment  = var.environment
  owner        = var.owner

  vpc_cidr = var.vpc_cidr

  availability_zones = var.availability_zones

  public_subnet_cidrs = var.public_subnet_cidrs

  private_subnet_cidrs = var.private_subnet_cidrs
}

module "compute" {

  source = "../../modules/compute"

  project_name = var.project_name
  environment  = var.environment
  owner        = var.owner

  vpc_id = module.networking.vpc_id

  public_subnet_id = module.networking.public_subnet_ids[0]

  private_subnet_ids = module.networking.private_subnet_ids

  bastion_ami_id = var.bastion_ami_id

  jenkins_ami_id = var.jenkins_ami_id

  bastion_instance_type = var.bastion_instance_type

  jenkins_instance_type = var.jenkins_instance_type

  key_name = var.key_name

  allowed_ssh_cidr = var.allowed_ssh_cidr

  ecs_ami_id = var.ecs_ami_id

  ecs_instance_type = var.ecs_instance_type

  ecs_min_size = var.ecs_min_size

  ecs_desired_size = var.ecs_desired_size

  ecs_max_size = var.ecs_max_size

  ecs_root_volume_size = var.ecs_root_volume_size

}

module "alb" {
  source = "../../modules/alb"

  project_name = var.project_name
  environment  = var.environment
  owner        = var.owner

  vpc_id = module.networking.vpc_id

  public_subnet_ids = module.networking.public_subnet_ids

  alb_security_group_id = module.compute.alb_security_group_id
}

module "data" {
  source = "../../modules/data"

  project_name = var.project_name
  environment  = var.environment
  owner        = var.owner

  vpc_id = module.networking.vpc_id

  private_subnet_ids = module.networking.private_subnet_ids

  ecs_security_group_id = module.compute.ecs_security_group_id

  mysql_username = var.mysql_username
  mysql_password = var.mysql_password
}

module "ecr" {
  source = "../../modules/ecr"

  project_name = var.project_name
  environment  = var.environment
  owner        = var.owner
}

module "s3" {
  source = "../../modules/s3"

  project_name = var.project_name
  environment  = var.environment
  owner        = var.owner
}

module "service_discovery" {
  source = "../../modules/service-discovery"

  project_name = var.project_name
  environment  = var.environment
  owner        = var.owner

  vpc_id = module.networking.vpc_id

  elasticsearch_private_ip = module.elasticsearch.private_ip
}

module "elasticsearch" {
  source = "../../modules/elasticsearch"

  project_name = var.project_name
  environment  = var.environment
  owner        = var.owner

  vpc_id            = module.networking.vpc_id
  private_subnet_id = module.networking.private_subnet_ids[0]

  ecs_security_group_id = module.compute.ecs_security_group_id

  elasticsearch_ami_id           = var.elasticsearch_ami_id
  elasticsearch_instance_type    = "t3.large"
  elasticsearch_data_volume_size = 30

  key_name = var.key_name
}

module "postgres" {
  source = "../../modules/postgres"

  project_name = var.project_name
  environment  = var.environment
  owner        = var.owner

  vpc_id             = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids

  ecs_security_group_id = module.compute.ecs_security_group_id

  postgres_username = var.postgres_username
  postgres_password = var.postgres_password

  postgres_engine_version    = "13"
  postgres_instance_class    = "db.t3.micro"
  postgres_allocated_storage = 30
}

module "redis" {
  source = "../../modules/redis"

  project_name = var.project_name
  environment  = var.environment
  owner        = var.owner

  vpc_id             = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids

  ecs_security_group_id = module.compute.ecs_security_group_id

  node_type = "cache.t3.micro"
}

module "ecs_app" {

  source = "../../modules/ecs-app"

  project_name = var.project_name
  environment  = var.environment
  owner        = var.owner

  aws_region = var.aws_region

  ecs_cluster_id        = module.compute.ecs_cluster_id
  ecs_security_group_id = module.compute.ecs_security_group_id

  private_subnet_ids = module.networking.private_subnet_ids

  frontend_image = "${module.ecr.frontend_repository_url}:uat"
  backend_image  = "${module.ecr.backend_repository_url}:uat"

  frontend_target_group_arn = module.alb.frontend_target_group_arn
  backend_target_group_arn  = module.alb.backend_target_group_arn

  frontend_cpu    = 512
  frontend_memory = 1024

  backend_cpu    = 512
  backend_memory = 1024

  frontend_desired_count = 2
  backend_desired_count  = 2
}

module "airflow" {

  source = "../../modules/airflow"

  project_name = var.project_name
  environment  = var.environment
  owner        = var.owner

  aws_region = var.aws_region

  ecs_cluster_id        = module.compute.ecs_cluster_id
  ecs_security_group_id = module.compute.ecs_security_group_id

  private_subnet_ids = module.networking.private_subnet_ids

  airflow_image = "${module.ecr.airflow_repository_url}:uat"

  airflow_target_group_arn = module.alb.airflow_target_group_arn

  airflow_base_url = "http://${module.alb.alb_dns_name}/airflow"

  airflow_namespace_id = module.service_discovery.namespace_id

  postgres_endpoint = module.postgres.endpoint
  postgres_port     = module.postgres.port
  postgres_database = module.postgres.database_name

  postgres_username = var.postgres_username
  postgres_password = var.postgres_password

  redis_url = module.redis.redis_url

  s3_bucket_arn  = module.s3.bucket_arn
  s3_bucket_name = module.s3.bucket_name

  airflow_admin_username = var.airflow_admin_username
  airflow_admin_password = var.airflow_admin_password
  airflow_fernet_key     = var.airflow_fernet_key
  airflow_secret_key     = var.airflow_secret_key
  airflow_jwt_secret     = var.airflow_jwt_secret

  api_desired_count           = 2
  scheduler_desired_count     = 1
  dag_processor_desired_count = 1
  worker_desired_count        = 1
  triggerer_desired_count     = 1
}
