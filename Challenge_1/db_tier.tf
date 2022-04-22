resource "aws_db_instance" "db_instance" {
  count = var.enable ? 1 : 0
  identifier = var.identifier
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type
  storage_encrypted = var.storage_encrypted
  kms_key_id        = var.kms_key_id

  name                             	  = var.db_name
  username                            = var.db_name
  password                            = var.db_name
  port                                = var.db_port

  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  parameter_group_name   = aws_db_parameter_group.db_parameter_group.name
  option_group_name      = var.option_group_name

  multi_az            = var.multi_az
  iops                = var.iops
  publicly_accessible = false

  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  apply_immediately           = var.apply_immediately
  maintenance_window          = var.maintenance_window

  snapshot_identifier       = var.snapshot_identifier
  copy_tags_to_snapshot     = var.copy_tags_to_snapshot
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.final_snapshot_identifier

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_enabled ? var.performance_insights_retention_period : null
  performance_insights_kms_key_id       = var.performance_insights_enabled ? var.performance_insights_kms_key_id : null

  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  max_allocated_storage   = var.max_allocated_storage
  monitoring_interval     = var.monitoring_interval
  monitoring_role_arn     = var.monitoring_role_arn

  timezone                        = var.timezone
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  deletion_protection      = var.deletion_protection
  delete_automated_backups = var.delete_automated_backups
  	tags = merge(
    {
      "Name" = "${db_name}"
    },
    var.tag_map,
  )
}

resource "aws_security_group" "db_sg" {
	name = "${var.app}-db-sg"
	description = "Ingress to DB"
	vpc_id = "${aws_vpc.main.id}"
	
	ingress {
		description      = "Ingress to DB"
		from_port        = var.db_port
		to_port          = var.db_port
		protocol         = "tcp"
		source_security_group_id      = aws_security_group.aws_appserver_sg.id

  }

    egress {
		from_port        = 0
		to_port          = 0
		protocol         = "-1"
		cidr_blocks      = ["0.0.0.0/0"]
		ipv6_cidr_blocks = ["::/0"]
  }
	
	tags = var.tag_map
	
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.app}-${var.db_name}-subnet-group"
  subnet_ids = ["${element(aws_subnet.db_subnet.*.id, count.index)}"]
  tags = var.tag_map

}

resource "aws_db_parameter_group" "db_parameter_group" {
	name 	= "${var.app}-${var.db_name}-parameter_group"
	family = var.engine_family
  dynamic "parameter" {
    for_each = var.db_parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
	  }
	 }
}
