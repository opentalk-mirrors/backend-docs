# OpenTalk Administration

OpenTalk consists of several components that provide different services, some
mandatory, some optional. Each of these services is documented in a separate
section.

| Component                                     | Required | Description                                                                       |
| --------------------------------------------- | -------- | --------------------------------------------------------------------------------- |
| [OpenTalk Controller](controller/README.md)   | Yes      | Web API which is accessed by the frontend                                         |
| [OpenTalk Obelisk](obelisk/README.md)         | No       | Service for participating in a meeting through call-in services, e.g. through SIP |
| [OpenTalk Recorder](recorder/README.md)       | No       | Service for recording and streaming meetings                                      |
| [OpenTalk RoomServer](roomserver/README.md)   | No       | Signaling API which is accessed by the frontend                                   |
| [OpenTalk SMTP Mailer](smtp-mailer/README.md) | No       | Service for sending out invitation and other notification mails to participants   |

## Deployment

For a ready-to-use deployment that ties the components above together,
see [OpenTalk Compose](deployment/opentalk-compose/README.md).
It provides a Docker Compose setup covering the controller and the optional services.

## Community

Feel free to interact with other administrators of OpenTalk instances in one of our community channels:

- Matrix Chat Community Space [`#opentalk-community:matrix.org`](https://matrix.to/#/#opentalk-community:matrix.org)
- Matrix Chat Hosting Channel [`#opentalk-hosting:matrix.org`](https://matrix.to/#/#opentalk-hosting:matrix.org)
- [Mailing Lists](https://lists.opentalk.eu/)

Please be aware that these channels are purely community-driven, and even though
some of the OpenTalk developers are occasionally present on their own
initiative, there is no guarantee for timely answers.
