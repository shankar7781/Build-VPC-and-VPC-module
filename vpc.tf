/* resource "aws_vpc" "vpc_terraform" {
  cidr_block       = "${var.cidr}"
  instance_tenancy = "default"

  tags = {
    Name = "vpc_terraform"
  }
}

*/

terraform {
  backend "s3" {
    bucket = "shankar7781"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}




module "my_vpc_module"{
source="./modules/vpc/"
cidr_block="${var.cidr}"
subnet1_cidr="${var.subnet1_cidr}"
subnet2_cidr="${var.subnet2_cidr}"
availability_zone_for_subnet1="${var.availability_zone_for_subnet1}"
availability_zone_for_subnet2="${var.availability_zone_for_subnet2}"
}
