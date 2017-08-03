# Contributions

Here is how to get started contributing to the FLOWCHART package for Stata.

- **Tests**: Use the two example files in the Ancillary Files as tests of whether the code builds or not after each change.
- **Debug**: Use the command `flowchart debug on` at the start of code you want to test and use `flowchart debug off` after it. This produces a DebugLog.log in the present working directory. This can be used to visualize how flowchart parses text and turns it into TikZ code. It functions a lot like a parser and somewhat like a [LALR Parser](https://en.wikipedia.org/wiki/LALR_parser).

### What Needs to be Done
- **Cleaning & Efficiency**: Help is needed to produce clean, readable code that still compiles and builds the same test files properly.
- **New Features**: The project is very open to new ideas. Please study the present source code and go right ahead and send a pull request.

### Attribution
Your help is greatly needed and would be greatly appreciated! You will be given proper attribution for any contributions you make to the flowchart package.
