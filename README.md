# terraform-aws-ecs-app-nlb

[![Lint Status](https://github.com/DNXLabs/terraform-aws-ecs-app-nlb/workflows/Lint/badge.svg)](https://github.com/DNXLabs/terraform-aws-ecs-app-nlb/actions)
[![LICENSE](https://img.shields.io/github/license/DNXLabs/terraform-aws-ecs-app-nlb)](https://github.com/DNXLabs/terraform-aws-ecs-app-nlb/blob/master/LICENSE)

This terraform module is an AWS ECS Application Module that creates a Networking LoadBalance Application setup on ECS.

This module is designed to be used with `DNXLabs/terraform-aws-ecs` (https://github.com/DNXLabs/terraform-aws-ecs).

The following resources will be created:

 - Cloudwatch Metrics alarm - Provides a CloudWatch Metric Alarm resource.
 - IAM roles - The cloudwatch event needs an IAM Role to run the ECS task definition. A role is created and a policy will be granted via IAM policy.
 - IAM policy - Policy to be attached to the IAM Role. This policy will have a trust with the cloudwatch event service. And it will use the managed policy `AmazonEC2ContainerServiceEventsRole` created by AWS.
 - Security Groups for the ECS nodes
 - Simple Notification Service (SNS) topics - Alarm topics to create and alert on ECS service metrics. Leaving empty disables all alarms.
 - Auto Scaling
    - You can specify the max number of containers to scale with autoscaling. The default is 4
    - You can specify the nin number of containers to scale with autoscaling. The default is 1
    - Cooldown in seconds to wait between scale in events. The default is 300
    - Cooldown in seconds to wait between scale out events. The default is 300
 - Cloudwatch Log Groups
 - Network Load Balancer (NLB)
 - ECS task definition - A task definition is required to run Docker containers in Amazon ECS. Some of the parameters you can specify in a task definition include:
      - Image - Docker image to deploy
           - Default value = "dnxsolutions/nginx-hello:latest"
      - CPU - Hard limit of the CPU for the container
           -  Default Value = 0
      - Memory - Hard memory of the container
           -  Default Value = 512
      - Name - Name of the ECS Service
      - Set log configuration

 - ECS Task-scheduler activated by cloudwatch events

In addition you have the option to create or not :
 - Autoscaling
     - Enables or not autoscaling based on average CPU tracking
     - Target average CPU percentage to track for autoscaling
 - A Hostname to create DNS record for this app

<!--- BEGIN_TF_DOCS --->

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alarm\_prefix | String prefix for cloudwatch alarms. (Optional, leave blank to use iam\_account\_alias) | `string` | `""` | no |
| alarm\_sns\_topics | Alarm topics to create and alert on ECS service metrics | `list` | `[]` | no |
| assign\_public\_ip | Configures ECS Service to assign public IP (Fargate Only) | `bool` | `false` | no |
| autoscaling\_cpu | Enables autoscaling based on average CPU tracking | `bool` | `false` | no |
| autoscaling\_max | Max number of containers to scale with autoscaling | `number` | `4` | no |
| autoscaling\_min | Min number of containers to scale with autoscaling | `number` | `1` | no |
| autoscaling\_scale\_in\_cooldown | Cooldown in seconds to wait between scale in events | `number` | `300` | no |
| autoscaling\_scale\_out\_cooldown | Cooldown in seconds to wait between scale out events | `number` | `300` | no |
| autoscaling\_target\_cpu | Target average CPU percentage to track for autoscaling | `number` | `50` | no |
| cluster\_name | n/a | `string` | `"Name of existing ECS Cluster to deploy this app to"` | no |
| container\_port | Port your container listens (used in the placeholder task definition) | `string` | `"8080"` | no |
| cpu | Hard limit for CPU for the container | `string` | `"0"` | no |
| fargate\_spot | Set true to use FARGATE\_SPOT capacity provider by default (only when launch\_type=FARGATE) | `bool` | `false` | no |
| hosted\_zone | Hosted Zone to create DNS record for this app | `string` | `""` | no |
| hostname | Hostname to create DNS record for this app | `string` | `""` | no |
| hostname\_create | Optional parameter to create or not a Route53 record | `string` | `"true"` | no |
| image | Docker image to deploy (can be a placeholder) | `string` | `"dnxsolutions/nginx-hello:latest"` | no |
| launch\_type | The launch type on which to run your service. The valid values are EC2 and FARGATE. Defaults to EC2. | `string` | `"EC2"` | no |
| memory | Hard memory of the container | `string` | `"512"` | no |
| name | Name of your ECS service | `any` | n/a | yes |
| network\_mode | The Docker networking mode to use for the containers in the task. The valid values are none, bridge, awsvpc, and host. (REQUIRED IF 'LAUCH\_TYPE' IS FARGATE) | `any` | `null` | no |
| nlb\_arn | Networking LoadBalance ARN - Required if nlb=false or nlb\_internal=false | `string` | `""` | no |
| nlb\_internal | Creates an Internal NLB for this service | `bool` | `false` | no |
| ordered\_placement\_strategy | Service level strategy rules that are taken into consideration during task placement. List from top to bottom in order of precedence. The maximum number of ordered\_placement\_strategy blocks is 5. | <pre>list(object({<br>    field      = string<br>    expression = string<br>  }))</pre> | `[]` | no |
| placement\_constraints | Rules that are taken into consideration during task placement. Maximum number of placement\_constraints is 10. | <pre>list(object({<br>    type       = string<br>    expression = string<br>  }))</pre> | `[]` | no |
| port | Port for target group to listen | `string` | `"80"` | no |
| security\_groups | The security groups associated with the task or service | `any` | `null` | no |
| service\_health\_check\_grace\_period\_seconds | Time until your container starts serving requests | `number` | `0` | no |
| service\_role\_arn | Existing service role ARN created by ECS cluster module | `any` | n/a | yes |
| subnets | The subnets associated with the task or service. (REQUIRED IF 'LAUCH\_TYPE' IS FARGATE) | `any` | `null` | no |
| task\_role\_arn | Existing task role ARN created by ECS cluster module | `any` | n/a | yes |
| vpc\_id | VPC ID to deploy this app to | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| aws\_cloudwatch\_log\_group\_arn | n/a |

<!--- END_TF_DOCS --->

## Authors

Module managed by [DNX Solutions](https://github.com/DNXLabs).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/DNXLabs/terraform-aws-ecs-app-nlb/blob/master/LICENSE) for full details.
