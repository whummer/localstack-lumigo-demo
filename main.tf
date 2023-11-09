variable "LUMIGO_TRACER_TOKEN" {
    type        = string
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

resource "aws_lambda_function" "func1" {
  function_name = "func1"
  role    = "arn:aws:iam::000000000000:role/r1"
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
