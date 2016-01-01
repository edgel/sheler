#!/bin/bash

###################################################################################################
# Usage:
#   export SHELIB_VERSION="1.0";
# 
#   sh build.sh -c [step-name];
#   sh build.sh -d [step-name] | -x [step-name] | -a;
# 
#   [step-name]: defined in test.sh, test_debug,test_info,test_warn,test_error
# 
# Sample:
#   export SHELIB_VERSION="1.0"; sh build.sh -c; sh build.sh -d; sh build.sh -x; sh build.sh -a;
###################################################################################################

SHELIB="./main/.shelib.rc"; SHELIB_DEMO="./test/test.sh"; SHELIB_BUILD="./build.sh";

if [ ! -f $SHELIB] || [ ! -f $SHELIB_DEMO ] ; then
  echo "No [$SHELIB] and [$SHELIB_DEMO] found!"; exit 1;
fi
. $SHELIB;

if [ -z $SHELIB_VERSION ] ; then
  export SHELIB_VERSION="latest";
fi
SHELIB_RELEASE="./release";

export SHELIB_TARGET="`pwd`/$SHELIB_RELEASE/shelib-$SHELIB_VERSION/.shelib.rc";

###################################################################################################

_args=$@;

if [ "-c" == "$1" ] ; then
  $sh info "Remove the release files: shelib-$SHELIB_VERSION.tgz";
  rm -fr $SHELIB_RELEASE/shelib-$SHELIB_VERSION;
  rm -f $SHELIB_RELEASE/shelib-$SHELIB_VERSION.tgz;
  if [ -z $2 ] ; then
    $sh info Clean done files for $0;
    $sh sdf -c $0; 
    $sh info "## The result: [$?] ##"; exit $?;
  else
    $sh info "Clean script step for ./demo/demo.sh ${_args:2}";
    $sh sdf -r ./demo/demo.sh ${_args:2};
    $sh info "## The result: [$?] ##"; exit $?;
  fi
fi

###################################################################################################

if [ ! -f $SHELIB_RELEASE/shelib-$_version.tgz ] ; then
  $sh info "Build the shelib-$SHELIB_VERSION";
  rm -fr $SHELIB_RELEASE/shelib-$SHELIB_VERSION/; 
  mkdir -p $SHELIB_RELEASE/shelib-$SHELIB_VERSION/; 

  sed "s/^# Version: {{SHELIB_VERSION}}/# Version: $SHELIB_VERSION/g" $SHELIB > $SHELIB_TARGET;
  #cp $SHELIB $SHELIB_RELEASE/shelib-$SHELIB_VERSION/;
  cp $SHELIB_DEMO $SHELIB_RELEASE/shelib-$SHELIB_VERSION/;
  cp $SHELIB_BUILD $SHELIB_RELEASE/shelib-$SHELIB_VERSION/;

  cd $SHELIB_RELEASE/; 
  tar czvf ./shelib-$SHELIB_VERSION.tgz ./shelib-$SHELIB_VERSION/;
  cd -;

  rm -fr $SHELIB_RELEASE/shelib-$SHELIB_VERSION/; 
  tar xzvf $SHELIB_RELEASE/shelib-$SHELIB_VERSION.tgz -C $SHELIB_RELEASE/; 
fi

###################################################################################################

echo '';
$sh info "Start run $SHELIB_DEMO $_args";
if [ "-a" == "$1" ] ; then 
  if [ "latest" != "$SHELIB_VERSION" ] ; then
    $sh info "Archive shelib-$SHELIB_VERSION";
    rm -fr ./archive/shelib-$SHELIB_VERSION/;
    mv -f $SHELIB_RELEASE/shelib-$SHELIB_VERSION/ ./archive/;
    mv -f $SHELIB_RELEASE/shelib-$SHELIB_VERSION.tgz ./archive/;
  else
    $sh info "Define version first. such as: export SHELIB_VERSION=\"1.0\";";
  fi
elif [ "-d" == "$1" ] ; then
  $sh exec -l $SHELIB_DEMO ${_args:2};
elif [ "-x" == "$1" ] ; then
  cd demo; $sh exec -x demo.sh ${_args:2}; 
fi
$sh info "## The result: [$?] ##";

###################################################################################################
