locals {
    resource_name ="${var.project_name}-${var.environment}"

}

locals {
  azl_zones=data.aws_availability_zones.az_zones.names
  az_list=slice(local.azl_zones,0,2)
}