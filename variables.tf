variable "aws_region" {
	default = "us-east-1"
}

variable "vpc_cidr" {
	type = string
}

variable "pub_subnet_cidr" {
	type = list
	default = []
}

variable "prv_subnet_cidr" {
	type = list
	default = []
}

variable "azs" {
	type = list
	default = []
}

variable "ami" {
	type = string
}

variable "instance_type" {
	type = string
}