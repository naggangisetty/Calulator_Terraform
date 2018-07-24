provider "aws" {
  region = "us-east-1"
}

variable lambda_name {
  default = "calculator_lambda"
}

data "archive_file" "lambda" {
type = "zip"
source_file = "${path.module}\\calculatorRestAppJava-0.0.1-SNAPSHOT.jar"
output_path = "${path.module}\\calculatorRestAppJava-0.0.1-SNAPSHOT.zip"
}

resource "aws_lambda_function" "function_lambda" {
  function_name = "${var.lambda_name}"
  //filename = "${data.archive_file.lambda.source_file}"
  //source_code_hash = "${base64sha256(file(data.archive_file.lambda.source_file))}"
  s3_bucket = "my-digital"
  s3_key = "calculatorRestAppJava-0.0.1-SNAPSHOT.jar"
  handler = "com.examples.rs.StreamLambdaHandler::handleRequest"  
  role = "${aws_iam_role.iam_for_lambda.arn}" 
  runtime = "java8" 
  memory_size = "3008" 
  timeout = "60"
  
  environment {
    variables = {
      DAI_ENV = "local"
	  }
   }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


