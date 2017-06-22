Scriptname spdfDancesBase extends Quest

Event OnInit()
	RegisterForModEvent("SkyrimPoleDancesRegistryUpdated", "RegisterDances")

endEvent


Event RegisterDances(int version, Form reg)
	spdfRegistry r = reg as spdfRegistry
	r.beginEdit("spdDancesBase")
	
	int errors = 0
	spdfPose myPose = r.registerPose("Pose 1", "IdleForceDefaultState", "spdPose1_Start", "IdleForceDefaultState", 6.0, 1.0)
	if !myPose
		errors+=1
	else
		myPose.setPreview("Standing Grab Pole 1.dds")
	endIf

	debug.trace("SPDF: Poses registration completed, " + errors + " errors")

	errors = 0
	spdfDance myDance = none
	myDance = r.registerDance("Dance CPU", "spdfPose1_Anim", "Pose 1", "Pose 1", 4.0, "Auth:CPU,Sexy:1,Stand,Grab")
	if myDance
		myDance.setPreview("DanceCPU_Preview.swf")
		myDance.setCycle(true, "spdfPose1_pre", 2.0, "spdfPose1_post", 3.0)
	else
		errors+=1
	endIf
	myDance = r.registerDance("Dance Kom 1", "spdfDance1", "Pose 1", "Pose 1", 12.0, "Auth:Komotor,Sexy:2,Stand,Grab")
	if myDance
		myDance.setPreview("Dance 1.swf")
		myDance.setCycle(true)
	else
		errors+=1
	endIf
	
	debug.trace("SPDF: Dances registration completed, " + errors + " errors")
	r.completeEdit()
	debug.notification("Base Pole Dances registered. Framework is ready")
endEvent

