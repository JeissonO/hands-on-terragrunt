variable "COMMAND_TAGS" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
variable "vpc_id" {
  description = "ID of the VPC where to create security group"
  type        = string
  default     = null
}
variable "asg_topaz_sg_id" {
  description = "ID of the SG ASG-Topaz (Dependency)"
  type        = string
  default     = null
}