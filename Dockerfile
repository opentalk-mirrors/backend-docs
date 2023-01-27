# SPDX-FileCopyrightText: OpenTalk GmbH <mail@opentalk.eu>
#
# SPDX-License-Identifier: EUPL-1.2

## Base ########################################################################
# Use a larger node image to do the build for native deps (e.g., gcc, python)
FROM node:lts as build

# We'll run the app as the `node` user, so put it in their home directory
WORKDIR /home/node/app
RUN chown -R node:node /home/node
USER node
COPY --chown=node:node .yarn /home/node/app/.yarn
COPY --chown=node:node package.json yarn.lock .yarnrc.yml /home/node/app/

RUN yarn install --immutable

ARG IS_PRIVATE=false
ARG BASE_URL

# Copy the source code over
COPY --chown=node:node . /home/node/app/

# Build the Docusaurus app
RUN yarn build

## Deploy ######################################################################
# Use a stable nginx image
FROM nginx:stable-alpine as deploy
WORKDIR /home/node/app
# Copy what we've installed/built from production
COPY --chown=nginx:nginx --from=build /home/node/app/build /usr/share/nginx/html/
