FROM python:3.11-slim-bookworm

# Install build dependencies and OpenCV runtime libs
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential cmake pkg-config git curl wget unzip \
    libjpeg-dev libpng-dev libtiff-dev \
    libgl1 libglib2.0-0 libsm6 libxext6 libxrender1 \
    && rm -rf /var/lib/apt/lists/*

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

# Update library cache and set environment
RUN ldconfig
ENV PATH="/root/.local/bin:$PATH"
ENV LD_LIBRARY_PATH="/root/.local/lib:$LD_LIBRARY_PATH"
ENV PKG_CONFIG_PATH="/root/.local/lib/pkgconfig:$PKG_CONFIG_PATH"

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Install s5cmd
RUN uv tool install s5cmd

# Install JupyterLab
RUN pip install --no-cache-dir jupyterlab ipykernel

# Install uv Jupyter kernel
RUN mkdir -p ~/.local/share/jupyter/kernels/python-uv && \
    printf '%s\n' \
    '{' \
    '  "argv": [' \
    '    "bash",' \
    '    "-c",' \
    '    "source ~/.bashrc && exec uv run python -m ipykernel -f {connection_file}"' \
    '  ],' \
    '  "display_name": "Python (uv auto)",' \
    '  "language": "python"' \
    '}' > ~/.local/share/jupyter/kernels/python-uv/kernel.json

WORKDIR /workspace
