Scriptname spdDancesBase extends Quest

Event OnInit()
	RegisterForModEvent("SkyrimPoleDancesRegistryUpdated", "RegisterDances")

endEvent


Event RegisterDances(int version, Form reg)
	debug.trace("SPD: begin registration of Poses")
	
	spdRegistry r = reg as spdRegistry
	
	
	int errors = 0
	errors += r.registerPose("Standing Grab Pole 1", "IdleForceDefaultState", "spdPose1_Start", "spdPose1_End", 1.0, 1.0)
	errors += r.registerPose("Down Grab Pole 1", "IdleForceDefaultState", "spdPose2_Start", "spdPose2_End", 1.0, 1.0)
	errors += r.registerPose("Moving RLegUp 1", "IdleForceDefaultState", "spdPose3_Start", "spdPose3_End", 1.0, 1.0)

	debug.trace("SPD: Poses registration completed, " + errors + " errors")

	debug.trace("SPD: begin registration of Dances")
	errors = 0
	errors += r.registerDance("Dance 1", "spdDance1", "Standing Grab Pole 1", "Down Grab Pole 1", 15.0, false, "Auth:Rydin,Sexy:0,Stand,Grab")
	errors += r.registerDance("Dance 2", "spdDance2", "Standing Grab Pole 1", "Standing Grab Pole 1", 15.0, true, "Auth:CPU,Sexy:2|3,Strip:body|feet")
	errors += r.registerDance("Dance 3", "spdDance3", "Down Grab Pole 1", "Standing Grab Pole 1", 15.0, false, "Auth:komotor,Float,Grab,Sexy:3|4,Bend,Spread")

	debug.trace("SPD: Dances registration completed, " + errors + " errors")
	r.dumpErrors()
endEvent

