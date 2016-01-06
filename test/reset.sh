#!/bin/bash

###################################################################################################

if [ -z $SHELIB_TARGET ] ; then SHELIB_TARGET="../main/.shelib.rc"; fi; . $SHELIB_TARGET;

###################################################################################################

if [ -z "$1" ] ; then
  $sh info '$sh done -r ./auto.sh test_error';
  $sh done -r ./auto.sh test_error
else
  $sh info "Clean script step for $@";
  $sh done -r "$@";
  $sh info "## The [$0 $@] result: [$?] ##"; exit $?;
fi

###################################################################################################
