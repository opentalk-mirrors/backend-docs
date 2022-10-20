# Legal Vote

## Terminology

* __User__ - A user is a an account inside OpenTalk, a single user may be inside a room as multiple participants.
* __Participant__ - A unique connection to a room. Participants may be a guest or logged in user.

## Overview

The legal vote module allows users to participate in a legally sound vote. When a vote is started a number of allowed participants
can cast the vote options `Yes`, `No` and `Abstain` on a defined vote topic. An allowed participant cannot be a guest, as each
participant needs to have an underlying user id in order to cast a vote.

While a vote is active, the occurring vote events are saved in a `vote protocol` which is moved to the database once the vote is complete.
This provides a foundation to backtrack results, votes and errors after a vote has ended. The result and protocol of a vote can be
accessed in redis for the lifetime of the room where the vote had taken place in.

The state of a vote is held in a redis instance. There can only be one active vote at a time, every completed vote gets moved to the
`vote history` for later access. Any operation that accesses more than one redis key is done with a Lua script in order to make those
operations atomic.
