resource "aws_vpc" "test_vpc" {
  cidr_block = var.vpc_cidr

    tags = merge(
        var.common_tags,
        var.vpc_tags,
        {
            Name = local.resource_name
        }
    )

}

resource "aws_subnet" "pub_sub" {
  count=length(var.public_sub_cidr)  
  vpc_id = aws_vpc.test_vpc.id
  cidr_block = var.public_sub_cidr[count.index]
  #availability_zone = zonename
  availability_zone = local.az_list[count.index]
  map_public_ip_on_launch = true

tags = merge(
        var.common_tags,
        {
            Name = "${local.resource_name}-pub-${local.az_list[count.index]}"
        }
    )

}

resource "aws_subnet" "pvt_sub" {
    count = length(var.pvt_cidr_block)
    vpc_id = aws_vpc.test_vpc.id
    cidr_block = var.pvt_cidr_block[count.index]
    availability_zone = local.azl_zones[count.index]
  
  tags = merge(
        var.common_tags,
        {
            Name = "${local.resource_name}-pvt-${local.az_list[count.index]}"
        }
    )
}

resource "aws_subnet" "dbase" {

    count = length(var.db_cidr_block)
    vpc_id = aws_vpc.test_vpc.id
    cidr_block = var.db_cidr_block[count.index]
    availability_zone = local.azl_zones[count.index]

    tags = merge(
        var.common_tags,
        {
            Name = "${local.resource_name}-dbase-${local.az_list[count.index]}"
        }
    )
}

resource "aws_db_subnet_group" "dbsubgrp" {
    name = local.resource_name
    subnet_ids = aws_subnet.dbase[*].id
    tags = merge(
        var.common_tags,
        var.db_subnet_group_tags,
        {
            Name = local.resource_name
        }
    )


}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.test_vpc.id

  tags = merge(

        var.common_tags,
        {
            Name = local.resource_name
        }
    )

}

resource "aws_eip" "nat" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.pub_sub[0].id

  tags = merge(
    var.nat_gateway_tags,
    var.common_tags,    
    {
        Name = local.resource_name
    }
  )
}

resource "aws_route_table" "public_tbl" {
  vpc_id = aws_vpc.test_vpc.id

  tags = merge(
    var.common_tags, 
    var.public_route_table_tags,   
    {
       Name= "${local.resource_name}-pub"
    }
  )
}

resource "aws_route_table" "pvt_tbl" {
  vpc_id = aws_vpc.test_vpc.id

  tags = merge(
    var.private_route_table_tags,
    var.common_tags,    
    {
       Name= "${local.resource_name}-pvt"
    }
  )
}

resource "aws_route_table" "db_tbl" {
  vpc_id = aws_vpc.test_vpc.id
  tags = merge(
    var.database_route_table_tags,
    var.common_tags,    
    {
       Name= "${local.resource_name}-db"
    }
  )
}

#begin updating routes to route table-----------------

resource "aws_route" "public" {
  route_table_id = aws_route_table.public_tbl.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id

}

resource "aws_route" "private" {
  route_table_id = aws_route_table.pvt_tbl.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
}

resource "aws_route" "database" {
  route_table_id = aws_route_table.db_tbl.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
}

#end updating routes to route table-------xxxxxx-------

#begin subnet association-----------------
#subnet association with route tables------------------

/*
resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.pub_sub.id
  route_table_id = aws_route_table.public_tbl.id
}  since we have 2 subnet in 2 AZ*/

resource "aws_route_table_association" "public" {
  count = length(var.public_sub_cidr)
  subnet_id = aws_subnet.pub_sub[count.index].id
  route_table_id = aws_route_table.public_tbl.id
} 

resource "aws_route_table_association" "private" {
  count = (length(var.pvt_cidr_block))
  subnet_id = aws_subnet.pvt_sub[count.index].id
  route_table_id = aws_route_table.pvt_tbl.id
}

resource "aws_route_table_association" "database" {
  count = (length(var.db_cidr_block))
  subnet_id = aws_subnet.dbase[count.index].id
  route_table_id = aws_route_table.db_tbl.id
}

#end subnet association with route tables-------xxxxxx-------