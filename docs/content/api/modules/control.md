# Control

The control module contains the base functionality for the conference including information like the participant list,
roles and hand raise.

## Commands

### Join

Must be the first message to be sent when the websocket connection is established.

__Fields:__

| Field          | Type     | Required | Description                                                   |
| -------------- | -------- | -------- | ------------------------------------------------------------- |
| `action`       | `enum`   | yes      | Must be "join"                                                |
| `display_name` | `string` | yes      | String to be displayed as the user's display name in the room |

__Example:__

```json
{
    "action": "join",
    "display_name": "Test"
}
```

### EnterRoom

Can only be sent while in the waiting room and after being accepted by an moderator.

See [InWaitingRoom](/api/modules/moderation#inwaitingroom)

__Fields:__

| Field    | Type   | Required | Description          |
| -------- | ------ | -------- | -------------------- |
| `action` | `enum` | yes      | Must be "enter_room" |

__Example:__

```json
{
    "action": "enter_room"
}
```

### Raise Hand

Notify other users that your hand is raised.

__Fields:__

| Field    | Type   | Required | Description          |
| -------- | ------ | -------- | -------------------- |
| `action` | `enum` | yes      | Must be "raise_hand" |

__Example:__

```json
{
    "action": "raise_hand"
}
```

### Lower Hand

Notify other users that your hand is no longer raised.

__Fields:__

| Field    | Type   | Required | Description          |
| -------- | ------ | -------- | -------------------- |
| `action` | `enum` | yes      | Must be "raise_hand" |

__Example:__

```json
{
    "action": "raise_hand"
}
```

### Grant moderator role

Requires moderator role.

Grant a participant the moderator role.

__Fields:__

| Field    | Type     | Required | Description                                       |
| -------- | -------- | -------- | ------------------------------------------------- |
| `action` | `enum`   | yes      | Must be "grant_moderator_role"                    |
| `target` | `string` | yes      | Id of the participant to grant the moderator role |
__Example:__

```json
{
    "action": "grant_moderator_role",
    "target": "00000000-0000-0000-0000-000000000000"
}
```

### Revoke moderator role

Requires moderator role.

Revoke the moderator role from a participant. Cannot revoke the moderator role from the creator of the room.

__Fields:__

| Field    | Type     | Required | Description                                             |
| -------- | -------- | -------- | ------------------------------------------------------- |
| `action` | `enum`   | yes      | Must be "grant_moderator_role"                          |
| `target` | `string` | yes      | Id of the participant to revoke the moderator role from |
__Example:__

```json
{
    "action": "revoke_moderator_role",
    "target": "00000000-0000-0000-0000-000000000000"
}
```

## Events

### Data Types

#### Participant

__Fields:__

Information about another participant

| Field                  | Type          | Always | Description                                                                                 |
| ---------------------- | ------------- | ------ | ------------------------------------------------------------------------------------------- |
| `id`                   | `string`      | yes    | ID of the participant                                                                       |
| `control`              | `ControlData` | yes    | Information about the participant provided by the control module                            |
| `some_other_module...` | `object`      | ?      | Not an actual field but every module can attach data about the participant under their name |

#### ControlData

Information about another participant provided by the `control` module

__Fields:__

| Field                | Type     | Always | Description                                                     |
| -------------------- | -------- | ------ | --------------------------------------------------------------- |
| `display_name`       | `string` | yes    | Display name of the participant                                 |
| `role`               | `enum`   | yes    | either `guest`, `user` or `moderator`                           |
| `avatar_url`         | `string` | no     | url to your avatar image if the participant is a logged in user |
| `participation_kind` | `enum`   | yes    | either `user`, `guest` or `sip`                                 |
| `hand_is_up`         | `bool`   | yes    | true if the user is currently raising his hand                  |
| `joined_at`          | `string` | yes    | timestamp of when the participant joined                        |
| `left_at`            | `string` | no     | timestamp of when the participant left the room                 |
| `hand_updated_at`    | `string` | yes    | timestamp of when the hand-raise status last changed            |

### JoinSuccess

Received after joining the room. Can be triggered bei either calling [Join](#join) or [EnterRoom](#enterroom).

__Fields:__

| Field          | Type            | Always | Description                           |
| -------------- | --------------- | ------ | ------------------------------------- |
| `message`      | `enum`          | yes    | Is "join_success"                     |
| `id`           | `string`        | yes    | Your participant-id in this session   |
| `display_name` | `string`        | yes    | Your display_name in this session     |
| `avatar_url`   | `string`        | no     | url to your avatar image if logged    |
| `role`         | `enum`          | yes    | either `guest`, `user` or `moderator` |
| `participants` | `[Participant]` | yes    | list of participants in the room      |

__Example:__

```json
{
  "message": "join_success",
  "id": "00000000-0000-0000-0000-000000000000",
  "display_name": "My Display Name",
  "avatar_url":"https://example.org/",
  "role": "moderator",
  "participants": [
    {
      "id": "00000000-0000-0000-0000-000000000000",
      "control": {
        "display_name": "Someone Else",
        "hand_is_up": false,
        "hand_updated_at": "2022-05-10T10:40:39Z",
        "joined_at": "2022-05-10T10:40:39Z",
        "left_at": "2022-05-10T10:40:42Z",
        "participation_kind": "user"
      }
    }
  ]
}
```

### Update

Received when a participant changes his state. Wraps a [Participant](#participant).

| Field     | Type   | Always | Description |
| --------- | ------ | ------ | ----------- |
| `message` | `enum` | yes    | Is "update" |

__Example:__

```json
{
    "message": "update",
    "id": "00000000-0000-0000-0000-000000000000",
    "control": {
      "display_name": "Someone Else",
      "hand_is_up": false,
      "hand_updated_at": "2022-05-10T10:40:39Z",
      "joined_at": "2022-05-10T10:40:39Z",
      "left_at": "2022-05-10T10:40:42Z",
      "participation_kind": "user"
    }
}
```

### Joined

Received when a participant joined the room. Wraps a [Participant](#participant).

| Field     | Type   | Always | Description |
| --------- | ------ | ------ | ----------- |
| `message` | `enum` | yes    | Is "joined" |

__Example:__

```json
{
    "message": "joined",
    "id": "00000000-0000-0000-0000-000000000000",
    "control": {
      "display_name": "Someone Else",
      "hand_is_up": false,
      "hand_updated_at": "2022-05-10T10:40:39Z",
      "joined_at": "2022-05-10T10:40:39Z",
      "left_at": "2022-05-10T10:40:42Z",
      "participation_kind": "user"
    }
}
```

### Left

Received when a participant left the room.

| Field     | Type     | Always | Description                         |
| --------- | -------- | ------ | ----------------------------------- |
| `message` | `enum`   | yes    | Is "left"                           |
| `id`      | `string` | yes    | Id of the participant that has left |

__Example:__

```json
{
    "message": "left",
    "id": "00000000-0000-0000-0000-000000000000"
}
```

### RoleUpdated

Received when a moderator assigned you a new role.

| Field      | Type   | Always | Description                         |
| ---------- | ------ | ------ | ----------------------------------- |
| `message`  | `enum` | yes    | Is "role_updated"                   |
| `new_role` | `enum` | yes    | either `guest`, `user`, `moderator` |

__Example:__

```json
{
    "message": "role_updated",
    "new_role": "moderator"
}
```

### Error

Received when something went wrong.

| Field     | Type   | Always | Description          |
| --------- | ------ | ------ | -------------------- |
| `message` | `enum` | yes    | Is "error"           |
| `text`    | `enum` | yes    | arbitrary error text |

__Example:__

```json
{
    "message": "error",
    "text": "something happened"
}
```
