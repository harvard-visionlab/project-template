# project-template

So you want to start a new project in the Visionlab? Start here...

## Why use this template?

1. **Git-based portability** - Your code lives in a GitHub repo, making it easy to work across your laptop, the cluster, and collaborators' machines.

2. **Reproducible uv environment** - Dependencies are managed with [uv](https://docs.astral.sh/uv/) and locked in `uv.lock`, ensuring everyone gets the same package versions.

3. **Installable Python package** - Your project is set up as a proper Python package. No more `sys.path` hacks or broken imports. Works locally and can be added as a dependency to other projects:
   ```python
   from visionlab.my_project import essential_function
   ```

4. **Jupyter notebooks with nbstripout** - Cell outputs are automatically stripped when you commit. Your notebooks stay in version control without bloating the repo with images/data. (Note: outputs are only removed from GitHub's copy - your local notebooks keep their outputs.)

5. **Optional JupyterLab server** - Run `uv run jupyter lab` for local notebook development.

6. **Optional devcontainer** - Need a sandboxed Linux environment? Open the project in VS Code's devcontainer for isolated development in a Docker container.

# Creating Your Project from This Template

## 1. Create a new repo from the template

On GitHub, click the green "Use this template" button, or:

```
gh repo create harvard-visionlab/my-project --template harvard-visionlab/project-template --private
git clone git@github.com:harvard-visionlab/my-project.git
cd my-project
```

## 2. Rename the project folder

Rename `project_template/` to your project name (use underscores, not hyphens):

```
mv project_template my_project
```

## 3. Update pyproject.toml

Update these fields to match your project name:

```toml
[project]
name = "my-project"  # your repo name

[tool.setuptools]
package-dir = { "visionlab.my_project" = "my_project" }
packages = ["visionlab.my_project"]
```

## 4. First time setup

Run these commands on any local clone of this repository:

```
uv lock --python 3.11
uv sync --locked --dev
uv run nbstripout --install
uv run python check_install.py
```

# optional: run a jupyerlab server

First install install the dev dependencies:

```
uv sync --dev
```

Run the jupyterlab server

```
uv run jupyter lab
```

# optional: run a dev container

If for any reason you need to run this in a "linux environment" you can use a dev container.

This might be necessary if you need to install system software that you don't want to install on your laptop (or cannot install for some reason).

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

# minimal git commands for making a commit

Preview what will be staged (dry run):

```
git add --all -n
```

Stage all changes:

```
git add --all
```

Or selectively stage specific files:

```
git add path/to/file.py
```

Commit staged changes with a message:

```
git commit -m "added great things"
```

Push commits to remote:

```
git push
```

# minimal git commands for syncing

Pull latest changes from remote (merge strategy):

```
git pull
```

Pull and replay your commits on top (cleaner history):

```
git pull --rebase
```

# troubleshooting

Ask Claude, obviously.
