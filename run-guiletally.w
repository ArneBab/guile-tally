#!/usr/bin/env bash
# -*- wisp -*-
GUILE="${GUILE:-guile}"
d=$(realpath -e "$0") || exit 127
d=${d%/*}
exec -a "$0" "${GUILE}" --language=wisp -x .w -L "$d" -C "$d" -e '(run-guiletally)' -c '' "$@"
; !#
define-module : run-guiletally
  . #:export : main

import : guiletally guiletally

define : main args
  guiletally

