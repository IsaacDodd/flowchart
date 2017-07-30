
capture program drop flowchart_writeblock
program define flowchart_writeblock
	syntax [anything] [using/] [, name(string) value(string) input(string) output(string) *]

	* Parse the token for a possible sub-command that contains a command (e.g., flowchart subcommand(parameter): ... )
	gettoken subcmd 0 : 0, parse(" :") quotes
	while `"`subcmd'"' != ":" & `"`subcmd'"' != "" {
		local subcmdwithparam `"`subcmdwithparam' `subcmd'"'
		gettoken subcmd 0 : 0, parse(" :") quotes
	}
	display ""
	display "Subcommand via GetToken: `subcmd'"
	local subcmdsyntax = "`1'"
	display "Subcommand via Syntax: `subcmdsyntax'"
	display `"Subcommand With Parameter: `subcmdwithparam'"'
	display `"Compound Quotes (CQ's):  `0'"'
	local subparam = substr("`subcmdwithparam'", strpos("`subcmdwithparam'", "(")+1, length("`subcmdwithparam'")-strpos("`subcmdwithparam'", "(")-1)
	local subcmdparsed = substr("`subcmdwithparam'", 1, strpos("`subcmdwithparam'", "(")-1)
	display `"Subparameter via String Parse (CQ's):  `subparam'"'
	display `"Subcommand via String Parse (CQ's):  `subcmdparsed'"'
	
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
		
		
		local i = 1		// Token Iterator
		local blockparse = "center"
flowchart_tdwrite `"      % Row - `subparam'"'
		
		while "``i''" != "" {
			display "`i': ``i''"
			
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
			display `"			LA: ``ilookahead'' "'
			
			if("`blockparse'" == "center") {
flowchart_tdwrite `"      \node [block_`blockparse'] (`subparam'_`blockparse') {"'	
			} // fi: End of BlockParse
			else if("`blockparse'" == "left") {
flowchart_tdwrite `"      & \node [block_`blockparse'] (`subparam'_`blockparse') {"'	
			} // fi: End of BlockParse
			
			local k = 1	// Line Iterator
			local stop = ""
			while("`stop'" == "") {
				local linename = `"``i''"'
				local i = `i' + 1
				local linenum = `"``i''"'
				flowchart_writevar, name(`"`linename'"') value(`"`linenum'"') // Store the number as the named line's number value.
				local i = `i' + 1
				local linedesc = `"``i''"'
				if(`k' == 1) {
					flowchart_tdwriteline, name(`"`linename'"') num(`"`linenum'"') desc(`"`linedesc'"') lead
				}
				else if(`k' != 1 & trim("``ilookahead''") == ",") {
					flowchart_tdwriteline, name(`"`linename'"') num(`"`linenum'"') desc(`"`linedesc'"') end
				}
				else {
					flowchart_tdwriteline, name(`"`linename'"') num(`"`linenum'"') desc(`"`linedesc'"') 
				}
				
				if(trim("``ilookahead''") != ",") {
					local stop = ""
				}
				else {
					local stop = "stop"
				}
			} // elihw: End of LineWhile
flowchart_tdwrite `"      }; \\ "'				
			local i = `i' + 1
		} // elihw: End of TokenWhile
	} //fi: End of Writerow
end

capture program drop flowchart_tdwrite
program define flowchart_tdwrite
	syntax [anything] [, indent]
	display  "1=|`1'|, 2=|`2'|, 3=|`3'| indent=|`indent'|"
*	texdoc write "`varname'"
end

capture program drop flowchart_tdwriteline
program define flowchart_tdwriteline
	syntax [anything] [, indent lead end name(string) num(string) desc(string)]
	if("`lead'" != "") {
		local linestring = `"        `desc' (n=`num'): \\ "'
	}
	else {
		if("`indent'" != "") {
			local linestring = `"        \h\h `num' `desc' \\ "'
		}
		else {
			local linestring = `"        \h`desc' (n=`num') \\ "'
		}
	}
flowchart_tdwrite `"`linestring'"'
*	texdoc write "`varname'"
end
capture program drop flowchart_writevar
program define flowchart_writevar
	syntax [anything] [, name(string) value(string) *]	
	local variablerow "`name' = `value'"
	* file write FlowchartFile "`variablerow'" _n	<-- Temporarily stop writing to file for unittest...
	if(substr("`name'",1,4) == "set_") {
		global Flowchart_Settings = `"$Flowchart_Settings @`name'"'
		global Flowchart_Settings = `"$Flowchart_Settings "`value'""'
	}
end
* ------------------------
flowchart_writeblock writerow(row_name): "referred" 173 "Referred" "lblock1_line2" 43 "This is another row, of a block" "lblock1_line3" 3 "This is another row, of a block", "rblock1_line1" 97 "This is one row, of a block." "rblock1_line2" 33 "This is another row, of a block" "rblock1_line3" 44 "This is another row, of a block"
