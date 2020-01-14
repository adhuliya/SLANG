#!/usr/bin/env bash

# copy relevant files into the repo
DEST_FOLDER=llvm-clang9.0.0/llvm
SRC_FOLDER=$MYDATA/local/packages-live/$DEST_FOLDER;

mkdir -p $DEST_FOLDER;
cp -R $SRC_FOLDER/tools/clang/lib/StaticAnalyzer/Checkers/SlangCheckers $DEST_FOLDER;
cp $SRC_FOLDER/tools/clang/include/clang/StaticAnalyzer/Checkers/Checkers.td $DEST_FOLDER;
cp $SRC_FOLDER/tools/clang/lib/StaticAnalyzer/Checkers/CMakeLists.txt $DEST_FOLDER;


