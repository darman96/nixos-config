#!/usr/bin/env bash
# Script to add a new host to the NixOS configuration
# Usage: ./add-host.sh <hostname>

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if hostname is provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: No hostname provided${NC}"
    echo "Usage: $0 <hostname>"
    echo "Example: $0 server"
    exit 1
fi

HOSTNAME="$1"

# Validate hostname for Nix identifier compatibility
# Nix identifiers can contain alphanumeric characters, underscores, and hyphens
# But they should start with a letter or underscore
if ! [[ "$HOSTNAME" =~ ^[a-zA-Z_][a-zA-Z0-9_-]*$ ]]; then
    echo -e "${RED}Error: Invalid hostname '${HOSTNAME}'${NC}"
    echo "Hostname must:"
    echo "  - Start with a letter or underscore"
    echo "  - Contain only alphanumeric characters, underscores, and hyphens"
    echo "Example valid hostnames: server, my_host, web-server, server01"
    exit 1
fi

HOST_DIR="hosts/${HOSTNAME}"

# Check if host already exists
if [ -d "$HOST_DIR" ]; then
    echo -e "${RED}Error: Host '${HOSTNAME}' already exists in ${HOST_DIR}${NC}"
    exit 1
fi

echo -e "${GREEN}Creating new host: ${HOSTNAME}${NC}"
echo ""

# Create host directory
mkdir -p "$HOST_DIR"
echo -e "${GREEN}✓${NC} Created directory: ${HOST_DIR}"

# Create configuration.nix
cat > "${HOST_DIR}/configuration.nix" << EOF
{ config, pkgs, ... }:

{
  # ${HOSTNAME} configuration
  
  # Hostname
  networking.hostName = "nixos-${HOSTNAME}";

  # Hardware configuration
  imports = [
    ./hardware-configuration.nix
  ];

  # Host-specific packages
  environment.systemPackages = with pkgs; [];

  # Define a user account
  users.users.user = {
    isNormalUser = true;
    description = "${HOSTNAME} User";
    extraGroups = [ "networkmanager" "wheel" ];
    # Set password with: passwd user
    # Or use hashedPassword option
  };

  # Firewall configuration (adjust as needed)
  # networking.firewall.allowedTCPPorts = [ 22 80 443 ];
  # networking.firewall.allowedUDPPorts = [ ];
}
EOF

# Create hardware-configuration.nix placeholder
cat > "${HOST_DIR}/hardware-configuration.nix" << EOF
# Placeholder
EOF


echo -e "${GREEN}✓${NC} Created ${HOST_DIR}/configuration.nix"

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Successfully created host: ${HOSTNAME}${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Next steps:"
echo ""
echo "1. Generate the hardware configuration:"
echo -e "   ${YELLOW}nixos-generate-config --show-hardware-config > ${HOST_DIR}/hardware-configuration.nix${NC}"
echo ""
echo "2. Customize the configuration:"
echo -e "   ${YELLOW}vim ${HOST_DIR}/configuration.nix${NC}"
echo ""
echo "3. Build and test the configuration:"
echo -e "   ${YELLOW}nixos-rebuild build --flake .#${HOSTNAME}${NC}"
echo ""
echo "4. Deploy the configuration:"
echo -e "   ${YELLOW}sudo nixos-rebuild switch --flake .#${HOSTNAME}${NC}"
echo ""
