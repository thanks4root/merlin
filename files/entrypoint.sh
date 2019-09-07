#! /bin/bash

export MERLIN_PORT="${MERLIN_PORT:-8443}"
export MERLIN_PROTO="${MERLIN_PROTO:-h2}"
export MERLIN_PSK="${MERLIN_PSK:-merlin}"

cd /opt/merlin

chgrp -R merlin /opt/merlin/data
chmod -R g+rwX /opt/merlin/data

exec -a merlin gosu merlin:merlin \
  /opt/merlin/merlin \
                     -i '0.0.0.0' \
                     -p "${MERLIN_PORT}" \
                     -proto "${MERLIN_PROTO}" \
                     -psk "${MERLIN_PSK}"


