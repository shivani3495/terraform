
resource "aws_launch_configuration" "launch_config" {
  name          = "web_config"
  image_id      = lookup(var.ami_id, "ap-south-1")
  instance_type = "t2.micro"
  key_name      = var.key_name
  security_groups = [ var.security_group_id]
}

resource "aws_autoscaling_group" "first_autoscaling" {
  name                      = "autoscaling-terraform-test"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 1
  force_delete              = true
  launch_configuration      = aws_launch_configuration.launch_config.name
  availability_zones        = ["ap-south-1a","ap-south-1b","ap-south-1c"]
}

resource "aws_autoscaling_policy" "autopolicy" {
  name                   = "autopolicy-terraform-test"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  policy_type            = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.first_autoscaling.name
}


resource "aws_sns_topic" "user_updates" {
  name = "user-updates-topic"
  display_name = "example auto scaling"
}

resource "aws_autoscaling_notification" "example_notifications" {
  group_names = [
    aws_autoscaling_group.first_autoscaling.name]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]
   topic_arn = aws_sns_topic.user_updates.arn
}