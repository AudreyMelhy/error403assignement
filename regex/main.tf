# Create the regex pattern set to allow specific table width styles
resource "aws_wafv2_regex_pattern_set" "allow_table_style" {
  name  = "AllowTableStyle"
  scope = "REGIONAL"

  regular_expression {
    regex_string = "<table[^>]*style=\"width:[0-9]+pt;\""
  }
}

# Create the Web ACL with the rule that references the regex pattern set
resource "aws_wafv2_web_acl" "regex_xss_protection" {
  name  = "regex_xss_protection"
  scope = "REGIONAL"

  default_action {
    block {}
  }

  # Rule that uses the regex pattern set created above
  rule {
    name     = "AllowTableWidthStyle"
    priority = 1

    action {
      allow {}
    }

    statement {
      regex_pattern_set_reference_statement {
        arn = aws_wafv2_regex_pattern_set.allow_table_style.arn

        field_to_match {
          body {}
        }

        text_transformation {
          priority = 0
          type     = "NONE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AllowTableWidthStyle"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "CustomXSSProtection"
    sampled_requests_enabled   = true
  }
}

