
* DISPOSITION SUBANALYSIS: Analyze and setup the subject disposition.


* DIAGRAM: Call Post-Production texdoc file to write this analysis as a diagram.

capture program drop flowchart
*! version 0.0.1  28jul2017  Isaac M. E. Dodd
program define flowchart
	version 13
	syntax [anything] [using/] [, name(string) value(string) input(string) output(string) *]
	
	if("`1'" == "init" | "`1'" == "init,") {
		global Flowchart_Settings = ""
		capture file close FlowchartFile
		file open FlowchartFile using "`using'", write text replace
		flowchart_init
	}
	else if("`1'" == "close" | "`1'" == "finalize" | "`1'" == "close," | "`1'" == "finalize," ) {
		display "Closed."
		capture file close FlowchartFile 
		flowchart_tdfinalize, input("`input'") output("`output'")
	}
	else if("`1'" == "write") {
		if("`2'" == "box" | "`2'" == "box,") {
			display "Write: `2' `name' `value'"
			flowchart_writevar, name("Test") value("Testing testing 1 2 3 5 6 7 8 9 10 ...")
		}
		else if("`2'" == "row" | "`2'" == "row,") {
			display "Write: `2' `name' `value'"
		}
		*display "0 = `0' ; 1 = `1' ; 2 = `2' ; 3 = `3' ; 4 = `4' ; 5 = `5' ; 6 = `6' ; 7 = `7'"
	}
	else if("`1'" == "newbox") {
		display "New Box: `1' `2'"
	}
	else {
	
		* Parse the token for a possible sub-command that contains a parameter (e.g., flowchart subcommand(parameter): ... )
		* 	This is necessary since Stata's 'syntax' command returns the subcommand token `1' with a colon. This method ensures the proper string is parsed.
		gettoken subcommand 0 : 0, parse(" :") quotes
		while `"`subcommand'"' != ":" & `"`subcommand'"' != "" {
			local subcmdwithparam `"`subcmdwithparam' `subcommand'"'
			gettoken subcommand 0 : 0, parse(" :") quotes
			display `"Subcommand via GetToken: `subcommand'"'
			display "Subcommand via Syntax: `1'"
			display `"Subcommand with Parameter: `subcmdwithparam'"'
			display `"Compound Quotes (CQ's):  `0'"'
		}
		* Parse the possible sub-command with parameter, accounting for any whitespace within the passed parameter and subcommand.
		local subparam = trim(substr(trim("`subcmdwithparam'"), strpos(trim("`subcmdwithparam'"), "(")+1, length(trim("`subcmdwithparam'"))-strpos(trim("`subcmdwithparam'"), "(")-1))
		local subcmdparsed = substr(trim("`subcmdwithparam'"), 1, strpos(trim("`subcmdwithparam'"), "(")-1)
		
			display `"Subparameter via String Parse (CQs):  `subparam'"'
			display `"Subcommand via String Parse (CQs):  `subcmdparsed'"'
			
		if("`1'" == "writerow:" | "`1'" == "writerow" | "`subcmdparsed'" == "writerow" | trim("`subcmdparsed'") == "writerow") {
	
			gettoken varfirst varothers : 0
			display ""
			display " First Variable: `varfirst'"
			display ""
			display "Macro Without Quotes: " `varothers'
			display ""
			display `"Compound Quotes (CQ's):  `varothers'"'
			display ""
			display `"Entire Statement (With CQ's): `0'"'
			display ""

			display `"Tokens:"'
			display ""
			local i = 1
			while "``i''" != "" {
				display "`i': ``i''"
				display ""
				local i = `i' + 1
			}
	   }
	}
end
capture program drop flowchart_init
program define flowchart_init
	flowchart_writevar, name("set_dummy") value("null")	// Set dummy variable since the first variable is not recognized by texdoc.
	flowchart_writevar, name("set_draw") value("black")
	flowchart_writevar, name("set_fill") value("white")
	flowchart_writevar, name("set_center_textwidth") value("8em")
	flowchart_writevar, name("set_center_textalign") value("centered")
	flowchart_writevar, name("set_center_minheight") value("4em")
	flowchart_writevar, name("set_left_textwidth") value("16em")
	flowchart_writevar, name("set_left_textalign") value("ragged")
	flowchart_writevar, name("set_left_minheight") value("4em")
	flowchart_writevar, name("set_left_innersep") value("6pt")
	flowchart_writevar, name("set_noborder_textwidth") value("18em")
	flowchart_writevar, name("set_noborder_textalign") value("centered")
	flowchart_writevar, name("set_noborder_minheight") value("1em")
	flowchart_writevar, name("set_noborder_draw") value("none")
	flowchart_writevar, name("set_noborder_fill") value("none")
	flowchart_writevar, name("set_assign_textwidth") value("18em")
	flowchart_writevar, name("set_assign_textalign") value("ragged")
	flowchart_writevar, name("set_assign_minheight") value("3em")
	flowchart_writevar, name("set_assign_innersep") value("6pt")
	flowchart_writevar, name("set_lost_textwidth") value("16em")
	flowchart_writevar, name("set_lost_textalign") value("ragged")
	flowchart_writevar, name("set_lost_minheight") value("3em")
	flowchart_writevar, name("set_lost_innersep") value("6pt")
end
capture program drop flowchart_writevar
program define flowchart_writevar
	syntax [anything] [, name(string) value(string) *]	
	local variablerow "`name' = `value'"
	file write FlowchartFile "`variablerow'" _n
	if(substr("`name'",1,4) == "set_") {
		global Flowchart_Settings = `"$Flowchart_Settings @`name'"'
		global Flowchart_Settings = `"$Flowchart_Settings "`value'""'
	}
end

capture program drop flowchart_tdfinalize
program define flowchart_tdfinalize
	syntax , input(string) output(string)
	***\\ TIKZ PICTURE: Write the TikZ Picture to the file.
	*display "`input' `output'"
	texdoc do "`input'", init("`output'") replace
	* Important Note: The '.tikz' extension here is important since if it is not specified, calling 'texdoc do' in the Main Analysis Do File will overwrite the .tex file of the same name in the same directory.
	texdoc close
end

capture program drop flowchart_tdwrite
program define flowchart_tdwrite
	syntax [anything]
	tokenize Some Words
	texdoc write "1=|`1'|, 2=|`2'|, 3=|`3'|"
*	texdoc write "`varname'"
end

flowchart init using "..\Data\Subanalysis Data\Methods--Fig-TEST.data"

flowchart write box, name("Test")
flowchart write box, name("TestBoxName") value("TestBoxValue")
flowchart write row, name("TestRow")
flowchart write row, name("TestRowName") value("TestRowValue")
flowchart write row


flowchart writerow(row_name): "lblock1_line1" 46 "This is one row, \\ of a block." "lblock1_line2" 43 "This is another row, of a block" "lblock1_line3" 3 "This is another row, of a block", ///
	"rblock1_line1" 97 "This is one row, of a block." "rblock1_line2" 33 "This is another row, of a block" "rblock1_line3" 44 "This is another row, of a block"

display `" $Flowchart_Settings "'
flowchart finalize, input("98-IQSCVDMort-PostProduction-Methods--Fig-Flowchart.texdoc") output("..\..\Manuscript\04-IQSCVDMort-Methods--Fig-TEST.tikz")
