# SPDX-FileCopyrightText: OpenTalk GmbH <mail@opentalk.eu>
#
# SPDX-License-Identifier: EUPL-1.2
#
# This file can be used with the [`just`](https://just.systems) tool.

REPO_BASE := env('REPO_BASE', 'ssh://git@git.opentalk.dev:222')
TEMP_DIR := '.tmp'
DOCS_DIR := 'docs'
REPO_TEMP_DIR := TEMP_DIR + '/repos'
EXTRACTORS_DIR := 'extractors'

REPO_NAME_PRODUCT_RELEASES := env('REPO_NAME_PRODUCT_RELEASES', 'opentalk/product-releases')
REPO_BRANCH_PRODUCT_RELEASES := env('REPO_BRANCH_PRODUCT_RELEASES', 'main')
REPO_URL_PRODUCT_RELEASES := env('REPO_URL_PRODUCT_RELEASES', REPO_BASE + '/' + REPO_NAME_PRODUCT_RELEASES + '.git')
REPO_PATH_PRODUCT_RELEASES := REPO_TEMP_DIR + '/' + REPO_NAME_PRODUCT_RELEASES

REPO_NAME_OPENTALK_COMPOSE := env('REPO_NAME_OPENTALK_COMPOSE', 'opentalk/opentalk-devops/opentalk-compose')
REPO_VERSION_BRANCH_PREFIX_OPENTALK_COMPOSE := env('REPO_VERSION_BRANCH_PREFIX_OPENTALK_COMPOSE', 'origin/release/v')
REPO_VERSION_BRANCH_SUFFIX_OPENTALK_COMPOSE := env('REPO_VERSION_BRANCH_SUFFIX_OPENTALK_COMPOSE', '.x')
REPO_URL_OPENTALK_COMPOSE := env('REPO_URL_OPENTALK_COMPOSE', REPO_BASE + '/' + REPO_NAME_OPENTALK_COMPOSE + '.git')
REPO_PATH_OPENTALK_COMPOSE := REPO_TEMP_DIR + '/' + REPO_NAME_OPENTALK_COMPOSE

REPO_NAME_USER := env('REPO_NAME_USER', 'opentalk/support')
REPO_BRANCH_USER := env('REPO_BRANCH_USER', 'main')
REPO_URL_USER := env('REPO_URL_USER', REPO_BASE + '/' + REPO_NAME_USER + '.git')
REPO_PATH_USER := REPO_TEMP_DIR + '/' + REPO_NAME_USER

REPO_NAME_ARCHITECTURE := env('REPO_NAME_ARCHITECTURE', 'opentalk/backend/architecture')
REPO_BRANCH_ARCHITECTURE := env('REPO_BRANCH_ARCHITECTURE', 'main')
REPO_URL_ARCHITECTURE := env('REPO_URL_ARCHITECTURE', REPO_BASE + '/' + REPO_NAME_ARCHITECTURE + '.git')
REPO_PATH_ARCHITECTURE := REPO_TEMP_DIR + '/' + REPO_NAME_ARCHITECTURE

REPO_NAME_CONTROLLER := env('REPO_NAME_CONTROLLER', 'opentalk/backend/services/controller')
REPO_VERSION_BRANCH_PREFIX_CONTROLLER := env('REPO_VERSION_BRANCH_PREFIX_CONTROLLER', 'origin/release/v')
REPO_VERSION_BRANCH_SUFFIX_CONTROLLER := env('REPO_VERSION_BRANCH_SUFFIX_CONTROLLER', '.x')
REPO_URL_CONTROLLER := env('REPO_URL_USER', REPO_BASE + '/' + REPO_NAME_CONTROLLER + '.git')
REPO_PATH_CONTROLLER := REPO_TEMP_DIR + '/' + REPO_NAME_CONTROLLER

REPO_NAME_OBELISK := env('REPO_NAME_OBELISK', 'opentalk/backend/services/obelisk')
REPO_VERSION_BRANCH_PREFIX_OBELISK := env('REPO_VERSION_BRANCH_PREFIX_OBELISK', 'origin/release/v')
REPO_VERSION_BRANCH_SUFFIX_OBELISK := env('REPO_VERSION_BRANCH_SUFFIX_OBELISK', '.x')
REPO_URL_OBELISK := env('REPO_URL_OBELISK', REPO_BASE + '/' + REPO_NAME_OBELISK + '.git')
REPO_PATH_OBELISK := REPO_TEMP_DIR + '/' + REPO_NAME_OBELISK

REPO_NAME_RECORDER := env('REPO_NAME_RECORDER', 'opentalk/backend/services/recorder')
REPO_VERSION_BRANCH_PREFIX_RECORDER := env('REPO_VERSION_BRANCH_PREFIX_RECORDER', 'origin/release/v')
REPO_VERSION_BRANCH_SUFFIX_RECORDER := env('REPO_VERSION_BRANCH_SUFFIX_RECORDER', '.x')
REPO_URL_RECORDER := env('REPO_URL_RECORDER', REPO_BASE + '/' + REPO_NAME_RECORDER + '.git')
REPO_PATH_RECORDER := REPO_TEMP_DIR + '/' + REPO_NAME_RECORDER

REPO_NAME_SMTP_MAILER := env('REPO_NAME_SMTP_MAILER', 'opentalk/backend/services/smtp-mailer')
REPO_VERSION_BRANCH_PREFIX_SMTP_MAILER := env('REPO_VERSION_BRANCH_PREFIX_SMTP_MAILER', 'origin/release/v')
REPO_VERSION_BRANCH_SUFFIX_SMTP_MAILER := env('REPO_VERSION_BRANCH_SUFFIX_SMTP_MAILER', '.x')
REPO_URL_SMTP_MAILER := env('REPO_URL_SMTP_MAILER', REPO_BASE + '/' + REPO_NAME_SMTP_MAILER + '.git')
REPO_PATH_SMTP_MAILER := REPO_TEMP_DIR + '/' + REPO_NAME_SMTP_MAILER

REPO_NAME_ROOMSERVER := env('REPO_NAME_ROOMSERVER', 'opentalk/backend/services/roomserver')
REPO_VERSION_BRANCH_PREFIX_ROOMSERVER := env('REPO_VERSION_BRANCH_PREFIX_ROOMSERVER', 'origin/release/v')
REPO_VERSION_BRANCH_SUFFIX_ROOMSERVER := env('REPO_VERSION_BRANCH_SUFFIX_ROOMSERVER', '.x')
REPO_URL_ROOMSERVER := env('REPO_URL_ROOMSERVER', REPO_BASE + '/' + REPO_NAME_ROOMSERVER + '.git')
REPO_PATH_ROOMSERVER := REPO_TEMP_DIR + '/' + REPO_NAME_ROOMSERVER

export RETOKI_RELEASE_FILE := REPO_PATH_PRODUCT_RELEASES + '/releases.yml'
export RETOKI_PROFILE := 'opencode'

_default:
    just --justfile "{{ justfile() }}" --list

[no-exit-message]
_check-retoki:
    #!/usr/bin/env bash
    set -euo pipefail
    if ! retoki --help &>/dev/null; then
        echo 'retoki is not available, you can install it with `cargo install --git ssh://git@git.opentalk.dev:222/opentalk/tools/retoki.git`' >&2
        exit 1
    fi

[no-exit-message]
_check-git:
    #!/usr/bin/env bash
    set -euo pipefail
    if ! git --help &>/dev/null; then
        echo 'git is not available' >&2
        exit 1
    fi

[no-exit-message]
_check-jq:
    #!/usr/bin/env bash
    set -euo pipefail
    if ! jq --help &>/dev/null; then
        echo 'jq is not available' >&2
        exit 1
    fi

_create-tmp-repos:
    mkdir -p "{{ REPO_TEMP_DIR }}"

_fetch_repo GIT_URL GIT_COMMITISH RELATIVE_DESTINATION: _check-git _create-tmp-repos
    #!/usr/bin/env bash
    set -xe
    DESTINATION="{{ REPO_TEMP_DIR }}/{{ RELATIVE_DESTINATION }}"
    if [ -d "$DESTINATION" ]; then
        git -C "$DESTINATION" fetch origin --prune
        git -C "$DESTINATION" switch --detach "{{ GIT_COMMITISH }}"
    else
        git clone --depth=1 --no-single-branch "{{ GIT_URL }}" "$DESTINATION"
        git -C "$DESTINATION" switch --detach "{{ GIT_COMMITISH }}"
    fi

_fetch-product-releases: (_fetch_repo REPO_URL_PRODUCT_RELEASES REPO_BRANCH_PRODUCT_RELEASES REPO_NAME_PRODUCT_RELEASES)

_fetch-user: (_fetch_repo REPO_URL_USER REPO_BRANCH_USER REPO_NAME_USER)

_fetch-architecture: (_fetch_repo REPO_URL_ARCHITECTURE REPO_BRANCH_ARCHITECTURE REPO_NAME_ARCHITECTURE)

_fetch-opentalk-compose BRANCH: (_fetch_repo REPO_URL_OPENTALK_COMPOSE BRANCH REPO_NAME_OPENTALK_COMPOSE)

_fetch-controller BRANCH: (_fetch_repo REPO_URL_CONTROLLER BRANCH REPO_NAME_CONTROLLER)

_fetch-obelisk BRANCH: (_fetch_repo REPO_URL_OBELISK BRANCH REPO_NAME_OBELISK)

_fetch-recorder BRANCH: (_fetch_repo REPO_URL_RECORDER BRANCH REPO_NAME_RECORDER)

_fetch-smtp-mailer BRANCH: (_fetch_repo REPO_URL_SMTP_MAILER BRANCH REPO_NAME_SMTP_MAILER)

_fetch-roomserver BRANCH: (_fetch_repo REPO_URL_ROOMSERVER BRANCH REPO_NAME_ROOMSERVER)

# Update everything
#
# This pulls the contents from all
update-all: _check-retoki _fetch-product-releases
    #!/usr/bin/env bash
    set -xe

    just --justfile "{{ justfile() }}" update-product-releases

    retoki series list --without-prereleases --format=jsonl | while read -r line; do
        echo "$line" | jq
        SERIES=$(echo "$line" | jq -r ".series_number")

        just --justfile "{{ justfile() }}" update-release-series "$SERIES"
    done

update-release-series SERIES_NUMBER: _check-retoki _fetch-product-releases
    #!/usr/bin/env bash
    set -xe

    INFO=$(retoki series show "{{ SERIES_NUMBER }}" --format=jsonl)
    EOL=$(echo "$INFO" | jq -r ".is_eol")

    if [ "$EOL" == "true" ]; then
        EOL_SINCE=$(echo "$INFO" | jq -r ".end_of_life")
        just --justfile "{{ justfile() }}" _populate-release-series-eol "{{ SERIES_NUMBER }}" "$EOL_SINCE"
    else
        just --justfile "{{ justfile() }}" _populate-release-series "{{ SERIES_NUMBER }}"
    fi

_populate-release-series-eol SERIES_NUMBER EOL_DATE:
    #!/usr/bin/env bash
    set -xe

    SERIES_DIR="{{ DOCS_DIR }}/{{ SERIES_NUMBER }}"
    NAVIGATION_FILE="$SERIES_DIR"/navigation.md
    rm -rf "$SERIES_DIR"

    for DEST in "" "user" "user/de" "user/en" "admin" "developer"; do
        LATEST_LINK="../../latest/$DEST/README.md"
        if [ "$DEST" == "user/de" ] || [ "$DEST" == "user/en" ]; then
            LATEST_LINK="../../../latest/user/README.md"
        fi
        if [ "$DEST" == "" ]; then
            LATEST_LINK="../latest/README.md"
        fi

    read -d '' MDSTRING << EOF || true
    # OpenTalk Release Series {{ SERIES_NUMBER }}

    !!! warning

        The OpenTalk **{{ SERIES_NUMBER }}** release series is no longer supported.

        It is end-of-life since **{{ EOL_DATE }}**, please use a newer version instead.

        [Latest version]($LATEST_LINK){ .md-button .md-button--primary }
    EOF

        DESTDIR="$SERIES_DIR/$DEST"
        mkdir -p "$DESTDIR"
        echo "$MDSTRING" > "$DESTDIR"/README.md

    done

    echo "* [{{ SERIES_NUMBER }}](README.md)" > "$NAVIGATION_FILE"
    if [ -f "$SERIES_DIR"/user/README.md ]; then
        echo "    * [🧑 User](user/README.md)" >> "$NAVIGATION_FILE"
        if [ -f "$SERIES_DIR"/user/de/README.md ]; then
            echo "        * [DE](user/de/README.md)" >> "$NAVIGATION_FILE"
        fi
        if [ -f "$SERIES_DIR"/user/en/README.md ]; then
            echo "        * [EN](user/en/README.md)" >> "$NAVIGATION_FILE"
        fi
    fi
    if [ -f "$SERIES_DIR"/admin/README.md ]; then
        echo "    * [🧑‍💻 Admin](admin/README.md)" >> "$NAVIGATION_FILE"
    fi
    if [ -f "$SERIES_DIR"/developer/README.md ]; then
        echo "    * [👷 Developer](developer/README.md)" >> "$NAVIGATION_FILE"
    fi


_populate-release-series SERIES_NUMBER:
    #!/usr/bin/env bash
    set -xe

    INFO=$(retoki series show "{{ SERIES_NUMBER }}" --format=jsonl)
    SERIES_DIR="{{ DOCS_DIR }}/{{ SERIES_NUMBER }}"
    NAVIGATION_FILE="$SERIES_DIR"/navigation.md
    ADMIN_NAVIGATION_FILE="$SERIES_DIR"/admin/navigation.md
    DEVELOPER_NAVIGATION_FILE="$SERIES_DIR"/developer/navigation.md
    README_FILE="$SERIES_DIR"/README.md

    if [ -f "$NAVIGATION_FILE" ]; then
        truncate --size 0 "$NAVIGATION_FILE"
    fi
    if [ -f "$ADMIN_NAVIGATION_FILE" ]; then
        truncate --size 0 "$ADMIN_NAVIGATION_FILE"
    fi
    if [ -f "$DEVELOPER_NAVIGATION_FILE" ]; then
        truncate --size 0 "$DEVELOPER_NAVIGATION_FILE"
    fi
    if [ -f "$README_FILE" ]; then
        truncate --size 0 "$README_FILE"
    fi

    just --justfile "{{ justfile() }}" update-user {{ SERIES_NUMBER }}
    # TODO: re-enable architecture
    # just --justfile "{{ justfile() }}" update-architecture {{ SERIES_NUMBER }}

    OPENTALK_COMPOSE_EXTRACTOR="{{ EXTRACTORS_DIR }}/{{ SERIES_NUMBER }}/admin/deployment/opentalk-compose"
    if [ -f "$OPENTALK_COMPOSE_EXTRACTOR" ]; then
        OPENTALK_COMPOSE_VERSION=$(echo "$INFO" | jq --arg "key_name" "opentalk-compose" -r '.highest_release_components.[$key_name]')
        OPENTALK_COMPOSE_RELEASE_SERIES=$(echo "$OPENTALK_COMPOSE_VERSION" | grep --extended-regexp --only-matching '^[0-9]+\.[0-9]+')
        echo "OPENTALK_COMPOSE_RELEASE_SERIES=$OPENTALK_COMPOSE_RELEASE_SERIES"
        just --justfile "{{ justfile() }}" update-admin-opentalk-compose {{ SERIES_NUMBER }} "$OPENTALK_COMPOSE_RELEASE_SERIES"
        echo "* [Deployment](deployment/)" >> "$ADMIN_NAVIGATION_FILE"
        echo "  * [OpenTalk Compose](deployment/opentalk-compose/)" >> "$ADMIN_NAVIGATION_FILE"
    fi

    CONTROLLER_VERSION=$(echo "$INFO" | jq --arg "key_name" "controller" -r '.highest_release_components.[$key_name]')
    CONTROLLER_RELEASE_SERIES=$(echo "$CONTROLLER_VERSION" | grep --extended-regexp --only-matching '^[0-9]+\.[0-9]+')
    just --justfile "{{ justfile() }}" update-admin-controller {{ SERIES_NUMBER }} "$CONTROLLER_RELEASE_SERIES"
    echo "* [Controller](controller/)" >> "$ADMIN_NAVIGATION_FILE"
    just --justfile "{{ justfile() }}" update-developer-controller {{ SERIES_NUMBER }} "$CONTROLLER_RELEASE_SERIES"
    echo "* [Controller](controller/)" >> "$DEVELOPER_NAVIGATION_FILE"

    OBELISK_VERSION=$(echo "$INFO" | jq --arg "key_name" "obelisk" -r '.highest_release_components.[$key_name]')
    OBELISK_RELEASE_SERIES=$(echo "$OBELISK_VERSION" | grep --extended-regexp --only-matching '^[0-9]+\.[0-9]+')
    just --justfile "{{ justfile() }}" update-admin-obelisk {{ SERIES_NUMBER }} "$OBELISK_RELEASE_SERIES"
    echo "* [Obelisk](obelisk/)" >> "$ADMIN_NAVIGATION_FILE"

    RECORDER_VERSION=$(echo "$INFO" | jq --arg "key_name" "recorder" -r '.highest_release_components.[$key_name]')
    RECORDER_RELEASE_SERIES=$(echo "$RECORDER_VERSION" | grep --extended-regexp --only-matching '^[0-9]+\.[0-9]+')
    just --justfile "{{ justfile() }}" update-admin-recorder {{ SERIES_NUMBER }} "$RECORDER_RELEASE_SERIES"
    echo "* [Recorder](recorder/)" >> "$ADMIN_NAVIGATION_FILE"

    SMTP_MAILER_VERSION=$(echo "$INFO" | jq --arg "key_name" "smtp-mailer" -r '.highest_release_components.[$key_name]')
    SMTP_MAILER_RELEASE_SERIES=$(echo "$SMTP_MAILER_VERSION" | grep --extended-regexp --only-matching '^[0-9]+\.[0-9]+')
    just --justfile "{{ justfile() }}" update-admin-smtp-mailer {{ SERIES_NUMBER }} "$SMTP_MAILER_RELEASE_SERIES"
    echo "* [SMTP-Mailer](smtp-mailer/)" >> "$ADMIN_NAVIGATION_FILE"

    cat << EOF >> $README_FILE
    ---
    title: 📚 OpenTalk {{ SERIES_NUMBER }} Documentation
    SPDX-FileCopyrightText: OpenTalk GmbH <mail@opentalk.eu>
    SPDX-License-Identifier: EUPL-1.2
    ---

    <center class="startpage" markdown>

    # OpenTalk {{ SERIES_NUMBER }} Documentation

    <div class="grid cards" markdown>
    EOF

    if [ -d "$SERIES_DIR"/user ]; then
        echo "* [🧑 User](user/)" >> "$NAVIGATION_FILE"
        echo '- [<span class="buttonicon">🧑</span><br />User](user/README.md){ .md-button .md-button--primary }' >> "$README_FILE"
    fi
    if [ -d "$SERIES_DIR"/admin ]; then
        echo "* [🧑‍💻 Admin](admin/)" >> "$NAVIGATION_FILE"
        echo '- [<span class="buttonicon">🧑‍💻</span><br />Admin](admin/README.md){ .md-button .md-button--primary }' >> "$README_FILE"
    fi
    if [ -d "$SERIES_DIR"/developer ]; then
        echo "* [👷 Developer](developer/)" >> "$NAVIGATION_FILE"
        echo '- [<span class="buttonicon">👷‍♂️</span><br />Developer](developer/README.md){ .md-button .md-button--primary }' >> "$README_FILE"
    fi
    if [ -d "$SERIES_DIR"/architecture ]; then
        echo "* [🏛️ Architecture](architecture/)" >> "$NAVIGATION_FILE"
        echo '- [<span class="buttonicon">🏛️</span><br />Architecture](architecture/README.md){ .md-button .md-button--primary }' >> "$README_FILE"
    fi

    cat << EOF >> $README_FILE

    </div>

    </center>
    EOF

update-product-releases: _check-retoki _fetch-product-releases
    #!/usr/bin/env bash
    set -xe

    DEST_DIR="{{ DOCS_DIR }}/releases"
    EXTRACTOR="{{ EXTRACTORS_DIR }}/releases"

    rm -rf "$DEST_DIR"
    mkdir "$DEST_DIR"
    "$EXTRACTOR" "{{ REPO_PATH_PRODUCT_RELEASES }}" "$DEST_DIR"

update-user SERIES: _check-retoki _fetch-product-releases _fetch-user
    #!/usr/bin/env bash
    set -xe

    DEST_DIR="{{ DOCS_DIR }}/{{ SERIES }}/user"
    EXTRACTOR="{{ EXTRACTORS_DIR }}/{{ SERIES }}/user"

    rm -rf "$DEST_DIR"

    if [ -x "$EXTRACTOR" ]; then
        mkdir -p "$DEST_DIR"
        "$EXTRACTOR" "{{ REPO_PATH_USER }}" "$DEST_DIR"
    fi

update-architecture SERIES: _fetch-product-releases _fetch-architecture
    #!/usr/bin/env bash
    set -xe

    DEST_DIR="{{ DOCS_DIR }}/{{ SERIES }}/architecture"
    EXTRACTOR="{{ EXTRACTORS_DIR }}/{{ SERIES }}/architecture"

    rm -rf "$DEST_DIR"

    if [ -x "$EXTRACTOR" ]; then
        mkdir -p "$DEST_DIR"
        "$EXTRACTOR" "{{ REPO_PATH_ARCHITECTURE }}" "$DEST_DIR"
    fi

update-admin-opentalk-compose SERIES OPENTALK_COMPOSE_SERIES: (_fetch-opentalk-compose REPO_VERSION_BRANCH_PREFIX_OPENTALK_COMPOSE + OPENTALK_COMPOSE_SERIES + REPO_VERSION_BRANCH_SUFFIX_OPENTALK_COMPOSE)
    #!/usr/bin/env bash
    set -xe
    if [ -x "{{ EXTRACTORS_DIR }}/{{ SERIES }}/admin/deployment/opentalk-compose" ]; then
        rm -rf "{{ DOCS_DIR }}/{{ SERIES }}/admin/deployment/opentalk-compose"
        mkdir -p "{{ DOCS_DIR }}/{{ SERIES }}/admin/deployment/opentalk-compose"
        "{{ EXTRACTORS_DIR }}/{{ SERIES }}/admin/deployment/opentalk-compose" "{{ REPO_PATH_OPENTALK_COMPOSE }}" "{{ DOCS_DIR }}/{{ SERIES }}/admin/deployment/opentalk-compose"
    fi

update-admin-controller SERIES CONTROLLER_SERIES: (_fetch-controller REPO_VERSION_BRANCH_PREFIX_CONTROLLER + CONTROLLER_SERIES + REPO_VERSION_BRANCH_SUFFIX_CONTROLLER)
    #!/usr/bin/env bash
    set -xe
    if [ -x "{{ EXTRACTORS_DIR }}/{{ SERIES }}/admin/controller" ]; then
        rm -rf "{{ DOCS_DIR }}/{{ SERIES }}/admin/controller"
        mkdir -p "{{ DOCS_DIR }}/{{ SERIES }}/admin/controller"
        "{{ EXTRACTORS_DIR }}/{{ SERIES }}/admin/controller" "{{ REPO_PATH_CONTROLLER }}" "{{ DOCS_DIR }}/{{ SERIES }}/admin/controller"
    fi

update-admin-obelisk SERIES OBELISK_SERIES: (_fetch-obelisk REPO_VERSION_BRANCH_PREFIX_OBELISK + OBELISK_SERIES + REPO_VERSION_BRANCH_SUFFIX_OBELISK)
    #!/usr/bin/env bash
    set -xe
    if [ -x "{{ EXTRACTORS_DIR }}/{{ SERIES }}/admin/obelisk" ]; then
        rm -rf "{{ DOCS_DIR }}/{{ SERIES }}/admin/obelisk"
        mkdir -p "{{ DOCS_DIR }}/{{ SERIES }}/admin/obelisk"
        "{{ EXTRACTORS_DIR }}/{{ SERIES }}/admin/obelisk" "{{ REPO_PATH_OBELISK }}" "{{ DOCS_DIR }}/{{ SERIES }}/admin/obelisk"
    fi

update-admin-recorder SERIES RECORDER_SERIES: (_fetch-recorder REPO_VERSION_BRANCH_PREFIX_RECORDER + RECORDER_SERIES + REPO_VERSION_BRANCH_SUFFIX_RECORDER)
    #!/usr/bin/env bash
    set -xe
    if [ -x "{{ EXTRACTORS_DIR }}/{{ SERIES }}/admin/recorder" ]; then
        rm -rf "{{ DOCS_DIR }}/{{ SERIES }}/admin/recorder"
        mkdir -p "{{ DOCS_DIR }}/{{ SERIES }}/admin/recorder"
        "{{ EXTRACTORS_DIR }}/{{ SERIES }}/admin/recorder" "{{ REPO_PATH_RECORDER }}" "{{ DOCS_DIR }}/{{ SERIES }}/admin/recorder"
    fi

update-admin-smtp-mailer SERIES SMTP_MAILER_SERIES: (_fetch-smtp-mailer REPO_VERSION_BRANCH_PREFIX_SMTP_MAILER + SMTP_MAILER_SERIES + REPO_VERSION_BRANCH_SUFFIX_SMTP_MAILER)
    #!/usr/bin/env bash
    set -xe
    if [ -x "{{ EXTRACTORS_DIR }}/{{ SERIES }}/admin/smtp-mailer" ]; then
        rm -rf "{{ DOCS_DIR }}/{{ SERIES }}/admin/smtp-mailer"
        mkdir -p "{{ DOCS_DIR }}/{{ SERIES }}/admin/smtp-mailer"
        "{{ EXTRACTORS_DIR }}/{{ SERIES }}/admin/smtp-mailer" "{{ REPO_PATH_SMTP_MAILER }}" "{{ DOCS_DIR }}/{{ SERIES }}/admin/smtp-mailer"
    fi

update-admin-roomserver SERIES ROOMSERVER_SERIES: (_fetch-roomserver REPO_VERSION_BRANCH_PREFIX_ROOMSERVER + ROOMSERVER_SERIES + REPO_VERSION_BRANCH_SUFFIX_ROOMSERVER)
    #!/usr/bin/env bash
    set -xe
    if [ -x "{{ EXTRACTORS_DIR }}/{{ SERIES }}/admin/roomserver" ]; then
        rm -rf "{{ DOCS_DIR }}/{{ SERIES }}/admin/roomserver"
        mkdir -p "{{ DOCS_DIR }}/{{ SERIES }}/admin/roomserver"
        "{{ EXTRACTORS_DIR }}/{{ SERIES }}/admin/roomserver" "{{ REPO_PATH_ROOMSERVER }}" "{{ DOCS_DIR }}/{{ SERIES }}/admin/roomserver"
    fi

update-developer-controller SERIES CONTROLLER_SERIES: (_fetch-controller REPO_VERSION_BRANCH_PREFIX_CONTROLLER + CONTROLLER_SERIES + REPO_VERSION_BRANCH_SUFFIX_CONTROLLER)
    #!/usr/bin/env bash
    set -xe
    if [ -x "{{ EXTRACTORS_DIR }}/{{ SERIES }}/developer/controller" ]; then
        rm -rf "{{ DOCS_DIR }}/{{ SERIES }}/developer/controller"
        mkdir -p "{{ DOCS_DIR }}/{{ SERIES }}/developer/controller"
        "{{ EXTRACTORS_DIR }}/{{ SERIES }}/developer/controller" "{{ REPO_PATH_CONTROLLER }}" "{{ DOCS_DIR }}/{{ SERIES }}/developer/controller"
    fi

clean:
    #!/usr/bin/env bash
    set -xe

    #find <path> -not -path <path-to-was-bleiben-soll> -delete
    find docs \
        -regex 'docs\/[0-9]+\.[0-9]+.*' \
        -not -path 'docs/25.2' \
        -not -path 'docs/25.2/admin' \
        -not -path 'docs/25.2/admin/README.md' \
        -not -path 'docs/25.2/developer' \
        -not -path 'docs/25.2/developer/README.md' \
        -not -path 'docs/25.3' \
        -not -path 'docs/25.3/admin' \
        -not -path 'docs/25.3/admin/README.md' \
        -not -path 'docs/25.3/developer' \
        -not -path 'docs/25.3/developer/README.md' \
        -not -path 'docs/25.4' \
        -not -path 'docs/25.4/admin' \
        -not -path 'docs/25.4/admin/README.md' \
        -not -path 'docs/25.4/developer' \
        -not -path 'docs/25.4/developer/README.md' \
        -not -path 'docs/26.1' \
        -not -path 'docs/26.1/admin' \
        -not -path 'docs/26.1/admin/README.md' \
        -not -path 'docs/26.1/developer' \
        -not -path 'docs/26.1/developer/README.md' \
        -delete

    rm -rf \
        "{{ TEMP_DIR }}" \
        .cache \
        site \
        "{{ DOCS_DIR }}"/releases \
