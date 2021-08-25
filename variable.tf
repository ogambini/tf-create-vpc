variable "vpc-cidr" {
  default       = "10.0.0.0/16"
  description   = "VPC CIDR Block"
  type          = string
}

variable "env_name" {
  default       = "Dev"
  description   = "Environment: Prod/Dev/Stage/QA"
  type          = string
}

variable "public_subnets_cidr" {
  description   = "Public subnets CIDR Block"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "public_availability_zones" {
  description   = "Public availability zones"
  type        = list(string)
  default     = ["sa-east-1a", "sa-east-1b"]

}

variable "private_subnets_cidr" {
  description   = "Private subnets CIDR Block"
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.4.0/24", "10.0.3.0/24", "10.0.5.0/24"]
}

variable "private_availability_zones" {
  description   = "Private availability zones"
  type        = list(string)
  default     = ["sa-east-1a", "sa-east-1a", "sa-east-1b", "sa-east-1b"]
}