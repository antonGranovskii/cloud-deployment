resource "aws_launch_template" "eks_node_lt" {
  name_prefix = "eks-${var.env}-node-template-"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = var.eks_volume_size
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }

  vpc_security_group_ids = [aws_security_group.worker.id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      "Name"                                      = "eks-${var.eks_name}"
      "kubernetes.io/cluster/${var.eks_name}" = "owned"
    }
  }


  lifecycle {
    create_before_destroy = true
  }
}