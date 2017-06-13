Scriptname spdDancesBase extends Quest

Event OnInit()
	RegisterForModEvent("SkyrimPoleDancesRegistryUpdated", "RegisterDances")

endEvent


Event RegisterDances(int version, Form reg)
	debug.trace("SPD: begin registration of Poses")
	
	spdRegistry r = reg as spdRegistry
	
	
	int errors = 0
	
	errors += r.registerPose("Pose 1", "IdleForceDefaultState", "spdPose1_Start", "spdPose1_End", 1.0, 1.0)
	errors += r.registerPose("Pose 2", "IdleForceDefaultState", "spdPose2_Start", "spdPose2_End", 1.0, 1.0)
	errors += r.registerPose("Pose 3", "IdleForceDefaultState", "spdPose3_Start", "spdPose3_End", 1.0, 1.0)

	debug.trace("SPD: Poses registration completed, " + errors + " errors")

	debug.trace("SPD: begin registration of Dances")
	errors = 0
	
	errors += r.registerDance("Dance 1", "spdDance1", "Pose 1", "Pose 2", 15.0, false)
	errors += r.registerDance("Dance 2", "spdDance2", "Pose 1", "Pose 1", 15.0, true)
	errors += r.registerDance("Dance 3", "spdDance3", "Pose 2", "Pose 1", 15.0, false)

	debug.trace("SPD: Dances registration completed, " + errors + " errors")
	r.dumpErrors()
endEvent

