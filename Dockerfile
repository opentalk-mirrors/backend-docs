# SPDX-FileCopyrightText: OpenTalk GmbH <mail@opentalk.eu>
#
# SPDX-License-Identifier: EUPL-1.2

FROM nginx:stable-alpine as deploy

COPY --chown=nginx:nginx build /usr/share/nginx/html/
COPY nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf
