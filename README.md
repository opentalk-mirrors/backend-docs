# OpenTalk Documentation

This website is built using
[mkdocs-material](https://squidfunk.github.io/mkdocs-material/), a modern static
website generator.

It hosts the user, admin, developer and release documentation. By default all
documentation is in English, some parts may be translated into other languages
as well.

## Structure and content

The documentation lives under the [`docs/`](docs) subdirectory. There are a few
static parts which form a skeleton for the documentation structure.
The other contents are loaded from other repositories using the
[`just`](https://just.systems/) command-line tool which is available in the
package repository of most Linux distributions. `just` provides recipes that are
used for pulling in the contents from other repositories. In order to see a list
of all available recipes, run `just` without any parameters.

By default, you might want to run `just update-all`. This takes some time to
run, but should pull in the contents for all components of all released OpenTalk
versions

### Debugging

If you want to gain more insights into what the `just` invocation does, run it
with the enviroment variable `JUST_VERBOSE=1` or `JUST_VERBOSE=2`.

### Extraction of content from the repositories

Each remote repository can have the required documentation content in a
different structure. This structure can evolve over time and require individual
handling for every repository or OpenTalk version. This is handled by extraction
scripts under the `extractors/` directory. The extraction scripts are put under
a subdirectory for the OpenTalk release series.

Each extraction script must be able to take these parameters:

- `SOURCE`: The directory path where the upstream git repository of the
  corresponding project has been checked out.
- `DESTINATION`: The directory path where the documentation should be placed.

In the simplest case, the script executes exactly one `cp` command that copies
the documentation contents from a subdirectory of the `SOURCE` path to the
`DESTINATION` path.

If no extraction script is found for a component, or if the script file does not
have the executable permission set, it will be ignored, and no content is copied
over for this specific component in that OpenTalk version.

## Building

Site configuration is defined in the [`mkdocs.yml`](mkdocs.yml) file.

Building the site requires `mkdocs-material` to be installed on the system. That
package is available in many Linux distributions.

Once the `docs/` directory has been populated, a local webserver with live
reloading capabilities can be started with `mkdocs serve`. This will build the
website ad-hoc, and expose the artifacts on a local port which it tells in the
command-line output. Whenever the documentation content changes, the site is
rebuilt and all open web browsers reload the page.

Run `mkdocs build` in order to build a distributable tree of static web content
under the `site/` directory. This can be served by a simple webserver.

Some additional `mkdocs-material` plugins may be required, the command-line
output  of `mkdocs serve` or `mkdocs build` tells you if that is the case.

## Development

In order to fetch e.g. using a development branch from a different repository,
some environment variables can be used to override the default values.

These environment variables are read at the top of the [`justfile`](justfile)
using the `env(…)` call.

- `REPO_NAME_<REPONAME>`, e.g. in order to clone the support repository from a
  personal repository run with `REPO_NAME_SUPPORT=a.cooper/support`.
- `REPO_BRANCH_<REPONAME>`, e.g. in order to use a dev branch on the support
  repository, run with `REPO_BRANCH_SUPPORT=dev/fix-issue`. This may not
  be available for all repositories, because in most cases the branch or
  tag is determined by the `releases.yml` file in the [`product-releases`
  repository](https://git.opentalk.dev/opentalk/product-releases).
- `REPO_VERSION_TAG_PREFIX_<REPONAME>`, a prefix to be prepended to the version
  tags. Default value is `v`, resulting in tags like `v1.2.3`. Can be used to
  test out changes without creating a full final release, in that case a tag
  must be present for each of the referenced component versions.
- `REPO_URL_<REPONAME>`, can override the whole URL for a source repository.
  Usually not needed, because the variable is built from `REPO_NAME_<REPONAME>`
  by default. Only required if the url is not served by the default git forge
  which is defined in `REPO_BASE`.
