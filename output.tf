output  "vpc_id" {
  value       = aws_vpc.test_vpc.id #test_vpc
}

output "public_subnet_ids"{
  value = aws_subnet.public[*].id
}

output "private_subnet_ids"{
  value = aws_subnet.private[*].id
}

output "database_subnet_ids"{
  value = aws_subnet.database[*].id
}

output "database_subnet_group_name"{
  value = aws_db_subnet_group.default.name
}