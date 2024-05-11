resource "aws_db_instance" "writer" {
  allocated_storage    = 10
  db_name              = "writer_db"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  name                 = "writer"
  username             = "admin"
  password             = "admin123"
  parameter_group_name = "default.mysql8.0"
  publicly_accessible   = false
  vpc_security_group_ids = OUR !!!#change
  db_subnet_group_name = OUR!!! #chaange
  skip_final_snapshot  = true
}


resource "aws_db_instance" "reader1" {
  allocated_storage    = 10
  db_name              = "writer_db"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  name                 = "writer"
  username             = "admin"
  password             = "admin123"
  parameter_group_name = "default.mysql8.0"
  publicly_accessible   = false
  vpc_security_group_ids = OUR !!! #change
  db_subnet_group_name = OUR!!!#change
  skip_final_snapshot  = true

  read_replica_source_db_instance_identifier = aws_db_instance.writer.id
}

