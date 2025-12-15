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

  # Enable X11 windowing system (optional - comment out for servers)
  services.xserver = {
    enable = true;
    
    # Choose your desktop environment
    # GNOME:
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    
    # Or KDE Plasma:
    # displayManager.sddm.enable = true;
    # desktopManager.plasma5.enable = true;
    
    # Or XFCE:
    # displayManager.lightdm.enable = true;
    # desktopManager.xfce.enable = true;
    
    # Keyboard layout
    xkb.layout = "us";
  };

  # Host-specific packages
  environment.systemPackages = with pkgs; [
    # Add your packages here
    vim
    wget
    curl
  ];

  # Enable CUPS for printing (optional)
  # services.printing.enable = true;

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

echo -e "${GREEN}✓${NC} Created ${HOST_DIR}/configuration.nix"

# Create hardware-configuration.nix template
cat > "${HOST_DIR}/hardware-configuration.nix" << 'EOF'
{ config, lib, pkgs, modulesPath, ... }:

{
  # Hardware configuration for this host
  # IMPORTANT: Replace this template with your actual hardware configuration
  # Generate it with: nixos-generate-config --show-hardware-config
  
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Boot configuration
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ]; # Use "kvm-amd" for AMD processors
  boot.extraModulePackages = [ ];

  # Filesystems - TEMPLATE ONLY, replace with your actual configuration
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  # Swap - uncomment and configure if needed
  # swapDevices = [
  #   { device = "/dev/disk/by-label/swap"; }
  # ];

  # CPU microcode updates
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # For AMD: hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Graphics
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Networking
  networking.useDHCP = lib.mkDefault true;
}
EOF

echo -e "${GREEN}✓${NC} Created ${HOST_DIR}/hardware-configuration.nix"

# Add entry to flake.nix
echo ""
echo -e "${YELLOW}Adding host to flake.nix...${NC}"

# Check if flake.nix exists
if [ ! -f "flake.nix" ]; then
    echo -e "${RED}Error: flake.nix not found${NC}"
    exit 1
fi

# Create a backup
cp flake.nix flake.nix.backup

# Add the new host configuration to flake.nix
# We'll insert it before the closing braces of nixosConfigurations
if grep -q "nixosConfigurations = {" flake.nix; then
    # Find the line number of the last host configuration
    # Insert the new configuration before the closing brace of nixosConfigurations
    
    # Create the new host entry
    NEW_HOST_ENTRY="
      # ${HOSTNAME} configuration
      ${HOSTNAME} = nixpkgs.lib.nixosSystem {
        system = \"x86_64-linux\";
        modules = [
          ./hosts/${HOSTNAME}/configuration.nix
          ./modules/nixos/common.nix
          
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.user = import ./home/common/home.nix;
          }
        ];
      };
"
    
    # Use awk to insert the new host before the closing brace of nixosConfigurations
    awk -v new_host="$NEW_HOST_ENTRY" '
    /^    };$/ && !done && in_nixos {
        print new_host
        done=1
    }
    /nixosConfigurations = \{/ {
        in_nixos=1
    }
    /^  };$/ && in_nixos {
        in_nixos=0
    }
    { print }
    ' flake.nix.backup > flake.nix
    
    echo -e "${GREEN}✓${NC} Added ${HOSTNAME} to flake.nix"
    rm flake.nix.backup
else
    echo -e "${RED}Error: Could not find nixosConfigurations in flake.nix${NC}"
    mv flake.nix.backup flake.nix
    exit 1
fi

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Successfully created host: ${HOSTNAME}${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Next steps:"
echo ""
echo "1. Replace the hardware configuration:"
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
