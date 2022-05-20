FROM python:3.9.13-slim-bullseye AS base

# Create the app directory
WORKDIR /usr/src/app

FROM base AS deps

# Install global packages
COPY requirements.txt ./
RUN --mount=type=cache,target=/home/root/.cache/pip \
  pip install -r requirements.txt

# Install dependencies
COPY pyproject.toml poetry.lock ./
RUN --mount=type=cache,target=/home/root/.cache/pypoetry \
  poetry install --no-dev

FROM deps AS app

# Copy sources
COPY python_template_project python_template_project
COPY README.md ./

# Overrider entrypoint to current virtual environment
ENTRYPOINT [ "poetry", "run" ]

# Run application
CMD ["python", "-m", "python_template_project.app" ]
