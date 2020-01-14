#!/usr/bin/env bash

# This script should be run before starting to commit the changes.

# copy relevant files into the repo
DEST_FOLDER=llvm-clang9.0.0/llvm
SRC_FOLDER=$MYDATA/local/packages-live/$DEST_FOLDER;

mkdir -p $DEST_FOLDER;
myConditionalCopy $SRC_FOLDER/tools/clang/lib/StaticAnalyzer/Checkers/SlangCheckers $DEST_FOLDER;
myConditionalCopy $SRC_FOLDER/tools/clang/include/clang/StaticAnalyzer/Checkers/Checkers.td $DEST_FOLDER;
myConditionalCopy $SRC_FOLDER/tools/clang/lib/StaticAnalyzer/Checkers/CMakeLists.txt $DEST_FOLDER;



# For clang8: change llvm-clang9 checkers to llvm-clang8 checkers

mkdir -p checkers;
CLANG8_FOLDER=checkers
myConditionalCopy $SRC_FOLDER/tools/clang/lib/StaticAnalyzer/Checkers/SlangCheckers $CLANG8_FOLDER;
myConditionalCopy $SRC_FOLDER/tools/clang/include/clang/StaticAnalyzer/Checkers/Checkers.td $CLANG8_FOLDER;
myConditionalCopy $SRC_FOLDER/tools/clang/lib/StaticAnalyzer/Checkers/CMakeLists.txt $CLANG8_FOLDER;

# cd $CLANG8_FOLDER/SlangCheckers;
# for cppfile in *.cpp; do
#   count="`grep ento::shouldRegister $cppfile | wc -l`";
#   if [[ $count -eq 1 ]]; then
# 
#   fi
# done

