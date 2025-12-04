;;; guiletally --- one-line description
;; -*- wisp -*-

;; Copyright (C) YEAR Draketo

;; Author: Dr. Arne Babenhauserheide <arne_bab@web.de>

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:


define-module : guiletally guiletally
  . #:export : guiletally make-tally tally-count tally-sum tally-sum-squares tally-product tally-harmonic-sum tally-max tally-min tally-mean tally-standard-deviation tally-range tally-harmonic-mean tally-geometric-mean

import : srfi :9 define-record-type

define-record-type <<tally>>
    make-tally* count sum sum-squares sum-log product harmonic-sum max min
    . tally?
    count tally-count set-tally-count!
    sum tally-sum set-tally-sum!
    sum-squares tally-sum-squares set-tally-sum-squares!
    sum-log tally-sum-log set-tally-sum-log!
    product tally-product set-tally-product!
    harmonic-sum tally-harmonic-sum set-tally-harmonic-sum!
    max tally-max* set-tally-max!
    min tally-min* set-tally-min!

define : tally-geometric-mean state
    define count : tally-count state
    if : zero? count
       . +nan.0
       exp
         / : tally-sum-log state
           . count

define : tally-max state
    define count : tally-count state
    if : zero? count
       . -inf.0
       tally-max* state

define : tally-min state
    define count : tally-count state
    if : zero? count
       . +inf.0
       tally-min* state

define : tally-mean state
    define count : tally-count state
    if : zero? count
       . +nan.0
       / : tally-sum state
         . count

define : tally-standard-deviation state
    define count : tally-count state
    if : <= count 1
       . 0
       sqrt
         -
           / : tally-sum-squares state
               tally-count state
           expt (tally-mean state) 2

define : tally-range state
    define count : tally-count state
    if : zero? count
       . +nan.0
       - : tally-max* state
           tally-min* state

define : tally-harmonic-mean state
    define count : tally-count state
    if : zero? count
       . +nan.0
       / count
         tally-harmonic-sum state

define : make-tally
    define state : make-tally* 0 0 0 0 1 0 #f #f
    define : tally-accumulator value
      cond
        : eof-object? value
          . state
        else
          set-tally-count! state : + 1 : tally-count state
          set-tally-sum! state : + value : tally-sum state
          set-tally-sum-squares! state : + (expt value 2) : tally-sum-squares state
          set-tally-product! state : * value : tally-product state
          set-tally-sum-log! state : if (zero? value) +nan.0 : + (log value) : tally-sum-log state
          set-tally-harmonic-sum! state : if (zero? value) +nan.0 : + (/ 1 value) : tally-harmonic-sum state
          let*
            : oldmax : tally-max* state
              oldmin : tally-min* state
            set-tally-max! state : if oldmax (max value oldmax) value
            set-tally-min! state : if oldmin (min value oldmin) value
    . tally-accumulator

define : guiletally
  display "Hello, World!\n"

