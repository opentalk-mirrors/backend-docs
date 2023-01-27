// SPDX-FileCopyrightText: OpenTalk GmbH <mail@opentalk.eu>
//
// SPDX-License-Identifier: EUPL-1.2

const NodePolyfillPlugin = require("node-polyfill-webpack-plugin");
// eslint-disable-next-line
module.exports = function (context, options) {
  return {
    name: "custom-docusaurus-plugin",
    // eslint-disable-next-line
    configureWebpack(config, isServer, utils) {
      return {
        resolve: {
          fallback: {
            fs: false,
          },
        },
        plugins: [new NodePolyfillPlugin()],
      };
    },
  };
};
