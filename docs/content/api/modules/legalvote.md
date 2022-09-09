# Legal Vote

---

## Commands

Commands are issued by a participant to start or interact with a vote.

### Start

The `Start` message can be send by a user to start a new legal vote.

#### Fields

| Field                  | Type       | Required | Validation        | Description                                                                              |
| ---------------------- | ---------- | -------- | ----------------- | ---------------------------------------------------------------------------------------- |
| `action`               | `enum`     | yes      |                   | Must be "start".                                                                         |
| `name`                 | `string`   | yes      | max 150 chars     | General name of the vote                                                                 |
| `topic`                | `string`   | yes      | max 500 chars     | Detailed topic that will be voted on.                                                    |
| `allowed_participants` | `string[]` | yes      | min 1 participant | An array of participant ids, where each contained participant is allowed to cast a vote. |
| `enable_abstain`       | `bool`     | yes      |                   | Enable/Disable the 'Abstain' option on this vote                                         |
| `auto_stop`            | `bool`     | yes      |                   | When set, the vote will automatically stop when every allowed participant casted a vote. |
| `duration`             | `int`      | no       | min 5 seconds     | Duration of the vote in seconds                                                          |

##### Example

```json
{
    "action": "start",
    "name": "Vote Test",
    "topic": "Yes or No?",
    "allowed_participants": [
        "00000000-0000-0000-0000-000000000001",
        "00000000-0000-0000-0000-000000000002",
        "00000000-0000-0000-0000-000000000003"
    ],
    "enable_abstain": false,
    "auto_stop": false,
    "duration": 60
}
```

#### Response

A [Started](#started) message is sent to all participants that are currently in the room.

---

### Stop

Stop the currently active vote. Will only succeed when the issuer is the vote initiator.

#### Fields

| Field     | Type     | Required | Description                    |
| --------- | -------- | -------- | ------------------------------ |
| `action`  | `enum`   | yes      | Must be "stop".                |
| `vote_id` | `string` | yes      | The vote that shall be stopped |

##### Example

```json
{
    "action": "stop",
    "vote_id": "00000000-0000-0000-0000-000000000000"
}
```

#### Response

A [Stopped](#stopped) message is sent to all participants that are currently in the room.

---

### Cancel

Cancel the currently active vote when the provided `vote_id` matches. This may only be sent by the vote initiator.
The vote protocol will still be saved in the database and in the room-vote-history, but the vote results should be handled as invalid.

This command may be triggered by the controller itself when an invalid state or error was detected.
See [Canceled](#canceled) for more details on which server events may cause this.

#### Fields

| Field     | Type     | Required | Validation    | Description                      |
| --------- | -------- | -------- | ------------- | -------------------------------- |
| `action`  | `enum`   | yes      |               | Must be "cancel".                |
| `vote_id` | `string` | yes      |               | The vote that shall be canceled. |
| `reason`  | `string` | yes      | max 255 chars | The reason for the cancel.       |

##### Example

```json
{
    "action": "cancel",
    "vote_id": "00000000-0000-0000-0000-000000000000",
    "reason": "A very descriptive reason",
}
```

#### Response

A [Canceled](#canceled) message is sent to all participants that are currently in the room.

---

### Vote

Cast a vote on the specified `vote_id`. Each user is allowed to only vote once.

#### Fields

| Field     | Type     | Required | Description                                                                                 |
| --------- | -------- | -------- | ------------------------------------------------------------------------------------------- |
| `action`  | `enum`   | yes      | Must be "vote".                                                                             |
| `vote_id` | `string` | yes      | The vote that shall be voted on.                                                            |
| `option`  | `enum`   | yes      | The chosen vote option, may be `yes`, `no` or `abstain` when the abstain option is enabled. |

##### Example

```json
{
    "action": "vote",
    "vote_id": "00000000-0000-0000-0000-000000000000",
    "option": "yes",
}
```

#### Response

When the vote is successful, a [Voted](#voted) message is sent to each participant that is logged in under the same user id.

When the vote failed, a [Voted](#voted) response is sent to the issuer.

---

## Events

Events are received by participants when the vote state is changed. Events may be a 'direct' response to an issued command or unrelated
to the actions of the receiving participant.

### Started

A vote has been started by a moderator.

This message will also be received when joining a room that has an active vote going.

#### Fields

| Field                  | Type       | Required | Description                                                                              |
| ---------------------- | ---------- | -------- | ---------------------------------------------------------------------------------------- |
| `message`              | `enum`     | yes      | Is "started".                                                                            |
| `initiator_id`         | `string`   | yes      | Id of the participant which started the vote.                                            |
| `vote_id`              | `string`   | yes      | Id of the vote.                                                                          |
| `start_time`           | `string`   | yes      | RFC 3339 timestamp when the vote started.                                                |
| `max_votes`            | `int`      | yes      | The maximum number of possible votes.                                                    |
| `name`                 | `string`   | yes      | General name of the vote.                                                                |
| `topic`                | `string`   | yes      | Detailed topic that will be voted on.                                                    |
| `allowed_participants` | `string[]` | yes      | An array of participant ids, where each contained participant is allowed to cast a vote. |
| `enable_abstain`       | `bool`     | yes      | Enable/Disable the 'Abstain' option on this vote.                                        |
| `auto_stop`            | `bool`     | yes      | When set, the vote will automatically stop when every allowed participant casted a vote. |
| `duration`             | `int`      | no       | Duration of the vote in seconds, counting from the `start_time`.                         |

##### Example

```json
{
    "message": "started",
    "initiator_id": "00000000-0000-0000-0000-000000000004",
    "vote_id": "00000000-0000-0000-0000-000000000123",
    "start_time": "1970-01-01T00:00:00Z",
    "max_votes": 3,
    "name": "Vote Test",
    "topic": "Yes or No?",
    "allowed_participants": [
        "00000000-0000-0000-0000-000000000001",
        "00000000-0000-0000-0000-000000000002",
        "00000000-0000-0000-0000-000000000003"
    ],
    "enable_abstain": false,
    "auto_stop": false,
    "duration": 60
}
```

---

### Voted

Event received whenever a user voted. Usually understood as a response to the [Vote](#vote) command.
Since every user may only vote once, each participant logged is as that user will receive this message after
any of them successfully cast their vote.

#### Fields

| Field         | Type     | Required                     | Description                                 |
| ------------- | -------- | ---------------------------- | ------------------------------------------- |
| `message`     | `enum`   | yes                          | Is "voted".                                 |
| `vote_id`     | `string` | yes                          | Id of the vote.                             |
| `response`    | `enum`   | yes                          | Either `success` or `failed`                |
| `vote_option` | `enum`   | when `response` is `success` | The option the `issuer` voted for           |
| `issuer`      | `string` | when `response` is `success` | Id of the participant which voted.          |
| `reason`      | `enum`   | when `response` is `failed`  | Reason why the vote failed, see table below |

__Failure reason:__

| Reason            | Description                                               |
| ----------------- | --------------------------------------------------------- |
| `invalid_vote_id` | the field `vote_id` contained an invalid or unknown id    |
| `ineligible`      | the user is not eligible to vote                          |
| `invalid_option`  | the given `vote_option` field contained an unknown option |

##### Examples

Successful vote:

```json
{
    "message": "voted",
    "vote_id": "00000000-0000-0000-0000-000000000123",
    "response": "success",
    "vote_option": "yes",
    "issuer": "00000000-0000-0000-0000-000000000001"
}
```

Failed vote:

```json
{
    "message": "voted",
    "vote_id": "00000000-0000-0000-0000-000000000123",
    "response": "failed",
    "reason": "ineligible"
}
```

---

### Updated

Update to a ongoing vote, signaling the newest results. Used to visualize the UI.

#### Fields

| Field     | Type     | Required                        | Description                                             |
| --------- | -------- | ------------------------------- | ------------------------------------------------------- |
| `message` | `enum`   | yes                             | Is "updated".                                           |
| `vote_id` | `string` | yes                             | Id of the vote.                                         |
| `yes`     | `int`    | yes                             | Number of `yes` votes                                   |
| `no`      | `int`    | yes                             | Number of `no` votes                                    |
| `abstain` | `int`    | when `enable_abstain` is `true` | Number of `abstain` votes                               |
| `voters`  | `map`    | yes                             | Mapping of participant which voted to their vote option |

##### Example

```json
{
    "message": "updated",
    "vote_id": "00000000-0000-0000-0000-000000000123",
    "yes": 1,
    "no": 2,
    "abstain": 2,
    "voters": {
        "00000000-0000-0000-0000-000000000001": "yes",
        "00000000-0000-0000-0000-000000000002": "no",
        "00000000-0000-0000-0000-000000000003": "abstain",
        "00000000-0000-0000-0000-000000000004": "abstain",
        "00000000-0000-0000-0000-000000000005": "no"
    }
}
```

---

### Stopped

Ongoing vote has been finished and the results are being distributed with this event. The vote results may be invalid, this happens when
the final vote results are not consistent or altered unexpectedly.

#### Fields

| Field     | Type     | Required                   | Description                                                                                               |
| --------- | -------- | -------------------------- | --------------------------------------------------------------------------------------------------------- |
| `message` | `enum`   | yes                        | Is "stopped".                                                                                             |
| `vote_id` | `string` | yes                        | Id of the vote.                                                                                           |
| `kind`    | `enum`   | yes                        | Either `user_stop`, `auto_stop` or `expired`                                                              |
| `issuer`  | `string` | when `kind` is `user_stop` | Id of the participant which issued the stop command                                                       |
| `results` | `enum`   | yes                        | Is either `valid` or `invalid`. This field changes the rest of the fields to one of the following tables. |

When `valid`:

| Field     | Type  | Required                        | Description                                             |
| --------- | ----- | ------------------------------- | ------------------------------------------------------- |
| `yes`     | `int` | yes                             | Number of `yes` votes                                   |
| `no`      | `int` | yes                             | Number of `no` votes                                    |
| `abstain` | `int` | when `enable_abstain` is `true` | Number of `abstain` votes                               |
| `voters`  | `map` | yes                             | Mapping of participant which voted to their vote option |

When `invalid`:

| Field    | Type   | Required | Description                                            |
| -------- | ------ | -------- | ------------------------------------------------------ |
| `reason` | `enum` | yes      | Either `abstain_disabled` or `vote_count_inconsistent` |

##### Example

Stopped with valid results:

```json
{
    "message": "stopped",
    "vote_id": "00000000-0000-0000-0000-000000000123",
    "kind": "user_stop",
    "issuer":  "00000000-0000-0000-0000-000000000001",
    "results": "valid",
    "yes": 1,
    "no": 2,
    "abstain": 2,
    "voters": {
        "00000000-0000-0000-0000-000000000001": "yes",
        "00000000-0000-0000-0000-000000000002": "no",
        "00000000-0000-0000-0000-000000000003": "abstain",
        "00000000-0000-0000-0000-000000000004": "abstain",
        "00000000-0000-0000-0000-000000000005": "no"
    }
}
```

Stopped with invalid results:

```json
{
    "message": "stopped",
    "vote_id": "00000000-0000-0000-0000-000000000123",
    "kind": "user_stop",
    "issuer":  "00000000-0000-0000-0000-000000000001",
    "results": "invalid",
    "reason": "vote_count_inconsistent"
}
```

---

### Canceled

Ongoing vote with `vote_id` has been canceled. This may either be issued by a moderator, or by the server when some error
or inconsistency occurred.

#### Fields

| Field     | Type     | Required                  | Description                                           |
| --------- | -------- | ------------------------- | ----------------------------------------------------- |
| `message` | `enum`   | yes                       | Is "canceled".                                        |
| `vote_id` | `string` | yes                       | Id of the vote.                                       |
| `reason`  | `enum`   | yes                       | Either `custom`, `room_destroyed` or `initiator_left` |
| `custom`  | `string` | when `reason` is `custom` | The reason for the cancel, set by the moderator.      |

##### Examples

```json
{
    "message": "canceled",
    "vote_id": "00000000-0000-0000-0000-000000000000",
    "reason": "initiator_left"
}
```

With custom reason:

```json
{
    "message": "canceled",
    "vote_id": "00000000-0000-0000-0000-000000000000",
    "reason": "custom",
    "custom": "Some important voters left"
}
```

---

### Error

The error event is a message that may be triggered by syntactically correct but invalid commands inside the `legal-vote` namespace
and therefore could be considered a kind of response. Errors must be handled outside of any context as they are considered events
that can happen at any time. (e.g. an `internal` error may occur at any time to signal an internal problem)

| Field     | Type       | Required                                    | Description                                          |
| --------- | ---------- | ------------------------------------------- | ---------------------------------------------------- |
| `message` | `enum`     | yes                                         | Is "error".                                          |
| `error`   | `enum`     | yes                                         | Exhaustive list of error strings, see table below    |
| `guests`  | `string[]` | when `error` is `allowlist_contains_guests` | A list of participants that where found to be quests |
| `fields`  | `string[]` | when `error` is `bad_request`               | A list of fields that ignored validation constraints |

| Error                       | Description                                                                                     |
| --------------------------- | ----------------------------------------------------------------------------------------------- |
| `vote_already_active`       | Start command sent while a vote was already active                                              |
| `no_vote_active`            | A vote related related request was send while no vote is active                                 |
| `invalid_vote_id`           | An invalid vote id was references inside a command                                              |
| `ineligible`                | The requesting user is ineligible for the issued command                                        |
| `allowlist_contains_guests` | The `allow_list` of a [Start](#start) provided `start` message contained guests                 |
| `bad_request`               | The input validation failed for one or more of the provided fields                              |
| `internal`                  | Backend services encountered an internal error and any active vote should be considered invalid |

#### Example

```json
{
    "message": "error",
    "error": "vote_already_active"
}
```

Error for an invalid [Start](#start) request, where the allowlist contains guests:

```json
{
    "message": "error",
    "error": "allowlist_contains_guest",
    "guests": ["00000000-0000-0000-0000-000000000123", "00000000-0000-0000-0000-000000011311"]
}
```

Error for an invalid [Start](#start) request, where `topic` and `duration` constraints where ignored:

```json
{
    "message": "error",
    "error": "bad_request",
    "guests": ["topic", "duration"]
}
```
