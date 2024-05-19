variable "aws_root_account_id" {
  description = "The AWS root account ID"
}

variable "oidc_provider_arn" {
  description = "value of the OIDC provider ARN"
  default     = ""
}

variable "oidc_connect_url" {
  description = "value of the OIDC provider URL"
  default     = ""
}

variable "serviceaccount_with_namespace" {
  description = "serviceaccount name for IRSA. For example kube-system:netshoot"
  default     = ""
}
