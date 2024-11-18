resource "aws_sfn_state_machine" "this" {
  name = "${var.name_prefix}-${var.environment}"
  role_arn = aws_iam_role.this.arn
  type = "EXPRESS"

  definition = templatefile("${var.folder}/${var.definition_file}", var.definition_variables)

  logging_configuration {
    log_destination        = "${aws_cloudwatch_log_group.this.arn}:*"
    include_execution_data = true
    level                  = "ALL"
  }

  tracing_configuration {
    enabled = true
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name = "/aws/vendedlogs/states/${var.name_prefix}-${var.environment}-StateMachine-Logs"
}