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
    organizationName: "OpenTalk", // Usually your GitHub org/user name.
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
            path: 'docs/signaling',
            routeBasePath: 'signaling',

            sidebarPath: require.resolve("./sidebars.js"),
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
              route: "/rest/",
              spec: "api/controller/frontend_api.yaml",
            }
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
    plugins: [],
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
              docId: "index",
              position: "left",
              label: "Signaling",
            },
            {
              to: "/rest/",
              position: "left",
              label: "REST API",
            },
            // Right
            {
              type: "docsVersionDropdown",
              position: "right",
              dropdownActiveClassDisabled: true,
            }
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
                  to: "/signaling/",
                },
                {
                  label: "REST API",
                  to: "/rest/",
                },
              ],
            },
            {
              title: "More",
              items: [
                {
                  label: "GitLab",
                  href: "https://git.opentalk.dev/opentalk",
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
