output  "vpc_id" {
  value       = aws_vpc.test_vpc.id #test_vpc
}

output "public_subnet_ids"{
  value = aws_subnet.pub_sub[*].id
}

output "private_subnet_ids"{
  value = aws_subnet.pvt_sub[*].id
}

output "database_subnet_ids"{
  value = aws_subnet.dbase[*].id
}

output "database_subnet_group_name"{
  value = aws_db_subnet_group.dbsubgrp.name
}