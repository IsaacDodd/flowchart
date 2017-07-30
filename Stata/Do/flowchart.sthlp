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
{cmd:by} is allowed; see {manhelp by D}.{p_end}
{p 4 4 2}
{cmd:fweight}s are allowed; see {help weight}.
{marker description}{. . .}
{title:Description}
{pstd}
{cmd:flowchart} is a command that generates a Subject Disposition Flowchart Diagram. This is similar in style to the ones used in the CONSORT 2010 Statement Reporting Guidelines, in LaTeX format using data from a dataset. This command uses the 'texdoc' command (written by Ben Jann). Install it first by typing into Stata: 'net install texdoc, replace'
{marker options}{. . .}
{title:Options}
{dlgtab:Main}
{phang}
{opt detail} displays detailed output of the calculation.
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
For detailed information on the whatever statistic, see {bf:[R] intro}.
{marker examples}{. . .}
{title:Examples}
{phang}{cmd:. whatever mpg weight}{p_end}
{phang}{cmd:. whatever mpg weight, meanonly}{p_end}
