# Chat

The chat module allows users to send messages to either the whole
conference room, or to individual users.

## Commands

### EnableChat

Allows a moderator to enable the chat if it is currently disabled.

#### Fields

| Field    | Type   | Required | Description           |
| -------- | ------ | -------- | --------------------- |
| `action` | `enum` | yes      | Must be "enable_chat" |

##### Example

```json
{
    "action": "enable_chat"
}
```

---

### DisableChat

Allows a moderator to disable the chat if it is currently enabled.

#### Fields

| Field    | Type   | Required | Description            |
| -------- | ------ | -------- | ---------------------- |
| `action` | `enum` | yes      | Must be "disable_chat" |

##### Example

```json
{
    "action": "disable_chat"
}
```

---

### SendMessage

Send a message to either the conference room (global message) or to a
specific user (direct message).

#### Fields

| Field     | Type     | Required | Description                                |
| --------- | -------- | -------- | ------------------------------------------ |
| `action`  | `enum`   | yes      | Must be "send_message"                     |
| `target`  | `string` | no       | The target participant for direct messages |
| `content` | `string` | yes      | The message content                        |

##### Example

```json
{
    "action": "send_message",
    "content": "Hello all!"
}
```

```json
{
    "action": "send_message",
    "target": "00000000-0000-0000-0000-000000000000",
    "content": "Hello Bob!"
}
```

---

### ClearHistory

Allows a moderator to clear the global chat history of the conference room.

#### Fields

| Field    | Type   | Required | Description             |
| -------- | ------ | -------- | ----------------------- |
| `action` | `enum` | yes      | Must be "clear_history" |

##### Example

```json
{
    "action": "clear_history"
}
```

## Events

### MessageSent

A message has been sent to either the global chat or directly to the participant.

#### Fields

| Field       | Type     | Always | Description                                                              |
| ----------- | -------- | ------ | ------------------------------------------------------------------------ |
| `message`   | `enum`   | yes    | Is "message_sent"                                                        |
| `source`    | `string` | yes    | Id of the participant who sent the message                               |
| `scope`     | `enum`   | yes    | Either "global" or "private"                                             |
| `target`    | `string` | no     | Only present if `scope` is "private". Participant id of the current user |
| `timestamp` | `string` | yes    | Deprecated, use `timestamp` field of the Namespaced struct instead       |

##### Example

```json
{
    "message": "message_sent",
    "source": "00000000-0000-0000-0000-000000000000",
    "scope": "global",
    "timestamp": "1970-01-01T00:00:00Z",
    "content": "Hello all!"
}
```

```json
{
    "message": "message_sent",
    "source": "00000000-0000-0000-0000-000000000000",
    "scope": "private",
    "target": "00000000-0000-0000-0000-0000deadbeef",
    "timestamp": "1970-01-01T00:00:00Z",
    "content": "Hello Bob!"
}
```

### Error

Received when something went wrong processing messages sent to the server.

#### Fields

| Field     | Type   | Always | Description                                       |
| --------- | ------ | ------ | ------------------------------------------------- |
| `message` | `enum` | yes    | Is "error"                                        |
| `error`   | `enum` | yes    | Exhaustive list of error strings, see table below |

| Error                      | Description                                                     |
| -------------------------- | --------------------------------------------------------------- |
| `chat_disabled`            | A message was sent while the chat was disabled                  |
| `insufficient_permissions` | A moderator action was attempted by a non-moderator participant |

```json
{
    "message": "error",
    "error": "chat_disabled"
}
```
