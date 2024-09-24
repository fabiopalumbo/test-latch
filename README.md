# test-latch
Architectural / Devops design test

# DevOps Challenge

## Index

* [Instructions](#instructions)
* [Proposed Architecture](#proposed-architecture)
* [Terraform Plan](#terraform-plan-terratest)
* [CICD - Automation](#cicd-automation-bonus)
* [Observability](#observability-bonus)
* [Permissions](#permissions-bonus)
* [Best Practices](#best-practices-bonus)
* [Disaster Recovery Plan](#disaster-recovery-plan-bonus)
* [Compliance](#compliance-bonus)
* [Budget](#budget-bonus)


## Instructions

<summary><b>Test Details</b></summary>
<details>
```

Infrastructure / DevOps System Design
Interview @ Latch
Goal
Given the starting architecture below, address the following infrastructure requirements.
The idea is to have a technical conversation where you can take the lead and show how you
break down requirements and how you think about these items, what lessons you have learned
in your career, etc.

Please prepare the exercise prior to the day of the interview. We expect you to be able to lead
the conversation and guide us through your suggested solution.
The architecture reflects a few of the concepts we discussed in our initial interview. We will work
with a FigJam board with this same diagram so you can easily add infrastructure components
and notes. Please use the tool before our conversation so you can express your ideas with it
easily.

Requirements
● The system will be hosted in AWS.
● We need the ability to scale the system to deal with zillions of requests per day.
● The system has to be up at all times (high availability), otherwise we lose money and
so do our clients.
● The Engineering team has to be able to monitor the system to understand its health.
● When things are not okay, we need reliable alerts to reach out to the right members of
the team.
● Infrastructure and software engineers need proper instrumentation in our production
environment in order to be able to troubleshoot issues.
● Disaster recovery: if an AWS region goes down, a database change goes wrong, etc.
we have to have ways to recover from these potential critical issues.
```


</details>


## Proposed Architecture

La siguiente es ***una propuesta***. Por lo tanto, la infraestructura puede tener los recursos necesarios y la correlación entre ellos, pero de ninguna manera está lista para su uso. Funciona hasta cierto punto. 

Se comprende de un APi Gateway como Faccade pattern, con un Lambda Authorizer para authenticar los request Y servicios backend en 2 AZ basados en ECS + EC2, mas una Subnet para Data de RDS

Todo a ser aplicado con Github Actions

 Este es un ejemplo que está completado en un 70% y no está destinado a ser aplicado.

![alt text](/images/latch.drawio.png "Proposed diagram")

La solución propuesta realiza las siguientes acciones.
```
1. El usuario final consumirá los endpoint mediante un ApiGateway con alta disponibilidad con cloudfront.
2. ALB redijira al ECS con Backend
3. RDS suminitrara la informacion al Backend.
```

## Requerimientos

* An active AWS account
* Github Secrets added for the CICD
* AWS Keys
* Terraform => https://learn.hashicorp.com/tutorials/terraform/install-cli
* AWS CLI => https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

## Restricciones

* CICD con privilegios de AWS para ejecutar Terraform
* Secretos almacenados en el repositorio de Github para que el proceso no falle.
* Un S3 Bucket para almacenar el backend del código Terraform (o en su defecto local)
* Vars de entorno local (.env) para implementación de prueba

# Process for local testing

1. Use the `env.template` file to create the `.env` file.
2. Populate the `.env` file with your AWS access KEYs and selected Region.
3. Execute `source .env`.
4. Change Backend to `local {}`
5. Execute `terraform init`
6. Execute `terraform plan`

## Terraform plan / Terratest

<details>
<summary>Summary</summary>
  
```
terraform init
terraform init
Initializing modules...

Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/random versions matching ">= 3.1.0"...
- Finding hashicorp/aws versions matching ">= 5.0.0"...
- Installing hashicorp/random v3.5.1...
- Installed hashicorp/random v3.5.1 (signed by HashiCorp)
- Installing hashicorp/aws v5.20.1...
- Installed hashicorp/aws v5.20.1 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

terraform plan

[0m[1mmodule.db.module.db_instance.data.aws_partition.current: Reading...[0m[0m
[0m[1mmodule.db.module.db_instance.data.aws_iam_policy_document.enhanced_monitoring: Reading...[0m[0m
[0m[1mdata.aws_caller_identity.current: Reading...[0m[0m
[0m[1mmodule.db.module.db_instance.data.aws_iam_policy_document.enhanced_monitoring: Read complete after 0s [id=76086537][0m
[0m[1mmodule.db.module.db_instance.data.aws_partition.current: Read complete after 0s [id=aws][0m
[0m[1mdata.aws_caller_identity.current: Read complete after 0s [id=476795228417][0m

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  [32m+[0m create
[0m
Terraform will perform the following actions:

[1m  # aws_autoscaling_group.ecs_asg[0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_autoscaling_group" "ecs_asg" {
      [32m+[0m [0m[1m[0marn[0m[0m                              = (known after apply)
      [32m+[0m [0m[1m[0mavailability_zones[0m[0m               = (known after apply)
      [32m+[0m [0m[1m[0mdefault_cooldown[0m[0m                 = (known after apply)
      [32m+[0m [0m[1m[0mdesired_capacity[0m[0m                 = 2
      [32m+[0m [0m[1m[0mforce_delete[0m[0m                     = false
      [32m+[0m [0m[1m[0mforce_delete_warm_pool[0m[0m           = false
      [32m+[0m [0m[1m[0mhealth_check_grace_period[0m[0m        = 300
      [32m+[0m [0m[1m[0mhealth_check_type[0m[0m                = (known after apply)
      [32m+[0m [0m[1m[0mid[0m[0m                               = (known after apply)
      [32m+[0m [0m[1m[0mignore_failed_scaling_activities[0m[0m = false
      [32m+[0m [0m[1m[0mload_balancers[0m[0m                   = (known after apply)
      [32m+[0m [0m[1m[0mmax_size[0m[0m                         = 3
      [32m+[0m [0m[1m[0mmetrics_granularity[0m[0m              = "1Minute"
      [32m+[0m [0m[1m[0mmin_size[0m[0m                         = 1
      [32m+[0m [0m[1m[0mname[0m[0m                             = (known after apply)
      [32m+[0m [0m[1m[0mname_prefix[0m[0m                      = (known after apply)
      [32m+[0m [0m[1m[0mpredicted_capacity[0m[0m               = (known after apply)
      [32m+[0m [0m[1m[0mprotect_from_scale_in[0m[0m            = false
      [32m+[0m [0m[1m[0mservice_linked_role_arn[0m[0m          = (known after apply)
      [32m+[0m [0m[1m[0mtarget_group_arns[0m[0m                = (known after apply)
      [32m+[0m [0m[1m[0mvpc_zone_identifier[0m[0m              = (known after apply)
      [32m+[0m [0m[1m[0mwait_for_capacity_timeout[0m[0m        = "10m"
      [32m+[0m [0m[1m[0mwarm_pool_size[0m[0m                   = (known after apply)

      [32m+[0m [0mlaunch_template {
          [32m+[0m [0m[1m[0mid[0m[0m      = (known after apply)
          [32m+[0m [0m[1m[0mname[0m[0m    = (known after apply)
          [32m+[0m [0m[1m[0mversion[0m[0m = "$Latest"
        }

      [32m+[0m [0mtag {
          [32m+[0m [0m[1m[0mkey[0m[0m                 = "AmazonECSManaged"
          [32m+[0m [0m[1m[0mpropagate_at_launch[0m[0m = true
          [32m+[0m [0m[1m[0mvalue[0m[0m               = "true"
        }

      [32m+[0m [0mtraffic_source {
          [32m+[0m [0m[1m[0midentifier[0m[0m = (known after apply)
          [32m+[0m [0m[1m[0mtype[0m[0m       = (known after apply)
        }
    }

[1m  # aws_cloudfront_distribution.this[0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_cloudfront_distribution" "this" {
      [32m+[0m [0m[1m[0marn[0m[0m                             = (known after apply)
      [32m+[0m [0m[1m[0mcaller_reference[0m[0m                = (known after apply)
      [32m+[0m [0m[1m[0mcontinuous_deployment_policy_id[0m[0m = (known after apply)
      [32m+[0m [0m[1m[0mdomain_name[0m[0m                     = (known after apply)
      [32m+[0m [0m[1m[0menabled[0m[0m                         = true
      [32m+[0m [0m[1m[0metag[0m[0m                            = (known after apply)
      [32m+[0m [0m[1m[0mhosted_zone_id[0m[0m                  = (known after apply)
      [32m+[0m [0m[1m[0mhttp_version[0m[0m                    = "http2"
      [32m+[0m [0m[1m[0mid[0m[0m                              = (known after apply)
      [32m+[0m [0m[1m[0min_progress_validation_batches[0m[0m  = (known after apply)
      [32m+[0m [0m[1m[0mis_ipv6_enabled[0m[0m                 = false
      [32m+[0m [0m[1m[0mlast_modified_time[0m[0m              = (known after apply)
      [32m+[0m [0m[1m[0mprice_class[0m[0m                     = "PriceClass_200"
      [32m+[0m [0m[1m[0mretain_on_delete[0m[0m                = false
      [32m+[0m [0m[1m[0mstaging[0m[0m                         = false
      [32m+[0m [0m[1m[0mstatus[0m[0m                          = (known after apply)
      [32m+[0m [0m[1m[0mtags_all[0m[0m                        = (known after apply)
      [32m+[0m [0m[1m[0mtrusted_key_groups[0m[0m              = (known after apply)
      [32m+[0m [0m[1m[0mtrusted_signers[0m[0m                 = (known after apply)
      [32m+[0m [0m[1m[0mwait_for_deployment[0m[0m             = true

      [32m+[0m [0mdefault_cache_behavior {
          [32m+[0m [0m[1m[0mallowed_methods[0m[0m        = [
              [32m+[0m [0m"GET",
              [32m+[0m [0m"HEAD",
            ]
          [32m+[0m [0m[1m[0mcached_methods[0m[0m         = [
              [32m+[0m [0m"GET",
              [32m+[0m [0m"HEAD",
            ]
          [32m+[0m [0m[1m[0mcompress[0m[0m               = false
          [32m+[0m [0m[1m[0mdefault_ttl[0m[0m            = 0
          [32m+[0m [0m[1m[0mmax_ttl[0m[0m                = 0
          [32m+[0m [0m[1m[0mmin_ttl[0m[0m                = 0
          [32m+[0m [0m[1m[0mtarget_origin_id[0m[0m       = "test_latch-origin"
          [32m+[0m [0m[1m[0mtrusted_key_groups[0m[0m     = (known after apply)
          [32m+[0m [0m[1m[0mtrusted_signers[0m[0m        = (known after apply)
          [32m+[0m [0m[1m[0mviewer_protocol_policy[0m[0m = "redirect-to-https"

          [32m+[0m [0mforwarded_values {
              [32m+[0m [0m[1m[0mheaders[0m[0m                 = (known after apply)
              [32m+[0m [0m[1m[0mquery_string[0m[0m            = true
              [32m+[0m [0m[1m[0mquery_string_cache_keys[0m[0m = (known after apply)

              [32m+[0m [0mcookies {
                  [32m+[0m [0m[1m[0mforward[0m[0m           = "all"
                  [32m+[0m [0m[1m[0mwhitelisted_names[0m[0m = (known after apply)
                }
            }
        }

      [32m+[0m [0morigin {
          [32m+[0m [0m[1m[0mconnection_attempts[0m[0m = 3
          [32m+[0m [0m[1m[0mconnection_timeout[0m[0m  = 10
          [32m+[0m [0m[1m[0mdomain_name[0m[0m         = "test_latch.s3-website-us-east-1.amazonaws.com"
          [32m+[0m [0m[1m[0morigin_id[0m[0m           = "test_latch-origin"

          [32m+[0m [0mcustom_origin_config {
              [32m+[0m [0m[1m[0mhttp_port[0m[0m                = 80
              [32m+[0m [0m[1m[0mhttps_port[0m[0m               = 443
              [32m+[0m [0m[1m[0morigin_keepalive_timeout[0m[0m = 5
              [32m+[0m [0m[1m[0morigin_protocol_policy[0m[0m   = "http-only"
              [32m+[0m [0m[1m[0morigin_read_timeout[0m[0m      = 30
              [32m+[0m [0m[1m[0morigin_ssl_protocols[0m[0m     = [
                  [32m+[0m [0m"TLSv1",
                ]
            }
        }

      [32m+[0m [0mrestrictions {
          [32m+[0m [0mgeo_restriction {
              [32m+[0m [0m[1m[0mlocations[0m[0m        = (known after apply)
              [32m+[0m [0m[1m[0mrestriction_type[0m[0m = "none"
            }
        }

      [32m+[0m [0mviewer_certificate {
          [32m+[0m [0m[1m[0mcloudfront_default_certificate[0m[0m = true
          [32m+[0m [0m[1m[0mminimum_protocol_version[0m[0m       = "TLSv1"
        }
    }

[1m  # aws_ecr_repository.accounting[0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_ecr_repository" "accounting" {
      [32m+[0m [0m[1m[0marn[0m[0m                  = (known after apply)
      [32m+[0m [0m[1m[0mid[0m[0m                   = (known after apply)
      [32m+[0m [0m[1m[0mimage_tag_mutability[0m[0m = "MUTABLE"
      [32m+[0m [0m[1m[0mname[0m[0m                 = "accounting"
      [32m+[0m [0m[1m[0mregistry_id[0m[0m          = (known after apply)
      [32m+[0m [0m[1m[0mrepository_url[0m[0m       = (known after apply)
      [32m+[0m [0m[1m[0mtags_all[0m[0m             = (known after apply)

      [32m+[0m [0mimage_scanning_configuration {
          [32m+[0m [0m[1m[0mscan_on_push[0m[0m = true
        }
    }

[1m  # aws_ecr_repository.inventory[0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_ecr_repository" "inventory" {
      [32m+[0m [0m[1m[0marn[0m[0m                  = (known after apply)
      [32m+[0m [0m[1m[0mid[0m[0m                   = (known after apply)
      [32m+[0m [0m[1m[0mimage_tag_mutability[0m[0m = "MUTABLE"
      [32m+[0m [0m[1m[0mname[0m[0m                 = "inventory"
      [32m+[0m [0m[1m[0mregistry_id[0m[0m          = (known after apply)
      [32m+[0m [0m[1m[0mrepository_url[0m[0m       = (known after apply)
      [32m+[0m [0m[1m[0mtags_all[0m[0m             = (known after apply)

      [32m+[0m [0mimage_scanning_configuration {
          [32m+[0m [0m[1m[0mscan_on_push[0m[0m = true
        }
    }

[1m  # aws_ecr_repository.shipping[0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_ecr_repository" "shipping" {
      [32m+[0m [0m[1m[0marn[0m[0m                  = (known after apply)
      [32m+[0m [0m[1m[0mid[0m[0m                   = (known after apply)
      [32m+[0m [0m[1m[0mimage_tag_mutability[0m[0m = "MUTABLE"
      [32m+[0m [0m[1m[0mname[0m[0m                 = "shipping"
      [32m+[0m [0m[1m[0mregistry_id[0m[0m          = (known after apply)
      [32m+[0m [0m[1m[0mrepository_url[0m[0m       = (known after apply)
      [32m+[0m [0m[1m[0mtags_all[0m[0m             = (known after apply)

      [32m+[0m [0mimage_scanning_configuration {
          [32m+[0m [0m[1m[0mscan_on_push[0m[0m = true
        }
    }

[1m  # aws_ecs_capacity_provider.ecs_capacity_provider[0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {
      [32m+[0m [0m[1m[0marn[0m[0m      = (known after apply)
      [32m+[0m [0m[1m[0mid[0m[0m       = (known after apply)
      [32m+[0m [0m[1m[0mname[0m[0m     = "testlatch"
      [32m+[0m [0m[1m[0mtags_all[0m[0m = (known after apply)

      [32m+[0m [0mauto_scaling_group_provider {
          [32m+[0m [0m[1m[0mauto_scaling_group_arn[0m[0m         = (known after apply)
          [32m+[0m [0m[1m[0mmanaged_termination_protection[0m[0m = (known after apply)

          [32m+[0m [0mmanaged_scaling {
              [32m+[0m [0m[1m[0minstance_warmup_period[0m[0m    = (known after apply)
              [32m+[0m [0m[1m[0mmaximum_scaling_step_size[0m[0m = 1000
              [32m+[0m [0m[1m[0mminimum_scaling_step_size[0m[0m = 1
              [32m+[0m [0m[1m[0mstatus[0m[0m                    = "ENABLED"
              [32m+[0m [0m[1m[0mtarget_capacity[0m[0m           = 3
            }
        }
    }

[1m  # aws_ecs_cluster.ecs_cluster[0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_ecs_cluster" "ecs_cluster" {
      [32m+[0m [0m[1m[0marn[0m[0m      = (known after apply)
      [32m+[0m [0m[1m[0mid[0m[0m       = (known after apply)
      [32m+[0m [0m[1m[0mname[0m[0m     = "testlatch"
      [32m+[0m [0m[1m[0mtags_all[0m[0m = (known after apply)

      [32m+[0m [0msetting {
          [32m+[0m [0m[1m[0mname[0m[0m  = (known after apply)
          [32m+[0m [0m[1m[0mvalue[0m[0m = (known after apply)
        }
    }

[1m  # aws_ecs_cluster_capacity_providers.example[0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_ecs_cluster_capacity_providers" "example" {
      [32m+[0m [0m[1m[0mcapacity_providers[0m[0m = [
          [32m+[0m [0m"testlatch",
        ]
      [32m+[0m [0m[1m[0mcluster_name[0m[0m       = "testlatch"
      [32m+[0m [0m[1m[0mid[0m[0m                 = (known after apply)

      [32m+[0m [0mdefault_capacity_provider_strategy {
          [32m+[0m [0m[1m[0mbase[0m[0m              = 1
          [32m+[0m [0m[1m[0mcapacity_provider[0m[0m = "testlatch"
          [32m+[0m [0m[1m[0mweight[0m[0m            = 100
        }
    }

[1m  # aws_ecs_service.ecs_service_accounting[0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_ecs_service" "ecs_service_accounting" {
      [32m+[0m [0m[1m[0mcluster[0m[0m                            = (known after apply)
      [32m+[0m [0m[1m[0mdeployment_maximum_percent[0m[0m         = 200
      [32m+[0m [0m[1m[0mdeployment_minimum_healthy_percent[0m[0m = 100
      [32m+[0m [0m[1m[0mdesired_count[0m[0m                      = 2
      [32m+[0m [0m[1m[0menable_ecs_managed_tags[0m[0m            = false
      [32m+[0m [0m[1m[0menable_execute_command[0m[0m             = false
      [32m+[0m [0m[1m[0mforce_new_deployment[0m[0m               = true
      [32m+[0m [0m[1m[0miam_role[0m[0m                           = (known after apply)
      [32m+[0m [0m[1m[0mid[0m[0m                                 = (known after apply)
      [32m+[0m [0m[1m[0mlaunch_type[0m[0m                        = (known after apply)
      [32m+[0m [0m[1m[0mname[0m[0m                               = "my-ecs-service"
      [32m+[0m [0m[1m[0mplatform_version[0m[0m                   = (known after apply)
      [32m+[0m [0m[1m[0mscheduling_strategy[0m[0m                = "REPLICA"
      [32m+[0m [0m[1m[0mtags_all[0m[0m                           = (known after apply)
      [32m+[0m [0m[1m[0mtask_definition[0m[0m                    = (known after apply)
      [32m+[0m [0m[1m[0mtriggers[0m[0m                           = (known after apply)
      [32m+[0m [0m[1m[0mwait_for_steady_state[0m[0m              = false

      [32m+[0m [0mcapacity_provider_strategy {
          [32m+[0m [0m[1m[0mcapacity_provider[0m[0m = "testlatch"
          [32m+[0m [0m[1m[0mweight[0m[0m            = 100
        }

      [32m+[0m [0mload_balancer {
          [32m+[0m [0m[1m[0mcontainer_name[0m[0m   = "dockergs"
          [32m+[0m [0m[1m[0mcontainer_port[0m[0m   = 80
          [32m+[0m [0m[1m[0mtarget_group_arn[0m[0m = (known after apply)
        }

      [32m+[0m [0mnetwork_configuration {
          [32m+[0m [0m[1m[0massign_public_ip[0m[0m = false
          [32m+[0m [0m[1m[0msecurity_groups[0m[0m  = (known after apply)
          [32m+[0m [0m[1m[0msubnets[0m[0m          = (known after apply)
        }

      [32m+[0m [0mplacement_constraints {
          [32m+[0m [0m[1m[0mtype[0m[0m = "distinctInstance"
        }
    }

[1m  # aws_ecs_service.ecs_service_inventory[0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_ecs_service" "ecs_service_inventory" {
      [32m+[0m [0m[1m[0mcluster[0m[0m                            = (known after apply)
      [32m+[0m [0m[1m[0mdeployment_maximum_percent[0m[0m         = 200
      [32m+[0m [0m[1m[0mdeployment_minimum_healthy_percent[0m[0m = 100
      [32m+[0m [0m[1m[0mdesired_count[0m[0m                      = 2
      [32m+[0m [0m[1m[0menable_ecs_managed_tags[0m[0m            = false
      [32m+[0m [0m[1m[0menable_execute_command[0m[0m             = false
      [32m+[0m [0m[1m[0mforce_new_deployment[0m[0m               = true
      [32m+[0m [0m[1m[0miam_role[0m[0m                           = (known after apply)
      [32m+[0m [0m[1m[0mid[0m[0m                                 = (known after apply)
      [32m+[0m [0m[1m[0mlaunch_type[0m[0m                        = (known after apply)
      [32m+[0m [0m[1m[0mname[0m[0m                               = "my-ecs-service"
      [32m+[0m [0m[1m[0mplatform_version[0m[0m                   = (known after apply)
      [32m+[0m [0m[1m[0mscheduling_strategy[0m[0m                = "REPLICA"
      [32m+[0m [0m[1m[0mtags_all[0m[0m                           = (known after apply)
      [32m+[0m [0m[1m[0mtask_definition[0m[0m                    = (known after apply)
      [32m+[0m [0m[1m[0mtriggers[0m[0m                           = (known after apply)
      [32m+[0m [0m[1m[0mwait_for_steady_state[0m[0m              = false

      [32m+[0m [0mcapacity_provider_strategy {
          [32m+[0m [0m[1m[0mcapacity_provider[0m[0m = "testlatch"
          [32m+[0m [0m[1m[0mweight[0m[0m            = 100
        }

      [32m+[0m [0mload_balancer {
          [32m+[0m [0m[1m[0mcontainer_name[0m[0m   = "dockergs"
          [32m+[0m [0m[1m[0mcontainer_port[0m[0m   = 80
          [32m+[0m [0m[1m[0mtarget_group_arn[0m[0m = (known after apply)
        }

      [32m+[0m [0mnetwork_configuration {
          [32m+[0m [0m[1m[0massign_public_ip[0m[0m = false
          [32m+[0m [0m[1m[0msecurity_groups[0m[0m  = (known after apply)
          [32m+[0m [0m[1m[0msubnets[0m[0m          = (known after apply)
        }

      [32m+[0m [0mplacement_constraints {
          [32m+[0m [0m[1m[0mtype[0m[0m = "distinctInstance"
        }
    }

[1m  # aws_ecs_service.ecs_service_shipping[0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_ecs_service" "ecs_service_shipping" {
      [32m+[0m [0m[1m[0mcluster[0m[0m                            = (known after apply)
      [32m+[0m [0m[1m[0mdeployment_maximum_percent[0m[0m         = 200
      [32m+[0m [0m[1m[0mdeployment_minimum_healthy_percent[0m[0m = 100
      [32m+[0m [0m[1m[0mdesired_count[0m[0m                      = 2
      [32m+[0m [0m[1m[0menable_ecs_managed_tags[0m[0m            = false
      [32m+[0m [0m[1m[0menable_execute_command[0m[0m             = false
      [32m+[0m [0m[1m[0mforce_new_deployment[0m[0m               = true
      [32m+[0m [0m[1m[0miam_role[0m[0m                           = (known after apply)
      [32m+[0m [0m[1m[0mid[0m[0m                                 = (known after apply)
      [32m+[0m [0m[1m[0mlaunch_type[0m[0m                        = (known after apply)
      [32m+[0m [0m[1m[0mname[0m[0m                               = "my-ecs-service"
      [32m+[0m [0m[1m[0mplatform_version[0m[0m                   = (known after apply)
      [32m+[0m [0m[1m[0mscheduling_strategy[0m[0m                = "REPLICA"
      [32m+[0m [0m[1m[0mtags_all[0m[0m                           = (known after apply)
      [32m+[0m [0m[1m[0mtask_definition[0m[0m                    = (known after apply)
      [32m+[0m [0m[1m[0mtriggers[0m[0m                           = (known after apply)
      [32m+[0m [0m[1m[0mwait_for_steady_state[0m[0m              = false

      [32m+[0m [0mcapacity_provider_strategy {
          [32m+[0m [0m[1m[0mcapacity_provider[0m[0m = "testlatch"
          [32m+[0m [0m[1m[0mweight[0m[0m            = 100
        }

      [32m+[0m [0mload_balancer {
          [32m+[0m [0m[1m[0mcontainer_name[0m[0m   = "dockergs"
          [32m+[0m [0m[1m[0mcontainer_port[0m[0m   = 80
          [32m+[0m [0m[1m[0mtarget_group_arn[0m[0m = (known after apply)
        }

      [32m+[0m [0mnetwork_configuration {
          [32m+[0m [0m[1m[0massign_public_ip[0m[0m = false
          [32m+[0m [0m[1m[0msecurity_groups[0m[0m  = (known after apply)
          [32m+[0m [0m[1m[0msubnets[0m[0m          = (known after apply)
        }

      [32m+[0m [0mplacement_constraints {
          [32m+[0m [0m[1m[0mtype[0m[0m = "distinctInstance"
        }
    }

[1m  # aws_ecs_task_definition.accounting[0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_ecs_task_definition" "accounting" {
      [32m+[0m [0m[1m[0marn[0m[0m                   = (known after apply)
      [32m+[0m [0m[1m[0marn_without_revision[0m[0m  = (known after apply)
      [32m+[0m [0m[1m[0mcontainer_definitions[0m[0m = jsonencode(
            [
              [32m+[0m [0m{
                  [32m+[0m [0mcpu          = 256
                  [32m+[0m [0messential    = true
                  [32m+[0m [0mimage        = "public.ecr.aws/f9n5f1l7/dgs:latest"
                  [32m+[0m [0mmemory       = 512
                  [32m+[0m [0mname         = "inventory"
                  [32m+[0m [0mportMappings = [
                      [32m+[0m [0m{
                          [32m+[0m [0mcontainerPort = 80
                          [32m+[0m [0mhostPort      = 80
                          [32m+[0m [0mprotocol      = "tcp"
                        },
                    ]
                },
            ]
        )
      [32m+[0m [0m[1m[0mcpu[0m[0m                   = "256"
      [32m+[0m [0m[1m[0mexecution_role_arn[0m[0m    = "arn:aws:iam::476795228417:role/ecsTaskExecutionRole"
      [32m+[0m [0m[1m[0mfamily[0m[0m                = "accounting"
      [32m+[0m [0m[1m[0mid[0m[0m                    = (known after apply)
      [32m+[0m [0m[1m[0mnetwork_mode[0m[0m          = "awsvpc"
      [32m+[0m [0m[1m[0mrevision[0m[0m              = (known after apply)
      [32m+[0m [0m[1m[0mskip_destroy[0m[0m          = false
      [32m+[0m [0m[1m[0mtags_all[0m[0m              = (known after apply)

      [32m+[0m [0mruntime_platform {
          [32m+[0m [0m[1m[0mcpu_architecture[0m[0m        = "X86_64"
          [32m+[0m [0m[1m[0moperating_system_family[0m[0m = "LINUX"
        }
    }

[1m  # aws_ecs_task_definition.inventory[0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_ecs_task_definition" "inventory" {
      [32m+[0m [0m[1m[0marn[0m[0m                   = (known after apply)
      [32m+[0m [0m[1m[0marn_without_revision[0m[0m  = (known after apply)
      [32m+[0m [0m[1m[0mcontainer_definitions[0m[0m = jsonencode(
            [
              [32m+[0m [0m{
                  [32m+[0m [0mcpu          = 256
                  [32m+[0m [0messential    = true
                  [32m+[0m [0mimage        = "public.ecr.aws/f9n5f1l7/dgs:latest"
                  [32m+[0m [0mmemory       = 512
                  [32m+[0m [0mname         = "inventory"
                  [32m+[0m [0mportMappings = [
                      [32m+[0m [0m{
                          [32m+[0m [0mcontainerPort = 80
                          [32m+[0m [0mhostPort      = 80
                          [32m+[0m [0mprotocol      = "tcp"
                        },
                    ]
                },
            ]
        )
      [32m+[0m [0m[1m[0mcpu[0m[0m                   = "256"
      [32m+[0m [0m[1m[0mexecution_role_arn[0m[0m    = "arn:aws:iam::476795228417:role/ecsTaskExecutionRole"
      [32m+[0m [0m[1m[0mfamily[0m[0m                = "inventory"
      [32m+[0m [0m[1m[0mid[0m[0m                    = (known after apply)
      [32m+[0m [0m[1m[0mnetwork_mode[0m[0m          = "awsvpc"
      [32m+[0m [0m[1m[0mrevision[0m[0m              = (known after apply)
      [32m+[0m [0m[1m[0mskip_destroy[0m[0m          = false
      [32m+[0m [0m[1m[0mtags_all[0m[0m              = (known after apply)

      [32m+[0m [0mruntime_platform {
          [32m+[0m [0m[1m[0mcpu_architecture[0m[0m        = "X86_64"
          [32m+[0m [0m[1m[0moperating_system_family[0m[0m = "LINUX"
        }
    }

[1m  # aws_ecs_task_definition.shipping[0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_ecs_task_definition" "shipping" {
      [32m+[0m [0m[1m[0marn[0m[0m                   = (known after apply)
      [32m+[0m [0m[1m[0marn_without_revision[0m[0m  = (known after apply)
      [32m+[0m [0m[1m[0mcontainer_definitions[0m[0m = jsonencode(
            [
              [32m+[0m [0m{
                  [32m+[0m [0mcpu          = 256
                  [32m+[0m [0messential    = true
                  [32m+[0m [0mimage        = "public.ecr.aws/f9n5f1l7/dgs:latest"
                  [32m+[0m [0mmemory       = 512
                  [32m+[0m [0mname         = "shipping"
                  [32m+[0m [0mportMappings = [
                      [32m+[0m [0m{
                          [32m+[0m [0mcontainerPort = 80
                          [32m+[0m [0mhostPort      = 80
                          [32m+[0m [0mprotocol      = "tcp"
                        },
                    ]
                },
            ]
        )
      [32m+[0m [0m[1m[0mcpu[0m[0m                   = "256"
      [32m+[0m [0m[1m[0mexecution_role_arn[0m[0m    = "arn:aws:iam::476795228417:role/ecsTaskExecutionRole"
      [32m+[0m [0m[1m[0mfamily[0m[0m                = "shipping"
      [32m+[0m [0m[1m[0mid[0m[0m                    = (known after apply)
      [32m+[0m [0m[1m[0mnetwork_mode[0m[0m          = "awsvpc"
      [32m+[0m [0m[1m[0mrevision[0m[0m              = (known after apply)
      [32m+[0m [0m[1m[0mskip_destroy[0m[0m          = false
      [32m+[0m [0m[1m[0mtags_all[0m[0m              = (known after apply)

      [32m+[0m [0mruntime_platform {
          [32m+[0m [0m[1m[0mcpu_architecture[0m[0m        = "X86_64"
          [32m+[0m [0m[1m[0moperating_system_family[0m[0m = "LINUX"
        }
    }

[1m  # aws_internet_gateway.internet_gateway[0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_internet_gateway" "internet_gateway" {
      [32m+[0m [0m[1m[0marn[0m[0m      = (known after apply)
      [32m+[0m [0m[1m[0mid[0m[0m       = (known after apply)
      [32m+[0m [0m[1m[0mowner_id[0m[0m = (known after apply)
      [32m+[0m [0m[1m[0mtags[0m[0m     = {
          [32m+[0m [0m"Name" = "internet_gateway"
        }
      [32m+[0m [0m[1m[0mtags_all[0m[0m = {
          [32m+[0m [0m"Name" = "internet_gateway"
        }
      [32m+[0m [0m[1m[0mvpc_id[0m[0m   = (known after apply)
    }

[1m  # aws_launch_template.ecs_lt[0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_launch_template" "ecs_lt" {
      [32m+[0m [0m[1m[0marn[0m[0m                    = (known after apply)
      [32m+[0m [0m[1m[0mdefault_version[0m[0m        = (known after apply)
      [32m+[0m [0m[1m[0mid[0m[0m                     = (known after apply)
      [32m+[0m [0m[1m[0mimage_id[0m[0m               = "ami-062c116e449466e7f"
      [32m+[0m [0m[1m[0minstance_type[0m[0m          = "t3.micro"
      [32m+[0m [0m[1m[0mkey_name[0m[0m               = "ec2ecsglog"
      [32m+[0m [0m[1m[0mlatest_version[0m[0m         = (known after apply)
      [32m+[0m [0m[1m[0mname[0m[0m                   = (known after apply)
      [32m+[0m [0m[1m[0mname_prefix[0m[0m            = "ecs-template"
      [32m+[0m [0m[1m[0mtags_all[0m[0m               = (known after apply)
      [32m+[0m [0m[1m[0muser_data[0m[0m              = "IyEvYmluL2Jhc2gKZWNobyBFQ1NfQ0xVU1RFUj1teS1lY3MtY2x1c3RlciA+PiAvZXRjL2Vjcy9lY3MuY29uZmln"
      [32m+[0m [0m[1m[0mvpc_security_group_ids[0m[0m = (known after apply)

      [32m+[0m [0mblock_device_mappings {
          [32m+[0m [0m[1m[0mdevice_name[0m[0m = "/dev/xvda"

          [32m+[0m [0mebs {
              [32m+[0m [0m[1m[0miops[0m[0m        = (known after apply)
              [32m+[0m [0m[1m[0mthroughput[0m[0m  = (known after apply)
              [32m+[0m [0m[1m[0mvolume_size[0m[0m = 30
              [32m+[0m [0m[1m[0mvolume_type[0m[0m = "gp2"
            }
        }

      [32m+[0m [0miam_instance_profile {
          [32m+[0m [0m[1m[0mname[0m[0m = "ecsInstanceRole"
        }

      [32m+[0m [0mmetadata_options {
          [32m+[0m [0m[1m[0mhttp_endpoint[0m[0m               = (known after apply)
          [32m+[0m [0m[1m[0mhttp_protocol_ipv6[0m[0m          = (known after apply)
          [32m+[0m [0m[1m[0mhttp_put_response_hop_limit[0m[0m = (known after apply)
          [32m+[0m [0m[1m[0mhttp_tokens[0m[0m                 = (known after apply)
          [32m+[0m [0m[1m[0minstance_metadata_tags[0m[0m      = (known after apply)
        }

      [32m+[0m [0mtag_specifications {
          [32m+[0m [0m[1m[0mresource_type[0m[0m = "instance"
          [32m+[0m [0m[1m[0mtags[0m[0m          = {
              [32m+[0m [0m"Name" = "ecs-instance"
            }
        }
    }

[1m  # aws_lb.ecs_alb[0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_lb" "ecs_alb" {
      [32m+[0m [0m[1m[0marn[0m[0m                                         = (known after apply)
      [32m+[0m [0m[1m[0marn_suffix[0m[0m                                  = (known after apply)
      [32m+[0m [0m[1m[0mdesync_mitigation_mode[0m[0m                      = "defensive"
      [32m+[0m [0m[1m[0mdns_name[0m[0m                                    = (known after apply)
      [32m+[0m [0m[1m[0mdrop_invalid_header_fields[0m[0m                  = false
      [32m+[0m [0m[1m[0menable_deletion_protection[0m[0m                  = false
      [32m+[0m [0m[1m[0menable_http2[0m[0m                                = true
      [32m+[0m [0m[1m[0menable_tls_version_and_cipher_suite_headers[0m[0m = false
      [32m+[0m [0m[1m[0menable_waf_fail_open[0m[0m                        = false
      [32m+[0m [0m[1m[0menable_xff_client_port[0m[0m                      = false
      [32m+[0m [0m[1m[0mid[0m[0m                                          = (known after apply)
      [32m+[0m [0m[1m[0midle_timeout[0m[0m                                = 60
      [32m+[0m [0m[1m[0minternal[0m[0m                                    = false
      [32m+[0m [0m[1m[0mip_address_type[0m[0m                             = (known after apply)
      [32m+[0m [0m[1m[0mload_balancer_type[0m[0m                          = "application"
      [32m+[0m [0m[1m[0mname[0m[0m                                        = "ecs-alb"
      [32m+[0m [0m[1m[0mpreserve_host_header[0m[0m                        = false
      [32m+[0m [0m[1m[0msecurity_groups[0m[0m                             = (known after apply)
      [32m+[0m [0m[1m[0msubnets[0m[0m                                     = (known after apply)
      [32m+[0m [0m[1m[0mtags[0m[0m                                        = {
          [32m+[0m [0m"Name" = "ecs-alb"
        }
      [32m+[0m [0m[1m[0mtags_all[0m[0m                                    = {
          [32m+[0m [0m"Name" = "ecs-alb"
        }
      [32m+[0m [0m[1m[0mvpc_id[0m[0m                                      = (known after apply)
      [32m+[0m [0m[1m[0mxff_header_processing_mode[0m[0m                  = "append"
      [32m+[0m [0m[1m[0mzone_id[0m[0m                                     = (known after apply)

      [32m+[0m [0msubnet_mapping {
          [32m+[0m [0m[1m[0mallocation_id[0m[0m        = (known after apply)
          [32m+[0m [0m[1m[0mipv6_address[0m[0m         = (known after apply)
          [32m+[0m [0m[1m[0moutpost_id[0m[0m           = (known after apply)
          [32m+[0m [0m[1m[0mprivate_ipv4_address[0m[0m = (known after apply)
          [32m+[0m [0m[1m[0msubnet_id[0m[0m            = (known after apply)
        }
    }

[1m  # aws_lb_listener.ecs_alb_listener[0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_lb_listener" "ecs_alb_listener" {
      [32m+[0m [0m[1m[0marn[0m[0m               = (known after apply)
      [32m+[0m [0m[1m[0mid[0m[0m                = (known after apply)
      [32m+[0m [0m[1m[0mload_balancer_arn[0m[0m = (known after apply)
      [32m+[0m [0m[1m[0mport[0m[0m              = 80
      [32m+[0m [0m[1m[0mprotocol[0m[0m          = "HTTP"
      [32m+[0m [0m[1m[0mssl_policy[0m[0m        = (known after apply)
      [32m+[0m [0m[1m[0mtags_all[0m[0m          = (known after apply)

      [32m+[0m [0mdefault_action {
          [32m+[0m [0m[1m[0morder[0m[0m            = (known after apply)
          [32m+[0m [0m[1m[0mtarget_group_arn[0m[0m = (known after apply)
          [32m+[0m [0m[1m[0mtype[0m[0m             = "forward"
        }
    }

[1m  # aws_lb_target_group.ecs_tg[0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_lb_target_group" "ecs_tg" {
      [32m+[0m [0m[1m[0marn[0m[0m                                = (known after apply)
      [32m+[0m [0m[1m[0marn_suffix[0m[0m                         = (known after apply)
      [32m+[0m [0m[1m[0mconnection_termination[0m[0m             = false
      [32m+[0m [0m[1m[0mderegistration_delay[0m[0m               = "300"
      [32m+[0m [0m[1m[0mid[0m[0m                                 = (known after apply)
      [32m+[0m [0m[1m[0mip_address_type[0m[0m                    = (known after apply)
      [32m+[0m [0m[1m[0mlambda_multi_value_headers_enabled[0m[0m = false
      [32m+[0m [0m[1m[0mload_balancing_algorithm_type[0m[0m      = (known after apply)
      [32m+[0m [0m[1m[0mload_balancing_cross_zone_enabled[0m[0m  = (known after apply)
      [32m+[0m [0m[1m[0mname[0m[0m                               = "ecs-target-group"
      [32m+[0m [0m[1m[0mport[0m[0m                               = 80
      [32m+[0m [0m[1m[0mpreserve_client_ip[0m[0m                 = (known after apply)
      [32m+[0m [0m[1m[0mprotocol[0m[0m                           = "HTTP"
      [32m+[0m [0m[1m[0mprotocol_version[0m[0m                   = (known after apply)
      [32m+[0m [0m[1m[0mproxy_protocol_v2[0m[0m                  = false
      [32m+[0m [0m[1m[0mslow_start[0m[0m                         = 0
      [32m+[0m [0m[1m[0mtags_all[0m[0m                           = (known after apply)
      [32m+[0m [0m[1m[0mtarget_type[0m[0m                        = "ip"
      [32m+[0m [0m[1m[0mvpc_id[0m[0m                             = (known after apply)

      [32m+[0m [0mhealth_check {
          [32m+[0m [0m[1m[0menabled[0m[0m             = true
          [32m+[0m [0m[1m[0mhealthy_threshold[0m[0m   = 3
          [32m+[0m [0m[1m[0minterval[0m[0m            = 30
          [32m+[0m [0m[1m[0mmatcher[0m[0m             = (known after apply)
          [32m+[0m [0m[1m[0mpath[0m[0m                = "/"
          [32m+[0m [0m[1m[0mport[0m[0m                = "traffic-port"
          [32m+[0m [0m[1m[0mprotocol[0m[0m            = "HTTP"
          [32m+[0m [0m[1m[0mtimeout[0m[0m             = (known after apply)
          [32m+[0m [0m[1m[0munhealthy_threshold[0m[0m = 3
        }

      [32m+[0m [0mstickiness {
          [32m+[0m [0m[1m[0mcookie_duration[0m[0m = (known after apply)
          [32m+[0m [0m[1m[0mcookie_name[0m[0m     = (known after apply)
          [32m+[0m [0m[1m[0menabled[0m[0m         = (known after apply)
          [32m+[0m [0m[1m[0mtype[0m[0m            = (known after apply)
        }

      [32m+[0m [0mtarget_failover {
          [32m+[0m [0m[1m[0mon_deregistration[0m[0m = (known after apply)
          [32m+[0m [0m[1m[0mon_unhealthy[0m[0m      = (known after apply)
        }
    }

[1m  # aws_route_table.route_table[0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_route_table" "route_table" {
      [32m+[0m [0m[1m[0marn[0m[0m              = (known after apply)
      [32m+[0m [0m[1m[0mid[0m[0m               = (known after apply)
      [32m+[0m [0m[1m[0mowner_id[0m[0m         = (known after apply)
      [32m+[0m [0m[1m[0mpropagating_vgws[0m[0m = (known after apply)
      [32m+[0m [0m[1m[0mroute[0m[0m            = [
          [32m+[0m [0m{
              [32m+[0m [0mcarrier_gateway_id         = ""
              [32m+[0m [0mcidr_block                 = "0.0.0.0/0"
              [32m+[0m [0mcore_network_arn           = ""
              [32m+[0m [0mdestination_prefix_list_id = ""
              [32m+[0m [0megress_only_gateway_id     = ""
              [32m+[0m [0mgateway_id                 = (known after apply)
              [32m+[0m [0mipv6_cidr_block            = ""
              [32m+[0m [0mlocal_gateway_id           = ""
              [32m+[0m [0mnat_gateway_id             = ""
              [32m+[0m [0mnetwork_interface_id       = ""
              [32m+[0m [0mtransit_gateway_id         = ""
              [32m+[0m [0mvpc_endpoint_id            = ""
              [32m+[0m [0mvpc_peering_connection_id  = ""
            },
        ]
      [32m+[0m [0m[1m[0mtags_all[0m[0m         = (known after apply)
      [32m+[0m [0m[1m[0mvpc_id[0m[0m           = (known after apply)
    }

[1m  # aws_route_table_association.subnet2_route[0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_route_table_association" "subnet2_route" {
      [32m+[0m [0m[1m[0mid[0m[0m             = (known after apply)
      [32m+[0m [0m[1m[0mroute_table_id[0m[0m = (known after apply)
      [32m+[0m [0m[1m[0msubnet_id[0m[0m      = (known after apply)
    }

[1m  # aws_route_table_association.subnet_route[0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_route_table_association" "subnet_route" {
      [32m+[0m [0m[1m[0mid[0m[0m             = (known after apply)
      [32m+[0m [0m[1m[0mroute_table_id[0m[0m = (known after apply)
      [32m+[0m [0m[1m[0msubnet_id[0m[0m      = (known after apply)
    }

[1m  # aws_s3_bucket.this[0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_s3_bucket" "this" {
      [32m+[0m [0m[1m[0macceleration_status[0m[0m         = (known after apply)
      [32m+[0m [0m[1m[0macl[0m[0m                         = (known after apply)
      [32m+[0m [0m[1m[0marn[0m[0m                         = (known after apply)
      [32m+[0m [0m[1m[0mbucket[0m[0m                      = "test_latch"
      [32m+[0m [0m[1m[0mbucket_domain_name[0m[0m          = (known after apply)
      [32m+[0m [0m[1m[0mbucket_prefix[0m[0m               = (known after apply)
      [32m+[0m [0m[1m[0mbucket_regional_domain_name[0m[0m = (known after apply)
      [32m+[0m [0m[1m[0mforce_destroy[0m[0m               = false
      [32m+[0m [0m[1m[0mhosted_zone_id[0m[0m              = (known after apply)
      [32m+[0m [0m[1m[0mid[0m[0m                          = (known after apply)
      [32m+[0m [0m[1m[0mobject_lock_enabled[0m[0m         = (known after apply)
      [32m+[0m [0m[1m[0mpolicy[0m[0m                      = (known after apply)
      [32m+[0m [0m[1m[0mregion[0m[0m                      = (known after apply)
      [32m+[0m [0m[1m[0mrequest_payer[0m[0m               = (known after apply)
      [32m+[0m [0m[1m[0mtags_all[0m[0m                    = (known after apply)
      [32m+[0m [0m[1m[0mwebsite_domain[0m[0m              = (known after apply)
      [32m+[0m [0m[1m[0mwebsite_endpoint[0m[0m            = (known after apply)

      [32m+[0m [0mcors_rule {
          [32m+[0m [0m[1m[0mallowed_headers[0m[0m = (known after apply)
          [32m+[0m [0m[1m[0mallowed_methods[0m[0m = (known after apply)
          [32m+[0m [0m[1m[0mallowed_origins[0m[0m = (known after apply)
          [32m+[0m [0m[1m[0mexpose_headers[0m[0m  = (known after apply)
          [32m+[0m [0m[1m[0mmax_age_seconds[0m[0m = (known after apply)
        }

      [32m+[0m [0mgrant {
          [32m+[0m [0m[1m[0mid[0m[0m          = (known after apply)
          [32m+[0m [0m[1m[0mpermissions[0m[0m = (known after apply)
          [32m+[0m [0m[1m[0mtype[0m[0m        = (known after apply)
          [32m+[0m [0m[1m[0muri[0m[0m         = (known after apply)
        }

      [32m+[0m [0mlifecycle_rule {
          [32m+[0m [0m[1m[0mabort_incomplete_multipart_upload_days[0m[0m = (known after apply)
          [32m+[0m [0m[1m[0menabled[0m[0m                                = (known after apply)
          [32m+[0m [0m[1m[0mid[0m[0m                                     = (known after apply)
          [32m+[0m [0m[1m[0mprefix[0m[0m                                 = (known after apply)
          [32m+[0m [0m[1m[0mtags[0m[0m                                   = (known after apply)

          [32m+[0m [0mexpiration {
              [32m+[0m [0m[1m[0mdate[0m[0m                         = (known after apply)
              [32m+[0m [0m[1m[0mdays[0m[0m                         = (known after apply)
              [32m+[0m [0m[1m[0mexpired_object_delete_marker[0m[0m = (known after apply)
            }

          [32m+[0m [0mnoncurrent_version_expiration {
              [32m+[0m [0m[1m[0mdays[0m[0m = (known after apply)
            }

          [32m+[0m [0mnoncurrent_version_transition {
              [32m+[0m [0m[1m[0mdays[0m[0m          = (known after apply)
              [32m+[0m [0m[1m[0mstorage_class[0m[0m = (known after apply)
            }

          [32m+[0m [0mtransition {
              [32m+[0m [0m[1m[0mdate[0m[0m          = (known after apply)
              [32m+[0m [0m[1m[0mdays[0m[0m          = (known after apply)
              [32m+[0m [0m[1m[0mstorage_class[0m[0m = (known after apply)
            }
        }

      [32m+[0m [0mlogging {
          [32m+[0m [0m[1m[0mtarget_bucket[0m[0m = (known after apply)
          [32m+[0m [0m[1m[0mtarget_prefix[0m[0m = (known after apply)
        }

      [32m+[0m [0mobject_lock_configuration {
          [32m+[0m [0m[1m[0mobject_lock_enabled[0m[0m = (known after apply)

          [32m+[0m [0mrule {
              [32m+[0m [0mdefault_retention {
                  [32m+[0m [0m[1m[0mdays[0m[0m  = (known after apply)
                  [32m+[0m [0m[1m[0mmode[0m[0m  = (known after apply)
                  [32m+[0m [0m[1m[0myears[0m[0m = (known after apply)
                }
            }
        }

      [32m+[0m [0mreplication_configuration {
          [32m+[0m [0m[1m[0mrole[0m[0m = (known after apply)

          [32m+[0m [0mrules {
              [32m+[0m [0m[1m[0mdelete_marker_replication_status[0m[0m = (known after apply)
              [32m+[0m [0m[1m[0mid[0m[0m                               = (known after apply)
              [32m+[0m [0m[1m[0mprefix[0m[0m                           = (known after apply)
              [32m+[0m [0m[1m[0mpriority[0m[0m                         = (known after apply)
              [32m+[0m [0m[1m[0mstatus[0m[0m                           = (known after apply)

              [32m+[0m [0mdestination {
                  [32m+[0m [0m[1m[0maccount_id[0m[0m         = (known after apply)
                  [32m+[0m [0m[1m[0mbucket[0m[0m             = (known after apply)
                  [32m+[0m [0m[1m[0mreplica_kms_key_id[0m[0m = (known after apply)
                  [32m+[0m [0m[1m[0mstorage_class[0m[0m      = (known after apply)

                  [32m+[0m [0maccess_control_translation {
                      [32m+[0m [0m[1m[0mowner[0m[0m = (known after apply)
                    }

                  [32m+[0m [0mmetrics {
                      [32m+[0m [0m[1m[0mminutes[0m[0m = (known after apply)
                      [32m+[0m [0m[1m[0mstatus[0m[0m  = (known after apply)
                    }

                  [32m+[0m [0mreplication_time {
                      [32m+[0m [0m[1m[0mminutes[0m[0m = (known after apply)
                      [32m+[0m [0m[1m[0mstatus[0m[0m  = (known after apply)
                    }
                }

              [32m+[0m [0mfilter {
                  [32m+[0m [0m[1m[0mprefix[0m[0m = (known after apply)
                  [32m+[0m [0m[1m[0mtags[0m[0m   = (known after apply)
                }

              [32m+[0m [0msource_selection_criteria {
                  [32m+[0m [0msse_kms_encrypted_objects {
                      [32m+[0m [0m[1m[0menabled[0m[0m = (known after apply)
                    }
                }
            }
        }

      [32m+[0m [0mserver_side_encryption_configuration {
          [32m+[0m [0mrule {
              [32m+[0m [0m[1m[0mbucket_key_enabled[0m[0m = (known after apply)

              [32m+[0m [0mapply_server_side_encryption_by_default {
                  [32m+[0m [0m[1m[0mkms_master_key_id[0m[0m = (known after apply)
                  [32m+[0m [0m[1m[0msse_algorithm[0m[0m     = (known after apply)
                }
            }
        }

      [32m+[0m [0mversioning {
          [32m+[0m [0m[1m[0menabled[0m[0m    = (known after apply)
          [32m+[0m [0m[1m[0mmfa_delete[0m[0m = (known after apply)
        }

      [32m+[0m [0mwebsite {
          [32m+[0m [0m[1m[0merror_document[0m[0m           = (known after apply)
          [32m+[0m [0m[1m[0mindex_document[0m[0m           = (known after apply)
          [32m+[0m [0m[1m[0mredirect_all_requests_to[0m[0m = (known after apply)
          [32m+[0m [0m[1m[0mrouting_rules[0m[0m            = (known after apply)
        }
    }

[1m  # aws_s3_bucket_acl.this[0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_s3_bucket_acl" "this" {
      [32m+[0m [0m[1m[0macl[0m[0m    = "private"
      [32m+[0m [0m[1m[0mbucket[0m[0m = (known after apply)
      [32m+[0m [0m[1m[0mid[0m[0m     = (known after apply)

      [32m+[0m [0maccess_control_policy {
          [32m+[0m [0mgrant {
              [32m+[0m [0m[1m[0mpermission[0m[0m = (known after apply)

              [32m+[0m [0mgrantee {
                  [32m+[0m [0m[1m[0mdisplay_name[0m[0m  = (known after apply)
                  [32m+[0m [0m[1m[0memail_address[0m[0m = (known after apply)
                  [32m+[0m [0m[1m[0mid[0m[0m            = (known after apply)
                  [32m+[0m [0m[1m[0mtype[0m[0m          = (known after apply)
                  [32m+[0m [0m[1m[0muri[0m[0m           = (known after apply)
                }
            }

          [32m+[0m [0mowner {
              [32m+[0m [0m[1m[0mdisplay_name[0m[0m = (known after apply)
              [32m+[0m [0m[1m[0mid[0m[0m           = (known after apply)
            }
        }
    }

[1m  # aws_s3_bucket_policy.this[0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_s3_bucket_policy" "this" {
      [32m+[0m [0m[1m[0mbucket[0m[0m = (known after apply)
      [32m+[0m [0m[1m[0mid[0m[0m     = (known after apply)
      [32m+[0m [0m[1m[0mpolicy[0m[0m = (known after apply)
    }

[1m  # aws_s3_bucket_website_configuration.this[0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_s3_bucket_website_configuration" "this" {
      [32m+[0m [0m[1m[0mbucket[0m[0m           = "test_latch"
      [32m+[0m [0m[1m[0mid[0m[0m               = (known after apply)
      [32m+[0m [0m[1m[0mrouting_rules[0m[0m    = (known after apply)
      [32m+[0m [0m[1m[0mwebsite_domain[0m[0m   = (known after apply)
      [32m+[0m [0m[1m[0mwebsite_endpoint[0m[0m = (known after apply)

      [32m+[0m [0merror_document {
          [32m+[0m [0m[1m[0mkey[0m[0m = "index.html"
        }

      [32m+[0m [0mindex_document {
          [32m+[0m [0m[1m[0msuffix[0m[0m = "index.html"
        }

      [32m+[0m [0mrouting_rule {
          [32m+[0m [0mcondition {
              [32m+[0m [0m[1m[0mhttp_error_code_returned_equals[0m[0m = (known after apply)
              [32m+[0m [0m[1m[0mkey_prefix_equals[0m[0m               = (known after apply)
            }

          [32m+[0m [0mredirect {
              [32m+[0m [0m[1m[0mhost_name[0m[0m               = (known after apply)
              [32m+[0m [0m[1m[0mhttp_redirect_code[0m[0m      = (known after apply)
              [32m+[0m [0m[1m[0mprotocol[0m[0m                = (known after apply)
              [32m+[0m [0m[1m[0mreplace_key_prefix_with[0m[0m = (known after apply)
              [32m+[0m [0m[1m[0mreplace_key_with[0m[0m        = (known after apply)
            }
        }
    }

[1m  # aws_security_group.security_group[0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_security_group" "security_group" {
      [32m+[0m [0m[1m[0marn[0m[0m                    = (known after apply)
      [32m+[0m [0m[1m[0mdescription[0m[0m            = "Managed by Terraform"
      [32m+[0m [0m[1m[0megress[0m[0m                 = [
          [32m+[0m [0m{
              [32m+[0m [0mcidr_blocks      = [
                  [32m+[0m [0m"0.0.0.0/0",
                ]
              [32m+[0m [0mdescription      = ""
              [32m+[0m [0mfrom_port        = 0
              [32m+[0m [0mipv6_cidr_blocks = []
              [32m+[0m [0mprefix_list_ids  = []
              [32m+[0m [0mprotocol         = "-1"
              [32m+[0m [0msecurity_groups  = []
              [32m+[0m [0mself             = false
              [32m+[0m [0mto_port          = 0
            },
        ]
      [32m+[0m [0m[1m[0mid[0m[0m                     = (known after apply)
      [32m+[0m [0m[1m[0mingress[0m[0m                = [
          [32m+[0m [0m{
              [32m+[0m [0mcidr_blocks      = [
                  [32m+[0m [0m"0.0.0.0/0",
                ]
              [32m+[0m [0mdescription      = "any"
              [32m+[0m [0mfrom_port        = 0
              [32m+[0m [0mipv6_cidr_blocks = []
              [32m+[0m [0mprefix_list_ids  = []
              [32m+[0m [0mprotocol         = "-1"
              [32m+[0m [0msecurity_groups  = []
              [32m+[0m [0mself             = false
              [32m+[0m [0mto_port          = 0
            },
        ]
      [32m+[0m [0m[1m[0mname[0m[0m                   = "ecs-security-group"
      [32m+[0m [0m[1m[0mname_prefix[0m[0m            = (known after apply)
      [32m+[0m [0m[1m[0mowner_id[0m[0m               = (known after apply)
      [32m+[0m [0m[1m[0mrevoke_rules_on_delete[0m[0m = false
      [32m+[0m [0m[1m[0mtags_all[0m[0m               = (known after apply)
      [32m+[0m [0m[1m[0mvpc_id[0m[0m                 = (known after apply)
    }

[1m  # aws_subnet.subnet[0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_subnet" "subnet" {
      [32m+[0m [0m[1m[0marn[0m[0m                                            = (known after apply)
      [32m+[0m [0m[1m[0massign_ipv6_address_on_creation[0m[0m                = false
      [32m+[0m [0m[1m[0mavailability_zone[0m[0m                              = "us-east-1a"
      [32m+[0m [0m[1m[0mavailability_zone_id[0m[0m                           = (known after apply)
      [32m+[0m [0m[1m[0mcidr_block[0m[0m                                     = "10.0.1.0/24"
      [32m+[0m [0m[1m[0menable_dns64[0m[0m                                   = false
      [32m+[0m [0m[1m[0menable_resource_name_dns_a_record_on_launch[0m[0m    = false
      [32m+[0m [0m[1m[0menable_resource_name_dns_aaaa_record_on_launch[0m[0m = false
      [32m+[0m [0m[1m[0mid[0m[0m                                             = (known after apply)
      [32m+[0m [0m[1m[0mipv6_cidr_block_association_id[0m[0m                 = (known after apply)
      [32m+[0m [0m[1m[0mipv6_native[0m[0m                                    = false
      [32m+[0m [0m[1m[0mmap_public_ip_on_launch[0m[0m                        = true
      [32m+[0m [0m[1m[0mowner_id[0m[0m                                       = (known after apply)
      [32m+[0m [0m[1m[0mprivate_dns_hostname_type_on_launch[0m[0m            = (known after apply)
      [32m+[0m [0m[1m[0mtags_all[0m[0m                                       = (known after apply)
      [32m+[0m [0m[1m[0mvpc_id[0m[0m                                         = (known after apply)
    }

[1m  # aws_subnet.subnet2[0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_subnet" "subnet2" {
      [32m+[0m [0m[1m[0marn[0m[0m                                            = (known after apply)
      [32m+[0m [0m[1m[0massign_ipv6_address_on_creation[0m[0m                = false
      [32m+[0m [0m[1m[0mavailability_zone[0m[0m                              = "us-east-1b"
      [32m+[0m [0m[1m[0mavailability_zone_id[0m[0m                           = (known after apply)
      [32m+[0m [0m[1m[0mcidr_block[0m[0m                                     = "10.0.2.0/24"
      [32m+[0m [0m[1m[0menable_dns64[0m[0m                                   = false
      [32m+[0m [0m[1m[0menable_resource_name_dns_a_record_on_launch[0m[0m    = false
      [32m+[0m [0m[1m[0menable_resource_name_dns_aaaa_record_on_launch[0m[0m = false
      [32m+[0m [0m[1m[0mid[0m[0m                                             = (known after apply)
      [32m+[0m [0m[1m[0mipv6_cidr_block_association_id[0m[0m                 = (known after apply)
      [32m+[0m [0m[1m[0mipv6_native[0m[0m                                    = false
      [32m+[0m [0m[1m[0mmap_public_ip_on_launch[0m[0m                        = true
      [32m+[0m [0m[1m[0mowner_id[0m[0m                                       = (known after apply)
      [32m+[0m [0m[1m[0mprivate_dns_hostname_type_on_launch[0m[0m            = (known after apply)
      [32m+[0m [0m[1m[0mtags_all[0m[0m                                       = (known after apply)
      [32m+[0m [0m[1m[0mvpc_id[0m[0m                                         = (known after apply)
    }

[1m  # aws_vpc.main[0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_vpc" "main" {
      [32m+[0m [0m[1m[0marn[0m[0m                                  = (known after apply)
      [32m+[0m [0m[1m[0mcidr_block[0m[0m                           = "10.0.0.0/16"
      [32m+[0m [0m[1m[0mdefault_network_acl_id[0m[0m               = (known after apply)
      [32m+[0m [0m[1m[0mdefault_route_table_id[0m[0m               = (known after apply)
      [32m+[0m [0m[1m[0mdefault_security_group_id[0m[0m            = (known after apply)
      [32m+[0m [0m[1m[0mdhcp_options_id[0m[0m                      = (known after apply)
      [32m+[0m [0m[1m[0menable_dns_hostnames[0m[0m                 = true
      [32m+[0m [0m[1m[0menable_dns_support[0m[0m                   = true
      [32m+[0m [0m[1m[0menable_network_address_usage_metrics[0m[0m = (known after apply)
      [32m+[0m [0m[1m[0mid[0m[0m                                   = (known after apply)
      [32m+[0m [0m[1m[0minstance_tenancy[0m[0m                     = "default"
      [32m+[0m [0m[1m[0mipv6_association_id[0m[0m                  = (known after apply)
      [32m+[0m [0m[1m[0mipv6_cidr_block[0m[0m                      = (known after apply)
      [32m+[0m [0m[1m[0mipv6_cidr_block_network_border_group[0m[0m = (known after apply)
      [32m+[0m [0m[1m[0mmain_route_table_id[0m[0m                  = (known after apply)
      [32m+[0m [0m[1m[0mowner_id[0m[0m                             = (known after apply)
      [32m+[0m [0m[1m[0mtags[0m[0m                                 = {
          [32m+[0m [0m"name" = "main"
        }
      [32m+[0m [0m[1m[0mtags_all[0m[0m                             = {
          [32m+[0m [0m"name" = "main"
        }
    }

[1m  # module.db.module.db_instance.aws_db_instance.this[0][0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_db_instance" "this" {
      [32m+[0m [0m[1m[0maddress[0m[0m                               = (known after apply)
      [32m+[0m [0m[1m[0mallocated_storage[0m[0m                     = 5
      [32m+[0m [0m[1m[0mallow_major_version_upgrade[0m[0m           = false
      [32m+[0m [0m[1m[0mapply_immediately[0m[0m                     = false
      [32m+[0m [0m[1m[0marn[0m[0m                                   = (known after apply)
      [32m+[0m [0m[1m[0mauto_minor_version_upgrade[0m[0m            = true
      [32m+[0m [0m[1m[0mavailability_zone[0m[0m                     = (known after apply)
      [32m+[0m [0m[1m[0mbackup_retention_period[0m[0m               = (known after apply)
      [32m+[0m [0m[1m[0mbackup_target[0m[0m                         = (known after apply)
      [32m+[0m [0m[1m[0mbackup_window[0m[0m                         = "03:00-06:00"
      [32m+[0m [0m[1m[0mca_cert_identifier[0m[0m                    = (known after apply)
      [32m+[0m [0m[1m[0mcharacter_set_name[0m[0m                    = (known after apply)
      [32m+[0m [0m[1m[0mcopy_tags_to_snapshot[0m[0m                 = false
      [32m+[0m [0m[1m[0mdb_name[0m[0m                               = "demodb"
      [32m+[0m [0m[1m[0mdb_subnet_group_name[0m[0m                  = (known after apply)
      [32m+[0m [0m[1m[0mdelete_automated_backups[0m[0m              = true
      [32m+[0m [0m[1m[0mdeletion_protection[0m[0m                   = true
      [32m+[0m [0m[1m[0mendpoint[0m[0m                              = (known after apply)
      [32m+[0m [0m[1m[0mengine[0m[0m                                = "mysql"
      [32m+[0m [0m[1m[0mengine_version[0m[0m                        = "5.7"
      [32m+[0m [0m[1m[0mengine_version_actual[0m[0m                 = (known after apply)
      [32m+[0m [0m[1m[0mfinal_snapshot_identifier[0m[0m             = (known after apply)
      [32m+[0m [0m[1m[0mhosted_zone_id[0m[0m                        = (known after apply)
      [32m+[0m [0m[1m[0miam_database_authentication_enabled[0m[0m   = true
      [32m+[0m [0m[1m[0mid[0m[0m                                    = (known after apply)
      [32m+[0m [0m[1m[0midentifier[0m[0m                            = "testlatch"
      [32m+[0m [0m[1m[0midentifier_prefix[0m[0m                     = (known after apply)
      [32m+[0m [0m[1m[0minstance_class[0m[0m                        = "db.t3a.large"
      [32m+[0m [0m[1m[0miops[0m[0m                                  = (known after apply)
      [32m+[0m [0m[1m[0mkms_key_id[0m[0m                            = (known after apply)
      [32m+[0m [0m[1m[0mlatest_restorable_time[0m[0m                = (known after apply)
      [32m+[0m [0m[1m[0mlicense_model[0m[0m                         = (known after apply)
      [32m+[0m [0m[1m[0mlistener_endpoint[0m[0m                     = (known after apply)
      [32m+[0m [0m[1m[0mmaintenance_window[0m[0m                    = "mon:00:00-mon:03:00"
      [32m+[0m [0m[1m[0mmanage_master_user_password[0m[0m           = true
      [32m+[0m [0m[1m[0mmaster_user_secret[0m[0m                    = (known after apply)
      [32m+[0m [0m[1m[0mmaster_user_secret_kms_key_id[0m[0m         = (known after apply)
      [32m+[0m [0m[1m[0mmax_allocated_storage[0m[0m                 = 0
      [32m+[0m [0m[1m[0mmonitoring_interval[0m[0m                   = 30
      [32m+[0m [0m[1m[0mmonitoring_role_arn[0m[0m                   = (known after apply)
      [32m+[0m [0m[1m[0mmulti_az[0m[0m                              = false
      [32m+[0m [0m[1m[0mnchar_character_set_name[0m[0m              = (known after apply)
      [32m+[0m [0m[1m[0mnetwork_type[0m[0m                          = (known after apply)
      [32m+[0m [0m[1m[0moption_group_name[0m[0m                     = (known after apply)
      [32m+[0m [0m[1m[0mparameter_group_name[0m[0m                  = (known after apply)
      [32m+[0m [0m[1m[0mperformance_insights_enabled[0m[0m          = false
      [32m+[0m [0m[1m[0mperformance_insights_kms_key_id[0m[0m       = (known after apply)
      [32m+[0m [0m[1m[0mperformance_insights_retention_period[0m[0m = (known after apply)
      [32m+[0m [0m[1m[0mport[0m[0m                                  = 3306
      [32m+[0m [0m[1m[0mpublicly_accessible[0m[0m                   = false
      [32m+[0m [0m[1m[0mreplica_mode[0m[0m                          = (known after apply)
      [32m+[0m [0m[1m[0mreplicas[0m[0m                              = (known after apply)
      [32m+[0m [0m[1m[0mresource_id[0m[0m                           = (known after apply)
      [32m+[0m [0m[1m[0mskip_final_snapshot[0m[0m                   = false
      [32m+[0m [0m[1m[0msnapshot_identifier[0m[0m                   = (known after apply)
      [32m+[0m [0m[1m[0mstatus[0m[0m                                = (known after apply)
      [32m+[0m [0m[1m[0mstorage_encrypted[0m[0m                     = true
      [32m+[0m [0m[1m[0mstorage_throughput[0m[0m                    = (known after apply)
      [32m+[0m [0m[1m[0mstorage_type[0m[0m                          = (known after apply)
      [32m+[0m [0m[1m[0mtags[0m[0m                                  = {
          [32m+[0m [0m"Environment" = "dev"
          [32m+[0m [0m"Owner"       = "user"
        }
      [32m+[0m [0m[1m[0mtags_all[0m[0m                              = {
          [32m+[0m [0m"Environment" = "dev"
          [32m+[0m [0m"Owner"       = "user"
        }
      [32m+[0m [0m[1m[0mtimezone[0m[0m                              = (known after apply)
      [32m+[0m [0m[1m[0musername[0m[0m                              = "user"
      [32m+[0m [0m[1m[0mvpc_security_group_ids[0m[0m                = [
          [32m+[0m [0m"sg-12345678",
        ]

      [32m+[0m [0mtimeouts {}
    }

[1m  # module.db.module.db_instance.aws_iam_role.enhanced_monitoring[0][0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_iam_role" "enhanced_monitoring" {
      [32m+[0m [0m[1m[0marn[0m[0m                   = (known after apply)
      [32m+[0m [0m[1m[0massume_role_policy[0m[0m    = jsonencode(
            {
              [32m+[0m [0mStatement = [
                  [32m+[0m [0m{
                      [32m+[0m [0mAction    = "sts:AssumeRole"
                      [32m+[0m [0mEffect    = "Allow"
                      [32m+[0m [0mPrincipal = {
                          [32m+[0m [0mService = "monitoring.rds.amazonaws.com"
                        }
                    },
                ]
              [32m+[0m [0mVersion   = "2012-10-17"
            }
        )
      [32m+[0m [0m[1m[0mcreate_date[0m[0m           = (known after apply)
      [32m+[0m [0m[1m[0mforce_detach_policies[0m[0m = false
      [32m+[0m [0m[1m[0mid[0m[0m                    = (known after apply)
      [32m+[0m [0m[1m[0mmanaged_policy_arns[0m[0m   = (known after apply)
      [32m+[0m [0m[1m[0mmax_session_duration[0m[0m  = 3600
      [32m+[0m [0m[1m[0mname[0m[0m                  = "MyRDSMonitoringRole"
      [32m+[0m [0m[1m[0mname_prefix[0m[0m           = (known after apply)
      [32m+[0m [0m[1m[0mpath[0m[0m                  = "/"
      [32m+[0m [0m[1m[0mtags[0m[0m                  = {
          [32m+[0m [0m"Environment" = "dev"
          [32m+[0m [0m"Name"        = "MyRDSMonitoringRole"
          [32m+[0m [0m"Owner"       = "user"
        }
      [32m+[0m [0m[1m[0mtags_all[0m[0m              = {
          [32m+[0m [0m"Environment" = "dev"
          [32m+[0m [0m"Name"        = "MyRDSMonitoringRole"
          [32m+[0m [0m"Owner"       = "user"
        }
      [32m+[0m [0m[1m[0munique_id[0m[0m             = (known after apply)

      [32m+[0m [0minline_policy {
          [32m+[0m [0m[1m[0mname[0m[0m   = (known after apply)
          [32m+[0m [0m[1m[0mpolicy[0m[0m = (known after apply)
        }
    }

[1m  # module.db.module.db_instance.aws_iam_role_policy_attachment.enhanced_monitoring[0][0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_iam_role_policy_attachment" "enhanced_monitoring" {
      [32m+[0m [0m[1m[0mid[0m[0m         = (known after apply)
      [32m+[0m [0m[1m[0mpolicy_arn[0m[0m = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
      [32m+[0m [0m[1m[0mrole[0m[0m       = "MyRDSMonitoringRole"
    }

[1m  # module.db.module.db_instance.random_id.snapshot_identifier[0][0m will be created[0m[0m
[0m  [32m+[0m[0m resource "random_id" "snapshot_identifier" {
      [32m+[0m [0m[1m[0mb64_std[0m[0m     = (known after apply)
      [32m+[0m [0m[1m[0mb64_url[0m[0m     = (known after apply)
      [32m+[0m [0m[1m[0mbyte_length[0m[0m = 4
      [32m+[0m [0m[1m[0mdec[0m[0m         = (known after apply)
      [32m+[0m [0m[1m[0mhex[0m[0m         = (known after apply)
      [32m+[0m [0m[1m[0mid[0m[0m          = (known after apply)
      [32m+[0m [0m[1m[0mkeepers[0m[0m     = {
          [32m+[0m [0m"id" = "testlatch"
        }
    }

[1m  # module.db.module.db_option_group.aws_db_option_group.this[0][0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_db_option_group" "this" {
      [32m+[0m [0m[1m[0marn[0m[0m                      = (known after apply)
      [32m+[0m [0m[1m[0mengine_name[0m[0m              = "mysql"
      [32m+[0m [0m[1m[0mid[0m[0m                       = (known after apply)
      [32m+[0m [0m[1m[0mmajor_engine_version[0m[0m     = "5.7"
      [32m+[0m [0m[1m[0mname[0m[0m                     = (known after apply)
      [32m+[0m [0m[1m[0mname_prefix[0m[0m              = "testlatch-"
      [32m+[0m [0m[1m[0moption_group_description[0m[0m = "testlatch option group"
      [32m+[0m [0m[1m[0mtags[0m[0m                     = {
          [32m+[0m [0m"Environment" = "dev"
          [32m+[0m [0m"Name"        = "testlatch"
          [32m+[0m [0m"Owner"       = "user"
        }
      [32m+[0m [0m[1m[0mtags_all[0m[0m                 = {
          [32m+[0m [0m"Environment" = "dev"
          [32m+[0m [0m"Name"        = "testlatch"
          [32m+[0m [0m"Owner"       = "user"
        }

      [32m+[0m [0moption {
          [32m+[0m [0m[1m[0mdb_security_group_memberships[0m[0m  = []
          [32m+[0m [0m[1m[0moption_name[0m[0m                    = "MARIADB_AUDIT_PLUGIN"
          [32m+[0m [0m[1m[0mvpc_security_group_memberships[0m[0m = []

          [32m+[0m [0moption_settings {
              [32m+[0m [0m[1m[0mname[0m[0m  = "SERVER_AUDIT_EVENTS"
              [32m+[0m [0m[1m[0mvalue[0m[0m = "CONNECT"
            }
          [32m+[0m [0moption_settings {
              [32m+[0m [0m[1m[0mname[0m[0m  = "SERVER_AUDIT_FILE_ROTATIONS"
              [32m+[0m [0m[1m[0mvalue[0m[0m = "37"
            }
        }

      [32m+[0m [0mtimeouts {}
    }

[1m  # module.db.module.db_parameter_group.aws_db_parameter_group.this[0][0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_db_parameter_group" "this" {
      [32m+[0m [0m[1m[0marn[0m[0m         = (known after apply)
      [32m+[0m [0m[1m[0mdescription[0m[0m = "testlatch parameter group"
      [32m+[0m [0m[1m[0mfamily[0m[0m      = "mysql5.7"
      [32m+[0m [0m[1m[0mid[0m[0m          = (known after apply)
      [32m+[0m [0m[1m[0mname[0m[0m        = (known after apply)
      [32m+[0m [0m[1m[0mname_prefix[0m[0m = "testlatch-"
      [32m+[0m [0m[1m[0mtags[0m[0m        = {
          [32m+[0m [0m"Environment" = "dev"
          [32m+[0m [0m"Name"        = "testlatch"
          [32m+[0m [0m"Owner"       = "user"
        }
      [32m+[0m [0m[1m[0mtags_all[0m[0m    = {
          [32m+[0m [0m"Environment" = "dev"
          [32m+[0m [0m"Name"        = "testlatch"
          [32m+[0m [0m"Owner"       = "user"
        }

      [32m+[0m [0mparameter {
          [32m+[0m [0m[1m[0mapply_method[0m[0m = "immediate"
          [32m+[0m [0m[1m[0mname[0m[0m         = "character_set_client"
          [32m+[0m [0m[1m[0mvalue[0m[0m        = "utf8mb4"
        }
      [32m+[0m [0mparameter {
          [32m+[0m [0m[1m[0mapply_method[0m[0m = "immediate"
          [32m+[0m [0m[1m[0mname[0m[0m         = "character_set_server"
          [32m+[0m [0m[1m[0mvalue[0m[0m        = "utf8mb4"
        }
    }

[1m  # module.db.module.db_subnet_group.aws_db_subnet_group.this[0][0m will be created[0m[0m
[0m  [32m+[0m[0m resource "aws_db_subnet_group" "this" {
      [32m+[0m [0m[1m[0marn[0m[0m                     = (known after apply)
      [32m+[0m [0m[1m[0mdescription[0m[0m             = "testlatch subnet group"
      [32m+[0m [0m[1m[0mid[0m[0m                      = (known after apply)
      [32m+[0m [0m[1m[0mname[0m[0m                    = (known after apply)
      [32m+[0m [0m[1m[0mname_prefix[0m[0m             = "testlatch-"
      [32m+[0m [0m[1m[0msubnet_ids[0m[0m              = [
          [32m+[0m [0m"subnet-12345678",
          [32m+[0m [0m"subnet-87654321",
        ]
      [32m+[0m [0m[1m[0msupported_network_types[0m[0m = (known after apply)
      [32m+[0m [0m[1m[0mtags[0m[0m                    = {
          [32m+[0m [0m"Environment" = "dev"
          [32m+[0m [0m"Name"        = "testlatch"
          [32m+[0m [0m"Owner"       = "user"
        }
      [32m+[0m [0m[1m[0mtags_all[0m[0m                = {
          [32m+[0m [0m"Environment" = "dev"
          [32m+[0m [0m"Name"        = "testlatch"
          [32m+[0m [0m"Owner"       = "user"
        }
      [32m+[0m [0m[1m[0mvpc_id[0m[0m                  = (known after apply)
    }

[0m[1mPlan:[0m 37 to add, 0 to change, 0 to destroy.
[0m[0m
[1mChanges to Outputs:[0m[0m
  [32m+[0m [0m[1m[0maccount_id[0m[0m  = "476795228417"
  [32m+[0m [0m[1m[0mcaller_arn[0m[0m  = "arn:aws:iam::476795228417:user/fabio.palumbo"
  [32m+[0m [0m[1m[0mcaller_user[0m[0m = "AIDAW6AZV2EASH7BOWXHE"
[90m
─────────────────────────────────────────────────────────────────────────────[0m

Note: You didn't use the -out option to save this plan, so Terraform can't
guarantee to take exactly these actions if you run "terraform apply" now.

```
</details>

## Networking

We have created  1 Network(VPC)with 2 subnets.

4 Subnets of 256 ips (two public, two private with Internet access)


```
public-subnets ["10.0.0.0/24", "10.0.0.0/24"]

pruvate-subnets ["10.0.0.0/24", "10.0.0.0/24"]

```

## Testing 
```
```


## Observabilidad

Consideraremos las siguientes métricas.
```
* Escalabilidad
* Fiabilidad
* Disponibilidad
* Latencia
* Fexibilidad
```



## Monitoreo y alertas

Usaremos Cloudwatch para monitorear Cloudfront y ECS Metrics *utilizando las 4 Golden Signals

Key metrics para monitoreo Cloudwatch de Api Gateway
```
Latency
4XX Error
5XX Error
Saturation
```
Key metrics para monitoreo ECS+EC2
```
1. 5XX Error
2. 4XX Error
3. Service health status.
4. CPU
5. Memory
```

## Automatización CICD

![texto alternativo](/images/cicd.png "CICD")

Usar una herramienta CI/CD (es decir, aGithub Actions)
```
1. El CICD revisará el Código mediante Sonarqube.
2. El uso de las funciones de Terraform Github Actions ejecutará terraform fmt/validate/plan.
3. Se realizara el Docker Build de las aplicaciones (por simplicidad, pero consideramos que a futuro estos fluos seran separados)
3. Actualiza la task definition con una nueva versión si es necesario.
4. La CICD publicará el plan terraforma en PR
5. Después de que el PR se mergea en main, el CICD ejecutará Terraform Apply
```

## Permisos

Toda la autenticación de la infraestructura está controlada por los roles de IAM.

Usaremos el principio de Least Priviledge
```
1. Crearemos roles de IAM específicos para ApiGateway para acceder solo al recurso backend.
2. El bucket S3 estará restringido y la ACL estará configurada como privada.
3. Business Logic se implementará en la capa privada
```

## Informe de cálculo
![texto alternativo](/images/estimate.png "Estimación de precios de AWS")

Lo anterior se generó usando https://calculator.aws/#/. Es una aproximación para un uso intensivo de 100 millones de solicitudes por mes.