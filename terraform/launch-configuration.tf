resource "aws_launch_configuration" "ecs-launch-rockstar-configuration" { 
    name                        = "ecs-launch-rockstar-configuration" 
    image_id                    = "ami-fad25980" 
    instance_type               = "t2.xlarge" 
    iam_instance_profile        = "${aws_iam_instance_profile.ecs-instance-profiletf.id}" 
     
    root_block_device { 
      volume_type = "standard" 
      volume_size = 100 
      delete_on_termination = true 
    } 
 
    lifecycle { 
      create_before_destroy = true 
    } 
 
    security_groups             = ["${aws_security_group.test_public_sg.id}"] 
    associate_public_ip_address = "true" 
    key_name                    = "${var.ecs_key_pair_name}" 
  user_data = base64encode(<<EOF
#!/bin/bash
echo ECS_CLUSTER=${var.ecs_cluster} >> /etc/ecs/ecs.config
EOF
  )
} 
 



# resource "aws_launch_template" "ecs_launch_template" {
#   name_prefix                 = var.launch_configuration_name
#   image_id                    = var.ami_id
#   instance_type               = var.instance_type
#   key_name                    = var.ecs_key_pair_name

#   iam_instance_profile {
#     name = aws_iam_instance_profile.ecs-instance-profile-tf.name
#   }

#   block_device_mappings {
#     device_name = "/dev/xvda"
#     ebs {
#       volume_size = var.root_volume_size
#       volume_type = var.root_volume_type
#       delete_on_termination = true
#     }
#   }

#   network_interfaces {
#     associate_public_ip_address = true
#     security_groups             = [aws_security_group.test_public_sg.id]
#   }

#   user_data = base64encode(<<EOF
# #!/bin/bash
# echo ECS_CLUSTER=${var.ecs_cluster} >> /etc/ecs/ecs.config
# EOF
#   )

#   tag_specifications {
#     resource_type = "instance"
#     tags = {
#       Name = var.launch_configuration_name
#     }
#   }
# }
