# OpenTalk Documentation

This website is built using [Docusaurus 2](https://docusaurus.io/), a modern static website generator.

It hosts the user, admin and developer documentation. All documentation is in english, expect for the user
documentation which is also available in german.

## Building

Building the site required the following folders to be present:

- `user-docs/` containing the english user documentation
- `admin-docs/` containing the english admin documentation
- `developer-docs/` containing the english developer documentation
- `i18n/de/docusaurus-plugin-content-docs-user/current/` containing the german version of the user docs
  content ([why the long weird path?](https://docusaurus.io/docs/i18n/introduction#translation-files-location))
- `i18n/de/docusaurus-plugin-content-docs-admin/current/` A copy of the admin-docs folder
  content (because there's no german version)
- `i18n/de/docusaurus-plugin-content-docs-developer/current/` A copy of the developer-docs folder
  content (because there's no german version)
- `openapi/controller.yaml` openapi spec of the controller's HTTP API which is integrated
  using [redocusaurus](https://github.com/rohit-gohri/redocusaurus)

### Installing the required dependencies

```shell
yarn
```

### Developing with live reload

This works with only one language at a time, to start the german version append `--locale de`

```shell
yarn start
```

### Building a production ready version

```shell
yarn build
```

## Swizzled components

[What is swizzling?](https://docusaurus.io/docs/swizzling)

The component wrappers can be found in [`src/theme`](src/theme).

- The language selector because it should only be visible on the user docs.
- The version selector as this site runs multiple instances of the `content-docs` plugin and the version selector can
  always just select one. To work around this a version selector is only visible on the docs page it's responsible
  for.
