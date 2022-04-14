output "hostname" {
  value = "${aws_db_instance.default.endpoint}"
}
output "connection_string" {
  value = "Server=${aws_db_instance.default.address};Port=${aws_db_instance.default.port};Database=${var.db_name};Uid=${var.username};Pwd=${var.password};"
}