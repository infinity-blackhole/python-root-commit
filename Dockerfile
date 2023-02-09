FROM python:3.10-slim-bullseye AS base

# Change working directory
WORKDIR /usr/src/app

# Install global packages
# hadolint ignore=DL3042
RUN --mount=type=cache,target=/home/root/.cache/pip \
  --mount=type=bind,source=requirements.txt,target=requirements.txt \
  pip install -r requirements.txt

FROM base

# Install application
# hadolint ignore=DL3042
RUN --mount=type=cache,target=/home/root/.cache/pip \
  --mount=type=bind,source=python_template_project,target=python_template_project \
  --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
  --mount=type=bind,source=README.md,target=README.md \
  pip install .

# Run application
CMD ["python", "-m", "python_template_project.app" ]
