resource "aws_iam_role" "kentik_role" {
  name        = "TerraformKentikIngestRole"
  description = "This role allows Kentik to ingest the VPC flow logs."
  tags        = {
    Provisioner = "Terraform"
  }
  assume_role_policy = <<EOF
{
  "Statement" : [
    {
      "Action" : "sts:AssumeRole",
      "Effect" : "Allow",
      "Principal" : {
        "AWS" : "arn:aws:iam::834693425129:role/eks-ingest-node"
      },
      "Sid" : ""
    }
  ],
  "Version" : "2008-10-17"
}
EOF

}

resource "aws_iam_policy" "kentik_ec2_access" {
  name = "KentikEC2Access"
  description = "Defines required accesses for Kentik platform to EC2 resources"
  path = "/"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:Describe*",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "elasticloadbalancing:Describe*",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:ListMetrics",
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:Describe*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "autoscaling:Describe*",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "kentik_s3_ro_access" {
  name = "KentisS3ROAccess"
  description = "Defines read-only accesses for Kentik platform to S3 resources"
  path = "/"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:Get*",
        "s3:List*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "kentik_s3_rw_access" {
  name = "KentisS3RWAccess"
  description = "Defines read-write accesses for Kentik platform to S3 resources"
  path = "/"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "kentik_s3_access" {
  name       = "kentik-s3-access"
  roles      = [ aws_iam_role.kentik_role.name ]
  policy_arn = (var.rw_s3_access == true ? aws_iam_policy.kentik_s3_rw_access.arn : aws_iam_policy.kentik_s3_ro_access.arn )
}

resource "aws_iam_policy_attachment" "kentik_ec2_access" {
  name       = "kentik-ec2-access"
  roles      = [ aws_iam_role.kentik_role.name ]
  policy_arn = aws_iam_policy.kentik_ec2_access.arn
}

data "aws_s3_bucket" "manual" {
  bucket = "boscard-k8s-kentik-logs"
}
