{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {"CanonicalUser":"${canonical_user_id}"},
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::${s3_bucket_name}"
    },
    {
      "Effect": "Allow",
      "Principal": {"CanonicalUser":"${canonical_user_id}"},
      "Action": ["s3:GetObject", "s3:PutObject"],
      "Resource": "arn:aws:s3:::${s3_bucket_name}/*"
    }
  ]
}