variable "vpc_cidr" {
  default = "10.31.0.0/16"
}

variable "common_tags" {
    default = { }
  }

variable "vpc_tags" {
  default = { }
}

variable "project_name" {
  default = { 

  }
  
}

variable "environment" {
   default = { 
    
  }
 
}

variable "public_sub_cidr" {
      type = list
      
}

variable "pvt_cidr_block" {
  type = list
    
}

variable "db_cidr_block" {
  type = list
    
}

variable "db_subnet_group_tags" {
    default = {}
}

variable "nat_gateway_tags" {
    default = {}
}

variable "public_route_table_tags" {
    default = {}
}

variable "private_route_table_tags" {
    default = {}
}

variable "database_route_table_tags" {
    default = {}
}

variable "is_peering_req" {
  type = bool
  default = false
}

variable "vpc_peer_tags" {
    default = {}
}

