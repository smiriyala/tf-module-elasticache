
#Creating Elastic Cache Cluster
resource "aws_elasticache_cluster" "elasticache" {
  cluster_id           = "${var.env}-elasticache"
  engine               = var.engine
  engine_version       = var.engine_version
  node_type            = var.node_type
  num_cache_nodes      = var.nun_cache_nodes
  port                 = 6379
  subnet_group_name = aws_elasticache_subnet_group.main.name

  tags = merge(
    var.tags,
    { Name = "${var.env}-elasticache" }
  )
}


##Elasticache SubnetGroup for Elastic Cache
resource "aws_elasticache_subnet_group" "main" {
  name       =  "${var.env}-elasticache"
  subnet_ids = var.subnet_ids

  tags = merge(
    var.tags,
    { Name = "${var.env}-subnet-group" }
  )
  lifecycle {
    create_before_destroy = true
  }
}