# FLOWCHART

Stata module to generate a publication-quality subject disposition flow diagram in LaTeX using the TikZ package directly within Stata using texdoc 

## Introduction

Use the **_flowchart_** package in Stata to generate a publication-quality **Subject Disposition Flowchart Diagram** in LaTeX Format. This package gives Stata the ability to generate the necessary TikZ code to include in a LaTeX and produce the diagram as a PDF or any other format. 

The final diagram will be similar in style to the ones used in the PRISMA Statement, CONSORT 2010 Statement, or STROBE Statement Reporting Guidelines, which are very commonly used within formal publications for systematic review, clinical trial, or cohort study research findings. This package allows generating this diagram to be automated so that the numbers in the diagram change as the analysis changes, saving hours of work.

For an example of the package's output, please see [example1output.pdf](https://github.com/IsaacDodd/flowchart/blob/master/example1output.pdf "example1output.pdf") and the example code that produced it in [flowchart_example1.do](https://github.com/IsaacDodd/flowchart/blob/master/flowchart_example1.do "flowchart_example1.do"). 

Here is a low-resolution screenshot of the PDF:
![Example1Output](https://github.com/IsaacDodd/flowchart/blob/master/PreviousVersion/example1output.png "Example 1 Output")

The format follows closely the example of a [CONSORT-style flow diagram at TeXample](http://www.texample.net/tikz/examples/consort-flowchart/) which was written in PGF/TikZ by Morten Willert. The example code to generate the above diagram is incldued in the Ancillary Files installed with *flowchart*.

## Install

**New Install:** In Stata, to install the *flowchart* package and its main dependencies in your system's ado filepath, and also flowchart's ancillary files into your current working directory, type or copy-and-paste the following commands into Stata:

	. net install flowchart, from("https://raw.github.com/isaacdodd/flowchart/master/") replace
	. flowchart setup

**Updates:** To later update your flowchart installation with the latest changes to the package, use the following command in Stata: 

	. flowchart setup, update
	
**Uninstall:** In order to complete the remove the package, flowchart can uninstall itself with the following command:
	
	. flowchart setup, uninstall

## How to Use

After installation, type `flowchart getstarted` for an introductory message to the *flowchart package*. 
![GetStartedMessage](https://github.com/IsaacDodd/flowchart/blob/master/PreviousVersion/GetStartedMessage.png "Get Started Message")

Type `help flowchart` for detailed instructions on how to get started. Study the files **flowchart_example1.do** and **flowchart_example2.do** for very carefully laid out examples of usage and a very detailed, thorough explanation of the format.

The format for the code follows this typical example, which is available in **flowchart_example2.do**:

```stata
* INITIALIZE: Start a new datatool variable file.
flowchart init using "filename.data"

* WRITE ROWS: [center-block] , [left-block]
* Row with 2 blocks.
flowchart writerow(rownametest1): "lblock1_line1" 46 "This is one line, \\ of a block." ///
	"lblock1_line2" 43 "This is another line, of a block" ///
	"lblock1_line3" 3 "This is another line, of a block", ///
	"rblock1_line1" 97 "This is one line, of a block." ///
	"rblock1_line2" 33 "This is another line, of a block" ///
	"rblock1_line3" 44 "This is another line, of a block"
	
	* A '\\' in a description introduces a newline in LaTeX.
	* Each of the 2 blocks can take several lines.
	* Each line is a space-separated triplet of 3 fields: "variable_name" n_number "Descriptive text."

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

After running this code, the LaTeX figure and manuscript files, which tie in the TikZ file and data file, can then be compiled using a LaTeX distribution and IDE editor with a previewer. Please see [**flowchart_example1.do**](https://github.com/IsaacDodd/flowchart/blob/master/flowchart_example1.do) and the [list of resources](https://github.com/IsaacDodd/flowchart/blob/master/RESOURCES.md) for more information on LaTeX.

## Behind the Scenes

Under the hood, *flowchart* is an interesting package because it functions like a [compiler](https://en.wikipedia.org/wiki/Compiler) and extends to some of the limitations of Stata's language features. It converts a simplistic Stata format into discrete tokens using Stata's low-level [tokenizer](https://en.wikipedia.org/wiki/Lexical_analysis), then through a hand-written parser (similar to a 2-token [look-ahead](https://en.wikipedia.org/wiki/LALR_parser), or LALR(2) parser) flowchart makes sense of each parsed token based on its logical sequence. Other internal functions [transcompile](https://en.wikipedia.org/wiki/Source-to-source_compiler) the tokens into the correct [PGF/TikZ](https://en.wikipedia.org/wiki/PGF/TikZ) code, looping through each block's lines. The connections go into a separate section.

The result is TikZ code that compiles into a [flow diagram](https://en.wikipedia.org/wiki/Flowchart). (To see some of this in action, turn on the debugging log with the command `flowchart debug on` and run the code.) In the future, work can be done to simplify the overall structure to to extend its functionality to further forms of diagrams and other languages, replicating the underlying principles.

## Resources

As they are identified, useful resources that produce visuals and diagrams using statistical methods will be listed in [RESOURCES.md](https://github.com/IsaacDodd/flowchart/blob/master/RESOURCES.md).

## Contributions

Contributions are greatly, greatly appreciated, and a major goal for this package is for *flowchart* to become a community-driven package. Please send pull requests via the conventional means here on GitHub for review. Please feel free to make this project your own by contributing code, new features, and fixes rather than developing them within separate forks. Collaborations are greatly welcomed. Please click on [CONTRIBUTING.md](https://github.com/IsaacDodd/flowchart/blob/master/CONTRIBUTING.md) above for an explanation on how to get started.

## Issues/Bugs, Suggestions, & Feedback

Please submit bugs using [GitHub](https://github.com/IsaacDodd/flowchart/issues/new/ "Open a New Issue on GitHub for Flowchart"). It is very difficult to respond to issue requests via email. All comments, feedback, and suggestions are also greatly welcomed.

## Credit

Credit to Ben Jann, whose texdoc package is a dependency in flowchart, and Morten Willert, whose example of a flowchart diagram in TikZ was studied and used heavily to generate similar flowcharts in this package.

## License

By installing this program you agree to the GNU LGPL under which this program is licensed. Please see [License.txt](https://github.com/IsaacDodd/flowchart/blob/master/license.txt) for the full license of the GNU LGPL 2007, which allows for the incorporation of this program in proprietary software if necessary but without warranty.
Note: 'Flowchart' comes with ABSOLUTELY NO WARRANTY; This is free software, and you are welcome to redistribute it under certain conditions. Copyright © 2017.  Isaac M. E. Dodd. All rights reserved.
