resource "aws_db_instance" "writer" {
  allocated_storage      = 10
  db_subnet_group_name   = aws_db_subnet_group.subnetgroup.id
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.small"
  multi_az               = true
  
  username               = "username"
  password               = "password"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.projectsec.id]
}


  # db_subnet_group_name = OUR!!! #chaange
  



resource "aws_db_instance" "reader1" {
  allocated_storage      = 10
  db_subnet_group_name   = aws_db_subnet_group.subnetgroup.id
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.small"
  multi_az               = true
  
  username               = "username"
  password               = "password"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.projectsec.id]


  # db_subnet_group_name = OUR!!!#change
 
  # read_replica_source_db_instance_identifier = aws_db_instance.writer.id
}



