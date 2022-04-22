
variable "vpc_cidr" {}
variable "subnet_cidrs_public" {type = "list"}
variable "subnet_cidrs_private" {type = "list"}
variable "db_cidrs_private" {type = "list"}

variable "enable_disable_deletion_protection" {}
variable "alb_idle_timeout" {}
variable "app" {}
variable "tag_map" {}
variable "app_port"{}
variable "ssl_policy" {}
variable "ssl_certificate" {}
variable "appsever_ami" {}
variable "keypair_name" {}
variable "user_data" {}
variable "iam_instance_profile" {}
variable "volume_size" {}
variable "volume_type" {}
variable "appserver_port" {}
variable "max_size" {}
variable "min_size" {}
variable "desired_capacity" {}
variable "health_check_grace_period" {}
variable "health_check_type" {}
variable "heartbeat_timeout" {}

variable "frontend_port" {}
variable "webserver_port" {}
variable "websever_ami" {}

variable "region" {}
variable "enable" {}
variable "identifier" {}
variable "engine" {}
variable "engine_version" {}
variable "instance_class" {}
variable "allocated_storage" {}
variable "storage_type" {}
variable "storage_encrypted" {}
variable "kms_key_id" {}
variable "db_name" {}
variable "db_port" {}
variable "option_group_name" {}
variable "multi_az" {}
variable "iops" {}
variable "allow_major_version_upgrade" {}
variable "auto_minor_version_upgrade" {}
variable "apply_immediately" {}
variable "maintenance_window" {}
variable "snapshot_identifier" {}
variable "copy_tags_to_snapshot" {}
variable "skip_final_snapshot" {}
variable "final_snapshot_identifier" {}
variable "performance_insights_enabled" {}
variable "performance_insights_enabled" {} 
variable "performance_insights_retention_period" {}
variable "performance_insights_enabled" {}
variable "performance_insights_kms_key_id" {}
variable "backup_retention_period" {}
variable "backup_window" {}
variable "max_allocated_storage" {}
variable "monitoring_interval" {}
variable "monitoring_role_arn" {}
variable "timezone" {}
variable "enabled_cloudwatch_logs_exports" {}
variable "deletion_protection" {}
variable "delete_automated_backups" {}
variable "db_parameters" {}

