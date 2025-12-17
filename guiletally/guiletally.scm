;; guiletally --- implementation of a tally for Scheme
;; -*- wisp -*-

;; Copyright (C) 2025 Dr. Arne Babenhauserheide <arne_bab@web.de>

;; Author: Dr. Arne Babenhauserheide <arne_bab@web.de>

;; Permission is hereby granted, free of charge, to any person obtaining a
;; copy of this software and associated documentation files (the "Software"),
;; to deal in the Software without restriction, including without limitation
;; the rights to use, copy, modify, merge, publish, distribute, sublicense,
;; and/or sell copies of the Software, and to permit persons to whom the
;; Software is furnished to do so, subject to the following conditions:

;; The above copyright notice and this permission notice shall be included in
;; all copies or substantial portions of the Software.

;; Except as contained in this notice, the name(s) of the above copyright
;; holders shall not be used in advertising or otherwise to promote the sale,
;; use or other dealings in this Software without prior written authorization.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
;; THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
;; FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
;; DEALINGS IN THE SOFTWARE.

;;; Commentary:

;;; Code:


(define-module (guiletally guiletally)
  #:export (guiletally make-tally tally-count tally-sum tally-sum-squares tally-product tally-harmonic-sum tally-max tally-min tally-mean tally-standard-deviation tally-range tally-harmonic-mean tally-geometric-mean))

(import (srfi :9 define-record-type))

(define-record-type <<tally>>
    (make-tally* count sum sum-squares sum-log product harmonic-sum max min)
    tally?
    (count tally-count set-tally-count!)
    (sum tally-sum set-tally-sum!)
    (sum-squares tally-sum-squares set-tally-sum-squares!)
    (sum-log tally-sum-log set-tally-sum-log!)
    (product tally-product set-tally-product!)
    (harmonic-sum tally-harmonic-sum set-tally-harmonic-sum!)
    (max tally-max* set-tally-max!)
    (min tally-min* set-tally-min!))

(define (tally-geometric-mean state)
    (define count (tally-count state))
    (if (zero? count)
       +nan.0
       (exp
         (/ (tally-sum-log state)
           count))))

(define (tally-max state)
    (define count (tally-count state))
    (if (zero? count)
       -inf.0
       (tally-max* state)))

(define (tally-min state)
    (define count (tally-count state))
    (if (zero? count)
       +inf.0
       (tally-min* state)))

(define (tally-mean state)
    (define count (tally-count state))
    (if (zero? count)
       +nan.0
       (/ (tally-sum state)
         count)))

(define (tally-standard-deviation state)
    (define count (tally-count state))
    (if (<= count 1)
       0
       (sqrt
         (-
           (/ (tally-sum-squares state)
               (tally-count state))
           (expt (tally-mean state) 2)))))

(define (tally-range state)
    (define count (tally-count state))
    (if (zero? count)
       +nan.0
       (- (tally-max* state)
           (tally-min* state))))

(define (tally-harmonic-mean state)
    (define count (tally-count state))
    (if (zero? count)
       +nan.0
       (/ count
         (tally-harmonic-sum state))))

(define (make-tally)
    (define state (make-tally* 0 0 0 0 1 0 #f #f))
    (define (tally-accumulator value)
      (cond
        ((eof-object? value)
          state)
        (else
          (set-tally-count! state (+ 1 (tally-count state)))
          (set-tally-sum! state (+ value (tally-sum state)))
          (set-tally-sum-squares! state (+ (expt value 2) (tally-sum-squares state)))
          (set-tally-product! state (* value (tally-product state)))
          (set-tally-sum-log! state (if (zero? value) +nan.0 (+ (log value) (tally-sum-log state))))
          (set-tally-harmonic-sum! state (if (zero? value) +nan.0 (+ (/ 1 value) (tally-harmonic-sum state))))
          (let*
            ((oldmax (tally-max* state))
              (oldmin (tally-min* state)))
            (set-tally-max! state (if oldmax (max value oldmax) value))
            (set-tally-min! state (if oldmin (min value oldmin) value))))))
    tally-accumulator)

(define (guiletally)
  (display "Hello, World!\n"))



