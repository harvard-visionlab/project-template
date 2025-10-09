# project-template
So you want to start a new project in the Visionlab? Start here...

# One-time Cluster Setup
You can skip these steps if you've already setup/configured your cluster environment.

Install uv
```
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Edit your ~/.bashrc file, adding the following:
```
# Source lab-wide environment settings
source /n/alvarez_lab_tier1/shared/config/lab_environment.sh

# User-specific credentials (NEVER put in shared config)
export AWS_ACCESS_KEY_ID="your_key_here"
export AWS_SECRET_ACCESS_KEY="your_secret_here"

# Optional: e.g., Weights & Biases, other API keys, secrets
export WANDB_API_KEY="your_key_here"
export WANDB_ENTITY="your_entity_here"
```

Make sure you have user installations of libjpegturbo and opencv
```
install_libjpegturbo.sh
install_opencv.sh
```

Create symbolic links (otherwise fall victim to the dreaded 100GB storage limit for your home directory.
```

```

# Project Installation

# first time setup
```
uv lock --python 3.11
uv sync --locked
uv run nbstripout --install
uv run python check_install.py
```

# normal day-to-day (recommended)
```
uv run python project_tempate/example.py
uv run pytest
uv run ruff check .
```

# alternative (more like conda activate)
From your project root you can run:
```
source .venv/bin/activate
python project_tempate/example.py
```

Now everything you run from that terminal will use that uv environment. Later you can deactivate with
```
deactivate
```

# add packages
I prefer to add required packages manually to the pyproject.toml file, then run:
```
uv lock
```

Check the output, make sure the resulting versions look "ok" to you.

Then update the environment
```
uv sync --locked
```