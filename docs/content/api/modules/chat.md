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
