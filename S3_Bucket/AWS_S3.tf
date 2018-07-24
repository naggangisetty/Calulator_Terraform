resource "aws_s3_bucket" "my_digital" {
  bucket = "${var.bucketName}"
  provider = "aws"
  acl    = "public-read"  
  
  tags {
    Name        = "${var.tags}"
  }
}

data "archive_file" "archive_lambda" {
type = "zip"
source_file = "../target/${var.key}"
output_path = "../target/${var.outputpath}"
}

resource "aws_s3_bucket_object" "Upload_jar_File" {
  key                    = "${var.key}"
  bucket                 = "${aws_s3_bucket.my_digital.bucket}"
  source                 = "${data.archive_file.archive_lambda.source_file}"
}

output "aws_S3_Url"{
  value = "${aws_s3_bucket.my_digital.arn}"
}

resource "aws_s3_bucket_policy" "Mybucket_policy" {
  bucket = "${aws_s3_bucket.my_digital.bucket}"
  policy =<<POLICY
{
  "Version": "2012-10-17",
  "Id": "MYBUCKETPOLICY",
  "Statement": [
    {
      "Sid": "IPAllow",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::${var.bucketName}",
      "Condition": {
         "IpAddress": {"aws:SourceIp": "8.8.8.8/32"}
      } 
    } 
  ]
}
POLICY
}