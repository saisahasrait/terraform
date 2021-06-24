# This task is to create a high available cluster of web servers
# Steps:
1. Create an Auto Scaling Group with minimum 2 and maximum 10 instances
2. As there are a multiple web servers, to provide a single IP address
   create an Application Load Balancer and point it to ASG

1. The first step in creating an ASG is to create a launch configuration, which specifies how to configure each EC2 Instance in the ASG.

aws_launch_configuration resource uses almost the same parameters as the aws_instance resource.
and two of the parameters have different names (ami is now image_id and vpc_security_group_ids is now security_groups).

2. Now you can create the ASG itself using the aws_autoscaling_group resource.

 Note that the ASG uses a reference to fill in the launch configuration name. This leads to a problem: launch configurations are immutable, so if you change any parameter of your launch configuration, Terraform will try to replace it. Normally, when replacing a resource, Terraform deletes the old resource first and then creates its replacement, but because your ASG now has a reference to the old resource, Terraform won’t be able to delete it.

 To solve this problem, you can use a lifecycle setting. If you set create_before_destroy to true, Terraform will invert the order in which it replaces resources, creating the replacement resource first (including updating any references that were pointing at the old resource to point to the replacement) and then deleting the old resource.

3. Deploy the load balancer
    1. The first step is to create the ALB itself using the aws_lb resource
    2. The first step is to create the ALB itself using the aws_lb resource
4. Next, you need to create a target group for your ASG using the aws_lb_target_group resource
5. Go back to the aws_autoscaling_group resource and set its target_group_arns argument to point at your new target group
6. Finally, it’s time to tie all these pieces together by creating listener rules using the aws_lb_listener_rule resource