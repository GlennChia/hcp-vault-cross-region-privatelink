resource "aws_vpc" "ec2_client" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "ec2-client-vpc"
  }
}

resource "aws_subnet" "ec2_client_public1" {
  vpc_id                  = aws_vpc.ec2_client.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = local.matching_azs[0]

  tags = {
    Name = "ec2-client-public1"
  }
}

resource "aws_subnet" "ec2_client_endpoint1" {
  vpc_id            = aws_vpc.ec2_client.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = local.matching_azs[0]

  tags = {
    Name = "ec2-client-endpoint1"
  }
}

resource "aws_subnet" "ec2_client_endpoint2" {
  vpc_id            = aws_vpc.ec2_client.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = local.matching_azs[1]

  tags = {
    Name = "ec2-client-endpoint2"
  }
}

resource "aws_internet_gateway" "ec2_client" {
  tags = {
    Name = "ec2-client-igw"
  }
}

resource "aws_internet_gateway_attachment" "ec2_client" {
  internet_gateway_id = aws_internet_gateway.ec2_client.id
  vpc_id              = aws_vpc.ec2_client.id
}

resource "aws_route_table" "ec2_client_public" {
  vpc_id = aws_vpc.ec2_client.id

  tags = {
    Name = "ec2-client-public-rtb"
  }
}

resource "aws_route" "ec2_client_public_rtb_route_to_internet" {
  route_table_id         = aws_route_table.ec2_client_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ec2_client.id
}

resource "aws_route_table_association" "ec2_client_public1" {
  subnet_id      = aws_subnet.ec2_client_public1.id
  route_table_id = aws_route_table.ec2_client_public.id
}

resource "aws_route_table" "ec2_client_endpoint" {
  vpc_id = aws_vpc.ec2_client.id

  tags = {
    Name = "ec2-client-endpoint-rtb"
  }
}

resource "aws_route_table_association" "ec2_client_endpoint1" {
  subnet_id      = aws_subnet.ec2_client_endpoint1.id
  route_table_id = aws_route_table.ec2_client_endpoint.id
}

resource "aws_route_table_association" "ec2_client_endpoint2" {
  subnet_id      = aws_subnet.ec2_client_endpoint2.id
  route_table_id = aws_route_table.ec2_client_endpoint.id
}
