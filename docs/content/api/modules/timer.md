# Timer

---

## Overview

The timer module allows a moderator to start a timer for all participants in the room.

When a duration is configured, the timer behaves like a normal countdown that triggers a `stopped` event forall participants when the duration expired.

When no duration is configured, the timer will act like a stopwatch (count up) and must be stopped manually by one of the moderators via a `Stop` action.

There can only be one timer present at a time. Due to a current limitation of our module system,
all participants will receive a `stopped` event when the creator of a timer leaves the room. This behavior shall be fixed in the future.

## Commands

### Start

The `Start` action can be sent by a moderator to start a new timer.

Can return [Error](#error) of kind `insufficient_permissions`, `invalid_duration` or `timer_already_running`

__Response:__

Each participant receives an [Started](#started) message with the configuration of the timer

__Fields:__

| Field                | Type     | Required | Description                                                                                     |
| -------------------- | -------- | -------- | ----------------------------------------------------------------------------------------------- |
| `action`             | `enum`   | yes      | Must be "start"                                                                                 |
| `duration`           | `int`    | no       | The duration (seconds) of the timer. If not set, the timer will act like a stopwatch (count up) |
| `title`              | `string` | no       | The optional title for the timer                                                                |
| `enable_ready_check` | `bool`   | yes      | Enables/Disables participants to send a `update_ready_check` action                             |

When `duration` is set, the module will automatically send a [Stopped](#stopped) message when the duration expires.

__Examples:__

```json
{
    "action": "start",
    "duration": 5,
    "title": "Testing the timer!",
    "ready_check": false
}
```

### Stop

The `Stop` action can be sent by moderator to start a stop a timer.

__Response:__

Each participant receives an [Stopped](#stopped) message.

__Fields:__

| Field      | Type     | Required | Description                                           |
| ---------- | -------- | -------- | ----------------------------------------------------- |
| `action`   | `enum`   | yes      | Must be "stop"                                        |
| `timer_id` | `string` | yes      | The timer id (uuid)                                   |
| `reason`   | `string` | no       | An optional reason for the stop, set by the moderator |

__Examples:__

```json
        {
            "action": "stop",
            "timer_id": "00000000-0000-0000-0000-000000000000",
            "reason": "test"
        }
```

### Update Ready Status

Set the ready status of a participant.

Can be sent by any participant only when `ready_check` is set to true in [Start](#start).

__Response:__

Each participant receives a [Control Update](#control-update) event with the participants R2C status.

__Fields:__

| Field      | Type     | Required | Description                       |
| ---------- | -------- | -------- | --------------------------------- |
| `action`   | `enum`   | yes      | Must be "update_ready_status"     |
| `timer_id` | `string` | yes      | The timer id (uuid)               |
| `status`   | `bool`   | yes      | The R2C status of the participant |

__Examples:__

```json
{
    "action": "update_ready_status",
    "timer_id": "00000000-0000-0000-0000-000000000000",
    "status": true
}
```

## Events

### Started

A timer has been started.

This message is also received in the `join_success` message when joining a room where a timer is active.

__Fields:__

| Field                 | Type     | Always | Description                                                          |
| --------------------- | -------- | ------ | -------------------------------------------------------------------- |
| `message`             | `enum`   | yes    | Is "started"                                                         |
| `timer_id`            | `string` | yes    | The timer id (uuid)                                                  |
| `started_at`          | `string` | yes    | RFC 3339 timestamp of when the timer started                         |
| `ends at`             | `string` | no     | optional RFC 3339 timestamp of when the timer will end               |
| `title`               | `string` | no     | An optional title for the timer                                      |
| `ready_check_enabled` | `bool`   | yes    | Enables/Disables participants to send a `update_ready_status` action |

When the `ends_at` field is not set, the timer shall behave like a stopwatch (count up).

__Example:__

```json
{
    "message": "started",
    "timer_id": "00000000-0000-0000-0000-000000000000",
    "started_at": "1970-01-01T00:00:00Z",
    "ends_at": "1970-01-01T00:00:00Z",
    "title": "Testing the timer!",
    "ready_check_enabled": false
}
```

### Stopped

A timer has been stopped.

__Fields:__

| Field            | Type     | Always                        | Description                                                         |
| ---------------- | -------- | ----------------------------- | ------------------------------------------------------------------- |
| `message`        | `enum`   | yes                           | Is "stopped"                                                        |
| `timer_id`       | `string` | yes                           | The timer id (uuid)                                                 |
| `kind`           | `enum`   | yes                           | The kind of stop. Must me `by_moderator`, `expired`, `creator_left` |
| `participant_id` | `string` | when `kind` is `by_moderator` | The participant id of the moderator that stopped the timer          |
| `reason`         | `string` | when `kind` is `by_moderator` | Optional reason. Set by the moderator                               |

__StopKind:__

| Kind           | Description                                   |
| -------------- | --------------------------------------------- |
| `by_moderator` | The timer was stopped manually by a moderator |
| `expired`      | The duration of the timer has expired         |
| `creator_left` | The creator of the timer has left the room    |

__Example:__

by moderator:

```json
{
    "message": "stopped",
    "timer_id": "00000000-0000-0000-0000-000000000000",
    "kind": "by_moderator",
    "participant_id": "00000000-0000-0000-0000-000000000000",
    "reason": "A good reason!"
}
```

expired:

```json
{
    "message": "stopped",
    "timer_id": "00000000-0000-0000-0000-000000000000",
    "kind": "expired",
}
```

creator_left:

```json
{
    "message": "creator_left",
    "timer_id": "00000000-0000-0000-0000-000000000000",
    "kind": "expired",
}
```

### Updated ready status

A participant has updated its ready status.

__Fields:__

| Field            | Type     | Always | Description                                 |
| ---------------- | -------- | ------ | ------------------------------------------- |
| `message`        | `enum`   | yes    | Is "updated_ready_status"                   |
| `timer_id`       | `string` | yes    | The timer id (uuid)                         |
| `participant_id` | `string` | yes    | The participant that had its status updated |
| `status`         | `bool`   | yes    | The participants status                     |

__Examples:__

```json
{
    "message": "updated_ready_status",
    "timer_id": "00000000-0000-0000-0000-000000000000",
    "participant_id": "00000000-0000-0000-0000-000000000000",
    "status": true,
}
```

### Error

An error has occurred while issuing a command.

__Fields:__

| Error                      | Description                                                |
| -------------------------- | ---------------------------------------------------------- |
| `insufficient_permissions` | The issued command requires greater permissions            |
| `invalid_duration`         | The provided duration (in a start request) is invalid      |
| `timer_already_running`    | A timer is already running while trying to start a new one |

__Examples:__

```json
{
    "message":"error",
    "error":"insufficient_permissions"
}
```

```json
{
    "message":"error",
    "error":"invalid_duration"
}
```

```json
{
    "message":"error",
    "error":"timer_already_running"
}
```
