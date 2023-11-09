
variable "LUMIGO_TRACER_TOKEN" {
    type    = string
    default = "test"
}

resource "aws_dynamodb_table" "test" {
  hash_key     = "id"
  billing_mode = "PAY_PER_REQUEST"
  name         = "test"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_sqs_queue" "test" {
  name = "test"
}

resource "aws_iam_role" "lambda-role" {
  name = "r1"
  assume_role_policy = jsonencode({
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = ["lambda.amazonaws.com"]
        }
        Action = ["sts:AssumeRole"]
      }
    ]
  })
}

resource "aws_lambda_function" "func1" {
  function_name = "func1"
  role    = aws_iam_role.lambda-role.arn
  handler = "handler.handler"
  runtime = "nodejs18.x"
  layers = ["arn:aws:lambda:us-east-1:114300393969:layer:lumigo-node-tracer:252"]
  # Python layer: arn:aws:lambda:us-east-1:114300393969:layer:lumigo-python-tracer:252
  filename = "/tmp/testlambda.zip"
  timeout = 30
  environment {
    variables = {
      "AWS_LAMBDA_EXEC_WRAPPER": "/opt/lumigo_wrapper",
      "LUMIGO_DEBUG": "true",
      "LUMIGO_PROPAGATE_W3": "true",
      "LUMIGO_TRACER_TOKEN": var.LUMIGO_TRACER_TOKEN
    }
  }
}

resource "aws_iam_role_policy" "lambda-perms" {
  name   = "lambda-perms"
  role   = aws_iam_role.lambda-role.name
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ],
        "Effect": "Allow",
        "Resource": "arn:aws:logs:*:*:*",
      },
      {
        "Action": [
          "dynamodb:Scan",
        ],
        "Effect": "Allow",
        "Resource": aws_dynamodb_table.test.arn,
      },
      {
        "Action": [
          "sqs:SendMessage",
        ],
        "Effect": "Allow",
        "Resource": aws_sqs_queue.test.arn,
      }
    ]
  })
}
