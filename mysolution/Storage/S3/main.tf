module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  create_bucket = local.workspace["create_bucket"]

  bucket = local.workspace["bucket"]
  acl    = local.workspace["acl"]

  versioning = local.workspace["versioning"]

  # Allow deletion of non-empty bucket
  force_destroy = local.workspace["force_destroy"]

  # Required for ALB/NLB logs
  attach_lb_log_delivery_policy = local.workspace["attach_lb_log_delivery_policy"]

  tags = merge(
    var.COMMAND_TAGS,
    "${local.workspace["tags"]}"
  )

}