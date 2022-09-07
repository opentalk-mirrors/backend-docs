// @ts-check
// Note: type annotations allow type checking and IDEs autocompletion

const lightCodeTheme = require("prism-react-renderer/themes/github");
const darkCodeTheme = require("prism-react-renderer/themes/dracula");

const baseUrl = process.env.BASE_URL ?? "/";
const isDev = process.env.NODE_ENV === "development";

const isPublic = process.env.IS_PUBLIC === "true";

/** @type {import('@docusaurus/types').Config} */
const createConfig = async () => {
  const mdxMermaid = await import("mdx-mermaid");
  return {
    title: "OpenTalk API Docs",
    tagline: "OpenTalk",
    url: "https://opentalk.eu",
    baseUrl,
    onBrokenLinks: "throw",
    onBrokenMarkdownLinks: "warn",
    favicon: "img/favicon.ico",

    // GitHub pages deployment config.
    // If you aren't using GitHub pages, you don't need these.
    organizationName: "heinlein-video", // Usually your GitHub org/user name.
    projectName: "docs", // Usually your repo name.

    // Even if you don't use internalization, you can use this field to set useful
    // metadata like html lang. For example, if your site is Chinese, you may want
    // to replace "en" with "zh-Hans".
    i18n: {
      defaultLocale: "en",
      locales: ["en"],
    },

    presets: [
      [
        "classic",
        /** @type {import('@docusaurus/preset-classic').Options} */
        ({
          docs: {
            sidebarPath: require.resolve("./sidebars.js"),
            // Only show edit link on internal builds.
            editUrl: isPublic
              ? undefined
              : "https://git.heinlein-video.de/heinlein-video/k3k-docs/-/tree/main",
            remarkPlugins: [mdxMermaid.default],
          },

          theme: {
            customCss: require.resolve("./src/css/custom.css"),
          },
        }),
      ],
      [
        "redocusaurus",
        {
          specs: [
            {
              route: "/openapi/rest/",
              spec: "api/controller/frontend_api.yaml",
            },
            // Only include the internal docs in internal builds.
            !isPublic && {
              route: "/openapi/internal/",
              spec: "api/controller/internal.yaml",
            },
          ],
          theme: {
            primaryColor: "#1890ff",
            redocOptions: { hideDownloadButton: false },
          },
        },
      ],
    ],
    themes: [
      [
        require.resolve("@easyops-cn/docusaurus-search-local"),
        {
          indexPages: true,
          hashed: true,
        },
      ],
    ],
    plugins: [require.resolve("./sitePlugin")],
    themeConfig:
      /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
      ({
        navbar: {
          title: "OpenTalk API",
          logo: {
            alt: "My Site Logo",
            src: "img/logo.svg",
          },
          items: [
            {
              type: "doc",
              docId: "getting-started",
              position: "left",
              label: "Signaling",
            },
            {
              to: "/openapi/rest",
              position: "left",
              label: "REST API",
            },

            !isPublic && {
              to: "/openapi/internal",
              position: "left",
              label: "Internal Endpoints",
            },
            // Right
            {
              type: "docsVersionDropdown",
              position: "right",
              dropdownActiveClassDisabled: true,
            },

            {
              href: "https://github.com/facebook/docusaurus",
              label: "GitHub",
              position: "right",
            },
          ],
        },
        footer: {
          style: "dark",
          links: [
            {
              title: "Docs",
              items: [
                {
                  label: "Signaling",
                  to: "/docs/getting-started",
                },
                {
                  label: "REST API",
                  to: "/openapi/rest",
                },
              ],
            },
            {
              title: "More",
              items: [
                {
                  label: "GitLab",
                  href: "https://git.heinlein-video.de/heinlein-video",
                },
              ],
            },
          ],
          copyright: `Copyright © ${new Date().getFullYear()} OpenTalk GmbH. Built with Docusaurus.`,
        },
        prism: {
          theme: lightCodeTheme,
          darkTheme: darkCodeTheme,
        },
      }),
  };
};

module.exports = createConfig;
