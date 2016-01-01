#!/bin/bash

###############################################################################

if [ -z $SHELIB_TARGET ] ; then
  SHELIB_TARGET="../main/.shelib.rc";
fi

. $SHELIB_TARGET;

###############################################################################

test(){
  echo test;
}

test_debug(){
  $sh debug "debug xxx";

  $sh enable debug;
  $sh debug "debug msg";

  $sh disable debug;
  $sh debug "debug xxx";
}

test_info(){
  $sh info "info msg";
}

test_warn(){
  $sh warn "warn msg";
}

test_error(){
  $sh error "error msg";
}

$sh steps "{test_debug,test_info,test_warn,test_error}" "$@";

###############################################################################
