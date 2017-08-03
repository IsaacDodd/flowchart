# Contributions

The flowchart package has the potential of being an extremely useful addition to Stata. Your help is greatly needed and would be greatly appreciated! Here is how to get started contributing to the flowchart package.

- **Tests**: Use the two example files in the Ancillary Files as tests of whether the code builds or not after each change.
- **Debug**: Use the command `flowchart debug on` at the start of code you want to test and use `flowchart debug off` after it. This produces a DebugLog.log in the present working directory. This can be used to visualize how flowchart parses text and turns it into TikZ code. It functions a lot like a parser and somewhat like a [LALR Parser](https://en.wikipedia.org/wiki/LALR_parser).
- **Deprecated/Untracked Files**: In the .gitignore, a filename with an underscore ('_') at the start of it is ignored. So, you can use this to deprecate any files that you don't want git to track. Also, most of the LaTeX-generated file extensions have been ignored so you can build LaTeX documents without worrying about git recognizing all of the files it automatically generates.

### What Needs to be Done
- **Cleaning & Efficiency**: Help is needed to produce clean, readable code that still compiles and builds the same test files properly.
- **New Features**: The project is very open to new ideas. Please study the present source code and go right ahead and send a pull request.
- **Documentation**: Any improvements to the .sthlp documentation would be greatly appreciated.

### Attribution
You will be given the proper attribution for any contributions you make to the flowchart package.
