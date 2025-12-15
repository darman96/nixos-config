#!/usr/bin/env bash
# Simple validation script to check basic syntax

echo "Checking flake.nix structure..."

if [ ! -f "flake.nix" ]; then
    echo "ERROR: flake.nix not found!"
    exit 1
fi

echo "✓ flake.nix exists"

# Check directory structure
for dir in hosts modules home users; do
    if [ ! -d "$dir" ]; then
        echo "ERROR: $dir directory not found!"
        exit 1
    fi
    echo "✓ $dir directory exists"
done

# Check host configurations
for host in desktop laptop; do
    if [ ! -f "hosts/$host/configuration.nix" ]; then
        echo "ERROR: hosts/$host/configuration.nix not found!"
        exit 1
    fi
    echo "✓ hosts/$host/configuration.nix exists"
    
    if [ ! -f "hosts/$host/hardware-configuration.nix" ]; then
        echo "ERROR: hosts/$host/hardware-configuration.nix not found!"
        exit 1
    fi
    echo "✓ hosts/$host/hardware-configuration.nix exists"
done

# Check common module
if [ ! -f "modules/nixos/common.nix" ]; then
    echo "ERROR: modules/nixos/common.nix not found!"
    exit 1
fi
echo "✓ modules/nixos/common.nix exists"

# Check home manager configuration
if [ ! -f "home/common/home.nix" ]; then
    echo "ERROR: home/common/home.nix not found!"
    exit 1
fi
echo "✓ home/common/home.nix exists"

echo ""
echo "All structure checks passed!"
echo ""
echo "To validate with Nix (requires Nix with flakes enabled):"
echo "  nix flake check"
echo ""
echo "To build a configuration:"
echo "  nixos-rebuild build --flake .#desktop"
echo "  nixos-rebuild build --flake .#laptop"
