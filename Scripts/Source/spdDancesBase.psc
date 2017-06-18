Scriptname spdDancesBase extends Quest

Event OnInit()
	RegisterForModEvent("SkyrimPoleDancesRegistryUpdated", "RegisterDances")

endEvent


Event RegisterDances(int version, Form reg)
	spdRegistry r = reg as spdRegistry
	r.beginEdit("spdDancesBase")
	
	int errors = 0
	errors += r.registerPose("Pose 1", "IdleForceDefaultState", "spdPose1_Start", "spdPose1_End", 3.0, 3.0)
	errors += r.registerPose("Pose 2", "IdleForceDefaultState", "fip3", "spdPose1_End", 3.0, 3.0)

	debug.trace("SPD: Poses registration completed, " + errors + " errors")

	errors += r.registerDance("Dance 1", "spdDance1", "Pose 1", "Pose 1", 15.0, "Auth:Rydin,Sexy:0,Stand,Grab")
	errors += r.registerDance("Dance 2", "spdDance1", "Pose 2", "Pose 1", 15.0, "Auth:CPU,Sexy:2|3,Strip:body|feet")
	
	debug.trace("SPD: Dances registration completed, " + errors + " errors")
	r.dumpErrors()
	r.completeEdit()
	debug.notification("Base Pole Dances registered. Framework is ready")
endEvent

