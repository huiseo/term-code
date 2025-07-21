#!/bin/bash

# Import GGUF models from Hugging Face into Ollama
# This script helps import models without accessing ollama.com

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}
======================================
  Hugging Face Model Import for Ollama
======================================
${NC}"

# Function to download model from Hugging Face
download_hf_model() {
    local model_repo=$1
    local model_file=$2
    local model_name=$3
    
    echo -e "${BLUE}Downloading $model_file from $model_repo${NC}"
    
    # Create models directory
    mkdir -p ~/.ollama/models
    
    # Download using curl or wget
    local download_url="https://huggingface.co/$model_repo/resolve/main/$model_file"
    local output_file="/tmp/$model_file"
    
    if command -v curl &> /dev/null; then
        curl -L -o "$output_file" "$download_url"
    elif command -v wget &> /dev/null; then
        wget -O "$output_file" "$download_url"
    else
        echo -e "${RED}Neither curl nor wget found. Please install one.${NC}"
        return 1
    fi
    
    # Create Modelfile
    cat > /tmp/Modelfile << EOF
FROM $output_file
EOF
    
    # Import into Ollama
    echo -e "${BLUE}Importing model into Ollama as '$model_name'${NC}"
    ollama create "$model_name" -f /tmp/Modelfile
    
    # Clean up
    rm -f "$output_file" /tmp/Modelfile
    
    echo -e "${GREEN}✅ Model imported successfully!${NC}"
}

# Popular GGUF models from Hugging Face
echo -e "${YELLOW}Popular GGUF models available on Hugging Face:${NC}"
echo ""
echo "1. DeepSeek R1 (1.5B)"
echo "   Repo: deepseek-ai/deepseek-r1-distill-gguf"
echo "   File: deepseek-r1-distill-qwen-1.5b-q4_k_m.gguf"
echo ""
echo "2. Llama 2 7B"
echo "   Repo: TheBloke/Llama-2-7B-GGUF"
echo "   File: llama-2-7b.Q4_K_M.gguf"
echo ""
echo "3. Mistral 7B"
echo "   Repo: TheBloke/Mistral-7B-v0.1-GGUF"
echo "   File: mistral-7b-v0.1.Q4_K_M.gguf"
echo ""
echo "4. CodeLlama 7B"
echo "   Repo: TheBloke/CodeLlama-7B-GGUF"
echo "   File: codellama-7b.Q4_K_M.gguf"
echo ""
echo "5. TinyLlama 1.1B (lightweight)"
echo "   Repo: TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF"
echo "   File: tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf"
echo ""

# Example usage
echo -e "${BLUE}Example commands:${NC}"
echo ""
echo "# Import DeepSeek R1 1.5B:"
echo "./huggingface-model-import.sh deepseek-ai/deepseek-r1-distill-gguf deepseek-r1-distill-qwen-1.5b-q4_k_m.gguf deepseek-r1:1.5b"
echo ""
echo "# Import TinyLlama (small, fast model):"
echo "./huggingface-model-import.sh TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf tinyllama:1.1b"
echo ""

# Check if arguments provided
if [ $# -eq 3 ]; then
    download_hf_model "$1" "$2" "$3"
else
    echo -e "${YELLOW}Usage: $0 <hf-repo> <gguf-filename> <ollama-model-name>${NC}"
    echo ""
    echo "To find more GGUF models, search on Hugging Face:"
    echo "https://huggingface.co/models?search=gguf&sort=trending"
fi