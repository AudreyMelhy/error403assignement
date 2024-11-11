resource "aws_wafv2_web_acl" "ignore_specific_endpoint" {
  name  = "ignore_specific_endpoint_acl"
  scope = "REGIONAL" # or "CLOUDFRONT" if for CloudFront

  default_action {
    block {}
  }

  # Rule to allow specific endpoint with both URI and trusted header check
  rule {
    name     = "AllowHtmlEditorEndpoint"
    priority = 1

    action {
      allow {}
    }

    statement {
      and_statement {
        # First condition: Match the specific URI path
        statement {
          byte_match_statement {
            search_string = "/submitContent" # URI path to allow
            field_to_match {
              uri_path {}
            }
            positional_constraint = "EXACTLY"

            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }

        # Second condition: Match the trusted header for CKEdit source
        statement {
          byte_match_statement {
            search_string = "CKEdit" # Value of the trusted header
            field_to_match {
              single_header {
                name = "x-trusted-source"
              }
            }
            positional_constraint = "EXACTLY"

            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AllowHtmlEditorEndpoint"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "IgnoreSpecificEndpointACL"
    sampled_requests_enabled   = true
  }
}

