#!/bin/bash

WRK_DIR=/home/charles/git/sklearn-oblique-tree/oc1_source/

TEST_DATA_FILE=${WRK_DIR}data/train_data.dat
TRAIN_DATA_FILE=${WRK_DIR}data/test_data.dat
ANIM_FILE=${WRK_DIR}data/train.ps
args="$@"

# Generate data
echo "Generating data..."
if [[ -f ${TEST_DATA_FILE} ]]; then
  echo "Removing stale test data..."
  rm -f ${TEST_DATA_FILE}
fi
./build/generate_data "$@" -s 247 -o ${TEST_DATA_FILE}
if [[ -f ${TRAIN_DATA_FILE} ]]; then
  rm -f ${TRAIN_DATA_FILE}
fi
./build/generate_data "$@" -s 248 -o ${TRAIN_DATA_FILE}

# Make tree, argument pass-through
echo "Training model... parallel splits"
./build/make_tree "$@" -a -t ${TRAIN_DATA_FILE} -T ${TEST_DATA_FILE}
echo "Training model...oblique splits"
./build/make_tree "$@" -t ${TRAIN_DATA_FILE} -T ${TEST_DATA_FILE}

# If data is planar (d == 2), display
# Exctract dimension parameter
while [[ $# -gt 0 ]]; do
  dopt="$1"
  case $dopt in 
    -d)
    dvalue="$2"
    shift;shift
    ;;
    *)
    shift;shift
    ;;
esac
done

if [[ $dvalue -eq 2 ]]; then
  ./build/display -t ${TRAIN_DATA_FILE} -d ${dvalue} > -o ${ANIM_FILE}
fi