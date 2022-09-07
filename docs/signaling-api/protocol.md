# Protocol

---

## Commands

### SelectWriter

The `SelectWriter` message can be sent by a moderator to select a number of participants as writers.
The underlying etherpad state gets lazily initialized when this message is received by the controller.

Can return [Error](#error) of kind `insufficient_permissions`, `currently_initializing` `failed_initialization`.

#### Fields

| Field             | Type       | Required | Description                                                                  |
| ----------------- | ---------- | -------- | ---------------------------------------------------------------------------- |
| `participant_ids` | `string[]` | yes      | An array of participant ids that shall get write access to the etherpad pad. |

##### Example

```json
{
    "action": "select_writer",
    "participant_ids": ["00000000-0000-0000-0000-000000000000", "00000000-0000-0000-0000-000000000001"]
}
```

#### Response

Each participant receives an access url. Depending if they were selected as a writer they will receive
either a [WriteUrl](#writeurl) or [ReadUrl](#readurl).

---
### DeselectWriter

The `DeselectWriter` message can be sent by a moderator to deselect a number of writers.

The deselected participants will have their write session invalidated and will receive a read access url.

#### Response

Each selected participant that has write access, receives a new read-only access url.

Can return [Error](#error) of kind `insufficient_permissions`, `currently_initializing`, `not_initialized` or `invalid_participant_selection`.

#### Fields

| Field             | Type       | Required | Description                                                                   |
| ----------------- | ---------- | -------- | ----------------------------------------------------------------------------- |
| `participant_ids` | `[string]` | yes      | An array of participant ids that shall lose write access to the etherpad pad. |

#### Examples

```json
{
    "action": "deselect_writer",
    "participant_ids": ["00000000-0000-0000-0000-000000000000", "00000000-0000-0000-0000-000000000001"]
}
```

## Events

### WriteUrl

Received by participants that got selected as a writer by a moderator. (See [SelectWriter](#selectwriter))

#### Fields

| Field | Type       | Required | Description                                    |
| ----- | ---------- | -------- | ---------------------------------------------- |
| `url` | `string[]` | yes      | A url to the etherpad that grants write access |

##### Example

```json
{
    "message":"write_url",
    "url":"http://localhost/auth_session?sessionID=s.session&padName=protocol&groupID=g.group"
}
```

### ReadUrl

Received by all participants that did not get selected as a writer by a moderator. (See [SelectWriter](#selectwriter))

#### Fields

| Field | Type       | Required | Description                                       |
| ----- | ---------- | -------- | ------------------------------------------------- |
| `url` | `string[]` | yes      | A url to the etherpad that will set  write access |

##### Example

```json
{
    "message":"read_url",
    "url":"http://localhost/auth_session?sessionID=s.session&padName=protocol&groupID=g.group"
}
```

### Control Update

The `update` message in the `control` namespace contains the current etherpad access level of the updated participant.

This information is only present when the receiver is a moderator.

An update message is issued when a participants etherpad access level changes.

#### Fields

| Field      | Type   | Required | Description                                 |
| ---------- | ------ | -------- | ------------------------------------------- |
| `readonly` | `bool` | yes      | The current access level of the participant |

#### Examples

```json
{
    "namespace": "control",
    "timestamp": "2022-06-14T17:18:52Z",
    "payload": {
        "message": "update",
        "id": "24500907-334b-47d4-b54a-00db40b9a613",
        ...
        "protocol": {
            "readonly": false
        }
    }
}
```

### Error

An error has occurred while issuing a command.

#### Fields

| Field                     | Type       | Required | Description                                                                                          |
| ------------------------- | ---------- | -------- | ---------------------------------------------------------------------------------------------------- |
| `InsufficientPermissions` | `string[]` | yes      | The requesting user has insufficient permissions for the operation                                   |
| `CurrentlyInitializing`   | `string[]` | yes      | A moderator just send a [SelectWriter](#selectwriter) message and the etherpad is still initializing |
| `FailedInitialization`    | `string[]` | yes      | The etherpad initialization failed                                                                   |
| `NotInitialized`          | `string[]` | yes      | The etherpad is not yet initialized                                                                  |

##### Example

```json
{
    "message":"error",
    "error":"insufficient_permissions"
}
```

```json
{
    "message":"error",
    "error":"currently_initializing"
}
```

```json
{
    "message":"error",
    "error":"failed_initialization"
}
```

```json
{
    "message":"error",
    "error":"not_initialized"
}
```
