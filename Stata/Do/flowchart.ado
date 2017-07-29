*##############################################################################*
********************************************************************************
*** FIGURE: SUBJECT DISPOSITION FLOW DIAGRAM (FLOWCHART)                    ****
********************************************************************************
*##############################################################################*
* 
* DEPENDENCIES: 
*   texdoc - STATA Command
*      Installation Instructions:
*         In the STATA command-line, run the following 2 commands:
*	       ssc install texdoc, replace
*          net install sjlatex, from(http://www.stata-journal.com/production)
*   LaTeX, Distribution (MiKTeX or TeXLive), Distribution Engine, and IDE Editor
*         
* EXPLANATION:
*   The following details the directory structure needed:
* 
* 	/Manuscript/
* 		|
*		|-- ##-[ProjectName]-[Section]-Fig-[FigureName].tex  <-- LaTeX Document
*       +-- ##-[ProjectName]-[Section]-Fig-[FigureName].tikz <-- TikZ Picture
* 
*   /Stata/
*       |
*       |-- /Data/
*       |     |
*       |     +-- /Subanalysis Data/
*       |           |
*       |           +-- [Section]-Fig-[FigureName].data      <-- Suba. Data File
*       +-- /Do/
*             |
*             |-- ##-[ProjectName]-PostProduction-[Section]--Fig-[FigureName].do
*             |                                  Figure Do-File -------^
*             \\   ...
*             | 
*             +-- ##-[ProjectName]-[Section]-[Main Analysis File].do
*                                     Main Analysis File -----^
*
*   LaTeX Document
*       This is a (.tex) file that contains a \begin{figure}...\end{figure} Environment command. STATA does not manipulate this file. It instead contains all of the design elements that arrange the TikZ picture appropriately in the Manuscrupt and also loads the Subanalysis Data (.data) in the Data file for generating the different components of the TikZ picture's diagram (e.g., data for the boxes of a Subject Disposition Flowchart).
*   Figure Do File (Texdoc Do File)
*       This Do file is a 'Texdoc Do File' which is to say it is invoked by the texdoc command in STATA in the Main Analysis File that is producing the Subanalysis Data off of the main analysis using the Dataset that is loaded.
*   TikZ Picture (Automatically regenerated)
*       This is a 'picture' that is used by the TikZ package in LaTeX to generate a diagram in LaTeX. It relies upon 
*   Subanalysis Data File (Automatically regenerated)
*       The data for a figure is produced from a subanalysis and is assigned to variables. The Data file consists of variables with the generated data, as one variable assignment per line. A '=' sign is used as a delimiter to denote [variable] = [value] where the left-hand side is the variable-name and the right-hand side is the value or data produced in the subanalysis. The variables with data produced by the subanalysis have to have a unique name and are given a name in the do file that produces the figure. Data from the Dataset used in an analysis can be used to generate the data for the diagram.
*
* Overall
*     Main Analysis File --> Runs the Figure Do-File (which is changed by the user to reflect the flow of data analysis )
*     Figure Do-File --> Produces the boxes in the TikZ Picture and writes the equivalent values in the Subanalysis Data File
*     LaTeX Document --> Changed by the user to arrange or re-arrange the TikZ picture in the Manuscript.
*     
* REFERENCES
*     Citation: Jann, Ben (2016 Nov 27). Creating LaTeX documents from within Stata using texdoc. University of Bern Social Sciences Working Paper No. 14; The Stata Journal 16(2): 245-263. Reprinted with updates at ftp://ftp.repec.org/opt/ReDIF/RePEc/bss/files/wp14/jann-2015-texdoc.pdf Retrieved on July 28, 2017.

********************************************************************************
****** TEXDOC: TIKZ PICTURE
********************************************************************************

