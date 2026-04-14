resource "aws_redshift_subnet_group" "diwt-subnet-group" {
  name       = "diwt-subnet-group"
  subnet_ids = [aws_subnet.diwt-subnet-a.id, aws_subnet.diwt-subnet-b.id]
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_ssm_parameter" "foo" {
  name  = "master_password"
  type  = "String"
  value = random_password.password.result
}

resource "aws_redshift_cluster" "diwt-redshift-cluster" {
  cluster_identifier = "tf-redshift-cluster"
  database_name      = "testdb"
  master_username    = "test-user"
  master_password    = aws_ssm_parameter.foo.value
  node_type          = "dc1.large"
  cluster_type       = "single-node"
  vpc_security_group_ids = [aws_security_group.diwt-SG.id]
  cluster_subnet_group_name = aws_redshift_subnet_group.diwt-subnet-group.name
  preferred_maintenance_window = "sun:11:00-sun:11:30"
  publicly_accessible = true
  skip_final_snapshot = true
}