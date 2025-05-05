resource "aws_vpc_security_group_egress_rule" "cluster_to_workers_https" {
  security_group_id            = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  referenced_security_group_id = aws_security_group.worker.id
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"

  depends_on = [aws_eks_cluster.this]
}


resource "aws_vpc_security_group_egress_rule" "cluster_to_workers_kubelet" {
  security_group_id            = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  referenced_security_group_id = aws_security_group.worker.id
  from_port                    = 10250
  to_port                      = 10250
  ip_protocol                  = "tcp"

  depends_on = [aws_eks_cluster.this]
}

resource "aws_vpc_security_group_egress_rule" "cluster_to_workers_dns_tcp" {
  security_group_id            = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  referenced_security_group_id = aws_security_group.worker.id
  from_port                    = 53
  to_port                      = 53
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "cluster_to_workers_dns_udp" {
  security_group_id            = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  referenced_security_group_id = aws_security_group.worker.id
  from_port                    = 53
  to_port                      = 53
  ip_protocol                  = "udp"
}

resource "aws_vpc_security_group_egress_rule" "remove_default_cp_egress" {
  security_group_id = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

  lifecycle {
    prevent_destroy = false
  }

  count = 0

  depends_on = [aws_eks_cluster.this]
}

resource "aws_vpc_security_group_ingress_rule" "kubelet_all_ips" {
  security_group_id = aws_security_group.worker.id
  from_port         = 10250
  to_port           = 10250
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "api_checks_all_ips" {
  security_group_id = aws_security_group.worker.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "dns_tcp_all_ips" {
  security_group_id = aws_security_group.worker.id
  from_port         = 53
  to_port           = 53
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "dns_udp_all_ips" {
  security_group_id = aws_security_group.worker.id
  from_port         = 53
  to_port           = 53
  ip_protocol       = "udp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "node_tcp" {
  security_group_id            = aws_security_group.worker.id
  from_port                    = 1024
  to_port                      = 65535
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.worker.id
}

resource "aws_vpc_security_group_ingress_rule" "node_udp" {
  security_group_id            = aws_security_group.worker.id
  from_port                    = 1024
  to_port                      = 65535
  ip_protocol                  = "udp"
  referenced_security_group_id = aws_security_group.worker.id
}

resource "aws_vpc_security_group_ingress_rule" "dns_tcp" {
  security_group_id            = aws_security_group.worker.id
  from_port                    = 53
  to_port                      = 53
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.worker.id
}

resource "aws_vpc_security_group_ingress_rule" "dns_udp" {
  security_group_id            = aws_security_group.worker.id
  from_port                    = 53
  to_port                      = 53
  ip_protocol                  = "udp"
  referenced_security_group_id = aws_security_group.worker.id
}

resource "aws_vpc_security_group_egress_rule" "all_outbound" {
  security_group_id = aws_security_group.worker.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

