
#  Create templates



resource "aws_launch_template" "projecttemplate" {
  name_prefix   = "projecttemplate-launch-template"
  image_id      = "ami-04b70fa74e45c3917" 
  instance_type = "t2.large"   
  key_name      = "local"   
   user_data = <<-EOF
    #!/bin/bash
   apt update
   apt install apache2 -y
   systemctl start apache2
   systemctl enable apache2
    EOF
}


# Create auto scaling

resource "aws_autoscaling_group" "asg" {
  name = "projecttemplate-asg"

  launch_template {
    id = aws_launch_template.projecttemplate.id
    # vesrion = "$Latest"
  }

  min_size             = 1
  max_size             = 5
  desired_capacity     = 1  
  health_check_type    = "EC2"
  health_check_grace_period = 300  
  
}



# Create an ALB



resource "aws_lb" "wordpress_alb" {
  name               = "wordpress-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-12345678"]       # needt to change
  subnets            = concat(aws_subnet.public[*].id, aws_subnet.private[*].id)

  tags = {
    Name = "WordPressALB"
  }
}