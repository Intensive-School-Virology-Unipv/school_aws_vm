provider "aws" {
    region = "eu-central-1"
}

resource "aws_instance" "viro-vm" {
    count = var.instance_count
    ami = "ami-09f0086e65f02e893"
    instance_type = var.instance_type
    security_groups = [ "training-test-01" ]

    tags = {
      "use" = "School of Virology"
      "step" = "testing"
    }

    root_block_device {
      volume_size = 50
    }
}

variable "instance_count" {
  default = 4
}

variable "instance_type" {
  default = "t2.large"
}

