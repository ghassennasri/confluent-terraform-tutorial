output "Webserver-Public-IP" {
  value = aws_instance.app_server.public_ip
}
output "url" {
  description = "Browser URL for container site"
  value       = "http://${aws_instance.app_server.public_ip}"
}