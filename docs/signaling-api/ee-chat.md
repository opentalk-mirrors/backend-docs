# EE-Chat

The ee-chat module allows users to send messages to groups as defined in
the identity management system used by the deployment.

## Commands

### SendMessage

Send a message to a group.

#### Fields

| Field     | Type     | Required | Description                      |
| --------- | -------- | -------- | -------------------------------- |
| `action`  | `enum`   | yes      | Must be "send_message"           |
| `group`   | `string` | yes      | The target group for the message |
| `content` | `string` | yes      | The message content              |

##### Example

```json
{
    "action": "send_message",
    "group": "management",
    "content": "Hi managers!"
}
```

## Events

### MessageSent

A message has been sent to a group which is visible to the current participant.

#### Fields

| Field       | Type     | Always | Description                                                        |
| ----------- | -------- | ------ | ------------------------------------------------------------------ |
| `message`   | `enum`   | yes    | Is "message_sent"                                                  |
| `source`    | `string` | yes    | Id of the participant who sent the message                         |
| `group`     | `string` | yes    | The target group                                                   |
| `timestamp` | `string` | yes    | Deprecated, use `timestamp` field of the Namespaced struct instead |
| `content`   | `string` | yes    | The message content                                                |

##### Example

```json
{
    "message": "message_sent",
    "source": "00000000-0000-0000-0000-000000000000",
    "group": "management",
    "timestamp": "1970-01-01T00:00:00Z",
    "content": "Hi managers!"
}
```

### Error

Received when the server wasn't able to process a command.

#### Fields

| Field     | Type   | Always | Description                                       |
| --------- | ------ | ------ | ------------------------------------------------- |
| `message` | `enum` | yes    | Is "error"                                        |
| `error`   | `enum` | yes    | Exhaustive list of error strings, see table below |

| Error                      | Description                                                     |
| -------------------------- | --------------------------------------------------------------- |
| `chat_disabled`            | A message was sent while the chat was disabled                  |

##### Example

```json
{
    "message": "error",
    "error": "chat_disabled"
}
```
