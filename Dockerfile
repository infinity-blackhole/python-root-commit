ARG PYTHON_VERSION=3.10.9
ARG POETRY_VERSION==1.3.1

FROM python:${PYTHON_VERSION}-slim-bullseye AS base

# Create the app directory
WORKDIR /usr/src/app

FROM base AS deps

# Install global packages
RUN --mount=type=cache,target=/home/root/.cache/pip \
  pip install "poetry==${POETRY_VERSION}"

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
