*! version 0.0.7  26aug2017  Isaac M. E. Dodd

*##############################################################################*
********************************************************************************
*** FLOWCHART - SUBJECT DISPOSITION FLOW DIAGRAM FIGURE GENERATOR           ****
********************************************************************************
*##############################################################################*

* FLOWCHART --------------------------------------------------------------------
capture program drop flowchart
program define flowchart
	version 13
	syntax [anything] [using/] [, name(string) value(string) template(string) output(string) arrow(string) *]
	
	if("`1'" == "" | "`1'" == "getstarted" | "`1'" == "firsttime" | ("`1'" == "get" & "`2'" == "started")) {
		display ""
		flowchart_hline
		flowchart_header
		flowchart_title
		flowchart_subtitle "Getting Started"
		display ""
		if("`1'" == "" | "`1'" == "firsttime") {
			display "  Setup: If this is your first time running the flowchart package, type: " //_newline
			display "		. {stata flowchart setup:flowchart setup}" _newline
			display `"	  Start with the example flow diagram in "flowchart_example1.do" "'
			display ""
		}
		display `"  To start a new flowchart, here is a general starting point: "'
		display `"	  Start with the command '. flowchart init using <filename>.data'"'
		display `"	  (<filename>.data is an automatically generated/regenerated variable file.)"'
		display `"	  Study the documentation and examples on how to properly format 'writerow' commands."'
		display `"	  Use the 'connect' command to draw arrows between the blocks in each row."'
		display `"	  End a diagram with the 'flowchart finalize' command with 2 important options:"'
		display `"	  - template("...") is the .texdoc file, is an ancillary file which you don't need to edit."'
		display `"	  - output("...") is the .tikz file which is automatically generated/regenerated."'
		display ""
		if("`1'" == "" | "`1'" == "firsttime") {
			display `"	  If you do not have a LaTeX distribution installed you can get started using an online editor:"'
			display `"	  	{browse "https://www.sharelatex.com/"}"'
			display `"	  	{browse "https://www.overleaf.com/"}"'
			display `"	  See the notes in "flowchart_example1.do" on how to eventually get started with a full LaTeX setup."'
			display ""
		}
		flowchart_subtitle "Other Options"
		display "	1. Updates: To update flowchart, type: " //_newline
		display "		. {stata flowchart setup, update:flowchart setup, update}" _newline
		display "	2. Help: For extensive documentation, type: " //_newline
		display "		. {help flowchart:help flowchart}" _newline
		display "	3. Support: For the URL to submit a support ticket, type: " //_newline
		display "		. {stata flowchart setup, support:flowchart setup, support}" _newline
		display "	4. Uninstall: To uninstall flowchart, type: " //_newline
		display "		. {stata flowchart setup, uninstall:flowchart setup, uninstall}"
		display ""
		flowchart_subtitle "Website"
		display "	The flowchart package's website is available at:"
		display `"	  	{browse "https://github.com/IsaacDodd/flowchart/"}"'
		display ""
		flowchart_subtitle "License"
		display "	GNU LGPL 2007 - By installing this program you agree to this license, available in full here:" //_newline
		display `"	 	{browse "https://github.com/IsaacDodd/flowchart/blob/master/LICENSE.txt"}"'
		display ""
		display "Read this message again at anytime by typing '{stata flowchart getstarted:flowchart getstarted}'"
		display ""
		flowchart_footer
		flowchart_hline
	}
	else if("`1'" == "status" | "`1'" == "status,") {
		display ""
		flowchart_header
		flowchart_title
		flowchart_footer
	}
	else if("`1'" == "help" | "`1'" == "help,") {
		help flowchart
	}
	else if("`1'" == "init" | "`1'" == "init,") {
		global Flowchart_Settings = ""	// Stores settings in a space-delimited string.
		global Flowchart_IteratorBlockfields = 0
		global Flowchart_IteratorPathfields = 0
		.Global.blockfields=.object.new
		.Global.pathfields=.object.new
		.Global.blockfields.Declare array list
		.Global.pathfields.Declare array list
		
		capture file close FlowchartFile
		if("$Flowchart_Debug" == "on") {
			display _rc
		}
		file open FlowchartFile using "`using'", write text replace
		if("$Flowchart_Debug" == "on") {
			display _rc
		}
		flowchart_init
		display ""
		display "...flowchart initialized."
	}
	else if("`1'" == "close" | "`1'" == "finalize" | "`1'" == "close," | "`1'" == "finalize," ) {
		if("$Flowchart_Debug" == "on") {
			display "Closed."
		}
		capture file close FlowchartFile 
		flowchart_tdfinalize, template("`template'") output("`output'")
	}
	else if("`1'" == "setup" | "`1'" == "setup,") {
		gettoken varfirst varothers : 0
		if("$Flowchart_Debug" == "on") {
			display " First Variable: `varfirst'"
			display `" Other Variables:  `varothers'"'
		}
		flowchart_setup, `varothers'	// Setup Function
	}
	else if("`1'" == "debug" | "`1'" == "debug,") {
		gettoken varfirst varothers : 0
		if("$Flowchart_Debug" == "on") {
			display " First Variable: `varfirst'"
			display `" Other Variables:  `varothers'"'
		}
		flowchart_debug, `varothers'	// Debug Function
	}
	else if("`1'" == "set") {
		if("`2'" == "layout" | "`2'" == "layout,") {
			if("$Flowchart_Debug" == "on") {
				display "Write: `2' `name' `value'"
				* To Do: Not yet implemented, other options: Move the variable writing to finalize so that if the 
				* 	user overrides default values they are committed afterwards. Use cond() to iterate through each 
				* 	variable to determine if the user has specified a new layout variable to override the default.
			}
			flowchart_writevar, name(`"set_`name'"') value(`"`value'"')
		}
		else if("`2'" == "variable" | "`2'" == "variable,") {
			if("$Flowchart_Debug" == "on") {
				display "Write: `2' `name' `value'"
			}
			flowchart_writevar, name(`"`name'"') value(`"`value'"')
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
				* display ""
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
					display `"			LA: |``ilookahead''|"'
				}
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
						display "   Added to Block-Line [`k']: "
					}
					if(`k' == 1) {
						if(trim("``ilookahead''") == ",") {
							local ilookaheadx2 = `ilookahead' + 1
							if("$Flowchart_Debug" == "on") {
								display "      [blockparse: `blockparse'] [ i#: `i'] [ token: ``i''] [ k: `k']"
								display "Lead-Line LA"
								display "Look Ahead x 1: |``ilookahead''|"
								display "Look Ahead x 2: |``ilookaheadx2''|"
							}
							if(lower(trim("``ilookaheadx2''")) == "flowchart_blank") {
								if("$Flowchart_Debug" == "on") {
									display "...--- EndBlank Detection on Singleton:"
									display "	--- Singleton Lead-line on Center Block but BLANK Left Block (k=1, LA is Comma, LA is flowchart_blank): tdwriteline - [content] [lead] [singleton] [end] [endblank]"
								}
								flowchart_tdwriteline, name(`"`linename'"') num(`"`linenum'"') desc(`"`linedesc'"') lead(`"`blockparsetoken'"') singleton end endblank
								if("$Flowchart_Debug" == "on") {
									display "BREAK SINGLETON"
								}
								local blockparse = "left"
								local i = `i' + 2	// Move by 2 tokens to move past the flowchart_blank
								local stop = "stop"
								continue, break 
							}
							else {
								if("$Flowchart_Debug" == "on") {
									display "	--- Singleton Lead-line on Center Block (k=1, LA is Comma): tdwriteline - [content] [lead] [singleton]"
								}
								flowchart_tdwriteline, name(`"`linename'"') num(`"`linenum'"') desc(`"`linedesc'"') lead(`"`blockparsetoken'"') singleton
							}
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
								display "Non-Lead-Line LA"
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
								local i = `i' + 1
								local stop = "stop"
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
capture program drop flowchart_setup
program define flowchart_setup
	syntax [anything] [, update support uninstall]
	display ""
	display "|||||| Setup"
	display ""
	if("`uninstall'" != "") {
		display "Uninstalling 'flowchart' package installation..."
		display ""
		capture ado uninstall flowchart
		if (_rc) {
			display as error "Uninstall Error: Previous version of 'flowchart' could not be uninstalled."
			exit 111
		}
		else {
			display "...Package 'flowchart' uninstalled successfully."
			display ""
			display "Note: If you uninstalled the package due to an error, please notify the developers"
			display "	   of this error so that it can be fixed for all users by submitting an issue"
			display "	   at the following URL:"
			display ""
			display `"{browse "https://github.com/IsaacDodd/flowchart/issues/new/"}"'
		}
	}
	else if("`support'" != "") {
		display ""
		display "Open a new support ticket using the following URL: " _newline
		display `"{browse "https://github.com/IsaacDodd/flowchart/issues/new/"}"'
		display ""
	}
	else if("`update'" != "") {
		display "Updating 'flowchart' package installation..."
		display ""
		capture ado uninstall flowchart
		if (_rc) {
			display as error "Update Error: Previous version of 'flowchart' could not be uninstalled."
			exit 111
		}
		capture net install flowchart, replace from("https://raw.github.com/IsaacDodd/flowchart/master/")
		if (_rc) {
			display "Update Error: Update could not be completed."
			display "Instructions:"
			display "  1. Uninstall 'flowchart' by running:"
			display "       . {stata ado uninstall flowchart:ado uninstall flowchart}"
			display "  2. Install 'flowchart' from GitHub directly by running:"
			display `"       . net install flowchart, replace from("https://raw.github.com/IsaacDodd/flowchart/master/")"'
			display "  If Instruction #2 does not work, check your internet connection." 
			display ""
			capture ssc install flowchart, replace // Attempt to reinstall flwochart from SSC.
			if(_rc) {
				display as error "Update Error: Attempt to reinstall flowchart failed. Please reinstall flowchart."
				exit 499
			}
		}
		else {
			display "...Update to flowchart installed successfully."
			display ""
		}
	}
	else {
		* SETUP (Default)
		* Update Flowchart from GitHub.
		display " (1/3) Updating 'flowchart' installation ..."
		display ""
		capture ado uninstall flowchart // Same effect as ssc or net uninstall flowchart.
		if (_rc) {
			display as error "Setup Error: Update of 'flowchart' could not be completed. Attempt to update a previous version of flowchart has failed."
			// exit 111 <-- This is the normal exit code. Rather than exist here, try to continue to see if the flowchart installation can be replaced.
		}		
		capture net install flowchart, replace from("https://raw.github.com/IsaacDodd/flowchart/master/")
		if (_rc) {
			capture ssc install flowchart	// Attempt to reinstall flowchart from SSC again since it was previously uninstalled.
			display as error "Setup Error: Update of 'flowchart' could not be completed. Please check your internet connection and try again, or you may need to reinstall flowchart."
			exit 499
		}
		else {
			display "...Update to flowchart installed successfully."
			display "Note: Updates to Flowchart will take effect when Stata is restarted."
			display ""
		}
		* Install an updated version of texdoc
		display " (2/3) Installing/Updating 'texdoc'..."
		display ""
		* Install texdoc
		display "	...Installing/Updating Texdoc..."
		capture ssc install texdoc, replace
		if (_rc) {
			display as error "Setup Error: Installation of dependency 'texdoc' could not be completed. Please check your internet connection and try again."
			exit 499
		}
		* Install sjlatex
		display "	...Installing/Updating sjlatex..."
		capture net install sjlatex, from("http://www.stata-journal.com/production")
		if (_rc) {
			display as error "Setup Error: Installation of dependency 'sjlatex' for dependency 'texdoc' could not be completed. Please check your internet connection and try again."
			exit 499
		}
		else {
			display "...Texdoc installed/updated successfully."
			display ""
		}
		display " (3/3) Installing Ancillary Files for 'flowchart'..."
		display ""
		capture net get flowchart, from("https://raw.github.com/IsaacDodd/flowchart/master/")
		if (_rc) {
			display as error "Setup Error: Setup could not install Ancillary Files. Please connect to the internet and try again." _newline ///
							 "	(1) Check your current working directory to see if these ancillary files already exist." _newline ///
							 "		If so, there is no need to re-run setup. Safely ignore this error message." _newline ///
							 "	(2) Try running the following command:" _newline ///
							 `"		. net get flowchart, from("https://raw.github.com/isaacdodd/flowchart/master/")"' _newline ///
							 "	(3) You may also download these ancillary files directly from the latest release at the following URL:" _newline ///
							 `"		{browse "https://github.com/IsaacDodd/flowchart/releases"} "'
			exit 499
		}
		else {
			display ""
			display "...Ancillary files installed successfully in current working directory:"
			pwd
			display ""
		}
		display "|||||| Setup Complete"
		display ""
		flowchart_hline
		display ""
		if(_rc == 0) {
			sleep 2000
			flowchart firsttime	// Print the get started message. Include the 'first time' part of the message
		}
	}
end
capture program drop flowchart_debug
program define flowchart_debug 
	syntax [anything] [, on off tikz logreset check info deletefiles yes]
	
	if("`on'" == "on") {
		global Flowchart_Debug = "on"
		
		set more off
		set linesize 161
		local logid = subinstr("`c(current_date)'_`c(current_time)'", ":", "", .)
		local logid = subinstr("`logid'", " ", "", .)
		capture log query DebugLog
		* If a log has already been started, DebugLog will exist. If it is off (i.e., it was started but has been closed/turned off), 
		* 	append to the existing log. If DebugLog does not exist (r(status) is blank) or it exists but is on already, replace the log.
		flowchart_subtitle "DEBUG MODE: ON"
		display ""
		display "  Starting Debug Log..."
		display ""
		if("`r(status)'" == "off") {	
			capture log close DebugLog
			log using "DebugLog.log", name(DebugLog) append text
			local debugtitle = "STARTED"
		}
		else {
			capture log close DebugLog
			log using "DebugLog.log", name(DebugLog) replace text
			local debugtitle = "RESUMED"
		}
		capture log close DebugLog
		log using "DebugLog.log", name(DebugLog) append text
		display ""
		flowchart_header "DEBUG LOG `debugtitle': Log ID = `logid'"
		display ""
		display ""
	}
	else if("`off'" == "off") {
		global Flowchart_Debug = "off"
		capture log off DebugLog
		if(_rc) {
			display as error "Could not turn off DebugLog."
		}
		else {
			display "...DebugLog Off."
		}
		display ""
		flowchart_footer "DEBUG MODE: OFF"
		display ""
		display ""
	}
	else if("`tikz'" == "tikz") {
		global Flowchart_Debug = "tikz"
		display ""
		flowchart_header "DEBUG MODE: TikZ"
		display ""
		display ""
	}
	else if("`check'" == "check") {
		flowchart_hline
		flowchart_header "DEBUG CHECK"
		flowchart_debugcheck
		flowchart_footer
		flowchart_hline
	}
	else if("`logreset'" == "logreset") {
		capture log close DebugLog
		if(_rc) {
			display as error "DebugLog could not be closed."
			display _rc
		}
		else {
			display "...DebugLog Closed."
			display ""
			flowchart_footer "DEBUG LOG RESET" // Close just the log without turning off $Flowchart_Debug
		}
	}
	else if("`close'" == "close") {
		global Flowchart_Debug = "off"
		capture log close DebugLog	// Close the log and also turn off $Flowchart_Debug
		if(_rc) {
			display as error "Could not close DebugLog."
		}
		else {
			display "...DebugLog Closed."
			display ""
			flowchart_footer "DEBUG MODE: OFF"
			display ""
		}
	}
	else if("`info'" == "info") {
		display ""
		flowchart_hline
		flowchart_header "DEBUG INFO"
		display ""
		flowchart_subtitle "Debug Options"
		display ""
		display "1. To Debug Code:" _newline
		display "	Turn Debugging Mode On: "
		display "	. {stata flowchart debug on:flowchart debug on}"
		display "	Use this at the start of code that produces errors." _newline
		
		display " 	Turn Debugging Mode Off: "
		display "	. {stata flowchart debug off:flowchart debug off}"
		display "	Use this at the end of code that produces errors." _newline
		display "	This will generate DebugLog.log in your working directory with debugging information." _newline
		
		display "2. To Get Environment Information: "
		display "	. {stata flowchart debug check:flowchart debug check}"
		display "	This will give you versioning information on Stata, the flowchart package, and dependencies installed." _newline
		
		display "3. To Debug TikZ Code: "
		display "	. {stata flowchart debug tikz:flowchart debug tikz}"
		display "	This will insert debugging information into the TikZ code." _newline
		
		display "4. To Uninstall Flowchart: "
		display "	. {stata flowchart setup, uninstall:flowchart setup, uninstall}"
		display "	This will uninstall the flowchart package. The dependencies will remain." _newline
		
		display "Read this message again at anytime by typing '{stata flowchart debug info:flowchart debug info}'"
		flowchart_footer
		flowchart_hline
	}
	else if("`deletefiles'" == "deletefiles") {
		if("`yes'" == "yes") {
			flowchart_debugdeletefiles
		}
		else {
			display "Are you sure you want to delete the ancillary files in the current working directory?"
			display "	{stata flowchart debug deletefiles yes: Yes}"
		}
	}
	else {
		if("$Flowchart_Debug" == "on") {
			flowchart debug off
		}
		else if("$Flowchart_Debug" == "off") {
			flowchart debug on
		}
		else {
			flowchart debug info
		}
	}
end
capture program drop flowchart_debugdeletefiles
program define flowchart_debugdeletefiles
	* DeleteFiles - This deletes the ancillary files from the current working directory - Use with caution.
	capture rm methods--figure-flowchart.tex
	capture rm methods--figure-flowchart.data
	capture rm methods--figure-flowchart.tikz
	capture rm manuscript.tex
	capture rm license.txt
	capture rm figure-flowchart.texdoc
	capture rm example1output.pdf
	capture rm example2output.pdf
	capture rm flowchart_example1.do
	capture rm flowchart_example2.do
	display ""
	display " ...Ancillary Files Deleted."
end
capture program drop flowchart_debugcheck
program define flowchart_debugcheck
		display ""
		
		* Machine Inforation:
		flowchart_subtitle "Machine"
		display ""
		display "  [Operating System]"
		display "`c(os)'"
		display "  [Machine Type]"
		display "`c(machine_type)'"
		display ""
		
		* Stata Version Information: 
		flowchart_subtitle "Stata"
		display ""
		display "  [Version]"
		version	// Returns the STATA Version #
		display ""
		display "  [ADO Directory]"
		capture noisily net query
		display ""
		
		* Dependencies - Check Presence & Give Version #'s: 
		flowchart_subtitle "Dependency Check"
		display ""
		display "  1. [Flowchart Package]"
		capture noisily which flowchart
		if(_rc) {
			display as error "Package 'flowchart' likely uninstalled itself. Please try reinstalling the package again."
			exit 111
		}
		capture noisily ado dir flowchart
		if(_rc) {
			display as error "ADO Directory could not be returned for the 'flowchart' package."
			exit 111
		}
		display ""
		display "  2. [TexDoc Package]"
		capture noisily which texdoc
		if(_rc) {
			display as error "Package 'texdoc' is required by the flowchart package. Please run command 'flowchart setup' and try again."
			exit 111
		}
		display ""
		display "  3. [SJLatex]"
		capture noisily which sjlatex
		if(_rc) {
			display as error "Package 'sjlatex' is required by the 'texdoc' package. Please run command 'flowchart setup' and try again."
			exit 111
		}
		display ""
end
capture program drop flowchart_init
program define flowchart_init
	flowchart_writevar, name("set_dummy") value("null")	// Set dummy variable since the first variable is not recognized by texdoc.
	flowchart_writevar, name("set_draw") value("black")
	flowchart_writevar, name("set_fill") value("white")
	flowchart_writevar, name("set_center_textwidth") value("18em")
	flowchart_writevar, name("set_center_textalign") value("centered")
	flowchart_writevar, name("set_center_minheight") value("4em")
	flowchart_writevar, name("set_left_textwidth") value("21em")
	flowchart_writevar, name("set_left_textalign") value("ragged")
	flowchart_writevar, name("set_left_minheight") value("4em")
	flowchart_writevar, name("set_left_innersep") value("6pt")
	/* To Do: Future Releases: Implement row-options - 'flowchart writerow(rowname,rowoption): ...' -- Allow noborder, assign, and lost-style boxes.
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
	flowchart_writevar, name("set_lost_innersep") value("6pt")*/
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
	syntax , template(string) output(string)
	***\\ TIKZ PICTURE: Write the TikZ Picture to the file.
	if("$Flowchart_Debug" == "on") {
		display "`template' `output'"
	}
	texdoc do "`template'", init("`output'") replace
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
				if("`endblank'" != "") {
					local addrowskip = "true"
				}
				local linestring = `"`lead'`desc' (n=\figvalue{`name'})}; \\"'	// Usually, a left-block that has only 1 line (a singleton) when the center-block was blank.

			}
			else {
				local linestring = `"`lead'`desc' (n=\figvalue{`name'})}; "'
			}
		}
		else {
			local linestring = `"`lead'`desc' (n=\figvalue{`name'}): \\"'
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
			local linestring = `"      \h\h \figvalue{`name'} `desc' `suffix'"'
		}
		else {
			local linestring = `"      \h `desc' (n=\figvalue{`name'}) `suffix'"'
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
		global Flowchart_IteratorBlockfields = $Flowchart_IteratorBlockfields + 1
		.blockfields.list[$Flowchart_IteratorBlockfields] = `"       % -- Blank Left Block"'
		macro drop addrowskip // Guarantee this is deleted from memory and only happens when it is supposed to happen.
		if("$Flowchart_Debug" == "on") {
			display `"Blockfield Linestring:       & \\"'
			display `"Blockfield Linestring:        % -- Blank Left Block"'
		}
	}
	*flowchart_tdwrite_blockfield `"`linestring'"'
	*	texdoc write "`varname'"
end
capture program drop flowchart_header
program define flowchart_header
	syntax [anything]
	
	if ("`1'" != "") {
		local text = "`1'"
	}
	else {
		local text = "FLOWCHART"
	}
	display "{bf:|||||| `text'}" 
end
capture program drop flowchart_footer
program define flowchart_footer
	syntax [anything]
	
	if ("`1'" != "") {
		local text = "`1'"
	}
	else {
		local text = "FLOWCHART"
	}
	display "{bf:|||||| `text'}" 
end
capture program drop flowchart_hline
program define flowchart_hline
	display "{hline}"
end
capture program drop flowchart_subtitle
program define flowchart_subtitle
	syntax [anything]
	display `"  {title:`1'}:"'	// Requirement: Quotes around text. Safer to use quotes with input to avoid unusual errors rather than compound quotes.
end
capture program drop flowchart_title
program define flowchart_title
	syntax [anything] [, num(string)]
	
	if("`num'" == "") {
		local num = floor((5-1+1)*runiform() + 1)
	}
	
	* Based on ASCII Generated from: http://www.network-science.de/ascii/
	* Citation: Seyfferth, Jorg. (19 Feb. 2011.). Imprint / Impressum. Network-science.de. Retrieved from http://www.network-science.de/impressum.html
	* larry3d
	display ""	// New Line - Before Title
	if("`num'" == "1") {
		display "    ___  ___                               __                       __       "
		display "  /'___\/\_ \                             /\ \                     /\ \__    "
		display " /\ \__/\//\ \     ___   __  __  __    ___\ \ \___      __     _ __\ \ ,_\   "
		display " \ \ ,__\ \ \ \   / __\`\/\ \/\ \/\ \  /'___\ \  _ \`\  /'__\`\  /\\`'__\ \ \ \   "
		display "  \ \ \_/  \_\ \_/\ \_\ \ \ \_/ \_/ \/\ \__/\ \ \ \ \/\ \_\.\_\ \ \/ \ \ \_  "
		display "   \ \_\   /\____\ \____/\ \___ ___/'\ \____\\ \_\ \_\ \__/.\_\\ \_\  \ \__\ "
		display "    \/_/   \/____/\/___/  \/__//__/   \/____/ \/_/\/_/\/__/\/_/ \/_/   \/__/ "
	}
	* ogre
	else if("`num'" == "2") {
		display "  __ _                   _                _    "
		display " / _| | _____      _____| |__   __ _ _ __| |_  "
		display "| |_| |/ _ \ \ /\ / / __| '_ \ / _\` | '__| __| "
		display "|  _| | (_) \ V  V / (__| | | | (_| | |  | |_  "
		display "|_| |_|\___/ \_/\_/ \___|_| |_|\__,_|_|   \__| "
	}
	* slant
	else if("`num'" == "3") {
		display "     ______                   __               __  "
		display "    / __/ /___ _      _______/ /_  ____ ______/ /_ "
		display "   / /_/ / __ \ | /| / / ___/ __ \/ __ \`/ ___/ __/ "
		display "  / __/ / /_/ / |/ |/ / /__/ / / / /_/ / /  / /_   "
		display " /_/ /_/\____/|__/|__/\___/_/ /_/\__,_/_/   \__/   "
	}
	* smslant
	else if("`num'" == "4") {
		display "    _____               __            __  "
		display "   / _/ /__ _    ______/ /  ___ _____/ /_ "
		display "  / _/ / _ \ |/|/ / __/ _ \/ _ \`/ __/ __/ "
		display " /_//_/\___/__,__/\__/_//_/\_,_/_/  \__/  "
	}
	* speed
	else if("`num'" == "5") {
		display " _____________                     ______               _____  "
		display " ___  __/__  /________      __________  /_______ _________  /_ "
		display " __  /_ __  /_  __ \_ | /| / /  ___/_  __ \  __ \`/_  ___/  __/ "
		display " _  __/ _  / / /_/ /_ |/ |/ // /__ _  / / / /_/ /_  /   / /_   "
		display " /_/    /_/  \____/____/|__/ \___/ /_/ /_/\__,_/ /_/    \__/   "
	}	
	display ""	// New Line - After Title
end
