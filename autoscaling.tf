# Create Launch Template
resource "aws_launch_template" "projecttemplate" {
  name_prefix   = "projecttemplate-launch-template"
  image_id      = "ami-07caf09b362be10b8"
  instance_type = "t2.large"
  key_name      = "local"
  
  
  user_data = base64encode(<<EOF
    #!/bin/bash
    apt update -y
    apt install -y apache2 php php-mysql
    systemctl start apache2
    systemctl enable apache2
    wget -c https://wordpress.org/latest.tar.gz
    tar -xvzf latest.tar.gz -C /var/www/html
    cp -r /var/www/html/wordpress/* /var/www/html/
    chown -R www-data:www-data /var/www/html/
EOF
  )
}


#_________________________________________________________________________________



# Create Auto Scaling Group
resource "aws_autoscaling_group" "asg" {
  name = "projecttemplate-asg"
 
  launch_template {
    id      = aws_launch_template.projecttemplate.id
    version = "$Latest"  
  }

  min_size             = 1
  max_size             = 5
  desired_capacity     = 1
  health_check_type    = "EC2"
  health_check_grace_period = 300
 
  vpc_zone_identifier = concat(aws_subnet.public[*].id, aws_subnet.private[*].id)
}



#__________________________________________________________________________




# Create an ALB
resource "aws_lb" "wordpress_alb" {
  name               = "wordpress-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.projectsec1.id]  
  subnets            = aws_subnet.public[*].id     
  tags = {
    Name = "WordPressALB"
  }
}
