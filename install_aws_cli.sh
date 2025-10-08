#!/bin/bash
set -e

echo "=== AWS CLI Installer ==="

# Check if aws is already installed
if command -v aws &> /dev/null; then
    echo "✓ AWS CLI is already installed at: $(which aws)"
    echo "  (Run 'aws --version' manually if you need version info)"
    exit 0
fi

echo "AWS CLI not found. Installing..."

# Install AWS CLI
cd /tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install -i ~/.local/aws-cli -b ~/.local/bin
rm -rf aws awscliv2.zip

echo ""
echo "✓ AWS CLI installed successfully"

# Check if ~/.local/bin is in PATH
if [[ ":$PATH:" == *":$HOME/.local/bin:"* ]]; then
    echo "✓ ~/.local/bin is already in your PATH"
else
    echo ""
    echo "⚠ WARNING: ~/.local/bin is NOT in your PATH"
    echo ""
    echo "Add this line to your ~/.bashrc:"
    echo "    export PATH=\$HOME/.local/bin:\$PATH"
    echo ""
    echo "Then run:"
    echo "    source ~/.bashrc"
fi

echo ""
echo "Installation complete!"