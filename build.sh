#!/bin/bash

###################################################################################################
# Usage:
#   sh build.sh [-c|-r|-l|-x|-a];
# 
# Sample:
#   sh build.sh -c; sh build.sh -r; sh build.sh -e; sh build.sh -l; sh build.sh -x; sh build.sh -a;
# 
###################################################################################################

SHELIB_VERSION="1.1";

SHELIB_RELEASE="./release"; SHELIB_ARCHIVE="./archive/";

export SHELIB_TARGET="`pwd`/$SHELIB_RELEASE/shelib-$SHELIB_VERSION/.shelib.rc"; 

###################################################################################################

SHELIB="./main/.shelib.rc"; SHELIB_TEST="./test/test.sh"; CHANGE_LOG="./changelog";

if [ ! -f $SHELIB ] || [ ! -f $SHELIB_TEST ] || [ ! -f $CHANGE_LOG ] ; then
  echo "No [$SHELIB], [$SHELIB_TEST], or [$CHANGE_LOG] found!"; exit 1;
fi

. $SHELIB; 

###################################################################################################

build_clean(){
  $sh info "Remove the release files: shelib-$SHELIB_VERSION.tgz";
  rm -fr $SHELIB_RELEASE/shelib-$SHELIB_VERSION;
  rm -f $SHELIB_RELEASE/shelib-$SHELIB_VERSION.tgz;
  if [ -z $2 ] ; then
    $sh info Clean done files for $0;
    $sh done -c $0; 
    $sh info "## The result: [$?] ##"; exit $?;
  else
    $sh info "Clean script step for ./test/test.sh ${@:2}";
    $sh done -r $0 build_run_test;
    $sh done -r ./test/test.sh ${@:2};
    $sh info "## The result: [$?] ##"; exit $?;
  fi
}

###################################################################################################

build_release(){
  if [ -f $SHELIB_RELEASE/shelib-$_version.tgz ] ; then
    $sh info "File exist for $SHELIB_RELEASE/shelib-$_version.tgz"; exit 1;
  fi

  $sh info "Build the shelib-$SHELIB_VERSION";
  rm -fr $SHELIB_RELEASE/shelib-$SHELIB_VERSION/; 
  mkdir -p $SHELIB_RELEASE/shelib-$SHELIB_VERSION/; 

  sed "s/^# Version: {{SHELIB_VERSION}}/# Version: $SHELIB_VERSION/g" $SHELIB > $SHELIB_TARGET;
  cp $SHELIB_TEST $SHELIB_RELEASE/shelib-$SHELIB_VERSION/;
  cp $CHANGE_LOG $SHELIB_RELEASE/shelib-$SHELIB_VERSION/;
  cp $0 $SHELIB_RELEASE/shelib-$SHELIB_VERSION/;

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

if [ "-c" == "$1" ] ; then
  build_clean $@;
elif [ "-r" == "$1" ] ; then 
  build_release $@;
elif [ "-a" == "$1" ] ; then 
  build_archive $@;
elif [ "-e" == "$1" ] ; then
  $sh exec -e build_run_exit;
  $sh exec -e build_run_test;
elif [ "-l" == "$1" ] ; then
  $sh exec -l build_run_test;
  $sh exec -l build_run_exit;
elif [ "-x" == "$1" ] ; then
  $sh exec -x build_run_test;
  $sh exec -x build_run_exit;
fi

$sh info "## The result: [$?] ##";

###################################################################################################
