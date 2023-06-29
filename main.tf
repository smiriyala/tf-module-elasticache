
#Creating Elastic Cache Cluster
resource "aws_elasticache_cluster" "elasticache" {
  cluster_id           = "${var.env}-elasticache"
  engine               = var.engine
  engine_version       = var.engine_version
  node_type            = var.node_type
  num_cache_nodes      = var.nun_cache_nodes
  port                 = 6379
  subnet_group_name = aws_elasticache_subnet_group.main.name
  security_group_ids = [aws_security_group.main.id]

  tags = merge(
    var.tags,
    { Name = "${var.env}-elasticache" }
  )
}


##Elasticache SubnetGroup for Elastic Cache
resource "aws_elasticache_subnet_group" "main" {
  name       =  "${var.env}-rds"
  subnet_ids = var.subnet_ids

  tags = merge(
    var.tags,
    { Name = "${var.env}-subnet-group" }
  )
  lifecycle {
    create_before_destroy = true
  }
}



##Add aws_ssm parameter elasticache endpoint
resource "aws_ssm_parameter" "elasticache_endpoint" {
  name  = "${var.env}.elasticache.endpoint"
  type  = "String"
  value = aws_elasticache_cluster.elasticache.cache_nodes[0].address
}

#Creating SG for accept connnections
resource "aws_security_group" "main" {
  name        = "elasticache-${var.env}"
  description = "elasticache-${var.env}"
  vpc_id      = var.vpc_id

  ingress {
    description = "ELASTICACHE"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [var.allow_subnets]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    var.tags,
    { Name = "elasticache-${var.env}" }
  )
}