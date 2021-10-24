data "archive_file" "client_api_artefact" {
  output_path = "files/client-api-artefact.zip"
  type        = "zip"
  source_file = "${local.lambdas_path}/client-api/index.js"
}

resource "aws_lambda_function" "client_api" {
  function_name = "client_api"
  handler       = "index.handler"
  description   = "integration to adalo API with client backend"
  role          = aws_iam_role.client_api_lambda.arn
  runtime       = "nodejs14.x"

  filename         = data.archive_file.client_api_artefact.output_path
  source_code_hash = data.archive_file.client_api_artefact.output_base64sha256

  timeout     = 5
  memory_size = 128

  layers = [aws_lambda_layer_version.got.arn]
}
