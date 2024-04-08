
output "dns_name_for_clixx" {
  value = aws_route53_record.clixxrecord.name
  description = "The DNS name of the Route 53 A record"
}

output "rds_instance_endpoint_forclixx" {
  description = "The connection endpoint for the RDS instance"
  value       = aws_db_instance.CLIXX_DB.endpoint
}

output "dns_name_for_myblog" {
  value = aws_route53_record.blogrecord.name
  description = "The DNS name of the Route 53 A record"
}


output "rds_instance_endpoint_for_myblog" {
  description = "The connection endpoint for the RDS instance"
  value       = aws_db_instance.blog_DB.endpoint
}

output "hosted_zone_id_for_clixx" {
  value = aws_route53_zone.clixx.zone_id
}

output "hosted_zone_id_for_blog" {
  value = aws_route53_zone.blog.zone_id
}




