{smcl}
{* *! version 0.0.1 01aug2017}{...}
{* References: http://www.stata.com/manuals13/u18.pdf#u18.11Ado-files , http://www.stata.com/manuals13/u17.pdf }{...}
{vieweralsosee "[R] help" "help help "}{...}
{vieweralsosee "[R] texdoc" "help texdoc"}{...}
{vieweralsosee "[R] sjlatex" "help sjlatex"}{...}
{viewerjumpto "Syntax" "flowchart##syntax"}{...}
{viewerjumpto "Description" "flowchart##description"}{...}
{viewerjumpto "Remarks" "flowchart##remarks"}{...}
{viewerjumpto "Examples" "flowchart##examples"}{...}
{viewerjumpto "Troubleshooting" "flowchart##troubleshooting"}{...}
{viewerjumpto "References" "flowchart##references"}{...}
{viewerjumpto "Credits" "flowchart##credits"}{...}
{title:FLOWCHART Package}

{phang}
{bf:flowchart} {hline 2}  Use this command to generate publication-quality Subject Disposition Flowchart 
Diagrams in TikZ code which can be compiled in LaTeX. These flow diagrams are the same as the ones used in the CONSORT 2010 
Statement, STROBE Statement, and PRISMA Statement Reporting Guidelines. 
	
{phang}
After installing the package, to setup flowchart type 'flowchart setup'. This will update the flowchart 
package and its main dependencies in your system's ado filepath and also download flowchart's ancillary 
files into your current working directory.
Updates to the FLOWCHART package can be installed by using the 'flowchart setup, update' command 
and are also available here: {browse "https://github.com/IsaacDodd/flowchart/"}

{p}
{bf:Support:} Support is available at: {browse "https://github.com/IsaacDodd/flowchart/issues/new/"}

{bf:Examples:} Please see the Ancillary Files for extensive examples with explanations of usage:
		{bf:flowchart_example1.do}, {bf:flowchart_example2.do}, and {bf:manuscript.tex}
	Example flow diagram: 
		{browse "http://www.texample.net/tikz/examples/consort-flowchart/"}
	Example of the {it:flowchart package}'s output to replicate this example: 
		{browse "https://github.com/IsaacDodd/flowchart/blob/master/example1output.pdf"}
	If you do not yet have a LaTeX setup, an online LaTeX editor is a good place to start:
		{browse "https://www.sharelatex.com"}
		{browse "https://www.overleaf.com"}

{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmdab:flo:wchart}
[{it:command}]
[{cmd:,}
{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Commands}
{synopt:{opt i:nit}} {bf:init} using {it:filename.data} {hline 2} Initialize the diagram by specifying a filename (or filename with filepath) where the data file to store variables will be generated. 
This file is created by the {it:flowchart package} in Stata and used by LaTeX's datatool package to generate numerical data within the diagram.{p_end}
{synopt:{opt wri:terow}(...):} {bf:writerow}({it:rowname}): {it:center-block}, {it:left-block} {hline 2} Create 
	a new row in the diagram. A detailed explanation is below.{p_end}
{synopt:{opt con:nect}} {bf:connect} rowname_{it:blockorientation} rowname_{it:blockorientation}, [arrow({it:type})] {hline 2} 
	Draws arrows between the blocks across or between rows by specifying 'rowname underscore block-orientation'. {p_end}
{synopt:{opt fin:alize}} {bf:finalize}, template("{it:filename.texdoc}") output("{it:filename.tikz}") {hline 2} 
	Takes the prespecified texdoc syntax in {it:filename.texdoc} and writes into it the TikZ code into {it:filename.tikz} to be included in a manuscript's LaTeX document. {p_end}
{synopt:{opt setu:p}} {bf:setup}, [{it:update}] {hline 2} Installs texdoc and any other dependencies and 
	replaces the current flowchart installation. Alternatively, option [, {it:update}] can be specified to 
	update the flowchart package installation.{p_end}
{synopt:{opt deb:ug}} {bf:debug}, [{it:on off logreset info check tikz}] {hline 2} Turns on or off the debugging features 
	and produces a DebugLog.log that can be used when support is needed. Option {it:tikz} can be specified 
	to produce debugging strings in the final TikZ file.{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{cmd:filename.data} can have any extension and can have a filepath. See {help filename} for more detailed syntax information.{p_end}
{p 4 6 2}
{cmd:by} is not allowed; see {manhelp by D}.{p_end}



{p 8 17 2}
{cmdab:fl:owchart}
[{it:writerow}({it:rowname}):]
[{it:line-triplets center-block orientation}] {cmd:,}
[
{it:line-triplets left-block orientation}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Commands}
{synopt:{opt wri:terow}({it:rowname}):} Create a new row with 'rowname'. The rowname must be alphanumeric. The rowname 
	also becomes a part of each row's blocks. The first block is the {bf:center block} and the second block is the {bf:left block}. 
	Each block is divided by a single comma (,).{p_end}
{synopt:{opt lin:e-triplets}} "variablename" nnn "Description." {hline 2} Each block can receive 
	multiple 'lines'. Each line is a triplet of 3 fields separated by a space. Each line-triplet is also separated separated by a space.
	The first is the variable name, the second is the number associated with it, and the third is the description that appears in the block.
	If more than one line is specified, the first line gets a comma at the end and the others are indented.{p_end}
{synopt:{opt Flowchart_Blank}} This is a keyword that lets the {it:flowchart package} know that a block is empty. 
	This can be used to connect the arrow to the block that comes after it.{p_end}
{synoptline}
{p2colreset}{...}

More detailed descriptions of these commands, with examples, are below.

{hline}


{marker description}{...}
{title:Description}

The following is a detailed description of the main commands in the {it:flowchart package}.

{dlgtab:Overall}

{p}
{cmd:flowchart} is a package that generates a Subject Disposition Flowchart Diagram. It does this by generating TikZ code that can be compiled 
from a variable file using the data you generate in your analysis in Stata.

{phang}
The diagram generated is similar in style to the ones used in many studies and required by the main Reporting Guidelines in LaTeX format.
The {it:flowchart oackage} allows you to use data from a dataset in your analysis and generate the flow diagram in a do file.{p_end}

{phang}
{bf:flowchart getstarted} {hline 2} Type this command for a simplified message on how to get started with the {it:flowchart package}.

{phang}
{bf:flowchart debug info} {hline 2} Type this command if you have a problem for a simplified message on what to do to get help with the {it:flowchart package}.


{phang} 
{bf:Dependencies:} This command uses the '{help texdoc}' package (written by Ben Jann) which uses the '{help sjlatex}' package as a dependency.
The flowchart package can install them both itself after you run in Stata the command: '{cmd:flowchart setup}' after installing 
	the flowchart package. This will install both dependencies and also flowchart's Ancillary Files (containing examples) in your current working directory.{p_end}
	

{dlgtab:Initialization}

{p}
{bf:flowchart} init using {it:filename.data}{p_end}

{phang}
This command takes the filename of a text file where data variables can be written so that the 
	datatool package in LaTeX can be used to load the file specified to fill in all of the 
	\figvalues{variable_name} with the numbers specified in each line. (Variable names entered into 
	this LaTeX command entered must be unique and alphanumeric.)

{phang}	
In LaTeX, place something like this in the preamble section of your .tex file (the space between \documentclass{article} ... \begin{document} ):

	...
	% 	Figures, Diagrams, and Other Graphics
	\usepackage{tikz}		% TikZ Package - Generates graphics (i.e., flowcharts generated)
		\usetikzlibrary{shapes,arrows}
		\newcommand*{\h}{\hspace{5pt}}% For indentation
		\newcommand*{\hh}{\h\h}% Double indentation
	\usepackage{datatool}		% DataTool Package - Loads variable data file
		\DTLsetseparator{ = }% Delimiter
	...

{phang}	
This will load the datatool and TikZ package in LaTeX. This tells the TikZ package to use \h and \hh to indent lines. 
It also tells the datatool package to interpet each line of the data file initialized as having '[variable_name] = [variable_value]' by using the equals sign as a delimiter.

{p}
{bf:flowchart set variable}, name("{it:name_of_setting}") value("{it:valuealphanumeric}")

{phang}
This will write a variable to the variable file ({it:flowchart.data} by default) which is loaded by the datatool in LaTeX. So, when the LaTeX
	document is compiled it will populate the LaTeX document with the variable's value. 
	
{phang}
Access this variable in a LaTeX document using '{it:\figvalue{variablename}}'
	
{phang}
To set layout variables:

		flowchart set layout, name("center_textwidth") value("12")
		flowchart set layout, name("left_textwidth") value("18")
		
{phang}
The variable name is prepended with 'set_' and written to the file. 
(Note: Every variable file also includes 1 dummy variable 'set_dummy'.)
	
	
{dlgtab:Writing Rows ("Boxes")}

{p}
{bf:flowchart writerow({it:rownamehere}): }

{phang}
{bf:Format:} flowchart writerow({it:Name_of_row}): [{it:Block_Center}], [{it:Block_Left}]

{phang}
The content within each block should be separated by a single comma (strings within a block can still 
use a comma, it just has to be within double-quotes).

{phang}		
The first block gets assigned the 'center' orientation and the second gets the 'left' orientation. 
	Each block can have several lines, and each line has to have a triplet of 3 fields which should be 
	separated by spaces.
	A single line is a triplet of these 3 fields: "variable_name" n# "Description of the variable 
			name and number."

{phang}			
In a Stata do file, multiple line-triplets can be separated by a '\\\' at the end of the line for readability. 
This can only be used in a do file and not the Stata command-line but can be used to wrap long triplet lines.

{phang}
{bf:Limitations:} Variable names must be unique and the numbers entered should be real numbers. 
Descriptions must not contain curly braces (i.e., '{' or '}').


{dlgtab:Keywords}

{p}
{bf:Flowchart_Blank}

{phang}
This keyword defines a blank block. Either the left or the center block can be set 
		to blank using this keyword before or after the comma respectively so that a box 
		doesn't appear on a given row.
		This can be of any casing (e.g., fLoWcHaRT_BLANK, flowchart_blank, or any combination) 
		as long as the keyword is spelled correctly, but for readibility it is wise to 
		use Flowchart_Blank.
		
{phang}
{bf:Block Orientations:} Each row can have 2 blocks: center and left. The center-block 
		appears on the left of the diagram and the left-block appears on the right of the diagram (note: this 
		can be confusing initially and must be learned).
		
		A blank block is a block with no lines or content (which won't be drawn in the final diagram) and should 
		have the special keyword 'flowchart_blank' to indicate to the program's parser internally that 
		there's no content for that block, otherwise the blocks will misalign and the .tex document will not 
		compile the TikZ picture.
		
{phang}
The sides of the diagram are initially counter-intuitive. Think of it like reading a chest x-ray: 
	when interpreting the x-ray the patient's left is on the right of the page and the patient's right 
	is on the left of the page -- the orientation being relative to a patient facing out of the plane 
	of the x-ray. 
	
	Likewise, the column that is immediately to the left of the page as the center column 
	and the column that is immediately to the right of the page is the left column.


{dlgtab:Block Connections ("Arrows")}

{p}
{bf:flowchart connect}

	{bf:Format:} [rowname_center] --> [rowname_left] - Connect a center block to a left block for horizontal 
		arrows across rows.
		[rowname_center] --> [rowname_center] - Connect a center block to a center block for vertical 
			across within the same column for blocks in the center.
		[rowname_left] --> [rowname_left] - Connect a left block to a left block for vertical across 
			within the same column for blocks on the left.
		, arrow(angled) - This option makes the arrow make a 90 degree angle. Use this across a blank row.
		
{phang}
Connect each row's block with an underscore and then the column-orientation corresponding to its 
	side in this manner.

	
{phang}
{cmd:flowchart connect} [blockname_orientation1] [blockname_orientation2], {opt arrow(shape)} allows you to specify the type of arrow.


{hline}


{marker remarks}{...}
{title:Remarks}

{phang}
For detailed information on the {it:flowchart package}, visit {browse "https://github.com/IsaacDodd/flowchart/"}.

		
{marker examples}{...}
{title:Examples}

See the very detailed examples in the Ancillary Files. Install them into your working directory by typing into stata:

	. flowchart setup

{phang}
Here is an example of how rows can be written in a {it:do file}.

	* |||||| EXAMPLE1: Dummy Row
	. flowchart writerow(rowname): "lblock1_line1" 46 "This is one line, of a block." ///
		"lblock1_line2" 43 "This is another line, of a block" ///
		"lblock1_line3" 3 "This is another line, of a block", ///
		"rblock1_line1" 97 "This is one line, of a block." ///
		"rblock1_line2" 33 "This is another line, of a block" ///
		"rblock1_line3" 44 "This is another line, of a block"

	* |||||| EXAMPLE2: Row with No center-block
	. flowchart writerow(rowname): flowchart_blank, "rblock1_line1" 97 "This is one line, of a block." ///
		"rblock1_line2" 33 "This is another line, of a block" ///
		"rblock1_line3" 44 "This is another line, of a block"

	* |||||| EXAMPLE3: Row with No left-block
	. flowchart writerow(rowname): "lblock1_line1" 46 "This is one line, \\ of a block." ///
		"lblock1_line2" 43 "This is another line, of a block" ///
		"lblock1_line3" 3 "This is another line, of a block", Flowchart_Blank

{phang}
A block with a single row is called a 'singleton'. Each new line in a block is indented under the first line (the 'lead-line').
You can use macros to fill in the numbers here so that you only need to type these rows once. 
The macros can be used to do math on the numbers to simplify adding new rows.

{hline}

	
{marker troubleshooting}{...}
{title:Troubleshooting}


Here is a list of known problems that can arise in using this program and their quick-fix solutions.

{phang}{cmd: STATA: unrecognized command:  Flowchart_Blank r(199);}{p_end}

	This is likely because you forgot to wrap a line where there is a blank.
	Here is an example:
		flowchart writerow(random): "randomized" 102 "Randomized", 
			Flowchart_Blank // Blank Row
	Here is how it is fixed:
		flowchart writerow(random): "randomized" 102 "Randomized", ///
			Flowchart_Blank // Blank Row
			
{phang}{cmd: TIKZ Error in LaTeX}{p_end}

	LATEX: Argument of \@dtl@lop@ff has an extra }. ...<filename of data file>.data"}

	This is likely because you tried to use the Flowchart_Blank keyword but actually 
	misspelled the 'Flowchart_Blank' keyword. Go back and edit the keyword and try again.
		
{phang}{cmd: TIKZ Package pgf Error}{p_end}

	Package pgf Error: No shape named <blockname_orientation> is known. \path (<blockname_orientation>)

	This is likely due to an error in using the 'flowchart connect' command where 
	you referred to a block that does not exist. If a row does not have an accompanying 
	block, whether left or center oriented, it cannot be connected to any other blocks. 
	Therefore, try reviewing the connection to determine if you may be connecting an 
	arrow to a block that is blank.

{phang}{cmd: Initialization Error}{p_end}

	flowchart init using C:\...\Filename With Spaces.data
	invalid 'With' 
	r(198);
	
		This error happens when you specify a filename that has spaces in it. Instead, put 
		the entire filepath in quotes:
	flowchart init using "C:\...\Filename With Spaces.data"
		Note: Specifying the entire path isn't necessary if you are using a working directory 
		with relative paths. See 'help filename' for an explanation of filenaming conventions.

{phang}{cmd: Setup Errors}{p_end}

	Flowchart won't uninstall:
	criterion matches more than one package
	r(111);

	This problem has been fixed in updated versions of flowchart, but this explanation is 
	left here in case it still happens. This is an error that is known to occur on Stata 
	version 13 and lower and was fixed by Stata Corp. starting with Stata version 14. This 
	occurs because Stata keeps track of which packages are installed, from where, and if 
	you originally installed flowchart from the Boston College SSC database (i.e., through 
	'ssc install flowchart', or did so through typing 'help flowchart', which may have chosen
	the ssc package by default), so updating flowchart by running 'flowchart setup' likely 
	installed a second installation of flowchart -- in reality you only have 1 installation 
	of flowchart but there are 2 entries in Stata's internal database of installed package. 
	
	This problem can be confirmed by typing into Stata: '. ado dir flowchart' and seeing 
	that there are 2 flowchart packages installed. Therefore, to fix the problem on Stata 
	version 13 or lower, type into Stata: '. net query flowchart'. Next to 'ado' you will 
	find where your packages are installed (i.e., for example 'c:\ado\plus\'). In that 
	directory, you will find stata.trk. Carefully edit the file: each package ends with 
	a 'e'; Delete the extra flowchart entry by deleting from the 'S' line to the 'e' line. 
	Then save this file. Now, run again the command  '. ado uninstall flowchart'. Now you 
	can confirm that both entries have been removed by running '. ado dir flowchart' and 
	seeing that no entries are returned. You can then install a fresh copy from GitHub by 
	running the command: 

	  . net install flowchart, from("https://raw.github.com/IsaacDodd/flowchart/master/")
		
		
	The problem should now be resolved.

{phang}{cmd: Other Issues}{p_end}
	
{phang}
	For problems not resolved through this list, please open an issue/bug on GitHub. When 
	opening a new issue, you can greatly speed up the issue resolution process by submitting 
	2 things:

{phang}	
	1. In Stata, type 'flowchart debug info'. Copy and paste the results into your issue. This 
	command returns the exact version of the packages you are running in case the problem was fixed 
	or introduced in a subsequent release.

{phang}
	2. In your do file, go to the line or lines that are giving you trouble. Before those 
	lines, put 'flowchart debug on' and after those lines put 'flowchart debug off'. Then, 
	rerun your program. You should notice in your working directory a new file was created 
	called 'DebugLog.log'. Either copy and paste the content or attach it as a new file. 
	Be sure to first remove any sensitive directories that you would not want the public 
	to see since GitHub is an open source community.

{phang}
	{browse "https://github.com/IsaacDodd/flowchart/issues/new/"}

{hline}
		
{marker references}{...}
{title:References & Bibliography}


1. Texdoc Command Use Based On: 
	Citation: Jann, Ben (2016 Nov 27). Creating LaTeX documents from within Stata using 
	texdoc. University of Bern Social Sciences Working Paper No. 14; The Stata Journal 
	16(2): 245-263. Reprinted with updates at 
	{browse "ftp://ftp.repec.org/opt/ReDIF/RePEc/bss/files/wp14/jann-2015-texdoc.pdf"} Retrieved on 
	July 28, 2017.

2. TikzPicture Diagram Code Based On: 
	 Citation: Willert, Morten Vejs (2011 Dec 31). "A CONSORT-style flowchart of a 
	 randomized controlled trial". TikZ Example (Texample.net). Retrieved from 
	 {browse "http://www.texample.net/tikz/examples/consort-flowchart/"}

{marker credit}{...}
{title:Credits & Acknowledgements}

	Credit to Ben Jann, whose texdoc package is a dependency in flowchart, and Morten 
	Willert, whose example of a flowchart diagram in TikZ was studied and used heavily 
	to generate similar flowcharts in this package.
