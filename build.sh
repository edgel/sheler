#!/bin/bash

###################################################################################################
# Usage:
#   sh build.sh [-c|-r|-e|-l|-d|-a];
# 
# Sample:
#   sh build.sh -c; sh build.sh -r; sh build.sh -e|-l|-d|-a;
# 
###################################################################################################

SHELIB_RELEASE="./release"; SHELIB_ARCHIVE="./archive/"; SHELIB_VERSION="2.0";

###################################################################################################

SHELIB_CORE="./main/.shelib.rc"; . $SHELIB_CORE;

SHELIB_TEST="./test/test.sh"; CHANGE_LOG="./changelog"; RELEASE_NOTE="./releasenote";

export SHELIB_TARGET="$(pwd)/$SHELIB_RELEASE/shelib-$SHELIB_VERSION/.shelib.rc";

###################################################################################################

build_clean(){
  $sh info "Remove the release files: shelib-$SHELIB_VERSION.tgz";
  rm -fr $SHELIB_RELEASE/shelib-$SHELIB_VERSION;
  rm -f $SHELIB_RELEASE/shelib-$SHELIB_VERSION.tgz;
  if [ -z $2 ] ; then
    $sh info Clean done files for $0; $sh done -c $0; 
  fi
}

###################################################################################################

build_release(){
  if [ -f $SHELIB_RELEASE/shelib-$_version.tgz ] ; then
    $sh info "File exist for $SHELIB_RELEASE/shelib-$_version.tgz"; exit 1;
  fi

  $sh info "Build the shelib-$SHELIB_VERSION";
  rm -fr $SHELIB_RELEASE/shelib-$SHELIB_VERSION/; 
  mkdir -p $SHELIB_RELEASE/shelib-$SHELIB_VERSION/.sources/src/main/;
  mkdir -p $SHELIB_RELEASE/shelib-$SHELIB_VERSION/.sources/src/test/; 

  cp $(dirname $SHELIB_CORE)/.*.rc $SHELIB_RELEASE/shelib-$SHELIB_VERSION/.sources/src/main/;
  cp $(dirname $SHELIB_TEST)/*.sh $SHELIB_RELEASE/shelib-$SHELIB_VERSION/.sources/src/test/;
  cp $CHANGE_LOG $SHELIB_RELEASE/shelib-$SHELIB_VERSION/.sources/;
  cp $RELEASE_NOTE $SHELIB_RELEASE/shelib-$SHELIB_VERSION/.sources/;
  cp $0 $SHELIB_RELEASE/shelib-$SHELIB_VERSION/.sources/;

  sed "s/^# Version: {{SHELIB_VERSION}}/# Version: $SHELIB_VERSION/g" $SHELIB_CORE \
  > $SHELIB_TARGET;

  cd $SHELIB_RELEASE/; 
  tar czvf ./shelib-$SHELIB_VERSION.tgz ./shelib-$SHELIB_VERSION/;
  cd -;

  rm -fr $SHELIB_RELEASE/shelib-$SHELIB_VERSION/; 
  tar xzvf $SHELIB_RELEASE/shelib-$SHELIB_VERSION.tgz -C $SHELIB_RELEASE/; 
}

###################################################################################################

build_archive(){
  if [ -f $SHELIB_ARCHIVE/shelib-$SHELIB_VERSION.tgz ] ; then
    $sh info "File exist for ./archive/shelib-$SHELIB_VERSION.tgz"; exit 1;
  fi
  $sh info "Archive shelib-$SHELIB_VERSION";
  rm -fr $SHELIB_ARCHIVE/shelib-$SHELIB_VERSION/;
  mv -f $SHELIB_RELEASE/shelib-$SHELIB_VERSION/ $SHELIB_ARCHIVE;
  mv -f $SHELIB_RELEASE/shelib-$SHELIB_VERSION.tgz $SHELIB_ARCHIVE;
}

###################################################################################################

build_run_exit(){
  ls ~/none;
}

build_run_test(){
  $sh info "Start run $SHELIB_TEST $@"; sh $SHELIB_TEST; 
}

###################################################################################################

if [ "-c" == "$1" ] ; then # clean
  build_clean "$@";

elif [ "-r" == "$1" ] ; then # release
  build_release "$@";

elif [ "-e" == "$1" ] ; then # exit 
  $sh exec -e build_run_test;
  $sh exec -e build_run_exit;

elif [ "-l" == "$1" ] ; then # log
  $sh exec -l build_run_test;
  $sh exec -l build_run_exit;

elif [ "-d" == "$1" ] ; then # debug
  $sh exec -d build_run_test;
  $sh exec -d build_run_exit;

elif [ "-a" == "$1" ] ; then # archive
  build_archive "$@";

fi

$sh info "## The [$0 $@] result: [$?] ##";

###################################################################################################
