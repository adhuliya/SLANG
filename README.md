SLANG
=======
A bridge between SPAN and Clang.

Authors: <br>
- Anshuman Dhuliya (dhuliya@cse.iitb.ac.in) <br>
- Ronak Chauhan (r.chauhan@somaiya.edu)

Summary
--------
The SLANG project interfaces SPAN (Synergistic Program Analyzer) with Clang.
Specifically it does the following:

1. Converts Clang's AST to SPAN IR (in Python).
2. Processes SPAN results (in a text format) to generate Clang checker reports.

Useful Info
------------
* `grep -R TODO` to get list of things todo.
* `grep -R FIXME` to get list of things to fix.

FAQ's
----------

### What is the supported Clang version?

Currently the system is tested to work on Clang 8.0.1 only.

### How to install and use?

Note: Don't miss the 'IMPORTANT' step at the end too.

We require that clang/llvm to be built from source. We assume `MY_LLVM_DIR` points to the directory housing the `build` as well as the `llvm` source directory.

Now to use "./checkers/SlangCheckers/" do the following,

    $ cp -r ./checkers/SlangCheckers $MY_LLVM_DIR/llvm/tools/clang/lib/StaticAnalyzer/Checkers/

or you can also create a symbolic link with the same name in the Clang's source, to point to the files in the `./checkers/SlangCheckers/` folder.

Modify `$MY_LLVM_DIR/llvm/tools/clang/lib/StaticAnalyzer/Checkers/CMakeLists.txt` to add the name of the new source files so that `cmake` can pick it up. Add the file name just below the line that reads `DebugCheckers.cpp`, maintaining the indentation. The file would then read something like this,

    $ cd $MY_LLVM_DIR/llvm/tools/clang/lib/StaticAnalyzer/Checkers/
    $ cat CMakeLists.txt
    ...
      DebugCheckers.cpp
      SlangCheckers/SlangBugReporterChecker.cpp
      SlangCheckers/SlangGenAstChecker.cpp
      SlangCheckers/SlangUtil.cpp
      SlangCheckers/MyScratchpadChecker.cpp
      SlangCheckers/MyOwnChecker.cpp
      SlangCheckers/MyTraverseAST.cpp
    ...

Modify `$MY_LLVM_DIR/llvm/tools/clang/include/clang/StaticAnalyzer/Checkers/Checkers.td`
and add the text between the "BOUND" lines below the `CFGViewer` entry, as shown below,

    $ cd $MY_LLVM_DIR/llvm/tools/clang/include/clang/StaticAnalyzer/Checkers/
    $ cat Checkers.td
    ...
      def CFGViewer : Checker<"ViewCFG">,
        HelpText<"View Control-Flow Graphs using GraphViz">,
        Documentation<NotDocumented>;
      
      //BOUND START : AD
      
      def SlangGenAstChecker : Checker<"SlangGenAst">,
        HelpText<"SlangGen: Checker to convert Clang AST to SPAN IR and dump it.">,
        Documentation<NotDocumented>;
      
      def SlangBugReporterChecker : Checker<"slangbug">,
        HelpText<"SlangBug: Checker to report bugs given in file.">,
        Documentation<NotDocumented>;
      
      def MyScratchpadChecker : Checker<"myscratch">,
        HelpText<"MyScratchpad: Checker for testing">,
        Documentation<NotDocumented>;
      
      def MyOwnChecker : Checker<"myownchecker">,
        HelpText<"My own checker just for hacks.">,
        Documentation<NotDocumented>;
      
      def MyTraverseAST : Checker<"myt">,
        HelpText<"Print the traversal of the AST (block wise).">,
        Documentation<NotDocumented>;
      
      //BOUND END   : AD
    ...

Note: IMPORTANT Step: These checkers work only on LLVM 9.0.0 or above. To make it
work on LLVM 8.0.0 or LLVM 8.0.1, in each `cpp` file in the `checker/SlangCheckers` folder
remove the function that starts with `ento::shouldRegister` prefix.
(I try to remove these functions myself when updating the repo, but just in case.)

Now go to the `$MY_LLVM_DIR/build` directory and build the system using `make` or `ninja` (which ever you have used to build clang/llvm system).

Once done you can use the checker as any other checker in the system.
The invocation name of each checker is:

1. SlangGenAstChecker: `debug.SlangGenAst`
1. SlangBugReporterChecker: `debug.slangbug`
1. MyScratchpadChecker: `debug.myscratch`
1. MyOwnChecker: `debug.myownchecker`
1. MyTraverseAST: `debug.myt`

An example usage of `debug.SlangGenAst` is:

    clang --analyze -Xanalyzer -analyzer-checker=debug.SlangGenAst test.c

where `test.c` is a valid C program, and `clang` refers to the program
built in the process above.


Misc Info
--------------------------------

### Why does CMake use full paths, or can I copy my build tree?

CMake uses full paths because:

* configured header files may have full paths in them, and moving those files without re-configuring would cause upredictable behavior.

* because cmake supports out of source builds, if custom commands used relative paths to the source tree, they would not work when they are run in the build tree because the current directory would be incorrect.

* on Unix systems rpaths might be built into executables so they can find shared libraries at run time. If the build tree is moved old executables may use the old shared libraries, and not the new ones.

#### Can the build tree be copied or moved?

The short answer is NO. The reason is because full paths are used in CMake, see above. The main problem is that cmake would need to detect when the binary tree has been moved and rerun. Often when people want to move a binary tree it is so that they can distribute it to other users who may not have cmake in which case this would not work even if cmake would detect the move.

The workaround is to create a new build tree without copying or moving the old one.

Resource = [kitware-faq](https://gitlab.kitware.com/cmake/community/wikis/FAQ#why-does-cmake-use-full-paths-or-can-i-copy-my-build-tree)

