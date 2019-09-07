FROM golang:buster AS builder

WORKDIR /go/src/github.com/Ne0nd0g/merlin

COPY ./go.mod /go/src/github.com/Ne0nd0g/merlin
COPY ./go.sum /go/src/github.com/Ne0nd0g/merlin

RUN    set -x \
    && go mod download \
    && echo '[+] Done'

COPY . /go/src/github.com/Ne0nd0g/merlin

RUN    set -x \
    && go build -o /tmp/merlin cmd/merlinserver/main.go \
    && echo '[+] Done'


FROM debian:buster-slim AS runner

LABEL \
      maintainer="@audibleblink"

EXPOSE 8443/tcp

WORKDIR /opt/merlin

COPY --from=builder /tmp/merlin /opt/merlin/merlin
COPY ./files/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN    set -x \
    && echo '[+] Install required software' \
    && apt-get update \
    && apt-get install \
                       -y \
                         gosu \
    \
    && echo '[+] Create user' \
    && useradd \
               --shell /usr/sbin/nologin \
               --no-create-home \
                 merlin \
    \
    && echo '[+] Cleanup image' \
    && install \
               -d \
               -g merlin \
               -m 3775 \
                 /opt/merlin/data \
    && chmod 0755 /usr/local/bin/entrypoint.sh \
    && rm -fr /var/cache/apt/lists/* \
    && echo '[+] Done'

VOLUME /opt/merlin/data

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

