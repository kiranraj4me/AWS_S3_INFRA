provider "aws" {
  region = "${var.region}"
  shared_credentials_file = "/var/credentials"
}

resource "aws_s3_bucket" "website" {
  bucket = "${var.env}.${var.root-domain}"
  acl    = "private"
  force_destroy = true
  
  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

    versioning {
    enabled = true
  }
}