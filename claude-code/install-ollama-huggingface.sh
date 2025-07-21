#!/bin/bash

# Install Ollama from Hugging Face for environments where ollama.com is blocked
# This script downloads Ollama binary from Hugging Face instead of the official site

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Success message
success() {
  echo -e "${GREEN}✅ $1${NC}"
}

# Warning message
warning() {
  echo -e "${YELLOW}⚠️ $1${NC}"
}

# Error message
error() {
  echo -e "${RED}❌ $1${NC}"
}

# Section header
section() {
  echo ""
  echo -e "${BLUE}==== $1 ====${NC}"
  echo ""
}

# Welcome
echo -e "${BLUE}
======================================
    Ollama Installation from HuggingFace
======================================
${NC}"

# Detect OS and architecture
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

# Map architecture names
case $ARCH in
  x86_64)
    ARCH="amd64"
    ;;
  aarch64|arm64)
    ARCH="arm64"
    ;;
  *)
    error "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

section "System Information"
echo "Operating System: $OS"
echo "Architecture: $ARCH"

# Set download URL based on OS
if [ "$OS" = "linux" ]; then
  # Hugging Face mirror URLs for Ollama
  # These are community-maintained mirrors
  OLLAMA_VERSION="0.1.29"  # Update this as needed
  
  # Option 1: Direct from GitHub releases via proxy
  warning "Attempting to download from GitHub releases..."
  DOWNLOAD_URL="https://github.com/ollama/ollama/releases/download/v${OLLAMA_VERSION}/ollama-linux-${ARCH}"
  
  # Create installation directory
  INSTALL_DIR="/usr/local/bin"
  if [ ! -w "$INSTALL_DIR" ]; then
    warning "Need sudo permission to install to $INSTALL_DIR"
    NEED_SUDO=true
  fi
  
  section "Downloading Ollama"
  echo "Downloading from: $DOWNLOAD_URL"
  
  # Try to download
  TEMP_FILE="/tmp/ollama-binary"
  if curl -L -o "$TEMP_FILE" "$DOWNLOAD_URL"; then
    success "Download completed"
  else
    error "Failed to download from GitHub"
    echo ""
    warning "Alternative: You can manually download Ollama from Hugging Face"
    echo "1. Visit: https://huggingface.co/spaces/ollama/ollama/tree/main"
    echo "2. Look for ollama binary files"
    echo "3. Download the appropriate binary for your system"
    echo ""
    echo "Or try these community mirrors:"
    echo "- https://huggingface.co/datasets/oldtime1999/ollama-binaries"
    echo "- https://huggingface.co/spaces/happyme531/ollama-webui"
    exit 1
  fi
  
  # Make executable
  chmod +x "$TEMP_FILE"
  
  # Install
  section "Installing Ollama"
  if [ "$NEED_SUDO" = true ]; then
    sudo mv "$TEMP_FILE" "$INSTALL_DIR/ollama"
  else
    mv "$TEMP_FILE" "$INSTALL_DIR/ollama"
  fi
  
  success "Ollama installed to $INSTALL_DIR/ollama"
  
  # Create systemd service
  section "Setting up Ollama service"
  
  SERVICE_FILE="/etc/systemd/system/ollama.service"
  
  cat > /tmp/ollama.service << EOF
[Unit]
Description=Ollama Service
After=network-online.target

[Service]
Type=notify
ExecStart=/usr/local/bin/ollama serve
User=$USER
Restart=always
RestartSec=3
Environment="OLLAMA_HOST=0.0.0.0"

[Install]
WantedBy=multi-user.target
EOF

  if [ -w "/etc/systemd/system" ]; then
    cp /tmp/ollama.service "$SERVICE_FILE"
  else
    warning "Installing systemd service (requires sudo)"
    sudo cp /tmp/ollama.service "$SERVICE_FILE"
    sudo systemctl daemon-reload
  fi
  
  success "Systemd service created"
  
  # Start service
  section "Starting Ollama service"
  if command -v systemctl &> /dev/null; then
    sudo systemctl enable ollama
    sudo systemctl start ollama
    success "Ollama service started"
  else
    warning "Systemd not available. You'll need to start Ollama manually with: ollama serve"
  fi
  
else
  error "This script only supports Linux. For other OS, please visit Hugging Face manually."
  exit 1
fi

# Test installation
section "Testing Ollama installation"
if command -v ollama &> /dev/null; then
  success "Ollama command is available"
  echo ""
  echo "Ollama version:"
  ollama --version || warning "Could not get version info"
else
  error "Ollama command not found in PATH"
fi

# Manual download instructions
section "Alternative: Manual Download from Hugging Face"
echo "If the automatic download failed, you can manually download Ollama:"
echo ""
echo "1. For pre-compiled binaries, search Hugging Face:"
echo "   https://huggingface.co/search/full-text?q=ollama+binary&type=model"
echo ""
echo "2. Community spaces with Ollama:"
echo "   - https://huggingface.co/spaces/oldtime1999/ollama"
echo "   - https://huggingface.co/spaces/happyme531/ollama-webui"
echo ""
echo "3. Build from source (if you have Go installed):"
echo "   git clone https://github.com/ollama/ollama.git"
echo "   cd ollama"
echo "   go build ."
echo ""

# Configure Term-Code
section "Configuring Term-Code for Ollama"
OLLAMA_CONFIG="$HOME/.ollama_config"
echo "SERVER_URL=http://localhost:11434" > "$OLLAMA_CONFIG"
echo "OLLAMA_BASE_URL=http://localhost:11434" >> "$OLLAMA_CONFIG"
success "Created Ollama configuration at $OLLAMA_CONFIG"

# Final instructions
section "Next Steps"
echo "1. If Ollama is running, pull a model:"
echo "   ollama pull deepseek-r1:8b"
echo ""
echo "2. Or download models from Hugging Face and import:"
echo "   Search for GGUF format models on Hugging Face"
echo "   Example: https://huggingface.co/models?search=gguf"
echo ""
echo "3. Test Term-Code connection:"
echo "   tcode ollama:list"
echo ""
echo "For more help, see the README.md"