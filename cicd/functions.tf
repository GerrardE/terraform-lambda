# -----------------------------------------------------------------------------
# Resource: Lambda Role and Policy Document
# -----------------------------------------------------------------------------
data "template_file" "assume-role-template" {
  template = file("${path.module}/policies/assume-role.tpl")

  vars = {
    service = "lambda.amazonaws.com"
    action  = "sts:AssumeRole"
  }
}

resource "aws_iam_role" "lambda_exec" {
  name = "${local.resource_name}-lambda-role"

  assume_role_policy = data.template_file.assume-role-template.rendered
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# -----------------------------------------------------------------------------
# Resource: Lambda Functions
# -----------------------------------------------------------------------------

module "fn_1" {
  source        = "./modules/lambda-function"
  function_name = "createEvent"

  s3_bucket_id = aws_s3_bucket.artifact_store.id
  s3_key       = aws_s3_bucket_object.artifact.key

  handler = "index.createEvent"

  iam_role = aws_iam_role.lambda_exec.arn

  dependency = aws_s3_bucket_object.artifact
}

module "fn_1_logs" {
  source = "./modules/cloudwatch-log-group"

  log_name = "/aws/lambda/${module.fn_1.function_name}"
}

module "fn_2" {
  source        = "./modules/lambda-function"
  function_name = "getEvent"

  s3_bucket_id = aws_s3_bucket.artifact_store.id
  s3_key       = aws_s3_bucket_object.artifact.key

  handler = "index.getEvent"

  iam_role = aws_iam_role.lambda_exec.arn

  dependency = aws_s3_bucket_object.artifact
}

module "fn_2_logs" {
  source = "./modules/cloudwatch-log-group"

  log_name = "/aws/lambda/${module.fn_2.function_name}"
}

# -----------------------------------------------------------------------------
# Resource: Api Gateway
# -----------------------------------------------------------------------------

resource "aws_apigatewayv2_api" "lambda_gw" {
  name          = "${local.resource_name}-gw"
  protocol_type = "HTTP"
}

module "api_gw_lg" {
  source = "./modules/cloudwatch-log-group"

  log_name = "/aws/api_gw/${aws_apigatewayv2_api.lambda_gw.name}"
}

resource "aws_apigatewayv2_stage" "lambda_gw_stg" {
  api_id = aws_apigatewayv2_api.lambda_gw.id

  name        = local.resource_name
  auto_deploy = true

  access_log_settings {
    destination_arn = module.api_gw_lg.arn

    format = file("${path.module}/policies/access-log.json")
  }
}

# -----------------------------------------------------------------------------
# Resource: Api Gateway Integrations
# -----------------------------------------------------------------------------
module "fn_1_integrtn" {
  source = "./modules/apigatewayv2-integration"

  api_id = aws_apigatewayv2_api.lambda_gw.id

  integration_uri = module.fn_1.invoke_arn
}

module "fn_2_integrtn" {
  source = "./modules/apigatewayv2-integration"

  api_id = aws_apigatewayv2_api.lambda_gw.id

  integration_uri = module.fn_2.invoke_arn
}

# -----------------------------------------------------------------------------
# Resource: Api Gateway Integration Routes
# -----------------------------------------------------------------------------

resource "aws_apigatewayv2_route" "fn_1_rte" {
  api_id = aws_apigatewayv2_api.lambda_gw.id

  route_key = "POST /createEvent"
  target    = "integrations/${module.fn_1_integrtn.id}"
}

resource "aws_apigatewayv2_route" "fn_2_rte" {
  api_id = aws_apigatewayv2_api.lambda_gw.id

  route_key = "GET /getEvent"
  target    = "integrations/${module.fn_2_integrtn.id}"
}

# -----------------------------------------------------------------------------
# Resource: Api Exec Permissions
# -----------------------------------------------------------------------------

module "api_gw_perm_1" {
  source  = "Cloud-42/lambda-permission/aws"
  version = "2.0.0"

  function_name = module.fn_1.function_name
  statement_id  = var.apigw_statement_id
  source_arn    = "${aws_apigatewayv2_api.lambda_gw.execution_arn}/*/*"
}

module "api_gw_perm_2" {
  source  = "Cloud-42/lambda-permission/aws"
  version = "2.0.0"

  function_name = module.fn_2.function_name
  statement_id  = var.apigw_statement_id
  source_arn    = "${aws_apigatewayv2_api.lambda_gw.execution_arn}/*/*"
}
