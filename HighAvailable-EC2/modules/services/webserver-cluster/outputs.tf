output "alb_dns_name" {
  value       = aws_lb.myELB.dns_name
  description = "The domain name of the load balancer"
}
output "asg_name" {
  value       = aws_autoscaling_group.myASG.name
  description = "The name of the Auto Scaling Group"
}