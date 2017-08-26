********************
* EXAMPLE 2:
********************

* TESTS: This is a barebones test file for running tests. Use this as a template
* of the flowchart syntax to follow.

flowchart init using "filename.data"

* |||||| TEST1: Row with 2 blocks.
flowchart writerow(rownametest1): "lblock1_line1" 46 "This is one line, \\ of a block." ///
	"lblock1_line2" 43 "This is another line, of a block" ///
	"lblock1_line3" 3 "This is another line, of a block", ///
	"rblock1_line1" 97 "This is one line, of a block." ///
	"rblock1_line2" 33 "This is another line, of a block" ///
	"rblock1_line3" 44 "This is another line, of a block"

* |||||| TEST2: Row with No center-block (a center-block appears on the left)
flowchart writerow(rownametest2): Flowchart_Blank, ///
	"rblock1_line1" 97 "This is one line, of a block." ///
	"rblock1_line2" 33 "This is another line, of a block" ///
	"rblock1_line3" 44 "This is another line, of a block"

* |||||| TEST3: Row with No left-block (a left-block appears on the right)
flowchart writerow(rownametest3): "lblock1_line1" 46 "This is one line, \\ of a block." ///
	"lblock1_line2" 43 "This is another line, of a block" ///
	"lblock1_line3" 3 "This is another line, of a block", Flowchart_Blank

* |||||| TEST4: Row with No center-block and a Singleton Lead-Line in the left-block
flowchart writerow(rownametest4): Flowchart_Blank, "rblock1_line1" 97 "This is one line, \\ of a block."
	
* |||||| TEST5: Row with Singleton Lead-Line in the center-block and No left-block
flowchart writerow(rownametest5): "lblock1_line1" 46 "This is one line, \\ of a block.", Flowchart_Blank

* |||||| CONNECTIONS: Use the block orientation to connect arrows to the appropriate blocks
flowchart connect rownametest1_center rownametest1_left
flowchart connect rownametest1_left rownametest2_left
flowchart connect rownametest1_center rownametest3_center
flowchart connect rownametest3_center rownametest5_center
flowchart connect rownametest2_left rownametest4_left

* |||||| FINALIZE: This writes the files and generates the 'tikzpicture'
flowchart finalize, template("figure.texdoc") output("figure.tikz")
