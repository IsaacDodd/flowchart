
* DISPOSITION SUBANALYSIS: Analyze and setup the subject disposition.


* DIAGRAM: Call Post-Production texdoc file to write this analysis as a diagram.

capture program drop flowchart
*! version 0.0.1  28jul2017  Isaac M. E. Dodd
program define flowchart
	version 13
	syntax [anything] [using/] [, name(string) value(string) input(string) output(string) arrow(string) *]
	
	if("`1'" == "init" | "`1'" == "init,") {
		global Flowchart_Settings = ""	// Stores settings in a space-delimited string.
		global Flowchart_IteratorBlockfields = 0
		global Flowchart_IteratorPathfields = 0
		.Global.blockfields=.object.new
		.Global.pathfields=.object.new
		.Global.blockfields.Declare array list
		.Global.pathfields.Declare array list
		
		capture file close FlowchartFile
		file open FlowchartFile using "`using'", write text replace
		flowchart_init
	}
	else if("`1'" == "close" | "`1'" == "finalize" | "`1'" == "close," | "`1'" == "finalize," ) {
		if("$Flowchart_Debug" == "on") {
			display "Closed."
		}
		capture file close FlowchartFile 
		flowchart_tdfinalize, input("`input'") output("`output'")
	}
	else if("`1'" == "write") {
		if("`2'" == "box" | "`2'" == "box,") {
			if("$Flowchart_Debug" == "on") {
				display "Write: `2' `name' `value'"
			}
			flowchart_writevar, name("Test") value("Testing testing 1 2 3 5 6 7 8 9 10 ...")
		}
		else if("`2'" == "row" | "`2'" == "row,") {
			if("$Flowchart_Debug" == "on") {
				display "Write: `2' `name' `value'"
			}
		}
	}
	else if("`1'" == "connect") {
		if("$Flowchart_Debug" == "on") {
			display "Connect: `1' `2' `3'"
		}
		if("`arrow'" != "") {
			if("`arrow'" == "angled" | "`arrow'" == "angle") {
				local arrow = "-|"
				if("$Flowchart_Debug" == "on") {
					display "`3'"
				}
				if(strpos(trim("`3'"), ",") > 0) {					
					local 3 = substr(trim("`3'"), 1, strpos(trim("`3'"), ",")-1)
					if("$Flowchart_Debug" == "on") {
						display "`3'"
					}
				}					
			}
		}
		else {
			local arrow = "--"
		}
		flowchart_tdwrite_pathfield `"      \path (`2')   `arrow' (`3');"'
	}
	else {
		*Sub-Commands that Require More Advanced Parsing
		* Parse the token for a possible sub-command that contains a parameter (e.g., flowchart subcommand(parameter): ... )
		* 	This is necessary since Stata's 'syntax' command returns the subcommand token `1' with a colon. This method ensures the proper string is parsed.
		gettoken subcommand 0 : 0, parse(" :") quotes
		while `"`subcommand'"' != ":" & `"`subcommand'"' != "" {
			local subcmdwithparam `"`subcmdwithparam' `subcommand'"'
			
			gettoken subcommand 0 : 0, parse(" :") quotes
			if("$Flowchart_Debug" == "on") {
				display ""
				display `"Subcommand via GetToken: `subcommand'"'
			}
			local subcmdsyntax = "`1'"
			if("$Flowchart_Debug" == "on") {
				display "Subcommand via Syntax: `subcmdsyntax'"
				display `"Subcommand with Parameter: `subcmdwithparam'"'
				display `"Compound Quotes (CQ's):  `0'"'
			}
		}
		* Parse the possible sub-command with parameter, accounting for any whitespace within the passed parameter and subcommand.
		local subparam = trim(substr(trim("`subcmdwithparam'"), strpos(trim("`subcmdwithparam'"), "(")+1, length(trim("`subcmdwithparam'"))-strpos(trim("`subcmdwithparam'"), "(")-1))
		local subcmdparsed = substr(trim("`subcmdwithparam'"), 1, strpos(trim("`subcmdwithparam'"), "(")-1)
		if("$Flowchart_Debug" == "on") {
			display `"Subparameter via String Parse (CQs):  `subparam'"'
			display `"Subcommand via String Parse (CQs):  `subcmdparsed'"'
		}
			
		if("`1'" == "writerow:" | "`1'" == "writerow" | "`subcmdparsed'" == "writerow" | trim("`subcmdparsed'") == "writerow") {
	
			gettoken varfirst varothers : 0
			if("$Flowchart_Debug" == "on") {
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
			}
			
			local i = 1		// Token Iterator
			local blockparse = "center"
flowchart_tdwrite_blockfield `"      % Row - `subparam'"'

			while "``i''" != "" {
				if("$Flowchart_Debug" == "on") {
					display "`i': ``i''"
				}
				
				if("``i''" == "`subcmdparsed'" | trim("``i''") == "`subcmdwithparam'" | trim("``i''") == "`subcmdsyntax'") {
					local i = `i' + 1
					continue
				}
				else if(trim("``i''") == ",") {
					* If a comma is encountered, switch the blockparse flag to parse the left block (lblock) instead of the center block (cblock).
					local blockparse = "left"
					local i = `i' + 1
					continue
				}
				
				* Generate a Look-Ahead Macro: This allows the conditional if statements determine the end of a block.
				local ilookahead = `i' + 3
				if("$Flowchart_Debug" == "on") {
					display `"			LA: ``ilookahead'' "'
				}
					* To Do: Fix this so that the program puts the node on the lead rather than defining this at the start.
				if("`blockparse'" == "center") {
	local blockparsetoken = `"      \node [block_`blockparse'] (`subparam'_`blockparse') {"'	
				} // fi: End of BlockParse
				else if("`blockparse'" == "left") {
	local blockparsetoken = `"      & \node [block_`blockparse'] (`subparam'_`blockparse') {"'	
				} // fi: End of BlockParse
				
				local k = 1	// Line Iterator
				local stop = ""
				while("`stop'" == "") {	// while: LineWhile
					if(trim("``i''") == ",") {	// Inept - To Do
						local blockparse = "left"
						local stop = "stop"
						break
					}
					local linename = `"``i''"'
					local i = `i' + 1
					if("$Flowchart_Debug" == "on") {
						display "	iter: `i'"
						display "	lnum: ``i''"
					}
					local linenum = `"``i''"'
					flowchart_writevar, name(`"`linename'"') value(`"`linenum'"') // Store the number as the named line's number value.
					local i = `i' + 1
					if("$Flowchart_Debug" == "on") {
						display "	iter: `i'"
						display "	desc: ``i''"
					}
					local linedesc = `"``i''"'
					if("$Flowchart_Debug" == "on") {
						display "   Added to Block - Line `k': "
					}
					if(`k' == 1) {
						if(trim("``ilookahead''") == ",") {
							flowchart_tdwriteline, name(`"`linename'"') num(`"`linenum'"') desc(`"`linedesc'"') lead(`"`blockparsetoken'"') singleton
						}
						else {
							flowchart_tdwriteline, name(`"`linename'"') num(`"`linenum'"') desc(`"`linedesc'"') lead(`"`blockparsetoken'"')
						}
					}
					else if(trim("``ilookahead''") == "," | trim("``ilookahead''") == "" ) {
						local ilookaheadx2 = `ilookahead' + 1
							if("$Flowchart_Debug" == "on") {
								display "Look Ahead x 1: ``ilookahead''"
								display "Look Ahead x 2: ``ilookaheadx2''"
							}
						if(trim("``ilookahead''") == "") {
							flowchart_tdwriteline, name(`"`linename'"') num(`"`linenum'"') desc(`"`linedesc'"') newrow end
						}
						else if(trim("``ilookahead''") == "," & trim("``ilookaheadx2''") == "") {
							if("$Flowchart_Debug" == "on") {
								display "...EndBlank..."
							}
							flowchart_tdwriteline, name(`"`linename'"') num(`"`linenum'"') desc(`"`linedesc'"') newrow end endblank
						}
						else {
							flowchart_tdwriteline, name(`"`linename'"') num(`"`linenum'"') desc(`"`linedesc'"') end
						}
					}
					else {
						flowchart_tdwriteline, name(`"`linename'"') num(`"`linenum'"') desc(`"`linedesc'"') 
					}
					if("$Flowchart_Debug" == "on") {
						display " ---- "
						display ""
					}
					local k = `k' + 1
					local i = `i' + 1
					local ilookahead = `ilookahead' + 3
					if("$Flowchart_Debug" == "on") {
						display `"			LA: ``ilookahead'' "'
					}
					if(trim("``i''") == "," | "``i''" == "") {
						local blockparse = "left"
						local stop = "stop"
					}
						
				} // elihw: End of LineWhile
	
if("$Flowchart_Debug" == "on") {
	flowchart_tdwrite_blockfield `"      % 	end block for row: `subparam'"'	// End of the Row
}
				local i = `i' + 1
			} // elihw: End of TokenWhile
		} // fi: End of Writerow
	} // fi: End of SyntaxCmdElse
end
capture program drop flowchart_debug
program define flowchart_debug 
	syntax [anything] [, on off]
	if("`on'" == "on") {
		global Flowchart_Debug = "on"
	}
	else if("`off'" == "off") {
		global Flowchart_Debug = "off"
	}
	else {
		global Flowchart_Debug = "off"
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
	if("$Flowchart_Debug" == "on") {
		display "`input' `output'"
	}
	texdoc do "`input'", init("`output'") replace
	* Important Note: The '.tikz' extension here is important since if it is not specified, calling 'texdoc do' in the Main Analysis Do File will overwrite the .tex file of the same name in the same directory.
	texdoc close
end


capture program drop flowchart_tdwrite_blockfield
program define flowchart_tdwrite_blockfield
	syntax [anything] [, indent]
	global Flowchart_IteratorBlockfields = $Flowchart_IteratorBlockfields + 1
	.blockfields.list[$Flowchart_IteratorBlockfields] = `"`linestring'"'
	if("$Flowchart_Debug" == "on") {
		display  "1=|`1'|, 2=|`2'|, 3=|`3'| indent=|`indent'|"
	}
*	texdoc write "`varname'"
end

capture program drop flowchart_tdwrite_pathfield
program define flowchart_tdwrite_pathfield
	syntax [anything] [, indent]
	global Flowchart_IteratorPathfields = $Flowchart_IteratorPathfields + 1
	.pathfields.list[$Flowchart_IteratorPathfields] = `"`1'"'
	if("$Flowchart_Debug" == "on") {
		display  "1=|`1'|, 2=|`2'|, 3=|`3'| indent=|`indent'|"
	}
*	texdoc write "`varname'"
end
capture program drop flowchart_tdwriteline
program define flowchart_tdwriteline
	syntax [anything] [, indent lead(string) singleton end endblank newrow name(string) num(string) desc(string)]
	if("`lead'" != "") {
		if("`singleton'" != "") {
			local linestring = `"`lead' `desc' (n=\figvalue{`name'})}; "'
		}
		else {
			local linestring = `"`lead' `desc' (n=\figvalue{`name'}): \\"'
		}
	}
	else {
		* Determine ending first (suffix)
		if("`end'" != "") {
			if("`newrow'" != "") {
				if("`endblank'" != "") {
					local suffix = "}; \\" + "      & \\"
				}
				else {
					local suffix = "}; \\"
				}
			}
			else {
				local suffix = "};"
			}
		}
		else {
			local suffix = "\\"
		}

		if("`indent'" != "") {
			local linestring = `"        \h\h \figvalue{`name'} `desc' `suffix'"'
		}
		else {
			local linestring = `"        \h `desc' (n=\figvalue{`name'}) `suffix'"'
		}
	}
global Flowchart_IteratorBlockfields = $Flowchart_IteratorBlockfields + 1
.blockfields.list[$Flowchart_IteratorBlockfields] = `"`linestring'"'
*flowchart_tdwrite_blockfield `"`linestring'"'
*	texdoc write "`varname'"
end

* ---------------------------------------------------------------------

flowchart init using "..\Data\Subanalysis Data\Methods--Fig-TEST.data"

*flowchart write box, name("Test")
*flowchart write box, name("TestBoxName") value("TestBoxValue")
*flowchart write row, name("TestRow")
*flowchart write row, name("TestRowName") value("TestRowValue")
*flowchart write row

*display `" $Flowchart_Settings "'

flowchart_debug, off

flowchart writerow(enrollment): ///
	"referred" 173 "Referred", ///
	"referred_excluded" 17 "Excluded" ///
	"referred_excluded_nopartic" 9 "a) Did not wish to participate" ///
	"referred_excluded_noshow" 5 "b) Did not show for interview" ///
	"referred_excluded_other" 3 "c) Other reasons"
	
flowchart writerow(assessment): ///
	"assessed" 156 "{Assessed for Eligibility", ///
	"assessed_excluded" 54 "Excluded" ///
	"assessed_excluded_inclusioncritunmet" 22 "a) Inclusion criteria not met" ///
	"assessed_excluded_exclusioncritmet" 13 "b) Exclusion criteria met" ///
	"assessed_excluded_unsuitedgroup" 7 "c) Not suited for waitlist group" ///
	"assessed_excluded_unsuitedtx" 2 "d) Not suited for intervention" ///
	"assessed_excluded_othertx" 3 "e) Sought other treatment" ///
	"assessed_excluded_other" 7 "f) Other reasons"
	
flowchart_debug, on
display "Start Isaac"
flowchart writerow(random): "randomized" 102 "Randomized", 
	// Blank Row

flowchart writerow(allocgroup): ///
	"alloc_interventiongroup" 51 "{Allocated to Intervention group", ///
	"alloc_waitlistgroup" 51 "Allocated to Wait-list control group"
flowchart_debug, off	
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
	
flowchart writerow(wlistintervention): , ///	
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

flowchart writerow(wlist3mon): , ///
	"postwaitlist_3monthfollowup" 2 "3-months follow-up measurement \\ \h Did not complete measurement"
	
flowchart writerow(analyzed): ///
	"intervention_analyzed" 51 "Analyzed", ///
	"postwaitlist_analyzed" 51 "Analyzed"


* Dummy Row
*flowchart writerow(rowname): "lblock1_line1" 46 "This is one line, \\ of a block." "lblock1_line2" 43 "This is another line, of a block" "lblock1_line3" 3 "This is another line, of a block", ///
*	"rblock1_line1" 97 "This is one line, of a block." "rblock1_line2" 33 "This is another line, of a block" "rblock1_line3" 44 "This is another line, of a block"

* Row with No left-block
*flowchart writerow(rowname): , "rblock1_line1" 97 "This is one line, of a block." "rblock1_line2" 33 "This is another line, of a block" "rblock1_line3" 44 "This is another line, of a block"

* Row with No right-block
*flowchart writerow(rowname): "lblock1_line1" 46 "This is one line, \\ of a block." "lblock1_line2" 43 "This is another line, of a block" "lblock1_line3" 3 "This is another line, of a block", 

* Format: [rowname_center] --> [rowname_left] - Connect a center block to a left block for horizontal arrows across rows.
	* [rowname_center] --> [rowname_center] - Connect a center block to a center block for vertical across within the same column for blocks in the center.
	* [rowname_left] --> [rowname_left] - Connect a left block to a left block for vertical across within the same column for blocks on the left.
	* , angled - This option makes the arrow make a 90 degree angle. Use this across a blank row.
* Column Orientation: 
* The sides of the diagram are initially counter-intuitive. Think of it like reading a chest x-ray: when interpreting the x-ray the patient's left is on the right of the page and the patient's right is on the left of the page -- the orientation being
* 	relative to a patient facing out of the plane of the x-ray. Likewise, the column that is immediately to the left of the page as the center column and the column that is immediately to the right of the page is the left column.
*	Connect each row's block with an underscore and then the column-orientation corresponding to its side in this manner.
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

flowchart finalize, input("98-IQSCVDMort-PostProduction-Methods--Fig-Flowchart.texdoc") output("..\..\Manuscript\04-IQSCVDMort-Methods--Fig-TEST.tikz")
