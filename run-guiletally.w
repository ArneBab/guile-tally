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
         only (rnrs io ports) eof-object
         ice-9 format

define : main args
  define tally : make-tally
  for-each tally : map 1+ : iota 500
  let : : state : tally : eof-object
      for-each
          lambda : f
              format #t "~s: ~a \n"
                  procedure-name f
                  f state
          list tally-count tally-product tally-sum tally-sum-squares tally-max tally-min tally-range tally-mean tally-standard-deviation tally-geometric-mean

