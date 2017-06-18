Scriptname spdDancesBase extends Quest

Event OnInit()
	RegisterForModEvent("SkyrimPoleDancesRegistryUpdated", "RegisterDances")

endEvent


Event RegisterDances(int version, Form reg)
	spdRegistry r = reg as spdRegistry
	r.beginEdit("spdDancesBase")
	
	int errors = 0
	errors += r.registerPose("Pose 1", "IdleForceDefaultState", "spdPose1_Start", "IdleForceDefaultState", 6.0, 1.0)

	debug.trace("SPD: Poses registration completed, " + errors + " errors")

	errors += r.registerDance("Dance 1", "spdDance1", "Pose 1", "Pose 1", 12.0, "Auth:Komotor,Sexy:2,Stand,Grab", "spdDance1", 12.0, "spdDance1", 12.0)
	
	debug.trace("SPD: Dances registration completed, " + errors + " errors")
	r.dumpErrors()
	r.completeEdit()
	debug.notification("Base Pole Dances registered. Framework is ready")
endEvent

