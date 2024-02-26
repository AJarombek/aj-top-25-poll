/**
 * Infrastructure for hosting the AJ Top 25 Poll website on AWS.
 * Author: Andrew Jarombek
 * Date: 2/24/2024
 */

provider "aws" {
  region = "us-east-1"
}

terraform {
  required_version = "~> 1.6.6"

  required_providers {
    aws = "~> 5.32.1"
  }

  backend "s3" {
    bucket  = "andrew-jarombek-terraform-state"
    encrypt = true
    key     = "aj-top-25-poll/infra/website"
    region  = "us-east-1"
  }
}

locals {
  terraform_tag = "aj-top-25-poll/infra/website"

  # A unique identifier for the S3 origin.  This is needed for CloudFront.
  s3_origin_id = "pollJarombekIO"
}

data "aws_acm_certificate" "jarombek-io" {
  domain = "*.jarombek.io"
}

data "aws_route53_zone" "jarombek-io" {
  name = "jarombek.io."
}

resource "aws_s3_bucket" "poll-jarombek-io" {
  bucket = "poll.jarombek.io"

  tags = {
    Name        = "poll.jarombek.io"
    Application = "poll-jarombek-io"
    Environment = "production"
    Terraform   = local.terraform_tag
  }
}

resource "aws_s3_bucket_website_configuration" "poll-jarombek-io" {
  bucket = "poll.jarombek.io"

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_policy" "poll-jarombek-io" {
  bucket = aws_s3_bucket.poll-jarombek-io.id
  policy = data.aws_iam_policy_document.poll-jarombek-io.json
}

data "aws_iam_policy_document" "poll-jarombek-io" {
  statement {
    sid = "CloudfrontOAI"

    principals {
      identifiers = [aws_cloudfront_origin_access_identity.origin-access-identity.iam_arn]
      type        = "AWS"
    }

    actions = ["s3:GetObject", "s3:ListBucket"]
    resources = [
      aws_s3_bucket.poll-jarombek-io.arn,
      "${aws_s3_bucket.poll-jarombek-io.arn}/*"
    ]
  }
}

resource "aws_cloudfront_distribution" "poll-jarombek-io-distribution" {
  origin {
    domain_name = aws_s3_bucket.poll-jarombek-io.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin-access-identity.cloudfront_access_identity_path
    }
  }

  # Whether the cloudfront distribution is enabled to accept uer requests
  enabled = true

  # Which HTTP version to use for requests
  http_version = "http2"

  # Whether the cloudfront distribution can use ipv6
  is_ipv6_enabled = true

  comment             = "poll.jarombek.io CloudFront Distribution"
  default_root_object = "index.html"

  # Extra CNAMEs for this distribution
  aliases = ["poll.jarombek.io"]

  # The pricing model for CloudFront
  price_class = "PriceClass_100"

  default_cache_behavior {
    # Which HTTP verbs CloudFront processes
    allowed_methods = ["HEAD", "GET", "OPTIONS"]

    # Which HTTP verbs CloudFront caches responses to requests
    cached_methods = ["HEAD", "GET", "OPTIONS"]

    forwarded_values {
      cookies {
        forward = "none"
      }
      headers      = ["Origin", "Access-Control-Request-Headers", "Access-Control-Request-Method"]
      query_string = false
    }

    target_origin_id = local.s3_origin_id

    # Which protocols to use which accessing items from CloudFront
    viewer_protocol_policy = "redirect-to-https"

    # Determines the amount of time an object exists in the CloudFront cache
    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # The SSL certificate for CloudFront
  viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.jarombek-io.arn
    ssl_support_method  = "sni-only"
  }

  tags = {
    Name        = "poll-jarombek-io-cloudfront"
    Application = "poll-jarombek-io"
    Environment = "production"
    Terraform   = local.terraform_tag
  }
}

resource "aws_cloudfront_origin_access_identity" "origin-access-identity" {
  comment = "poll.jarombek.io origin access identity"
}

resource "aws_route53_record" "poll-jarombek-io-a" {
  name    = "poll.jarombek.io."
  type    = "A"
  zone_id = data.aws_route53_zone.jarombek-io.zone_id

  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.poll-jarombek-io-distribution.domain_name
    zone_id                = aws_cloudfront_distribution.poll-jarombek-io-distribution.hosted_zone_id
  }
}
