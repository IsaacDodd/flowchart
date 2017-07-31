********************
* EXAMPLE:
********************

* DISPOSITION SUBANALYSIS: Analyze and setup the subject disposition.

	*** Subanalysis Data is performed here where the numbers and data to produce the flowchart are created. 
	*** Rows can be created using macros to fill in each row as the data for the analysis are changed.

* DIAGRAM: Call Post-Production texdoc file to write this analysis as a diagram.

flowchart init using "Methods--Fig-TEST.data"

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
	
flowchart_debug, off

flowchart writerow(random): "randomized" 102 "Randomized", flowchart_blank // Blank Row

flowchart writerow(allocgroup): ///
	"alloc_interventiongroup" 51 "Allocated to Intervention group", ///
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
	"intervention_analyzed" 51 "Analyzed in Intervention group", ///
	"postwaitlist_analyzed" 51 "Analyzed in Wait-list control group"

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

flowchart finalize, input("figure.texdoc") output("figure.tikz")

/*
* TESTS: Uncomment the following lines to run tests. Alternatively, use this as a template to follow:
flowchart init using "filename.data"

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

* |||||| TEST4: Row with No left-block and a Singleton Lead-Line in the right-block
flowchart writerow(rownametest4): flowchart_blank, "rblock1_line1" 97 "This is one line, \\ of a block."
	
* |||||| TEST5: Row with Singleton Lead-Line in the left-block and No right-block
flowchart writerow(rownametest5): "lblock1_line1" 46 "This is one line, \\ of a block.", flowchart_blank

flowchart connect rownametest1_center rownametest1_left
flowchart connect rownametest1_left rownametest2_left
flowchart connect rownametest1_center rownametest3_center
flowchart connect rownametest3_center rownametest5_center
flowchart connect rownametest2_left rownametest4_left

flowchart finalize, input("figure.texdoc") output("figure.tikz")
*/


