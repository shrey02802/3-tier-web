variable "region" {
  type = string
}


variable "ecr_repo_url" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "project" {
  type = string
}


variable "DB_NAME" {
  type = string
}


variable "DB_HOST" {
  type = string
}

variable "DB_USER" {
  type = string
}

variable "DB_PASS" {
  type = string
}
#variable "alb_private_subnet" {
  #description = "Private subnet where the internal ALB is deployed"
  #type        = string
#}

variable "alb_dns_name" {
  description = "Internal ALB DNS name to integrate with API Gateway"
  type        = string
}