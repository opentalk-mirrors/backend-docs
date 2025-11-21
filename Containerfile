# SPDX-FileCopyrightText: OpenTalk GmbH <mail@opentalk.eu>
#
# SPDX-License-Identifier: EUPL-1.2

FROM caddy:2-alpine as deploy

COPY Caddyfile /etc/caddy/Caddyfile
COPY site /usr/share/caddy
