resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "${var.env}-${var.root-domain}-cloudfront-access-identity"
}

resource "aws_cloudfront_distribution" "web" {
  origin {
    domain_name = "${aws_s3_bucket.website.bucket_regional_domain_name}"
    origin_id   = "${var.env}-${var.root-domain}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    }
  }

  restrictions {
    geo_restriction {
      locations        = ["IN"]
      restriction_type = "whitelist"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"


  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    compress         = "true"
    target_origin_id = "${var.env}-${var.root-domain}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl     = "0"
    default_ttl = "86400"
    max_ttl     = "31536000"
  }

  price_class = "PriceClass_All"

  tags = {
    Environment = "production"
  }

 viewer_certificate {
    cloudfront_default_certificate = true
  }

  
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    sid = "1"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }
}

resource "aws_s3_bucket_policy" "website" {
  bucket = "${aws_s3_bucket.website.id}"
  policy = "${data.aws_iam_policy_document.s3_policy.json}"
}
