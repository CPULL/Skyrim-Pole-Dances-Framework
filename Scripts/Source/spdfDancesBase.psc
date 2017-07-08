Scriptname spdfDancesBase extends Quest

Event OnInit()
	RegisterForModEvent("SkyrimPoleDancesRegistryUpdated", "RegisterDances")

endEvent


Event RegisterDances(int version, Form reg)
	spdfRegistry r = reg as spdfRegistry
	r.beginEdit("spdDancesBase")
	
	int errors = 0
	spdfPose myPose = r.registerPose("Standing Grab Pole 1", "spdfPose1_Anim", 3.0, "spdfPose1_Start", "spdfPose1_End", 5.0, 5.0)
	if !myPose
		errors+=1
	else
		myPose.previewfile = "Standing Grab Pole 1.dds"
	endIf
	myPose = r.registerPose("Moving LegUp 1", "spdfPose3_Anim", 3.0, "spdfPose3_Start", "spdfPose3_End", 6.0, 6.0)
	if !myPose
		errors+=1
	else
		myPose.previewfile = "Moving RLegUp 1.dds"
	endIf
	
	debug.trace("SPDF: Poses registration completed, " + errors + " errors, " + r.getPosesNum(1) + " poses")

	errors = 0
	spdfDance myDance = none
	myDance = r.registerDance("Transition P1 to P3", "spdfTransition_P1_to_P3", "Standing Grab Pole 1", "Moving LegUp 1", 4.0, "Auth:CPU,Sexy:2,Stand,Grab", true)
	if !myDance
		errors+=1
	endIf
	myDance = r.registerDance("Dance Kom 1", "spdfDanceKom1", "Moving LegUp 1", "Moving LegUp 1", 12.0, "Auth:Komotor,Sexy:2,Stand,Grab")
	if myDance
		myDance.previewfile = "Dance 1.swf"
		myDance.setCycle(true)
	else
		errors+=1
	endIf
	myDance = r.registerDance("Dance CPU Ritm", "spdfDanceCPU1", "Standing Grab Pole 1", "Standing Grab Pole 1", 4.0, "Auth:CPU,Sexy:1,Stand,Grab")
	if myDance
		myDance.previewfile = "DanceCPU_Preview.swf"
		myDance.setCycle(true, "spdfPose1_pre", 2.0, "spdfPose1_post", 3.0)
	else
		errors+=1
	endIf
	myDance = r.registerDance("Dance CPU Swivel", "spdfDanceCPU2", "Standing Grab Pole 1", "Standing Grab Pole 1", 4.0, "Auth:CPU,Sexy:3,Spread,Grab")
	if myDance
		myDance.previewfile = "DanceCPU_Preview.swf"
	else
		errors+=1
	endIf
	
	
	debug.trace("SPDF: Dances registration completed, " + errors + " errors, " + r.getDancesNum(1) + " dances.")
	
	
	
	
	errors = 0
	spdfStrip myStrip = none
	myStrip = r.registerStrip("Strip 1", "spdfStrip1_Pose1", 2.0, 0.55, "Pose 1")
	if myStrip
		myStrip.parseStrips("Strip:body", false)
	else
		errors+=1
	endIf
	
	debug.trace("SPDF: Strips registration completed, " + errors + " errors, " + r.getStripsNum(1) + " strips.")
	r.completeEdit()
	debug.notification("Base Pole Dances registered. Framework is ready")
endEvent

