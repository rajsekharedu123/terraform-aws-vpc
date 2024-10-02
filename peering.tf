resource "aws_vpc_peering_connection" "peering" {
  count = var.is_peering_req ? 1 : 0  
  vpc_id = aws_vpc.test_vpc.id #requestor vpcid
  peer_vpc_id = "vpc-08feee291f80ed433" #acceptor
  auto_accept = true

  tags = merge(
    var.common_tags,
    var.vpc_peer_tags,
    {
        Name = "${local.resource_name}-default"
    }

  )

}

# begin adding routes to both vpc-route tables

# expense -public - route table to default vpc route tbl
resource "aws_route" "public-peer" {
  count = var.is_peering_req ? 1 : 0  #condition placed , so that below resouce is 
  #only when peering is true  
  route_table_id = aws_route_table.public_tbl.id  # route tbl of reqestor
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[count.index].id 
  destination_cidr_block = "10.0.0.0/16"
  
  }
# expense -private - route table to default vpc route tbl
  resource "aws_route" "private-peer" {
  count = var.is_peering_req ? 1 : 0  #condition placed , so that below resouce is 
  #only when peering is true  
  route_table_id = aws_route_table.pvt_tbl.id  # route tbl of reqestor
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[count.index].id 
  destination_cidr_block = "10.0.0.0/16"
  
  }

  # expense -database - route table to default vpc route tbl
  resource "aws_route" "database-peer" {
  count = var.is_peering_req ? 1 : 0  #condition placed , so that below resouce is 
  #only when peering is true  
  route_table_id = aws_route_table.db_tbl.id  # route tbl of reqestor
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[count.index].id 
  destination_cidr_block = "10.0.0.0/16"
  
  }

   # route table to default vpc route tbl to expense table
  resource "aws_route" "default-rtbl-peer" {
  count = var.is_peering_req ? 1 : 0  #condition placed , so that below resouce is 
  #only when peering is true  
  route_table_id = "rtb-0376e22741b60a349"  # route tbl of def vpc
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[count.index].id 
  destination_cidr_block = var.vpc_cidr
  
  }