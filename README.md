# Terraform Aws rds

# AWS Infrastructure Provisioning with Terraform

## Table of Contents

- [Introduction](#introduction)
- [Usage](#usage)
- [Example](#Example)
- [Author](#Author)
- [License](#license)
- [Inputs](#inputs)
- [Outputs](#outputs)

## Introduction

This module is basically combination of Terraform open source and includes automatation tests and examples. It also helps to create and improve your infrastructure with minimalistic code instead of maintaining the whole infrastructure code yourself.

## Usage

To use this module, you can include it in your Terraform configuration. Here's an example of how to use it:

## Examples

## Example: MariaDB

```hcl
module "mariadb" {
  source            = "git::https://github.com/opszero/terraform-aws-rds.git?ref=v1.0.2"
  name              = "mariadb"
  engine            = "MariaDB"
  engine_version    = "10.6.10"
  instance_class    = "db.m5.large"
  engine_name       = "MariaDB"
  allocated_storage = 50

  db_name     = "test"
  db_username = "user"
  port        = "3306"

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"
  multi_az           = false


  vpc_id        = module.vpc.vpc_id
  allowed_ip    = [module.vpc.vpc_cidr_block]
  allowed_ports = [3306]

  family = "mariadb10.6"

  backup_retention_period = 0

  enabled_cloudwatch_logs_exports = ["audit", "general"]

  subnet_ids          = module.private_subnets.public_subnet_id
  publicly_accessible = true

  engine_version = "10.6"

  deletion_protection = true

  ssm_parameter_endpoint_enabled = true
}
```

## Example: mysql-complete

```hcl
module "mysql" {
  source            = "git::https://github.com/opszero/terraform-aws-rds.git?ref=v1.0.2"
  name              = "mysql"
  engine            = "mysql"
  engine_version    = "8.0.28"
  instance_class    = "db.m6i.xlarge"
  allocated_storage = 5


  vpc_id        = module.vpc.vpc_id
  allowed_ip    = [module.vpc.vpc_cidr_block]
  allowed_ports = [3306]

  db_name     = "test"
  db_username = "user"
  port        = "3306"

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"
  multi_az           = false

  backup_retention_period = 7

  enabled_cloudwatch_logs_exports = ["audit", "general"]

  subnet_ids          = module.subnets.public_subnet_id
  publicly_accessible = true

  family = "mysql8.0"

  engine_version = "8.0"

  deletion_protection = true

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8"
    },
    {
      name  = "character_set_server"
      value = "utf8"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
  ssm_parameter_endpoint_enabled = true
}
```

## Example: oracle_db

```hcl
module "oracle" {
  source            = "git::https://github.com/opszero/terraform-aws-rds.git?ref=v1.0.2"
  name              = "oracle"

  engine            = "oracle-ee"
  engine_version    = "19"
  instance_class    = "db.t3.medium"
  engine_name       = "oracle-ee"
  allocated_storage = 50
  storage_encrypted = true
  family            = "oracle-ee-19"

  db_name     = "test"
  db_username = "admin"
  port        = "1521"

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"
  multi_az           = false


  vpc_id        = module.vpc.vpc_id
  allowed_ip    = [module.vpc.vpc_cidr_block]
  allowed_ports = [1521]

  backup_retention_period = 0

  enabled_cloudwatch_logs_exports = ["audit"]

  subnet_ids          = module.private_subnets.public_subnet_id
  publicly_accessible = true

  engine_version = "19"

  deletion_protection                 = true
  iam_database_authentication_enabled = false

  ssm_parameter_endpoint_enabled = true

}
```

## Example: postgreSQL

```hcl
module "postgresql" {
  source            = "git::https://github.com/opszero/terraform-aws-rds.git?ref=v1.0.2"
  name              = "postgresql"

  engine            = "postgres"
  engine_version    = "14.6"
  instance_class    = "db.t3.medium"
  allocated_storage = 50
  engine_name       = "postgres"
  storage_encrypted = true
  family            = "postgres14"

  db_name     = "test"
  db_username = "dbname"
  port        = "5432"

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"
  multi_az           = false


  vpc_id        = module.vpc.vpc_id
  allowed_ip    = [module.vpc.vpc_cidr_block]
  allowed_ports = [5432]

  backup_retention_period = 0

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  subnet_ids          = module.private_subnets.public_subnet_id
  publicly_accessible = true

  engine_version = "14"

  deletion_protection = true


  ssm_parameter_endpoint_enabled = true

}
```

## Example: replica-mysql

```hcl
module "mysql" {
  source                 = "git::https://github.com/opszero/terraform-aws-rds.git?ref=v1.0.2"
  name                   = "rds"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t4g.large"
  replica_instance_class = "db.t4g.large"
  allocated_storage      = 32
  identifier             = ""
  snapshot_identifier    = ""
  kms_key_id             = ""
  enabled_read_replica   = true

  db_name     = "replica"
  db_username = "replica_mysql"
  password    = "cdsjhcjjkxnna5s"

  port               = 3306
  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"
  multi_az           = true

  vpc_id        = module.vpc.vpc_id
  allowed_ip    = [module.vpc.vpc_cidr_block]
  allowed_ports = [3306]

  backup_retention_period = 1

  enabled_cloudwatch_logs_exports = ["general"]

  subnet_ids          = module.subnets.public_subnet_id
  publicly_accessible = false

  family = "mysql8.0"

  engine_version       = "8.0"
  auto_minor_version_upgrade = false

  deletion_protection = true

  ssm_parameter_endpoint_enabled = true
}
```

## Example

For detailed examples on how to use this module, please refer to the [Example](https://github.com/opszero/terraform-aws-rds/tree/master/example) directory within this repository.

## Author

Your Name Replace **MIT** and **opsZero** with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.

## License

This project is licensed under the **MIT** License - see the [LICENSE](https://github.com/opszero/terraform-aws-rds/blob/master/LICENSE) file for details.

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                                     | Version   |
| ------------------------------------------------------------------------ | --------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.13.3 |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | >= 6.14.0 |
| <a name="requirement_random"></a> [random](#requirement_random)          | 3.7.2     |

## Providers

| Name                                             | Version   |
| ------------------------------------------------ | --------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | >= 6.14.0 |

## Modules

No modules.

## Resources

| Name                                                                                                                                                         | Type        |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group)                            | resource    |
| [aws_db_instance.read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance)                                              | resource    |
| [aws_db_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance)                                              | resource    |
| [aws_db_option_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_option_group)                                      | resource    |
| [aws_db_parameter_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group)                                | resource    |
| [aws_db_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group)                                      | resource    |
| [aws_iam_role.enhanced_monitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                     | resource    |
| [aws_iam_role_policy_attachment.enhanced_monitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource    |
| [aws_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                                     | resource    |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule)                            | resource    |
| [aws_security_group_rule.egress_ipv6](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule)                       | resource    |
| [aws_security_group_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule)                           | resource    |
| [aws_ssm_parameter.secret-endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter)                               | resource    |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)                                | data source |
| [aws_iam_policy_document.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)                        | data source |
| [aws_iam_policy_document.enhanced_monitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)            | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition)                                            | data source |

## Inputs

| Name                                                                                                                                                | Description                                                                                                                                                                                                                                                                                | Type                | Default                                                              | Required |
| --------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------- | -------------------------------------------------------------------- | :------: |
| <a name="input_allocated_storage"></a> [allocated_storage](#input_allocated_storage)                                                                | The allocated storage in gigabytes                                                                                                                                                                                                                                                         | `string`            | `null`                                                               |    no    |
| <a name="input_allow_major_version_upgrade"></a> [allow_major_version_upgrade](#input_allow_major_version_upgrade)                                  | Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible                                                                                                                       | `bool`              | `false`                                                              |    no    |
| <a name="input_allowed_ip"></a> [allowed_ip](#input_allowed_ip)                                                                                     | List of allowed ip.                                                                                                                                                                                                                                                                        | `list(any)`         | <pre>[<br> "0.0.0.0/0"<br>]</pre>                                    |    no    |
| <a name="input_allowed_ports"></a> [allowed_ports](#input_allowed_ports)                                                                            | List of allowed ingress ports                                                                                                                                                                                                                                                              | `list(any)`         | <pre>[<br> -1<br>]</pre>                                             |    no    |
| <a name="input_apply_immediately"></a> [apply_immediately](#input_apply_immediately)                                                                | Specifies whether any database modifications are applied immediately, or during the next maintenance window                                                                                                                                                                                | `bool`              | `false`                                                              |    no    |
| <a name="input_auto_minor_version_upgrade"></a> [auto_minor_version_upgrade](#input_auto_minor_version_upgrade)                                     | Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window                                                                                                                                                                        | `bool`              | `true`                                                               |    no    |
| <a name="input_availability_zone"></a> [availability_zone](#input_availability_zone)                                                                | The Availability Zone of the RDS instance                                                                                                                                                                                                                                                  | `string`            | `null`                                                               |    no    |
| <a name="input_backup_retention_period"></a> [backup_retention_period](#input_backup_retention_period)                                              | The days to retain backups for                                                                                                                                                                                                                                                             | `number`            | `null`                                                               |    no    |
| <a name="input_backup_window"></a> [backup_window](#input_backup_window)                                                                            | The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window                                                                                                                             | `string`            | `null`                                                               |    no    |
| <a name="input_blue_green_update"></a> [blue_green_update](#input_blue_green_update)                                                                | Enables low-downtime updates using RDS Blue/Green deployments.                                                                                                                                                                                                                             | `map(string)`       | `{}`                                                                 |    no    |
| <a name="input_ca_cert_identifier"></a> [ca_cert_identifier](#input_ca_cert_identifier)                                                             | Specifies the identifier of the CA certificate for the DB instance                                                                                                                                                                                                                         | `string`            | `null`                                                               |    no    |
| <a name="input_character_set_name"></a> [character_set_name](#input_character_set_name)                                                             | The character set name to use for DB encoding in Oracle instances. This can't be changed. See Oracle Character Sets Supported in Amazon RDS and Collations and Character Sets for Microsoft SQL Server for more information. This can only be set on creation.                             | `string`            | `null`                                                               |    no    |
| <a name="input_cloudwatch_log_group_retention_in_days"></a> [cloudwatch_log_group_retention_in_days](#input_cloudwatch_log_group_retention_in_days) | The number of days to retain CloudWatch logs for the DB instance                                                                                                                                                                                                                           | `number`            | `7`                                                                  |    no    |
| <a name="input_copy_tags_to_snapshot"></a> [copy_tags_to_snapshot](#input_copy_tags_to_snapshot)                                                    | On delete, copy all Instance tags to the final snapshot                                                                                                                                                                                                                                    | `bool`              | `true`                                                               |    no    |
| <a name="input_custom_iam_instance_profile"></a> [custom_iam_instance_profile](#input_custom_iam_instance_profile)                                  | RDS custom iam instance profile                                                                                                                                                                                                                                                            | `string`            | `null`                                                               |    no    |
| <a name="input_db_name"></a> [db_name](#input_db_name)                                                                                              | The DB name to create. If omitted, no database is created initially                                                                                                                                                                                                                        | `string`            | `null`                                                               |    no    |
| <a name="input_db_username"></a> [db_username](#input_db_username)                                                                                  | Username for the master DB user                                                                                                                                                                                                                                                            | `string`            | `"opszero"`                                                          |    no    |
| <a name="input_delete_automated_backups"></a> [delete_automated_backups](#input_delete_automated_backups)                                           | Specifies whether to remove automated backups immediately after the DB instance is deleted                                                                                                                                                                                                 | `bool`              | `true`                                                               |    no    |
| <a name="input_deletion_protection"></a> [deletion_protection](#input_deletion_protection)                                                          | The database can't be deleted when this value is set to true.                                                                                                                                                                                                                              | `bool`              | `true`                                                               |    no    |
| <a name="input_domain"></a> [domain](#input_domain)                                                                                                 | The ID of the Directory Service Active Directory domain to create the instance in                                                                                                                                                                                                          | `string`            | `null`                                                               |    no    |
| <a name="input_domain_iam_role_name"></a> [domain_iam_role_name](#input_domain_iam_role_name)                                                       | (Required if domain is provided) The name of the IAM role to be used when making API calls to the Directory Service                                                                                                                                                                        | `string`            | `null`                                                               |    no    |
| <a name="input_egress_rule"></a> [egress_rule](#input_egress_rule)                                                                                  | Enable to create egress rule                                                                                                                                                                                                                                                               | `bool`              | `true`                                                               |    no    |
| <a name="input_enable_security_group"></a> [enable_security_group](#input_enable_security_group)                                                    | Enable default Security Group with only Egress traffic allowed.                                                                                                                                                                                                                            | `bool`              | `true`                                                               |    no    |
| <a name="input_enabled_cloudwatch_log_group"></a> [enabled_cloudwatch_log_group](#input_enabled_cloudwatch_log_group)                               | Determines whether a CloudWatch log group is created for each `enabled_cloudwatch_logs_exports`                                                                                                                                                                                            | `bool`              | `false`                                                              |    no    |
| <a name="input_enabled_cloudwatch_logs_exports"></a> [enabled_cloudwatch_logs_exports](#input_enabled_cloudwatch_logs_exports)                      | List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine): alert, audit, error, general, listener, slowquery, trace, postgresql (PostgreSQL), upgrade (PostgreSQL).                                           | `list(string)`      | `[]`                                                                 |    no    |
| <a name="input_enabled_monitoring_role"></a> [enabled_monitoring_role](#input_enabled_monitoring_role)                                              | Create IAM role with a defined name that permits RDS to send enhanced monitoring metrics to CloudWatch Logs.                                                                                                                                                                               | `bool`              | `false`                                                              |    no    |
| <a name="input_enabled_read_replica"></a> [enabled_read_replica](#input_enabled_read_replica)                                                       | A list of enabled read replica                                                                                                                                                                                                                                                             | `bool`              | `false`                                                              |    no    |
| <a name="input_engine"></a> [engine](#input_engine)                                                                                                 | The database engine to use                                                                                                                                                                                                                                                                 | `string`            | `"mysql"`                                                            |    no    |
| <a name="input_engine_name"></a> [engine_name](#input_engine_name)                                                                                  | Specifies the name of the engine that this option group should be associated with                                                                                                                                                                                                          | `string`            | `"mysql"`                                                            |    no    |
| <a name="input_engine_version"></a> [engine_version](#input_engine_version)                                                                         | The engine version to use                                                                                                                                                                                                                                                                  | `string`            | `null`                                                               |    no    |
| <a name="input_family"></a> [family](#input_family)                                                                                                 | The family of the DB parameter group                                                                                                                                                                                                                                                       | `string`            | `null`                                                               |    no    |
| <a name="input_iam_database_authentication_enabled"></a> [iam_database_authentication_enabled](#input_iam_database_authentication_enabled)          | Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled                                                                                                                                                                         | `bool`              | `true`                                                               |    no    |
| <a name="input_identifier"></a> [identifier](#input_identifier)                                                                                     | The name of the RDS instance                                                                                                                                                                                                                                                               | `string`            | `""`                                                                 |    no    |
| <a name="input_instance_class"></a> [instance_class](#input_instance_class)                                                                         | The instance type of the RDS instance                                                                                                                                                                                                                                                      | `string`            | `null`                                                               |    no    |
| <a name="input_iops"></a> [iops](#input_iops)                                                                                                       | The amount of provisioned IOPS. Setting this implies a storage_type of 'io1' or `gp3`. See `notes` for limitations regarding this variable for `gp3`                                                                                                                                       | `number`            | `null`                                                               |    no    |
| <a name="input_is_external"></a> [is_external](#input_is_external)                                                                                  | enable to udated existing security Group                                                                                                                                                                                                                                                   | `bool`              | `false`                                                              |    no    |
| <a name="input_kms_key_id"></a> [kms_key_id](#input_kms_key_id)                                                                                     | KMS key ARN/ID used for encrypting RDS instance                                                                                                                                                                                                                                            | `string`            | `null`                                                               |    no    |
| <a name="input_license_model"></a> [license_model](#input_license_model)                                                                            | License model information for this DB instance. Optional, but required for some DB engines, i.e. Oracle SE1                                                                                                                                                                                | `string`            | `null`                                                               |    no    |
| <a name="input_maintenance_window"></a> [maintenance_window](#input_maintenance_window)                                                             | The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'                                                                                                                                                                                         | `string`            | `null`                                                               |    no    |
| <a name="input_engine_version"></a> [major_engine_version](#input_major_engine_version)                                                             | Specifies the major version of the engine that this option group should be associated with                                                                                                                                                                                                 | `string`            | `null`                                                               |    no    |
| <a name="input_manage_master_user_password"></a> [manage_master_user_password](#input_manage_master_user_password)                                  | Whether to allow RDS to manage the master user password in Secrets Manager                                                                                                                                                                                                                 | `bool`              | `true`                                                               |    no    |
| <a name="input_max_allocated_storage"></a> [max_allocated_storage](#input_max_allocated_storage)                                                    | Specifies the value for Storage Autoscaling                                                                                                                                                                                                                                                | `number`            | `0`                                                                  |    no    |
| <a name="input_monitoring_interval"></a> [monitoring_interval](#input_monitoring_interval)                                                          | The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60.                                                        | `number`            | `0`                                                                  |    no    |
| <a name="input_monitoring_role_description"></a> [monitoring_role_description](#input_monitoring_role_description)                                  | Description of the monitoring IAM role                                                                                                                                                                                                                                                     | `string`            | `null`                                                               |    no    |
| <a name="input_monitoring_role_permissions_boundary"></a> [monitoring_role_permissions_boundary](#input_monitoring_role_permissions_boundary)       | ARN of the policy that is used to set the permissions boundary for the monitoring IAM role                                                                                                                                                                                                 | `string`            | `null`                                                               |    no    |
| <a name="input_multi_az"></a> [multi_az](#input_multi_az)                                                                                           | Specifies if the RDS instance is multi-AZ                                                                                                                                                                                                                                                  | `bool`              | `false`                                                              |    no    |
| <a name="input_name"></a> [name](#input_name)                                                                                                       | Name (e.g. `app` or `cluster`).                                                                                                                                                                                                                                                            | `string`            | `""`                                                                 |    no    |
| <a name="input_network_type"></a> [network_type](#input_network_type)                                                                               | The type of network stack                                                                                                                                                                                                                                                                  | `string`            | `null`                                                               |    no    |
| <a name="input_option_group_description"></a> [option_group_description](#input_option_group_description)                                           | The description of the option group                                                                                                                                                                                                                                                        | `string`            | `null`                                                               |    no    |
| <a name="input_options"></a> [options](#input_options)                                                                                              | A list of Options to apply                                                                                                                                                                                                                                                                 | `any`               | `[]`                                                                 |    no    |
| <a name="input_parameters"></a> [parameters](#input_parameters)                                                                                     | A list of DB parameter maps to apply                                                                                                                                                                                                                                                       | `list(map(string))` | `[]`                                                                 |    no    |
| <a name="input_password"></a> [password](#input_password)                                                                                           | Master user password for MySQL database                                                                                                                                                                                                                                                    | `string`            | `null`                                                               |    no    |
| <a name="input_performance_insights_enabled"></a> [performance_insights_enabled](#input_performance_insights_enabled)                               | Specifies whether Performance Insights are enabled                                                                                                                                                                                                                                         | `bool`              | `false`                                                              |    no    |
| <a name="input_performance_insights_retention_period"></a> [performance_insights_retention_period](#input_performance_insights_retention_period)    | The amount of time in days to retain Performance Insights data. Either 7 (7 days) or 731 (2 years).                                                                                                                                                                                        | `number`            | `7`                                                                  |    no    |
| <a name="input_port"></a> [port](#input_port)                                                                                                       | The port on which the DB accepts connections                                                                                                                                                                                                                                               | `string`            | `null`                                                               |    no    |
| <a name="input_publicly_accessible"></a> [publicly_accessible](#input_publicly_accessible)                                                          | Bool to control if instance is publicly accessible                                                                                                                                                                                                                                         | `bool`              | `false`                                                              |    no    |
| <a name="input_replica_instance_class"></a> [replica_instance_class](#input_replica_instance_class)                                                 | The instance type of the RDS instance                                                                                                                                                                                                                                                      | `string`            | `""`                                                                 |    no    |
| <a name="input_replica_mode"></a> [replica_mode](#input_replica_mode)                                                                               | Specifies whether the replica is in either mounted or open-read-only mode. This attribute is only supported by Oracle instances. Oracle replicas operate in open-read-only mode unless otherwise specified                                                                                 | `string`            | `null`                                                               |    no    |
| <a name="input_replicate_source_db"></a> [replicate_source_db](#input_replicate_source_db)                                                          | Specifies that this resource is a Replicate database, and to use this value as the source database. This correlates to the identifier of another Amazon RDS Database to replicate.                                                                                                         | `string`            | `null`                                                               |    no    |
| <a name="input_restore_to_point_in_time"></a> [restore_to_point_in_time](#input_restore_to_point_in_time)                                           | Restore to a point in time (MySQL is NOT supported)                                                                                                                                                                                                                                        | `map(string)`       | `null`                                                               |    no    |
| <a name="input_s3_import"></a> [s3_import](#input_s3_import)                                                                                        | Restore from a Percona Xtrabackup in S3 (only MySQL is supported)                                                                                                                                                                                                                          | `map(string)`       | `null`                                                               |    no    |
| <a name="input_sg_description"></a> [sg_description](#input_sg_description)                                                                         | The security group description.                                                                                                                                                                                                                                                            | `string`            | `"Instance default security group (only egress access is allowed)."` |    no    |
| <a name="input_sg_egress_description"></a> [sg_egress_description](#input_sg_egress_description)                                                    | Description of the egress and ingress rule                                                                                                                                                                                                                                                 | `string`            | `"Description of the rule."`                                         |    no    |
| <a name="input_sg_egress_ipv6_description"></a> [sg_egress_ipv6_description](#input_sg_egress_ipv6_description)                                     | Description of the egress_ipv6 rule                                                                                                                                                                                                                                                        | `string`            | `"Description of the rule."`                                         |    no    |
| <a name="input_sg_ids"></a> [sg_ids](#input_sg_ids)                                                                                                 | of the security group id.                                                                                                                                                                                                                                                                  | `list(any)`         | `[]`                                                                 |    no    |
| <a name="input_sg_ingress_description"></a> [sg_ingress_description](#input_sg_ingress_description)                                                 | Description of the ingress rule                                                                                                                                                                                                                                                            | `string`            | `"Description of the ingress rule use elasticache."`                 |    no    |
| <a name="input_skip_final_snapshot"></a> [skip_final_snapshot](#input_skip_final_snapshot)                                                          | Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted                                                                     | `bool`              | `true`                                                               |    no    |
| <a name="input_snapshot_identifier"></a> [snapshot_identifier](#input_snapshot_identifier)                                                          | Specifies whether or not to create this database from a snapshot. This correlates to the snapshot ID you'd find in the RDS console, e.g: rds:production-2015-06-26-06-05.                                                                                                                  | `string`            | `""`                                                                 |    no    |
| <a name="input_ssm_parameter_description"></a> [ssm_parameter_description](#input_ssm_parameter_description)                                        | SSM Parameters can be imported using.                                                                                                                                                                                                                                                      | `string`            | `"Description of the parameter."`                                    |    no    |
| <a name="input_ssm_parameter_endpoint_enabled"></a> [ssm_parameter_endpoint_enabled](#input_ssm_parameter_endpoint_enabled)                         | Name of the parameter.                                                                                                                                                                                                                                                                     | `bool`              | `false`                                                              |    no    |
| <a name="input_ssm_parameter_type"></a> [ssm_parameter_type](#input_ssm_parameter_type)                                                             | Type of the parameter.                                                                                                                                                                                                                                                                     | `string`            | `"SecureString"`                                                     |    no    |
| <a name="input_storage_encrypted"></a> [storage_encrypted](#input_storage_encrypted)                                                                | Enable encryption for storage                                                                                                                                                                                                                                                              | `bool`              | `true`                                                               |    no    |
| <a name="input_storage_throughput"></a> [storage_throughput](#input_storage_throughput)                                                             | Storage throughput value for the DB instance. This setting applies only to the `gp3` storage type. See `notes` for limitations regarding this variable for `gp3`                                                                                                                           | `number`            | `null`                                                               |    no    |
| <a name="input_storage_type"></a> [storage_type](#input_storage_type)                                                                               | One of 'standard' (magnetic), 'gp2' (general purpose SSD), 'gp3' (new generation of general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'gp2' if not. If you specify 'io1' or 'gp3' , you must also include a value for the 'iops' parameter | `string`            | `"gp3"`                                                              |    no    |
| <a name="input_subnet_ids"></a> [subnet_ids](#input_subnet_ids)                                                                                     | A list of VPC Subnet IDs to launch in.                                                                                                                                                                                                                                                     | `list(string)`      | `[]`                                                                 |    no    |
| <a name="input_tags"></a> [tags](#input_tags)                                                                                                       | Additional tags for the DB instance                                                                                                                                                                                                                                                        | `map(any)`          | `{}`                                                                 |    no    |
| <a name="input_timeouts"></a> [timeouts](#input_timeouts)                                                                                           | Define maximum timeout for deletion of `aws_db_option_group` resource                                                                                                                                                                                                                      | `map(string)`       | `{}`                                                                 |    no    |
| <a name="input_timezone"></a> [timezone](#input_timezone)                                                                                           | Time zone of the DB instance. timezone is currently only supported by Microsoft SQL Server. The timezone can only be set on creation. See MSSQL User Guide for more information.                                                                                                           | `string`            | `null`                                                               |    no    |
| <a name="input_use_identifier_prefix"></a> [use_identifier_prefix](#input_use_identifier_prefix)                                                    | Determines whether to use `identifier` as is or create a unique identifier beginning with `identifier` as the specified prefix                                                                                                                                                             | `bool`              | `false`                                                              |    no    |
| <a name="input_vpc_id"></a> [vpc_id](#input_vpc_id)                                                                                                 | The ID of the VPC that the instance security group belongs to.                                                                                                                                                                                                                             | `string`            | `""`                                                                 |    no    |

## Outputs

| Name                                                                                                                                   | Description                                                                             |
| -------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| <a name="output_db_instance_address"></a> [db_instance_address](#output_db_instance_address)                                           | The address of the RDS instance                                                         |
| <a name="output_db_instance_arn"></a> [db_instance_arn](#output_db_instance_arn)                                                       | The ARN of the RDS instance                                                             |
| <a name="output_db_instance_availability_zone"></a> [db_instance_availability_zone](#output_db_instance_availability_zone)             | The availability zone of the RDS instance                                               |
| <a name="output_db_instance_ca_cert_identifier"></a> [db_instance_ca_cert_identifier](#output_db_instance_ca_cert_identifier)          | Specifies the identifier of the CA certificate for the DB instance                      |
| <a name="output_db_instance_cloudwatch_log_groups"></a> [db_instance_cloudwatch_log_groups](#output_db_instance_cloudwatch_log_groups) | Map of CloudWatch log groups created and their attributes                               |
| <a name="output_db_instance_domain"></a> [db_instance_domain](#output_db_instance_domain)                                              | The ID of the Directory Service Active Directory domain the instance is joined to       |
| <a name="output_db_instance_domain_iam_role_name"></a> [db_instance_domain_iam_role_name](#output_db_instance_domain_iam_role_name)    | The name of the IAM role to be used when making API calls to the Directory Service.     |
| <a name="output_db_instance_endpoint"></a> [db_instance_endpoint](#output_db_instance_endpoint)                                        | The connection endpoint                                                                 |
| <a name="output_db_instance_engine"></a> [db_instance_engine](#output_db_instance_engine)                                              | The database engine                                                                     |
| <a name="output_db_instance_hosted_zone_id"></a> [db_instance_hosted_zone_id](#output_db_instance_hosted_zone_id)                      | The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record) |
| <a name="output_db_instance_id"></a> [db_instance_id](#output_db_instance_id)                                                          | The RDS instance ID                                                                     |
| <a name="output_db_instance_name"></a> [db_instance_name](#output_db_instance_name)                                                    | The database name                                                                       |
| <a name="output_db_instance_password"></a> [db_instance_password](#output_db_instance_password)                                        | The master password                                                                     |
| <a name="output_db_instance_port"></a> [db_instance_port](#output_db_instance_port)                                                    | n/a                                                                                     |
| <a name="output_db_instance_resource_id"></a> [db_instance_resource_id](#output_db_instance_resource_id)                               | The RDS Resource ID of this instance                                                    |
| <a name="output_db_instance_status"></a> [db_instance_status](#output_db_instance_status)                                              | The RDS instance status                                                                 |
| <a name="output_db_instance_username"></a> [db_instance_username](#output_db_instance_username)                                        | The master username for the database                                                    |
| <a name="output_db_parameter_group_arn"></a> [db_parameter_group_arn](#output_db_parameter_group_arn)                                  | The ARN of the db parameter group                                                       |
| <a name="output_db_parameter_group_id"></a> [db_parameter_group_id](#output_db_parameter_group_id)                                     | The db parameter group id                                                               |
| <a name="output_db_subnet_group_id"></a> [db_subnet_group_id](#output_db_subnet_group_id)                                              | The db subnet group name                                                                |
| <a name="output_db_subnet_group_name"></a> [db_subnet_group_name](#output_db_subnet_group_name)                                        | The db subnet group name                                                                |
| <a name="output_enhanced_monitoring_iam_role_arn"></a> [enhanced_monitoring_iam_role_arn](#output_enhanced_monitoring_iam_role_arn)    | The Amazon Resource Name (ARN) specifying the monitoring role                           |
| <a name="output_enhanced_monitoring_iam_role_name"></a> [enhanced_monitoring_iam_role_name](#output_enhanced_monitoring_iam_role_name) | The name of the monitoring role                                                         |

<!-- END_TF_DOCS -->
