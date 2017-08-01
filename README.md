# FLOWCHART

Stata module to generate a publication-quality subject disposition flow diagram in LaTeX using the TikZ package directly within Stata using texdoc 

## Introduction

Use the **_flowchart_** package in Stata to generate a publication-quality **Subject Disposition Flowchart Diagram** in LaTeX Format. This package gives Stata the ability to generate the necessary TikZ code to include in a LaTeX and produce the diagram as a PDF or any other format. 
The final diagram will be similar in style to the ones used in the CONSORT 2010 Statement or STROBE Statement Reporting Guidelines, which are very commonly used within formal publications for clinical trial or cohort study research findings. 

For an example of the package's output, please see [Example1Output.pdf](https://github.com/IsaacDodd/flowchart/blob/master/example1output.pdf "Example1Output.pdf"). Here is a low-resolution screenshot of the PDF:
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

The format for the code follows this typical example, which is available in **example2.do**:

```stata
* INITIALIZE: Start a new datatool variable file.
flowchart init using "filename.data"

* Row with 2 blocks.
flowchart writerow(rownametest1): "lblock1_line1" 46 "This is one line, \\ of a block." ///
	"lblock1_line2" 43 "This is another line, of a block" ///
	"lblock1_line3" 3 "This is another line, of a block", ///
	"rblock1_line1" 97 "This is one line, of a block." ///
	"rblock1_line2" 33 "This is another line, of a block" ///
	"rblock1_line3" 44 "This is another line, of a block"
	
	* A '\\' in a description introduces a newline in LaTeX.

* Row with No center-block (a center-block appears on the left)
flowchart writerow(rownametest2): Flowchart_Blank, ///
	"rblock1_line1" 97 "This is one line, of a block." ///
	"rblock1_line2" 33 "This is another line, of a block" ///
	"rblock1_line3" 44 "This is another line, of a block"

* Row with No left-block (a left-block appears on the right)
flowchart writerow(rownametest3): "lblock1_line1" 46 "This is one line, \\ of a block." ///
	"lblock1_line2" 43 "This is another line, of a block" ///
	"lblock1_line3" 3 "This is another line, of a block", Flowchart_Blank

* Row with No center-block and a Singleton Lead-Line in the left-block
flowchart writerow(rownametest4): Flowchart_Blank, "rblock1_line1" 97 "This is one line, \\ of a block."
	
* Row with Singleton Lead-Line in the center-block and No left-block
flowchart writerow(rownametest5): "lblock1_line1" 46 "This is one line, \\ of a block.", Flowchart_Blank

* CONNECTIONS: Use the block orientation to connect arrows to the appropriate blocks
flowchart connect rownametest1_center rownametest1_left
flowchart connect rownametest1_left rownametest2_left
flowchart connect rownametest1_center rownametest3_center
flowchart connect rownametest3_center rownametest5_center
flowchart connect rownametest2_left rownametest4_left

* FINALIZE: This writes the files and generates the 'tikzpicture'
flowchart finalize, input("figure.texdoc") output("figure.tikz")
```
	
## Contributions

Contributions are greatly, greatly appreciated. Please send pull requests via the conventional means on GitHub for review. Please feel free to make this project your own by contributing code, new features, and fixes rather than making forks.

## Issues/Bugs, Suggestions, & Feedback

Please submit bugs using [GitHub](https://github.com/IsaacDodd/flowchart/issues/new/ "Open a New Issue on Github for Flowchart"). It is very difficult to respond to issue requests via email. All comments, feedback, and suggestions are also greatly welcomed.

## License

By installing this program you agree to the GNU LGPL under which this program is licensed. Please see License.txt for the full license of the GNU LGPL 2007, which allows for the incorporation of this program in proprietary software if necessary but without warranty.
Note: 'Flowchart' comes with ABSOLUTELY NO WARRANTY; This is free software, and you are welcome to redistribute it under certain conditions.

## Credit

Credit to Ben Jann, whose texdoc package is a dependency in flowchart, and Morten Willert, whose example of a flowchart diagram in TikZ was studied and used heavily to generate similar flowcharts in this package.
