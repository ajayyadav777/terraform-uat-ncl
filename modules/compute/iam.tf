############################################################
# ECS EC2 IAM Role
############################################################

resource "aws_iam_role" "ecs" {

  name = "itinerary-${local.name_prefix}-ecs-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = local.common_tags
}


############################################################
# ECS Instance Role Policy
############################################################

resource "aws_iam_role_policy_attachment" "ecs_ec2" {

  role = aws_iam_role.ecs.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}


############################################################
# SSM Access
############################################################

resource "aws_iam_role_policy_attachment" "ssm" {

  role = aws_iam_role.ecs.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


############################################################
# Instance Profile
############################################################

resource "aws_iam_instance_profile" "ecs" {

  name = "itinerary-${local.name_prefix}-ecs-instance-profile"

  role = aws_iam_role.ecs.name

  tags = local.common_tags
}

