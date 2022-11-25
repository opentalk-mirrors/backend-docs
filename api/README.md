# K3K API

API definition and documentation for the K3K conference system. The specifications are split into the two folders `controller` and `signaling`.
The `controller` OpenAPI specs describes the REST API that is used by a frontend in order to Login and manage Users/Rooms. The `signaling` AsyncAPI
specs describes the async messages that are sent over a WebSocket connection in order to connect to a room and manage the media session.

## How to render

The specs have to be rendered separately due to their different underlying specification

### Render controller frontend API

See [redoc.ly quickstart](https://redoc.ly/docs/redoc/quickstart/cli/)

### Render signaling async API

Install the spec renderer:

`yarn global add  @asyncapi/generator`

Build rendered spec:

`$(yarn global bin)/ag signaling/asyncapi.yaml @asyncapi/html-template --force-write -o build/signaling`
