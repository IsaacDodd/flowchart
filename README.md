# FLOWCHART

## Introduction

Use the **_flowchart_** package in Stata to generate a publication-quality **Subject Disposition Flowchart Diagram** in LaTeX Format. This package gives Stata the ability to generate the necessary TikZ code to include in a LaTeX and produce the diagram as a PDF or any other format. 
The final diagram will be similar in style to the ones used in the CONSORT 2010 Statement or STROBE Statement Reporting Guidelines, which are very commonly used within formal publications for clinical trial or cohort study research findings. 

For an example of the package's output, please see [Example1Output.pdf](https://github.com/IsaacDodd/flowchart/blob/master/example1output.pdf "Example1Output.pdf")
![Example1Output](https://github.com/IsaacDodd/flowchart/blob/master/PreviousVersions/example1output.png "Example 1 Output")

The format follows closely the example of a [CONSORT-style flow diagram at TeXample](http://www.texample.net/tikz/examples/consort-flowchart/) which was written in PGF/TikZ by Morten Willert. The example code to generate the above diagram is incldued in the Ancillary Files installed with *flowchart*.

## Install

In Stata, install flowchart and its main dependency in your system's ado filepath and also flowchart's ancillary files into your current working directory by typing the following commands:

	. net install flowchart, from(https://raw.github.com/isaacdodd/flowchart/master/) replace
	. net get flowchart, replace
	. ssc install texdoc, replace

To later update your Stata installation with the latest changes to the package, use the following command in Stata: 
	. net install flowchart, from(https://raw.github.com/isaacdodd/flowchart/master/) replace 

## How to Use

After installation, type **help flowchart** for detailed instructions on how to get started. Study the files **example1.do** and **example2.do** for very carefully laid out examples of usage and a very detailed, thorough explanation of the format.
	
## Contributions

Contributions are greatly, greatly appreciated. Please send pull requests via the conventional means on GitHub for review. Please feel free to make this project your own by contributing code, new features, and fixes rather than making forks.

## Issues/Bugs, Suggestions, & Feedback

Please submit bugs using [GitHub](https://github.com/IsaacDodd/flowchart/issues/new/ "Open a New Issue on Github for Flowchart"). It is very difficult to respond to issue requests via email. All comments, feedback, and suggestions are also greatly welcomed.

## License

By installing this program you agree to the GNU LGPL under which this program is licensed. Please see License.txt for the full license of the GNU LGPL 2007, which allows for the incorporation of this program in proprietary software if necessary but without warranty.
Note: 'Flowchart' comes with ABSOLUTELY NO WARRANTY; This is free software, and you are welcome to redistribute it under certain conditions.

## Credit

Credit to Ben Jann, whose texdoc package is a dependency in flowchart, and Morten Willert, whose example of a flowchart diagram in TikZ was studied and used heavily to generate similar flowcharts in this package.
