#!/bin/bash

# Parse command line arguments
FORCE=false
while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--force)
            FORCE=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [-f|--force]"
            exit 1
            ;;
    esac
done

install_kernel() {
    local kernel_name=$1
    local display_name=$2
    local uv_command=$3
    
    local kernel_dir="$HOME/.local/share/jupyter/kernels/$kernel_name"
    local kernel_json="$kernel_dir/kernel.json"
    
    if [ -f "$kernel_json" ] && [ "$FORCE" = false ]; then
        echo "  ✓ $display_name already exists (use -f to overwrite)"
        return 0
    fi
    
    if [ -f "$kernel_json" ]; then
        echo "  Overwriting $display_name..."
    else
        echo "  Installing $display_name..."
    fi
    
    mkdir -p "$kernel_dir"
    
    cat > "$kernel_json" <<JSON
{
  "argv": [
    "bash",
    "-c",
    "source ~/.bashrc && exec $uv_command -f {connection_file}"
  ],
  "display_name": "$display_name",
  "language": "python",
  "env": {}
}
JSON
    
    echo "  ✓ Installed at $kernel_json"
}

echo "Installing uv kernel specs..."
echo

install_kernel "python-uv" "Python (uv auto)" "uv run python -m ipykernel"
install_kernel "python-uv-310" "Python 3.10 (uv auto)" "uv run --python 3.10 python -m ipykernel"
install_kernel "python-uv-311" "Python 3.11 (uv auto)" "uv run --python 3.11 python -m ipykernel"
install_kernel "python-uv-312" "Python 3.12 (uv auto)" "uv run --python 3.12 python -m ipykernel"
install_kernel "python-uvx-scratch" "Python (uvx scratch)" "uvx --from ipykernel python -m ipykernel"

echo
echo "Done. Verify with: jupyter kernelspec list"