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

`./run.sh` does the following:

* build `publish` container
  * package site in tarball
  * host tarball on `httpd`
* build `run` container
  * downloads tarball from `publish` container
  * `untar` site into `/var/www/html`
  * start `httpd`

## Production (WIP)

Generate site:

```bash
hugo
```

Take contents of `src/public` and host an a web server.
