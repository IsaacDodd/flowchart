
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
		
		
		local i = 1
		local blockparse = "center"
display `"      % Row - `subparam'"'
		
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
			
			local ilookahead = `i' + 1
			display `"			LA: ``ilookahead'' "'
			
			if("`blockparse'" == "center") {
				local cblock_string_node = `"\node [block_`blockparse'] (``i'')"'
				local i = `i' + 1
				local cblock_string_n = `"(n=\figvalue{``i''})"'
				local i = `i' + 1
				local cblock_string_lead = `"``i''"'
display `"      `cblock_string_node' {`cblock_string_lead' `cblock_string_n'};"'
			} 
			else if("`blockparse'" == "left") {
				local lblock_string_node = `"\node [block_`blockparse'] (``i'')"'
				local i = `i' + 1
				local lblock_string_n = `"(n=\figvalue{``i''})"'
				local i = `i' + 1
				local lblock_string_lead = `"``i''"'
display `"      & `lblock_string_node' {`lblock_string_lead' `lblock_string_n'};"'
				
				* Set the block back to the center block for the next row.
				local blockparse = "center"
			}
*display `"      & \node [block_left] (excluded1) {Excluded (n=\figvalue{referred_excluded}): \\"'
*display `"        a) Did not wish to participate (n=\figvalue{referred_excluded_nopartic}) \\"'
*display `"        b) Did not show for interview (n=\figvalue{referred_excluded_noshow}) \\"'
*display `"        c) Other reasons (n=\figvalue{referred_excluded_other})}; \\"'

			local i = `i' + 1
		}
	}
end

flowchart_writeblock writerow(row_name): "referred" 173 "Referred" "lblock1_line2" 43 "This is another row, of a block" "lblock1_line3" 3 "This is another row, of a block", "rblock1_line1" 97 "This is one row, of a block." "rblock1_line2" 33 "This is another row, of a block" "rblock1_line3" 44 "This is another row, of a block"
