# Crete vpc

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
}

# ________________________________________________________________________________________





# Create subnets

resource "aws_subnet" "public" {
  count             = 3
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr_blocks[count.index]
  map_public_ip_on_launch = true
  
}



resource "aws_subnet" "private" {
  count             = 3
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  
}


# _________________________________________________________________________


# Subnets group

resource "aws_db_subnet_group" "subnetgroup" {
  name       = "subnetgroup"
  subnet_ids = concat(aws_subnet.public[*].id, aws_subnet.private[*].id)

  tags = {
    Name = "My DB subnet group"
  }
}









#___________________________________________________________________________________________________



# Cretae internet Gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}



# _____________________________________________________________________________________________________



# Create NAT Gateways


resource "aws_nat_gateway" "ngw" {
  count           = 3
  allocation_id   = aws_eip.nat[count.index].id
  subnet_id       = aws_subnet.private[count.index].id
}

resource "aws_eip" "nat" {
  count = 3
}


# _________________________________________________________________________________________________________________



# Create Route tables

resource "aws_route_table" "publicroute" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}


resource "aws_route_table_association" "publicroute" {
  count          = 3
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.publicroute.id
}


resource "aws_route_table" "private" {
  count = 3
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "privateroute" {
  count               = 3
  route_table_id      = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
   nat_gateway_id      = aws_nat_gateway.ngw[count.index].id
}

