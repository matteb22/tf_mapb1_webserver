variable "aws_key_name" {
  description = "provide the key that you provide through aws cli command"
  default     = ""
}

variable "my_private_key_path" {
  description = "provide the path where your ssh private key is"
  default     = "~/.ssh/id_rsa"
}
