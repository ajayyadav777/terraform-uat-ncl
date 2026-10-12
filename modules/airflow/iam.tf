############################################################
# Airflow ECS Task Execution Role
############################################################

resource "aws_iam_role" "execution" {

  name = "itinerary-${local.name_prefix}-airflow-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "execution" {

  role = aws_iam_role.execution.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


############################################################
# Airflow Task Role
############################################################

resource "aws_iam_role" "task" {

  name = "itinerary-${local.name_prefix}-airflow-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = local.common_tags
}


############################################################
# Airflow S3 Access
############################################################

resource "aws_iam_role_policy" "s3" {

  name = "itinerary-${local.name_prefix}-airflow-s3-access"

  role = aws_iam_role.task.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:ListBucket"
        ]

        Resource = [
          var.s3_bucket_arn
        ]
      },
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject"
        ]
        Resource = [
          "${var.s3_bucket_arn}/*"
        ]
      }
    ]
  })
}
