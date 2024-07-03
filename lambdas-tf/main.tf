provider "aws" {
  region = "us-east-1"
}

#S3 Bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "qrcode-tf"
}

resource "aws_lambda_layer_version" "lambda_layer" {
  filename   = "python.zip"
  layer_name = "qrcode_layer"

  compatible_runtimes = ["python3.11"]
}

# Lambda Function
resource "aws_lambda_function" "my_lambda" {
  function_name = "qr-code-TF"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"
  memory_size   = 128
  timeout       = 10
  filename      = "qr_code.zip"

  # Use an existing IAM role
  role = "arn:aws:iam::575864492282:role/qrcode-s3"
}

resource "aws_api_gateway_rest_api" "api" {
  name        = "QRCodeAPI"
  description = "API for QR Generation"
}

resource "aws_api_gateway_resource" "qr_code_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "qr-code"
}

resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.qr_code_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.qr_code_resource.id
  http_method             = aws_api_gateway_method.post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.my_lambda.invoke_arn
}

resource "aws_lambda_permission" "apigateway_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:us-east-1:575864492282:${aws_api_gateway_rest_api.api.id}/*/*"
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.qr_code_resource.id
  http_method = aws_api_gateway_method.post_method.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.qr_code_resource.id
  http_method = aws_api_gateway_method.post_method.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code

  response_templates = {
    "application/json" = "#set($origin = $input.params().header.get('Origin'))\n#if($origin)\n # set($context.responseOverride.header.Access-Control-Allow-Origin = $origin)\n#end\n{}"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
  depends_on = [aws_api_gateway_integration.lambda_integration]
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [aws_api_gateway_integration.lambda_integration]

  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "prod"
}

output "api_url" {
  value = aws_api_gateway_deployment.deployment.invoke_url
}