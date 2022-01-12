# -----------------------------------------------------------------------------
# Resource: Api Gateway Integration Routes
# -----------------------------------------------------------------------------

resource "aws_apigatewayv2_route" "fn_rte" {
  api_id = var.api_id

  route_key = var.route_key
  target    = var.lambda_id
}
