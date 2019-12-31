#!/bin/bash

WRK_DIR=/home/charles/git/sklearn-oblique-tree/oc1_source/

TEST_DATA_FILE=${WRK_DIR}data/train_data.dat
TRAIN_DATA_FILE=${WRK_DIR}data/test_data.dat
ANIM_FILE=${WRK_DIR}anime/anime.dat
args="$@"

# Generate data
echo "Generating data..."
if [[ -f ${TEST_DATA_FILE} ]]; then
  echo "Removing stale test data..."
  rm -f ${TEST_DATA_FILE}
fi
./build/generate_data "$@" -s 47 -o ${TEST_DATA_FILE}
if [[ -f ${TRAIN_DATA_FILE} ]]; then
  rm -f ${TRAIN_DATA_FILE}
fi
./build/generate_data "$@" -s 48 -o ${TRAIN_DATA_FILE}

# Make tree, argument pass-through
echo "Training model..."
./build/make_tree "$@" -t ${TRAIN_DATA_FILE} -T ${TEST_DATA_FILE}
