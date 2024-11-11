# Associate the existing Web ACL with the API Gateway route
resource "aws_wafv2_web_acl_association" "my_web_acl_association" {
  # ARN of the API Gateway route you want to associate with the Web ACL
  resource_arn = "arn:aws:apigateway:us-east-1::/apis/mll5lwf700/stages/test"

  # ARN of the existing Web ACL that you want to associate
  web_acl_arn = "arn:aws:wafv2:us-east-1:010928190963:regional/webacl/byte-match-web-acl/a330dc61-5531-4449-88e7-3fb149c97b3d"
}

