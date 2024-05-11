# Create RDS Cluster
resource "aws_rds_cluster" "wordpress_rds_cluster" {
  cluster_identifier      = "wordpress-rds-cluster"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.03.2"
  availability_zones      = ["us-west-2a", "us-west-2b", "us-west-2c"]
  database_name           = "wordpressdb"
  master_username         = "admin"
  master_password         = "your_master_password"  # Replace with your master password
  backup_retention_period = 7
  preferred_backup_window = "07:00-09:00"

  # Configure Writer
  writer {
    instance_type         = "db.t3.small"
  }

  # Configure Readers
  reader {
    instance_type         = "db.t3.small"
  }
  reader {
    instance_type         = "db.t3.small"
  }
  reader {
    instance_type         = "db.t3.small"
  }
}

# Create DNS records for RDS endpoints
resource "aws_route53_record" "writer_dns" {
  zone_id = var.hosted_zone_id
  name    = "writer.ourproject.link"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_rds_cluster.wordpress_rds_cluster.endpoint]
}

resource "aws_route53_record" "reader1_dns" {
  zone_id = var.hosted_zone_id
  name    = "reader1.ourproject.link"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_rds_cluster.wordpress_rds_cluster.reader_endpoint]
}

resource "aws_route53_record" "reader2_dns" {
  zone_id = var.hosted_zone_id
  name    = "reader2.ourproject.link"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_rds_cluster.wordpress_rds_cluster.reader_endpoint]
}

resource "aws_route53_record" "reader3_dns" {
  zone_id = var.hosted_zone_id
  name    = "reader3.ourproject.link"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_rds_cluster.wordpress_rds_cluster.reader_endpoint]
}
