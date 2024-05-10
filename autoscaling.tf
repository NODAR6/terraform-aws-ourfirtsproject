resource "aws_launch_template" "projecttemplate" {
  name_prefix   = "projecttemplate-launch-template"
  image_id      = "ami-07caf09b362be10b8" 
  instance_type = "t2.large"   
  key_name      = "local"   

}



resource "aws_autoscaling_group" "example" {
  name = "projecttemplate-asg"

  launch_template {
    id = aws_launch_template.projecttemplate.id
  }

  min_size             = 1
  max_size             = 5
  desired_capacity     = 1  
  health_check_type    = "EC2"
  health_check_grace_period = 300  
  
}