data "aws_availability_zones" "available" {}


resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = merge(
    {
      "Name" = "${var.app}-vpc"
    },
    var.tag_map,
  )
}

resource "aws_subnet" "public_subnet" {
  count = "${length(data.aws_availability_zones.available.names)}"
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.subnet_cidrs_public[count.index]}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = true
  tags = merge(
    {
      "Name" = "PublicSubnet-${count.index+1}"
    },
    var.tag_map,
  )
}

resource "aws_subnet" "private_subnet" {
  count = "${length(data.aws_availability_zones.available.names)}"
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.subnet_cidrs_private[count.index]}"
  availability_zone= "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = false
  tags = merge(
    {
      "Name" = "PrivateSubnet-${count.index+1}"
    },
    var.tag_map,
  )
}

resource "aws_subnet" "db_subnet" {
  count = "${length(data.aws_availability_zones.available.names)}"
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.db_cidrs_private[count.index]}"
  availability_zone= "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = false
  tags = merge(
    {
      "Name" = "DBSubnet-${count.index+1}"
    },
    var.tag_map,
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = var.tag_map
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  
resource "aws_route_table_association" "rt_association" {
  subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = aws_route_table.public_route_table.id
}





