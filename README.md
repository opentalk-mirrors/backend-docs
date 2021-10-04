# K3K Docs

This repository contains the user, API and technical documentation about the architecture.

## Development

To quickly view your latest changes, install:

- `mkdocs`

Then run in the `docs` folder:

```bash
mkdocs serve
```

## Build

To build the docs and view them, run:

```bash
podman build -f ci/Dockerfile -t k3k-docs .
podman run -p 8080:80 k3k-docs
```

The docs are now available at `localhost:8080`.
