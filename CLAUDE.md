# ruby-rails Docker Images

Base Docker images for Ruby on Rails applications, published as `brian978/ruby-rails`.

## Repository layout

```
<ruby-version>/rails/prod/Dockerfile   # production image (base)
<ruby-version>/rails/dev/Dockerfile    # development image (extends prod)
```

Supported Ruby versions: `3.2`, `3.3`, `3.4`, `4.0`

## Image variants

| Tag | Base | Purpose |
|-----|------|---------|
| `<version>` | `ruby:<version>-slim` (4.0) / `ruby:<version>-alpine` (≤3.4) | Production |
| `<version>-dev` | `brian978/ruby-rails:<version>` | Development (adds sudo, dev aliases) |

> **Note**: The 4.0 image uses `ruby:4.0-slim` (Debian Trixie) instead of Alpine because
> Oracle's `libmysqlclient` is not packaged for Alpine. Debian is required to pull
> `libmysqlclient-dev` from Oracle's MySQL 8.4 APT repo so that the `mysql2` gem links
> against Oracle's connector (not MariaDB's), which correctly honours `ssl_mode: DISABLED`
> in Rails `database.yml`.

## Building

```sh
# Production image
make 40

# Development image
make 40 env=dev
```

Targets: `40`, `34`, `33`, `32`. The build script (`build.sh`) uses `docker buildx` for
multi-platform builds (`linux/amd64`, `linux/arm64`) and pushes directly to Docker Hub.

## MySQL / MariaDB libraries (4.0 image)

The 4.0 prod image installs:

- `libmysqlclient-dev` — Oracle MySQL 8.4 client headers + `mysql_config` (from
  `repo.mysql.com/apt/debian bookworm mysql-8.4-lts`)
- `libmariadb3` — MariaDB runtime shared library (runtime-only, no header conflict)

`libmysqlclient-dev` and `libmariadb-dev` **cannot** be installed together (they conflict
on headers). Only the runtime `libmariadb3` coexists with `libmysqlclient-dev`.

### GPG key note

Oracle's MySQL signing key `BCA43417C3B485DD128EC6D4B7B3B788A8D3785C` expired 2025-10-22
and the replacement key is not yet distributed in any well-known public file. The
Dockerfile uses `[trusted=yes]` in the apt source entry to bypass `sqv` signature
verification. The repo is served over HTTPS so transport security is preserved.

### mysql2 build flags (4.0-dev image)

The dev image pre-configures bundler so that `bundle install` builds `mysql2` against
Oracle's `libmysqlclient`:

```sh
bundle config build.mysql2 \
  "--with-mysql-lib=$(mysql_config --variable=pkglibdir) \
   --with-mysql-include=$(mysql_config --variable=pkgincludedir)"
```

This ensures `ldd` on the compiled `mysql2.so` shows `libmysqlclient.so`, not
`libmariadb.so.3`.
