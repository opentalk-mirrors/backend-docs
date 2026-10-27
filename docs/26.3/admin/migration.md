---
title: Migration Guide
---

# Migrating to {{ product_name }} 26.3

{{ product_name }} 26.3 builds on the architecture introduced with [26.2](../../26.2/admin/migration.md). There are no
changes to the overall architecture of a deployment, but there are a few changes that require attention from
administrators:

- The bundled **PostgreSQL** is upgraded to a new major version (`17` → `18`).
- Signaling metrics are available again and are now provided by the **RoomServer**.
- Invite codes were removed in favor of a single join link per room.
- The **Orchestrator** is now scalable when a redis storage backend is configured.

This guide covers the upgrade from {{ product_name }} 26.2 to 26.3. It summarizes what changed and links to the
per-component migration guides for the details.

## Component versions

| Component      | 26.2.x      | 26.3.0      | Migration notes                                         |
| -------------- | ----------- | ----------- | ------------------------------------------------------- |
| Controller     | `v0.34.x`   | `v0.35.3`   | [Controller `v0.35.0`](controller/migration/v0.35.0.md) |
| RoomServer     | `v0.1.x`    | `v0.10.3`   | See [below](#2-update-the-controller-and-roomserver)    |
| Orchestrator   | `v0.8.x`    | `v0.12.1`   | See [below](#3-update-the-orchestrator)                 |
| Recorder       | `v0.17.x`   | `v0.18.2`   | See [below](#4-update-the-recorder)                     |
| Obelisk        | `v0.22.x`   | `v0.23.2`   | no configuration changes                                |
| SMTP Mailer    | `v0.18.x`   | `v0.19.1`   | See [below](#5-update-the-smtp-mailer)                  |
| Web Frontend   | `v2.9.x`    | `v2.10.2`   | -                                                       |
| Outlook Add-in | `v0.4.x`    | `v0.6.0`    | -                                                       |
| LiveKit Server | `v1.13.5`   | `v1.13.10`  | -                                                       |
| Keycloak       | `v26.7.2`   | `v26.8.1-1` | -                                                       |
| PostgreSQL     | `v17.11.0`  | `v18.6.0`   | **Major upgrade**, see [below](#1-upgrade-postgresql)   |
| NDT Server     | `v0.25.3-1` | `v0.26.1`   | -                                                       |

!!! note
    The RoomServer crates switched to unified versioning, which is why the service version jumps from `v0.1.x` to
    `v0.10.x`. There are no intermediate RoomServer releases to migrate through.

## Unchanged components

| Component | Version                          |
| --------- | -------------------------------- |
| RabbitMQ  | `v4.3.7`                         |
| Redis     | `v8.10.2`                        |
| Minio     | `RELEASE.2025-10-15T17-29-55Z-1` |
| Garage    | `v2.3.0-1`                       |
| Traefik   | `v3.7.16`                        |

## What changed

### One join link per room

Invite codes were removed from all components. Rooms are now joined through a single join link, and the room's
access settings (password, waiting room, guest access) decide who can enter. The invite-code API was removed from the
Controller, and the Web Frontend, SMTP Mailer, Outlook Add-in, Obelisk and Recorder were updated accordingly.

Invitation links sent before the change that still use the legacy URL format continue to work.

### Room aliases

Rooms can now have an optional alias to give a personal room a readable name. To protect rooms against brute-force
attacks, a random suffix is appended to the alias by default. The behavior can be tuned in the Controller,
see [below](#2-update-the-controller-and-roomserver).

### Further changes

- Guests can join rooms with 'very high level of protection' turned on.
- When a event/room is deleted through the REST API, any associated running meeting is closed.
- The Outlook Add-in supports recurring meetings.

## 1. Upgrade PostgreSQL

26.3 upgrades PostgreSQL from `17` to `18`. PostgreSQL does not read data directories of a previous major version, so
replacing the container image alone is **not** sufficient. The data has to be migrated, either with a dump and restore
or with `pg_upgrade`.

For **Opentalk compose** deployments follow the update procedure in
[Updating OpenTalk Compose](deployment/opentalk-compose/1-quickstart-installation.md#7-updating-opentalk-compose).

For other deployments, follow the
[PostgreSQL upgrade documentation](https://www.postgresql.org/docs/18/upgrading.html).

## 2. Update the Controller and RoomServer

Controller `v0.35` requires RoomServer `v0.10`. Running a `v0.35` Controller with a RoomServer from 26.2 is not
supported.

With `roomserver.kind = "internal"`, the RoomServer is part of the Controller and there is no separate roomserver update
required.

With `roomserver.kind = "external"`, the RoomServer must be updated to `v0.10` to ensure API compatibility. There are
**no** breaking changes in the RoomServer configuration.

See the [Controller `v0.35.0` migration guide](controller/migration/v0.35.0.md) for all details.

### Room alias configuration

The new `[defaults.room_alias]` section in the Controller configuration is optional. Existing configurations keep
working with secure defaults:

```toml
[defaults.room_alias]
# When `true`, rooms with an alias will not have a suffix appended to their name.
# This makes the rooms vulnerable to brute-force or guessing attacks. Only enable it in trusted environments.
disable_suffix = false
# Length of the random suffix appended to an aliased room name.
# Allowed values are between 8 and 64, inclusive.
suffix_length = 16
```

### Signaling metrics

With 26.3 The opentelemetry `signaling_*` metrics moved from the Controller's `/metrics` endpoint to the
RoomServer `/metrics` endpoint. When configuring the RoomServer to be `roomserver.kind = "internal"`, the `/metrics`
endpoint is still served by the Controller

Some metrics were removed and a few were renamed. Check out the
[Controller `v0.35.0` migration guide](controller/migration/v0.35.0.md#metric-mapping) for the full mapping and
the [RoomServer metrics documentation](roomserver/observability/metrics.md) for all available metrics.

## 3. Update the Orchestrator

Orchestrator `v0.12` gets a mandatory `storage` configuration and now supports `redis` as storage backend. The redis
storage backend enables the Orchestrator to scale. With `local` storage the state is kept in the memory of the
orchestrator process and only one Orchestrator instance can be deployed.

When only running a single orchestrator, add the `storage` section and set the kind to `"local"` in the
`orchestrator.toml`:

```toml
[storage]
kind = "local"
```

### Scaling with redis

When using redis as a storage backend, multiple Orchestrator instance can run in parallel and share their state through
redis. For this to work, the Orchestrator instances need to be deployed behind a load balancer.

Requirements for the Redis instance:

- Redis 7.2 or newer. The orchestrator always connects with the RESP3 protocol.
- Keyspace notifications for keyspace events (`K`) and expired events (`x`). The orchestrator reads the
  `notify-keyspace-events` setting on startup and enables missing flags with `CONFIG SET`. If the `CONFIG` command
  isn't permitted for the orchestrator, e.g. on managed Redis offerings, enable the flags (`notify-keyspace-events Kx`)
  in the Redis configuration beforehand.
- Only single instance Redis deployments. Redis clusters are currently **not** supported.

When running multiple Orchestrator instances, add the `storage` section, set the kind to `"redis"` and add the redis
`url` in the `orchestrator.toml`:

```toml
[storage]
# Set the storage kind to redis
kind = "redis"

# The url of the redis instance. Can only be set when kind = "redis"
url = "redis://localhost:6379"
```

!!! note
    Make sure that all orchestrator instances are behind a load balancer and accessible through the same URL.

## 4. Update the Recorder

Recorder `v0.18` has no breaking configuration changes.

Environment variables with a double underscore after the `OPENTALK_REC` prefix are deprecated. Use a single underscore
after the prefix instead. Nested fields are still separated by two underscores:

```sh
# deprecated
OPENTALK_REC__CONTROLLER__URL=http://localhost:11311
# correct
OPENTALK_REC_CONTROLLER__URL=http://localhost:11311
```

The deprecated form keeps working for now, but the Recorder prints a warning on startup. See the
[Recorder configuration](recorder/configuration/README.md#environment-variables) for details.

## 5. Update the SMTP Mailer

With the removal of invite codes, the `guest_link_builder` option in the `[template-builder]` section was removed. If your
configuration still sets it, the SMTP Mailer logs an `Unknown configuration key` warning on startup. Remove the option
from your configuration:

```toml
[template-builder]
#guest_link_builder = "{base_url}/invite/{invite_id}"
```

## 6. Update the Web Frontend and the remaining services

The following components have **no** configuration changes and can be updated by replacing the container image or
package:

- Web Frontend `v2.10.2`
- Obelisk `v0.23.2`
- Outlook Add-in `v0.6.0`
- LiveKit Server `v1.13.10`
- Keycloak `v26.8.1-1`
