provider "aws" {
  access_key = "${var.aws_access_key}"

  secret_key = "${var.aws_secret_key}"
 
  region = "${var.aws_region}"
}

# secure the elastic search using the security group
#https://www.terraform.io/docs/providers/aws/r/security_group.html
resource "aws_security_group" "elasticsearch_cluster_sg" {
  name        = "elasticsearch_cluster_sg"
  description = "Elasticsearch security group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9300
    to_port     = 9300
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "elasticsearch_iam_role" {
  name = "elasticsearch_iam_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "elasticsearch_iam_policy_document" {
  statement {
    sid = "1"

    actions = [
      "ec2:DescribeInstances"
    ]

    resources = [
      "*"
    ]
  }
}

#resource "aws_iam_policy" "elasticsearch_iam_policy" {
#  name   = "elasticsearch_iam_policy"
#  policy = "${data.aws_iam_policy_document.elasticsearch_iam_policy_document.json}"
#}

resource "aws_iam_instance_profile" "elasticsearch_profile" {
  name  = "elasticsearch_profile"
  role = "${aws_iam_role.elasticsearch_iam_role.name}"
}
