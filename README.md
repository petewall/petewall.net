# petewall.net

Source for [petewall.net](https://petewall.net) — a Hugo site using the [PaperMod](https://github.com/adityatelange/hugo-PaperMod) theme.

## Local development

```sh
git clone --recurse-submodules https://github.com/petewall/petewall.net.git
cd petewall.net
make serve
```

If you cloned without submodules, run `git submodule update --init --recursive` to fetch the theme.

Common targets (run `make help` for the full list):

| Target | What it does |
|---|---|
| `serve` | Hugo dev server with drafts |
| `build` | Build the static site into `public/` |
| `image` | Build the Docker image |
| `run`   | Build + run the Docker image locally on `:8080` |
| `push`  | Push the Docker image |
| `lint`  | Strict Hugo build (fails on warnings) |
| `test`  | Alias of `lint` |
| `clean` | Remove build artifacts |

## Content

- `content/posts/` — blog posts
- `content/series/` — multi-post series
- `content/portfolio/` — portfolio entries
- `content/about/` — about page

New post: `hugo new posts/my-post.md`.

## Docker

The site ships as a static `nginx:alpine` image that serves `public/`. The `image` target builds `public/` first via Hugo, then runs `docker build`.

```sh
make image                          # builds ghcr.io/petewall/petewall.net:dev
make run                            # builds and runs on http://localhost:8080
make image TAG=v1                   # custom tag
make push  TAG=v1                   # push (requires `docker login ghcr.io`)
```

Override `IMAGE` or `TAG` via env / make variables; defaults are in the [`Makefile`](Makefile).

## Deploys

- **Production:** pushes to `main` build the site and publish a container image to `ghcr.io/petewall/petewall.net` via [`build.yml`](.github/workflows/build.yml).
- **PR previews:** pull requests publish a preview to `https://petewall.github.io/petewall.net/pr-<N>/` via [`preview.yml`](.github/workflows/preview.yml). Closing the PR removes it ([`preview-cleanup.yml`](.github/workflows/preview-cleanup.yml)).

## License

[MIT](LICENSE).
