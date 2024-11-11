resource "aws_wafv2_web_acl" "example" {
  name        = "byte-match-web-acl"
  scope       = "REGIONAL" # Change to "CLOUDFRONT" if using with CloudFront
  description = "Web ACL with allowance for specific table style"

  default_action {
    block {}
  }

  # Rule to include managed rules but set override action to ignore specific matches
  rule {
    name     = "AWSManagedRules"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesCommonRuleSet"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRules"
      sampled_requests_enabled   = true
    }
  }

  # Custom rule to allow <table style="width:525pt;">
  rule {
    name     = "AllowSpecificTableStyle"
    priority = 2

    action {
      allow {}
    }

    statement {
      byte_match_statement {
        search_string = "<table style=\"width:525pt;\"" # Match specific style content
        field_to_match {
          body {}
        }

        positional_constraint = "CONTAINS"

        text_transformation {
          priority = 0
          type     = "NONE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AllowSpecificTableStyle"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "MyWebACL"
    sampled_requests_enabled   = true
  }
}

