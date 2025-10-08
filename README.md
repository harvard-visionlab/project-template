# project-template
So you want to start a new project in the Visionlab? Start here...

# One-time Cluster Setup
You can skip these steps if you've already setup/configured your cluster environment.


# Installation

# first time setup
uv lock --python 3.11
uv sync --locked
uv run nbstripout --install
uv run python check_install.py

# normal day-to-day (recommended)
uv run python project_tempate/example.py
uv run pytest
uv run ruff check .

# alternative (more like conda activate)
From your project root you can run:
```
source .venv/bin/activate
python project_tempate/example.py
```

Later you can deactivate with
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


