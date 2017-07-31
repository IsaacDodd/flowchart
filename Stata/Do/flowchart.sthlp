{smcl}
{* *! version 0.0.1 28jul2017}{. . .}
{* References: http://www.stata.com/manuals13/u18.pdf#u18.11Ado-files , http://www.stata.com/manuals13/u17.pdf }{. . .}
{vieweralsosee "[R] help" "help help "}{. . .}
{viewerjumpto "Syntax" "flowchart##syntax"}{. . .}
{viewerjumpto "Description" "flowchart##description"}{. . .}
{viewerjumpto "Options" "flowchart##options"}{. . .}
{viewerjumpto "Remarks" "flowchart##remarks"}{. . .}
{viewerjumpto "Examples" "flowchart##examples"}{. . .}
{title:Introduction}
{phang}
{bf:flowchart} {hline 2} Flowchart - Use this command to generate a publication-quality Subject Disposition Flowchart Diagram, similar in style to the ones used in the CONSORT 2010 Statement Reporting Guidelines, in LaTeX format
{marker syntax}{. . .}
{title:Syntax}
{p 8 17 2}
{cmdab:fl:owchart}
[{command}]
{ifin}
{weight}
[{cmd:,}
{it:options}]
{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt d:etail}}display additional statistics{p_end}
{synopt:{opt mean:only}}suppress the display; calculate only the mean;
programmer’s option{p_end}
{synopt:{opt f:ormat}}use variable’s display format{p_end}
{synopt:{opt sep:arator(#)}}draw separator line after every {it:#} variables;
default is {cmd:separator(5)}{p_end}
{synopt:{opth g:enerate(newvar)}}create variable name {it:newvar}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{cmd:by} is not allowed; see {manhelp by D}.{p_end}
{p 4 4 2}
{cmd:fweight}s are will be allowed on a future release; see {help weight}.
{marker description}{. . .}
{title:Description}
{pstd}
{cmd:flowchart} is a command that generates a Subject Disposition Flowchart Diagram. This is similar in style to the ones used in the CONSORT 2010 Statement Reporting Guidelines, in LaTeX format using data from a dataset. This command uses the 'texdoc' command (written by Ben Jann). Install it first by typing into Stata: 'net install texdoc, replace'
{cmd:flowchart init using <filename.data>}
	This command takes the filename of a text file where data variables can be written so that the datatool package in LaTeX can be used to load the file specified to fill in all of the \figvalues{variable_name} with the numbers specified in each line. (Variable names entered must be unique.)
	In LaTeX, place this in the preamble (the space between \documentclass{article}... and \begin{document} ):
		% 	Figures, Diagrams, and Other Graphics
		\usepackage{tikz}		% TikZ Package - Generates graphics (i.e., flowcharts)
			\usetikzlibrary{shapes,arrows}
			\newcommand*{\h}{\hspace{5pt}}% For indentation
			\newcommand*{\hh}{\h\h}% Double indentation
		\usepackage{datatool}	% DataTool Package - Loads Subanalysis Data to generate flowchart
			\DTLsetseparator{ = }% Delimiter
	This will load the datatool and TikZ package.
{cmd:flowchart writerow(rowname): } 
Format: flowchart writerow([Name_of_row]): [Block_Center], [Block_Left]
	The content within each block should be separated by a single comma (strings within a block can still use a comma, it just has to be within double-quotes).
		The first block gets assigned the 'center' orientation and the second gets the 'left' orientation. Each block can have several lines, and each line has to have a triplet of 3 fields which should be separated by spaces.
 		A single line is a triplet of these 3 fields: "variable_name" n# "Description of the variable name and number."
		Limitations: Variable names must be unique and the numbers entered should be real numbers. Descriptions must not contain curly braces (i.e., '{' or '}').
		In Stata, multiple triplets can be separated by a \\\ at the end of the line for readability.
	A blank block is a block with no lines or content (which won't be drawn in the final diagram) and should have the special keyword 'flowchart_blank' to indicate to the program's interpreter internally that there's no content for that block, otherwise the blocks will misalign and the .tex document will not compile the TikZ picture.
Format: [rowname_center] --> [rowname_left] - Connect a center block to a left block for horizontal arrows across rows.
	* [rowname_center] --> [rowname_center] - Connect a center block to a center block for vertical across within the same column for blocks in the center.
	* [rowname_left] --> [rowname_left] - Connect a left block to a left block for vertical across within the same column for blocks on the left.
	* , angled - This option makes the arrow make a 90 degree angle. Use this across a blank row.
Column Orientation: 
	The sides of the diagram are initially counter-intuitive. Think of it like reading a chest x-ray: when interpreting the x-ray the patient's left is on the right of the page and the patient's right is on the left of the page -- the orientation being relative to a patient facing out of the plane of the x-ray. Likewise, the column that is immediately to the left of the page as the center column and the column that is immediately to the right of the page is the left column.

{cmd:flowchart connect}
	Connect each row's block with an underscore and then the column-orientation corresponding to its side in this manner.

{marker options}{. . .}
{title:Options}
{dlgtab:Main}
{phang}
{cmd:flowchart connect} [blockname_orientation1] [blockname_orientation2] {opt arrow(shape)} allows you to specify the type of arrow.
{phang}
{opt meanonly} restricts the calculation to be based on only the
means. The default is to use a trimmed mean.
{phang}
{opt format} requests that the summary statistics be displayed using the display
formats associated with the variables, rather than the default {cmd:g} display
format; see {bf:[U] 12.5 Formats: Controlling how data are displayed}.
{phang}
{opt separator(#)} specifies how often to insert separation lines
into the output. The default is {cmd:separator(5)}, meaning that a
line is drawn after every 5 variables. {cmd:separator(10)} would
draw a line after every 10 variables. {cmd:separator(0)} suppresses
the separation line.
{phang}
{opth generate(newvar)} creates {it:newvar} containing the whatever values.
{marker remarks}{. . .}
{title:Remarks}
{pstd}
For detailed information on this command, see {bf:[R] flowchart}.

{title:Keywords}
	{bf:Flowchart_Blank}
		This keyword defines a blank block. Either the left or the center block can be set to blank using this keyword before or after the comma respectively so that a box doesn't appear on a given row.
		This can be of any casing (e.g., fLoWcHaRT_BLANK, flowchart_blank, or any combination) as long as the keyword is spelled correctly, but for readibility it is wise to use Flowchart_Blank.

		
{marker examples}{. . .}
{title:Examples}

* |||||| EXAMPLE1: Dummy Row
flowchart writerow(rowname): "lblock1_line1" 46 "This is one line, \\ of a block." "lblock1_line2" 43 "This is another line, of a block" "lblock1_line3" 3 "This is another line, of a block", ///
	"rblock1_line1" 97 "This is one line, of a block." "rblock1_line2" 33 "This is another line, of a block" "rblock1_line3" 44 "This is another line, of a block"

* |||||| EXAMPLE2: Row with No left-block
flowchart writerow(rowname): flowchart_blank, "rblock1_line1" 97 "This is one line, of a block." "rblock1_line2" 33 "This is another line, of a block" "rblock1_line3" 44 "This is another line, of a block"

* |||||| EXAMPLE3: Row with No right-block
flowchart writerow(rowname): "lblock1_line1" 46 "This is one line, \\ of a block." "lblock1_line2" 43 "This is another line, of a block" "lblock1_line3" 3 "This is another line, of a block", flowchart_blank

{marker troubleshooting}{. . .}
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
{phang}{cmd: TIKZ}{p_end}
LATEX: Argument of \@dtl@lop@ff has an extra }. ...<filename of data file>.data"}

	This is likely because you tried to use the Flowchart_Blank keyword but actually misspelled the 'Flowchart_Blank' keyword. Go back and edit the keyword and try again.
{phang}{cmd: TIKZ Package pgf Error}{p_end}
Package pgf Error: No shape named <blockname_orientation> is known. \path (<blockname_orientation>)

	This is likely due to an error in using the 'flowchart connect' command where you referred to a block that does not exist. If a row does not have an accompanying block, whether left or center oriented, it cannot be connected to any other blocks. Therefore, try reviewing the connection to determine if you may be connecting an arrow to a block that is blank.
	
For problems not resolved through this list, please open an issue/bug.