# FLOWCHART

## Introduction

Use this command to generate a publication-quality Subject Disposition Flowchart Diagram in LaTeX Format. This package uses Stata to generate the necessary TikZ code to run in LaTeX and produce the diagram as a PDF or any other format. 
The final diagram will be similar in style to the ones used in the CONSORT 2010 Statement or STROBE Statement Reporting Guidelines.

## Install

In Stata, install flowchart and its main dependency in your system's ado filepath and also flowchart's ancillary files into your current working directory by typing the following:

	. net install flowchart, from(https://raw.github.com/isaacdodd/flowchart/master/) replace
	. net get flowchart, replace
	. ssc install texdoc, replace
	
After installation, type **help flowchart** for detailed instructions on how to get started. Study the example1.do and example2.do files for very carefully laid out examples of its usage and a very detailed, thorough explanation.
	
## Contributions

Contributions are greatly, greatly appreciated. Please send pull requests via the conventional means on GitHub for review. Please feel free to make this project your own by contributing code, new features, and fixes rather than making forks.

## Issues/Bugs, Suggestions, & Feedback

Please submit bugs using [GitHub](https://github.com/IsaacDodd/flowchart/issues/new/ "Open a New Issue on Github for Flowchart"). It is very difficult to respond to issue requests via email. All comments, feedback, and suggestions are also greatly welcomed.

## License

By installing this program you agree to the GNU LGPL under which this program is licensed. Please see License.txt for the full license of the GNU LGPL 2007, which allows for the incorporation of this program in proprietary software if necessary but without warranty.
Note: 'Flowchart' comes with ABSOLUTELY NO WARRANTY; This is free software, and you are welcome to redistribute it under certain conditions.