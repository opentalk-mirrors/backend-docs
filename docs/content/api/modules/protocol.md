# Protocol

---

## Commands

### SelectWriter

The `SelectWriter` message can be send by a moderator to select a number of participants as writers.
The underlying etherpad state gets lazily initialized when this message is received by the controller.

Can return [Error](#error) of kind `insufficient_permissions`, `currently_initializing` `failed_initialization`.

__Response:__

Each participant receives an access url. Depending if they where selected as a writer they will receive
either a [WriteUrl](#writeurl) or [ReadUrl](#readurl).

__Fields:__

| Field             | Type       | Required | Description                                                                  |
| ----------------- | ---------- | -------- | ---------------------------------------------------------------------------- |
| `participant_ids` | `[string]` | yes      | An array of participant ids that shall get write access to the etherpad pad. |

__Examples:__

```json
{
    "action": "select_writer",
    "participant_ids": ["00000000-0000-0000-0000-000000000000", "00000000-0000-0000-0000-000000000001"]
}
```

## Events

### WriteUrl

Received by participants that got selected as a writer by a moderator. (See [SelectWriter](#selectwriter))

__Fields:__

| Field | Type       | Required | Description                                       |
| ----- | ---------- | -------- | ------------------------------------------------- |
| `url` | `[string]` | yes      | A url to the etherpad that will set  write access |

__Examples:__

```json
{
    "message":"write_url",
    "url":"http://localhost/auth_session?sessionID=s.session&padName=protocol&groupID=g.group"
}
```

---

### ReadUrl

Received by all participants that did not get selected as a writer by a moderator. (See [SelectWriter](#selectwriter))

__Fields:__

| Field | Type       | Required | Description                                       |
| ----- | ---------- | -------- | ------------------------------------------------- |
| `url` | `[string]` | yes      | A url to the etherpad that will set  write access |

__Examples:__

```json
{
    "message":"read_url",
    "url":"http://localhost/auth_session?sessionID=s.session&padName=protocol&groupID=g.group"
}
```

---

### Error

An error has occurred while issuing a command.

__Fields:__

| Field                     | Type       | Required | Description                                                                                          |
| ------------------------- | ---------- | -------- | ---------------------------------------------------------------------------------------------------- |
| `InsufficientPermissions` | `[string]` | yes      | The requesting user has insufficient permissions for the operation                                   |
| `CurrentlyInitializing`   | `[string]` | yes      | A moderator just send a [SelectWriter](#selectwriter) message and the etherpad is still initializing |
| `FailedInitialization`    | `[string]` | yes      | The etherpad initialization failed                                                                   |

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
    "error":"currently_initializing"
}
```

```json
{
    "message":"error",
    "error":"failed_initialization"
}
```
