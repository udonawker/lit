```
#!/bin/bash

readonly SCRIPT_DIR=$(\cd $(dirname -- $0); pwd)
readonly SCRIPT_NAME=${0##*/}

readonly MKTEMP_ARG="/tmp/${0##*/}.tmp.XXXXXX"

on_exit() {
    [[ -n ${TMPFILE-} ]] && rm -f "${TMPFILE}"
    \cd ${SCRIPT_DIR}
}

trap on_exit EXIT
trap 'rc=$?; trap - EXIT; on_exit; exit $?' INT PIPE TERM

TMPFILE=$(mktemp ${MKTEMP_ARG})
echo "TMPFILE=${TMPFILE}"
```
