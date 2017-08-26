********************************************************************************
****** EXAMPLE
********************************************************************************
*
********************
* INTRODUCTION: Producing a Subject Disposition Flowchart
********************
* 
* A similar example flowchart can be seen here: 
*   http://www.texample.net/tikz/examples/consort-flowchart/
*   The code from this example was used as a guide for this project.
*   Citation: Willert, Morten Vejs (2011 Dec 31). "A CONSORT-style flowchart of 
*       a randomized controlled trial". TikZ Example (Texample.net). Retrieved 
*       from http://www.texample.net/tikz/examples/consort-flowchart/
* Running this example should produce similar otuput.
* 
* INSTRUCTIONS:
*   This file is a part of the ancillary files that come with flowchart 
*       (installed by typing 'net get flowchart').
*   By default it installs to the working directory at the time that
*       the 'net get' command is run. 
*
*   Run this do file from the do editor by hitting Ctrl + D (or Cmd + D on a 
*       mac) in the same directory as the ancillary files.
*   After running, a .tikz file will be produced. Open this file. In your LaTeX 
*       editor, run the manuscript with this file 
*       included (\input{<filename>.tikz})
*   Be sure to use the recommended packages and commands in the preamble of the 
*       ancillary file manuscript for the diagram to display properly.
*
* DEPENDENCIES:
*   After installing flowchart, be sure the following are in place: 
*   1. texdoc, sjlatex - STATA Packages
*       Installation Instructions:
*       In the STATA command-line, run the following command:
*           flowchart setup
*       This installs 2 dependencies: texdoc and its dependency, sjlatex
*   2. figure-flowchart.texdoc = Ancillary File
*       Installation Instructions:
*       In the STATA command-line, when you ran the setup command, it also 
*           installed the Ancillary Files into your present working directory.
*   3. LaTeX Setup (Typesetting)
*       A LaTeX setup should be installed to compile .tex and .tikz files:
*       a) Distribution (MiKTeX or TeXLive)
*           Recommended: MiKTeX, then use it to install the following packages: 
*               datatool, listings, multicol, xcolor, graphicx, tikz
*           Download: https://miktex.org/download/
*       b) Distribution Engine 
*           Recommended: pdfLaTeX 
*           Download: (Comes preinstalled with either Distribution)
*       c) IDE Editor
*           Recommended: TeXstudio (instead of others: TeXworks, TeXMaker, etc.)
*           Download: http://www.texstudio.org/
*       -----------------------------
*       d) Online LaTeX Setup 
*           Setting up a, b, and c can take some time. Therefore, an online
*           LaTeX can be used if you would like get started quickly.
*               ShareLaTeX - http://www.sharelatex.com/
*               Overleaf - http://www.overleaf.com/
*           These two companies have announced that they will soon merge into 
*           one editor.
*       -----------------------------
*       If you are a beginner/new to LaTeX, here are good starting points:
*           Installations:
*               https://www.youtube.com/watch?v=WewSa9aaFXg
*           Syntax: 
*               https://www.sharelatex.com/learn/Learn_LaTeX_in_30_minutes
*               https://www.youtube.com/watch?v=SoDv0qhyysQ
*           Help: 
*               https://tex.stackexchange.com
*         
********************
* SUGGESTED ANALYSIS APPROACH: Organization, Workflow, and Writing Code
********************
*
*   Here is a proposed way to use the flowchart program:
*   * DISPOSITION SUBANALYSIS: Analyze and setup the subject disposition.
*       *** Subanalysis Data is performed here where the numbers and data to 
*           produce the flowchart are created. 
*       *** Rows can be created using macros to fill in each row as the data for
*           the analysis are changed.
*   
*   * DIAGRAM: This writes the analysis as a diagram.
*       * Note: All files are relative to the current working directory unless
*           you specify a path with the filenames specified. Here is an example.
* 
*   The following details suggested directory structures and naming conventions:
* 
*   /Manuscript/
*       |
*       |-- ##-[ProjectName]-[Main-Manuscript-File].tex      <-- LaTeX Document
*       |-- ##-[ProjectName]-[Section]-Fig-[FigureName].tex  <-- LaTeX Document
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
*   For this suggested structure, the filepaths to use would be as follows:
*   
*  . flowchart init using "..\Data\Subanalysis Data\methods--fig-flowchart.data"
*  
*  . flowchart writerow ...
*  . flowchart writerow ...
*  . flowchart writerow ...
*  
*  . flowchart connect ...
*  . flowchart connect ...
*  . flowchart connect ...
* 
*  . flowchart finalize, template("fig-flowchart.texdoc") output("..\..\Manuscript\methods--fig-flowchart.tikz")
*   
********************
* EXPLANATION OF FILES:
********************
* 
*   Do File
*       This is the .do file that contains your analysis where you can use
*       the flowchart commands to generate the diagram.
*           See Example: flowchart_example2.do
*   LaTeX Documents
*       This is a (.tex) file that contains a \begin{figure}...\end{figure} 
*       Environment command. STATA does not manipulate this file. It instead 
*       contains all of the design elements that arrange the TikZ picture 
*       appropriately in the Manuscript and also loads the Subanalysis Data 
*       (.data) in the Data file for generating the different components of the 
*       TikZ picture's diagram (e.g., data for the boxes of a 
*       Subject Disposition Flowchart).
*           See Example: methods--figure-flowchart.tex
*       The manuscript's .tex file can then include this .tex file specific to 
*       the figure directly into the manuscript file with an \input{ } command:
*       \input{methods--figure-flowchart.tex}
*           See Example: manuscript.tex
*   Figure Texdoc Do File - Do Not Edit
*       This Do file is a 'Texdoc Do File' which is to say it is invoked by the 
*       texdoc command in STATA in the Main Analysis File that is producing the 
*       Subanalysis Data created from your analysis using your dataset. There's
*       no need to edit this file beyond changing its filename to match your
*       project's naming convention.
*           See Example: figure-flowchart.texdoc (No Need to Edit)
*   TikZ Picture (Automatically regenerated)
*       This is a 'picture' that is used by the TikZ package in LaTeX to 
*       generate a diagram in LaTeX. There's no need to edit this file beyond
*       changing its filename to match your project's naming convention.
*       Instead, in your LaTeX document, use the \input{<filename.tikz>} to
*       make LaTeX automatically include it in the final document when 
*       compiling.
*           See Example: methods--figure-flowchart.tikz (No Need to Edit)
*   Subanalysis Data File (Automatically regenerated)
*       The data for a figure is produced from a subanalysis and is assigned to 
*       variables. The Data file consists of variables with the generated data, 
*       as one variable assignment per line. A '=' sign is used as a delimiter 
*       to denote [variable] = [value] where the left-hand side is the 
*       variable-name and the right-hand side is the value or data produced in 
*       the subanalysis. The variables with data produced by the subanalysis 
*       have to have a unique name and are given a name in the do file that 
*       produces the figure. Data from the Dataset used in an analysis can be 
*       used to generate the data for the diagram. There's no need to edit the
*       file beyond changing its filename to match your project's naming 
*       convention.
*           See Example: methods--figure-flowchart.data (No Need to Edit)
*
* OVERALL: 
* 
*     Main Analysis File --> Runs the Figure Do-File (which is changed by the 
*       user to reflect the flow of data analysis).
* 
*     Figure Do-File --> Produces the boxes in the TikZ Picture and writes the 
*       equivalent values in the Subanalysis Data File.
* 
*     LaTeX Document --> Changed by the user to arrange or re-arrange the 
*       'TikZ picture' in the Manuscript.
*     
* REFERENCES
* 1. Texdoc Command Use Based On: 
*    Citation: Jann, Ben (2016 Nov 27). Creating LaTeX documents from within Stata using texdoc. University of Bern Social Sciences Working Paper No. 14; The Stata Journal 16(2): 245-263. Reprinted with updates at ftp://ftp.repec.org/opt/ReDIF/RePEc/bss/files/wp14/jann-2015-texdoc.pdf Retrieved on July 28, 2017.
* 2. TikzPicture Diagram Code Based On: 
*    Citation: Willert, Morten Vejs (2011 Dec 31). "A CONSORT-style flowchart of a randomized controlled trial". TikZ Example (Texample.net). Retrieved from http://www.texample.net/tikz/examples/consort-flowchart/ 
* Acknowledgements: Thank you Morten Willert for the TikZ flowchart example.

********************************************************************************
****** EXAMPLE
********************************************************************************

* DISPOSITION SUBANALYSIS: 
*
*   ... This subanalysis section would be performed in your main analysis do file 
*       to produce the data for the the flowchart command.

* ------------------------------------------------------------------------------

* DIAGRAM: 
* Run this code to produce a similar flowchart to M. Willert's CONSORT-style 
*   flowchart: http://www.texample.net/tikz/examples/consort-flowchart/
* It should resemble that flowchart.

* Initiate a flowchart by specifying the subanalysis data file to write: 
flowchart init using "methods--figure-flowchart.data"


* Format: flowchart writerow(rowname): [center-block triplet lines] , [left-block triplet lines]
*   Triplet Format: "variable_name" n= "Descriptive text."

flowchart writerow(enrollment): ///
    "referred" 173 "Referred", ///
    "referred_excluded" 17 "Excluded" ///
        "referred_excluded_nopartic" 9 "a) Did not wish to participate" ///
        "referred_excluded_noshow" 5 "b) Did not show for interview" ///
        "referred_excluded_other" 3 "c) Other reasons"
    
flowchart writerow(assessment): ///
    "assessed" 156 "Assessed for Eligibility", ///
    "assessed_excluded" 54 "Excluded" ///
        "assessed_excluded_inclusioncritunmet" 22 "a) Inclusion criteria not met" ///
        "assessed_excluded_exclusioncritmet" 13 "b) Exclusion criteria met" ///
        "assessed_excluded_unsuitedgroup" 7 "c) Not suited for waitlist group" ///
        "assessed_excluded_unsuitedtx" 2 "d) Not suited for intervention" ///
        "assessed_excluded_othertx" 3 "e) Sought other treatment" ///
        "assessed_excluded_other" 7 "f) Other reasons"

flowchart writerow(random): "randomized" 102 "Randomized", flowchart_blank // Blank Row

flowchart writerow(allocgroup): ///
    "alloc_interventiongroup" 51 "Allocated to Intervention group", ///
    "alloc_waitlistgroup" 51 "Allocated to Wait-list control group"

flowchart writerow(allocdetails): ///
    "intervention_received" 49 "Received intervention" ///
        "intervention_unreceived" 2 "Did not receive intervention" ///
        "intervention_unreceived_exclusioncrit" 1 "With exclusionary criteria" ///
        "intervention_unreceived_notime" 1 "Could not find time to participate", ///
    "waitlist_stayedon" 48 "Stayed on wait-list" ///
        "waitlist_didnotstay" 3 "Did not stay on wait-list" ///
        "waitlist_didnotstay_selfinduced" 2 "Lost motivation" ///
        "waitlist_didnotstay_leftarea" 1 "Was offered treatment elsewhere"
    
flowchart writerow(postmeasurement): ///
    "postintervention_lost" 5 "Post-intervention measurement" ///
        "postintervention_lost_droppedout" 2 "Dropped out of the intervention" ///
        "postintervention_lost_nomeasurement" 3 "Did not complete measurement", ///
    "postwaitlist_lost" 6 "Post-wait-list measurement" ///
        "postwaitlist_lost_droppedout" 3 "Dropped out of the wait-list" ///
        "postwaitlist_lost_nomeasurement" 3 "Did not complete measurement" ///
    
flowchart writerow(wlistintervention): flowchart_blank, /// 
    "postwaitlist_intervention_allocated" 48 "Allocated to intervention" ///
        "postwaitlist_intervention_received" 46 "Received intervention" ///
        "postwaitlist_intervention_didnotreceive" 2 "Did not receive intervention" ///
        "postwaitlist_intervention_dnr_lowmotivation" 1 "Reported low motivation" ///
        "postwaitlist_intervention_dnr_notime" 1 "Could not find time to participate"
    
flowchart writerow(measurement3monpostint): ///
    "intervention_3monthfollowup" 9 "3-months follow-up measurement: \\ \h Loss to follow-up", ///
    "postwaitlist_postintervention_losstofollowup" 5 "Post-intervention measurement: \\ \h Loss to follow-up" ///
        "postwaitlist_postintervention_losstofollowup_droppedout" 2 "Dropped out of the intervention" ///
        "postwaitlist_postintervention_losstofollowup_incomplete" 3 "Did not complete measurement"

flowchart writerow(wlist3mon): flowchart_blank, ///
    "postwaitlist_3monthfollowup" 2 "3-months follow-up measurement \\ \h Did not complete measurement"
    
flowchart writerow(analyzed): ///
    "intervention_analyzed" 51 "Analyzed in Intervention group", ///
    "postwaitlist_analyzed" 51 "Analyzed in Wait-list control group"

* Format: rowname_blockorientation rowname_blockorientation
* This command connects the blocks with arrows by their assigned orientation. 
*   Use rowname_center for the center-block (first block of triplets), which will appear on the left of the diagram.
*   Use rowname_left for the left-block (second blow of triplets), which will appear on the right of the diagram.
flowchart connect enrollment_center enrollment_left
flowchart connect enrollment_center assessment_center
flowchart connect assessment_center assessment_left
flowchart connect assessment_center random_center
flowchart connect random_center allocgroup_center
flowchart connect random_center allocgroup_left, arrow(angled)
flowchart connect allocgroup_center allocdetails_center
flowchart connect allocgroup_left allocdetails_left
flowchart connect allocdetails_center postmeasurement_center
flowchart connect allocdetails_left postmeasurement_left
flowchart connect postmeasurement_center measurement3monpostint_center
flowchart connect measurement3monpostint_center analyzed_center
flowchart connect postmeasurement_left wlistintervention_left
flowchart connect wlistintervention_left measurement3monpostint_left
flowchart connect measurement3monpostint_left wlist3mon_left
flowchart connect wlist3mon_left analyzed_left 

flowchart finalize, template("figure-flowchart.texdoc") output("methods--figure-flowchart.tikz")


* Now, using LaTeX, compile the manuscript.tex file -- This file is already setup to tie all of these files together.
*   This file shows you how you would use \input{} to include the new .tikz file as a figure diagram into a 'figure' tex LaTeX document.
*   The preamble in the ancillary manuscript file is a guide on which packages and commands to include in your LaTeX setup.
