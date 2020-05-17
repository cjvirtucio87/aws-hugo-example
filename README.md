# aws-hugo-example

## Development

### Host Machine

While writing drafts:

```bash
cd src
hugo serve --buildDrafts
```

To run server using only non-drafts:

```bash
hugo serve
```

### Container

`./build.sh` builds the image.

`./run.sh` builds the image _and_ runs the container from that image.

## Production (WIP)

Generate site:

```bash
hugo
```

Take contents of `src/public` and host an a web server.
