# Site-to-Site VPN Connectivity from Hospital On-Premises to AWS VPC

# 1. Customer Gateway (Hospital router public IP)
resource "aws_customer_gateway" "hospital_gateway" {
  bgp_asn    = 65000
  ip_address = "203.0.113.12" # Placeholder for hospital's public edge router IP
  type       = "ipsec.1"

  tags = merge({
    Name = "${var.client_name}-${var.environment}-customer-gw"
  }, var.common_tags)
}

# 2. Virtual Private Gateway (Attached to AWS VPC)
resource "aws_vpn_gateway" "vpn_gateway" {
  vpc_id = module.vpc.vpc_id

  tags = merge({
    Name = "${var.client_name}-${var.environment}-vpn-gateway"
  }, var.common_tags)
}

# 3. Site-to-Site VPN Connection (IPSec tunnel)
resource "aws_vpn_connection" "hospital_vpn" {
  vpn_gateway_id      = aws_vpn_gateway.vpn_gateway.id
  customer_gateway_id = aws_customer_gateway.hospital_gateway.id
  type                = "ipsec.1"
  static_routes_only  = true

  tags = merge({
    Name = "${var.client_name}-${var.environment}-vpn-connection"
  }, var.common_tags)
}

# 4. Static Route mapping hospital's on-premises IP subnet
resource "aws_vpn_connection_route" "hospital_onprem_subnet" {
  destination_cidr_block = "192.168.0.0/16" # Hospital local network IP range
  vpn_connection_id      = aws_vpn_connection.hospital_vpn.id
}

# 5. Route Table Propagation (to route traffic automatically through VPN Gateway)
resource "aws_vpn_gateway_route_propagation" "private_propagation" {
  vpn_gateway_id = aws_vpn_gateway.vpn_gateway.id
  route_table_id = module.vpc.private_route_table_id
}
