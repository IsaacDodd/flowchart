
*! version 0.0.1  28jul2017  Isaac M. E. Dodd
* FLOWCHART ---------------------------------------------------------------------
capture program drop flowchart
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
		flowchart_tdwrite_pathfield `"      \path (`2') `arrow' (`3');"'
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
				display "COMMAND PARSING: "
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
				display "ROW CONTENT: "
				display ""
				display " First Variable: `varfirst'"
				display ""
				* display " Macro Without Quotes: " `varothers' <-- Breaks with flowchart_blank
				display ""
				display `" Compound Quotes (CQ's):  `varothers'"'
				display ""
				display `" Entire Statement (With CQ's): `0'"'
				display ""

				display "TOKENS:"
				display ""
			}
			
			local i = 1		// Token Iterator
			local blockparse = "center"						// First Block Default = Center
flowchart_tdwrite_blockfield `"      % Row - `subparam'"'	// Row Command with Subparam (This is the Rowname)

			while ("``i''" != "") {	// while: TokenWhileLoop -- Loop through all of the tokens passed after the 'writerow(subparam):' call
				if("$Flowchart_Debug" == "on") {
					display "BLOCK START ----         [blockparse: `blockparse']"
					display "`i': ``i''"	// Print Token Number that starts the block, and the contents of that Token
				}
				
				if("``i''" == "`subcmdparsed'" | trim("``i''") == "`subcmdwithparam'" | trim("``i''") == "`subcmdsyntax'") {
					local i = `i' + 1	// If the first token is the subparameter detected, ignore it and move to the next token instead.
					continue
				}
				else if(trim("``i''") == "," | ((lower(trim("``i''")) == "flowchart_blank" | lower(trim("``i''")) == "flowchart_blank,") & "`blockparse'" == "center") ) {
					* If a comma is encountered, or the block is blank/empty on the first block (default center), switch the blockparse flag to parse the left block (lblock) instead of the default center block (cblock).
					local blockparse = "left"
flowchart_tdwrite_blockfield `"      % -- Blank Center Block"'	// flowchart_blank detected at the start of a new row, the center block.
					local i = `i' + 1	// Move to the next token after the loop continues.
					continue
				}
				
				* Generate a Look-Ahead Macro: This allows conditional if statements to anticipate the end of a block. (Returns 1 triplet/line ahead of the current triplet/line being parsed.)
				local ilookahead = `i' + 3
				if("$Flowchart_Debug" == "on") {
					display `"          [blockparse: `blockparse']"'
					display `"			LA: ``ilookahead'' "'
				}
					* To Do: Fix this so that the program puts the node on the lead rather than defining this at the start.
				if("`blockparse'" == "center") {
	local blockparsetoken = `"      \node [block_`blockparse'] (`subparam'_`blockparse') {"'	
				} // fi: End of BlockParse
				else if("`blockparse'" == "left") {
	local blockparsetoken = `"      & \node [block_`blockparse'] (`subparam'_`blockparse') {"'	
				} // fi: End of BlockParse
				
				local k = 1	// Line Iterator	- The first line (k=1) is the lead line. If only 1 line for the block is present (i.e., the Look-Ahead is a ',' after the lead-line) then the lead line represents a singleton lead-line, which is the only line in the block.
				local stop = ""
				while("`stop'" == "") {	// while: LineWhileLoop - Loop through all of the lines for each block. The 'Stop' flag is raised when a comma is encountered or there is no more content passed in the command to parse.
					if("$Flowchart_Debug" == "on") {
						display " ---- NEW LINE"
					}
					if(trim("``i''") == "," | ((lower(trim("``i''")) == "flowchart_blank" | lower(trim("``i''")) == "flowchart_blank,") & "`blockparse'" == "center") ) {	// Inept - To Do
						* Here, if the first token encountered is a ',' or it's the first block parsed and the block is blank, produce no content. (If the second block, the left block, is blank, it needs to continue to produce a blank line '& \\' character.)
						if("$Flowchart_Debug" == "on") {
							display " --- "
							display " --- Blank First Row --- "
							display " --- 	Switching to parse the next block."
							display " --- "
						}
						local blockparse = "left"
						local stop = "stop"
						break
					}
					if( trim("``i''") == "flowchart_blank" & "`blockparse'" == "left") {						
						if("$Flowchart_Debug" == "on") {
							display "	FLOWCHART_BLANK [blockparse: `blockparse'] [ i#: `i'] [ token: ``i''] [ k: `k']"
						}
flowchart_tdwrite_blockfield `"      & \\ % -- Blank Left Block"'	// flowchart_blank detected at the start of a new row, the center block.
						local stop = "stop"
						continue, break
					}
					local linename = `"``i''"'	// Field 1 of the Line is expected to be the line-name, which is also the variable_name.
						if("$Flowchart_Debug" == "on") {
							display "	token: `i'"
							display "	 desc: ``i''"
						}
					local i = `i' + 1			// Move to the next field in the triplet/line.
						if("$Flowchart_Debug" == "on") {
							display "	token: `i'"
							display "	 lnum: ``i''"
						}
					local linenum = `"``i''"'	// Field 2 of the Line is expected to be the line's value-number, variable_value, the (n=#).
					flowchart_writevar, name(`"`linename'"') value(`"`linenum'"') // Store both the number and the line's name, with the line-name as 
					* the variable_name and the line's value-number as the variable_value with an equal sign as the delimiter (variable_name = variable_value) 
					* with a newline after. (Write it to the figvalue file.)
					local i = `i' + 1			// Move to the next field in the triplet/line.
						if("$Flowchart_Debug" == "on") {
							display "	token: `i'"
							display "	 desc: ``i''"
						}
					local linedesc = `"``i''"'	// Field 3 of the Line is expected to be the descriptive sentence.
					if("$Flowchart_Debug" == "on") {
						display "   Added to Block - Line `k': "
					}
					if(`k' == 1) {
						if(trim("``ilookahead''") == ",") {
							if("$Flowchart_Debug" == "on") {
								display "	--- Singleton Lead-line on Center Block (k=1, LA is Comma): tdwriteline - [content] [lead] [singleton]"
								display "      [blockparse: `blockparse'] [ i#: `i'] [ token: ``i''] [ k: `k']"
							}
							flowchart_tdwriteline, name(`"`linename'"') num(`"`linenum'"') desc(`"`linedesc'"') lead(`"`blockparsetoken'"') singleton
						}
						else if(trim("``ilookahead''") == "") {
							if("$Flowchart_Debug" == "on") {
								display "	--- Singleton Lead-line on Left Block With Blank Center Block (so k=1) and Singleton Left Block (so LA is Blank): tdwriteline - [content] [lead] [singleton] [end]"
								display "      [blockparse: `blockparse'] [ i#: `i'] [ token: ``i''] [ k: `k']"
							}
							flowchart_tdwriteline, name(`"`linename'"') num(`"`linenum'"') desc(`"`linedesc'"') lead(`"`blockparsetoken'"') singleton end
						}
						else {
							if("$Flowchart_Debug" == "on") {
								*display "	--- Singleton Lead-line on Left Block With Blank Center Block (so k=1) and Singleton Left Block (so LA is Blank): tdwriteline - [content] [lead] [singleton] [end]"
								display "      [blockparse: `blockparse'] [ i#: `i'] [ token: ``i''] [ k: `k']"
							}
							flowchart_tdwriteline, name(`"`linename'"') num(`"`linenum'"') desc(`"`linedesc'"') lead(`"`blockparsetoken'"')
						}
					}
					else if(trim("``ilookahead''") == "," | trim("``ilookahead''") == "" | lower(trim("``i''")) == "flowchart_blank" | lower(trim("``ilookahead''")) == "flowchart_blank") {
						local ilookaheadx2 = `ilookahead' + 1
							if("$Flowchart_Debug" == "on") {
								display "Look Ahead x 1: ``ilookahead''"
								display "Look Ahead x 2: ``ilookaheadx2''"
							}
						if(trim("``ilookahead''") == "") {
							if("$Flowchart_Debug" == "on") {
								display "	--- End of Row with New Row - LA is Blank: tdwriteline - [content] [newrow] [end]"
								display "      [blockparse: `blockparse'] [ i#: `i'] [ token: ``i''] [ k: `k']"
							}
							flowchart_tdwriteline, name(`"`linename'"') num(`"`linenum'"') desc(`"`linedesc'"') newrow end
						}
						else if( (trim("``ilookahead''") == "," & trim("``ilookaheadx2''") == "") | lower(trim("``ilookaheadx2''")) == "flowchart_blank" ) {
							if("$Flowchart_Debug" == "on") {
								display "...--- EndBlank Detection: Second Block is Blank... tdwriteline - [content] [newrow] [end] [endblank]"
								display "      [blockparse: `blockparse'] [ i#: `i'] [ token: ``i''] [ k: `k']"
							}
							flowchart_tdwriteline, name(`"`linename'"') num(`"`linenum'"') desc(`"`linedesc'"') newrow end endblank
							* The second block, the left block, is blank: Stop the LineWhileLoop to stop parsing the flowchart_blank token and any tokens after it.
							if(lower(trim("``ilookaheadx2''")) == "flowchart_blank") {
								if("$Flowchart_Debug" == "on") {
									display "BREAK"
								}
								local stop = "stop"
								local i = `i' + 1
								continue, break 
							}
						}
						else {
							if("$Flowchart_Debug" == "on") {
								display "...--- End of Row: tdwriteline - [content] [end]""
								display "      [blockparse: `blockparse'] [ i#: `i'] [ token: ``i''] [ k: `k']"
							}
							flowchart_tdwriteline, name(`"`linename'"') num(`"`linenum'"') desc(`"`linedesc'"') end
						}
					}
					else {
							if("$Flowchart_Debug" == "on") {
								display "...--- Same Row, End of Line: tdwriteline - [content] "
								display "      [blockparse: `blockparse'] [ i#: `i'] [ token: ``i''] [ k: `k']"
							}
						flowchart_tdwriteline, name(`"`linename'"') num(`"`linenum'"') desc(`"`linedesc'"') 
					}
					if("$Flowchart_Debug" == "on") {
						display " ---- END OF LINE"
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
						
				} // elihw: End of LineWhileLoop
	
if("$Flowchart_Debug" == "tikz") {
	flowchart_tdwrite_blockfield `"      %  +- Debug - End block for row: `subparam'"'	// End of the Row
}
				local i = `i' + 1
			} // elihw: End of TokenWhile
		} // fi: End of Writerow
	} // fi: End of SyntaxCmdElse
end
capture program drop flowchart_debug
program define flowchart_debug 
	syntax [anything] [, on off tikz logreset]
	if("`on'" == "on") {
		global Flowchart_Debug = "on"
		
		set more off
		set linesize 255
		local logid = subinstr("`c(current_date)'_`c(current_time)'", ":", "", .)
		local logid = subinstr("`logid'", " ", "", .)
		display "|||||| DebugLog Started: Log ID = `logid'"
		capture log query DebugLog
		* If a log has already been started, DebugLog will exist. If it is off (i.e., it was started but has been closed/turned off), 
		* 	append to the existing log. If DebugLog does not exist (r(status) is blank) or it exists but is on already, replace the log.
		if("`r(status)'" == "off") {	
			capture log close DebugLog
			log using "DebugLog.log", name(DebugLog) append text
		}
		else {
			capture log close DebugLog
			log using "DebugLog.log", name(DebugLog) replace text
		}
	}
	else if("`off'" == "off") {
		global Flowchart_Debug = "off"
		display "|||||| DebugLog Off"
		display ""
		display ""
		capture log off DebugLog
	}
	else if("`tikz'" == "tikz") {
		global Flowchart_Debug = "tikz"
		display "|||||| DebugLog Mode: Tikz"
		display ""
		display ""
	}
	else {
		global Flowchart_Debug = "off"
		capture log close DebugLog
	}
	
	if("`logreset'" != "") {
		capture log close DebugLog
		display "...DebugLog reset."
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
	.blockfields.list[$Flowchart_IteratorBlockfields] = `"`1'"'
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
			if("`end'" != "") {
				local linestring = `"`lead' `desc' (n=\figvalue{`name'})}; \\"'	// Usually, a left-block that has only 1 line (a singleton) when the center-block was blank.
			}
			else {
				local linestring = `"`lead' `desc' (n=\figvalue{`name'})}; "'
			}
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
					local suffix = "}; \\" // Add Row-Skip: + "      & \\"
					local addrowskip = "true"
				}
				else {
					local suffix = "}; \\"
				}
			}
			else {
				local suffix = "};"		// No New Row (i.e., it is the first block/center block, so don't print \\ at the end).
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
if("$Flowchart_Debug" == "on") {
	display `"Blockfield Linestring: `linestring'"'
}
global Flowchart_IteratorBlockfields = $Flowchart_IteratorBlockfields + 1
.blockfields.list[$Flowchart_IteratorBlockfields] = `"`linestring'"'

if("`addrowskip'" == "true") {
	global Flowchart_IteratorBlockfields = $Flowchart_IteratorBlockfields + 1
	.blockfields.list[$Flowchart_IteratorBlockfields] = `"      & \\"'
	macro drop addrowskip
	if("$Flowchart_Debug" == "on") {
		display `"Blockfield Linestring:       & \\"'
	}
}
*flowchart_tdwrite_blockfield `"`linestring'"'
*	texdoc write "`varname'"
end



* ---------------------------------------------------------------------

* DISPOSITION SUBANALYSIS: Analyze and setup the subject disposition.


* DIAGRAM: Call Post-Production texdoc file to write this analysis as a diagram.

flowchart init using "..\Data\Subanalysis Data\Methods--Fig-TEST.data"

*flowchart write box, name("Test")
*flowchart write box, name("TestBoxName") value("TestBoxValue")
*flowchart write row, name("TestRow")
*flowchart write row, name("TestRowName") value("TestRowValue")
*flowchart write row

*display `" $Flowchart_Settings "'

/*
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

flowchart writerow(random): "randomized" 102 "Randomized", flowchart_blank // Blank Row

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
	"intervention_analyzed" 51 "Analyzed", ///
	"postwaitlist_analyzed" 51 "Analyzed"
*/



* DEBUGGING
* |||||| TEST1: Dummy Row
flowchart writerow(rownametest1): "lblock1_line1" 46 "This is one line, \\ of a block." ///
	"lblock1_line2" 43 "This is another line, of a block" ///
	"lblock1_line3" 3 "This is another line, of a block", ///
	"rblock1_line1" 97 "This is one line, of a block." ///
	"rblock1_line2" 33 "This is another line, of a block" ///
	"rblock1_line3" 44 "This is another line, of a block"

* |||||| TEST2: Row with No left-block
flowchart writerow(rownametest2): flowchart_blank, ///
	"rblock1_line1" 97 "This is one line, of a block." ///
	"rblock1_line2" 33 "This is another line, of a block" ///
	"rblock1_line3" 44 "This is another line, of a block"

* |||||| TEST3: Row with No right-block
flowchart writerow(rownametest3): "lblock1_line1" 46 "This is one line, \\ of a block." ///
	"lblock1_line2" 43 "This is another line, of a block" ///
	"lblock1_line3" 3 "This is another line, of a block", flowchart_blank

flowchart_debug, on
* |||||| TEST4: Row with No left-block and a Singleton Lead-Line in the right-block
flowchart writerow(rownametest4): flowchart_blank, "rblock1_line1" 97 "This is one line, \\ of a block."
	* To do: Print '\\' at the end of this singleton's line.
	
* |||||| TEST5: Row with Singleton Lead-Line in the left-block and No right-block
flowchart writerow(rownametest5): "lblock1_line1" 46 "This is one line, \\ of a block.", flowchart_blank
	* To do: Print '& \\' at the end of this singleton's line.

flowchart_debug, off

flowchart connect rownametest1_center rownametest1_left
flowchart connect rownametest1_left rownametest2_left
flowchart connect rownametest1_center rownametest3_center
flowchart connect rownametest3_center rownametest5_center
flowchart connect rownametest2_left rownametest4_left

/*
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
*/

flowchart finalize, input("98-IQSCVDMort-PostProduction-Methods--Fig-Flowchart.texdoc") output("..\..\Manuscript\04-IQSCVDMort-Methods--Fig-TEST.tikz")
