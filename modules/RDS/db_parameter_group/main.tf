resource "aws_db_parameter_group" "name" {
  name   = "rds-${var.engine}-${split(".", var.engineversion)[0]}"
  family = "${var.engine}${split(".", var.engineversion)[0]}"
  
  parameter {
    name  = "log_connections"
    value = "1"
  }
  parameter {
    name  = "log_disconnections"
    value = "1"
  }
  parameter {
    name  = "rds.force_autovacuum_logging_level"
    value = "info"
  }
  parameter {
    name  = "log_autovacuum_min_duration"
    value = "1000"
  }
  parameter {
    apply_method = "pending-reboot" 
    name  = "rds.logical_replication"
    value = "1"
  }
  parameter {
    apply_method = "pending-reboot" 
    name  = "max_replication_slots"
    value = "20"
  }
  parameter {
    apply_method = "pending-reboot" 
    name  = "max_wal_senders"
    value = "25"
  }
  parameter {
    apply_method = "pending-reboot" 
    name  = "max_logical_replication_workers"
    value = "25"
  }
  parameter {
    apply_method = "pending-reboot" 
    name  = "max_worker_processes"
    value = "25"
  }
  parameter {
    apply_method = "pending-reboot" 
    name  = "max_connections"
    value = "1000"
  }
  parameter {
    apply_method = "pending-reboot" 
    name  = "shared_preload_libraries"
    value = "pglogical,pg_stat_statements,pg_prewarm,pg_hint_plan,auto_explain"
  }
  parameter {
    name  = "maintenance_work_mem"
    value = "1024000"
  }
}