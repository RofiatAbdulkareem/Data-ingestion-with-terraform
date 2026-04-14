resource "aws_vpc" "diwt-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "diwt-subnet-a" {
  vpc_id     = aws_vpc.diwt-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "diwt-subnet-a"
  }
}

resource "aws_subnet" "diwt-subnet-b" {
  vpc_id     = aws_vpc.diwt-vpc.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "diwt-subnet-b"
  }
}

resource "aws_security_group" "diwt-SG" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.diwt-vpc.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.diwt-SG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 5439
  to_port           = 5439
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.diwt-SG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
