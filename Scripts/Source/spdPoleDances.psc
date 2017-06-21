Scriptname spdPoleDances Extends Quest


; ((- Properties

spdRegistry Property registry Auto
Static Property spdWoodPole Auto
Actor Property PlayerRef Auto
Package Property spdDoNothingPackage Auto
Faction Property spdDancingFaction Auto
Keyword Property spdNoStrip Auto
MiscObject Property spdMarker Auto

int currentVersion

bool Property immediateDumps Auto


; -))

; ((- Main functions

int Function getVersion()
	return 1
endFunction

Function _doInit()
	immediateDumps = true ; FIXME just for debug

debug.trace("SPD: init doInit")
	errors = new string[32]
	errorSources = new string[32]
	errorMethods = new string[32]
	numErrors = 0
	
	if currentVersion != getVersion()
		_doUpdate()
	endIf
	currentVersion = getVersion()
	
	
	registry._doInit(Self) ; This will just check stuff, and call the mod event to have other mods to add their own dances
	
	int modEvId = ModEvent.Create("SkyrimPoleDancesInitialized")
	ModEvent.pushInt(modEvId, currentVersion)
	ModEvent.send(modEvId)
debug.trace("SPD: init completed")
endFunction

Function _doUpdate()
	; Nothing to do yet
endFunction

spdPoleDances Function getInstance() Global
	return Game.GetFormFromFile(0x0012C4, "Skyrim Pole Dances.esp") as spdPoleDances
endFunction

; -))

; ****************************************************************************************************************************************************************
; ************                                                                                                                                        ************
; ************                                             Performances and QuickStart                                                                     ************
; ************                                                                                                                                        ************
; ****************************************************************************************************************************************************************
; ((-

bool Function quickStart(Actor dancer, ObjectReference pole=None, float duration=-1.0, string startingPose="")
	spdPerformance th = Registry._allocatePerformance()
	if !th
		_addError(10, "No Performances available", "PoleDancesFramework", "QuickStart")
		return true
	endIf
	if duration==-1.0
		duration = 30.0
	endIf
	th.setBasicOption(dancer, pole, duration)
	th.setStartPose(startingPose)
	if th.start()
		Debug.Trace("SPD: problems starting a Pole Dance Performance.") ; FIXME
		return true
	endIf
	return false
endFunction

spdPerformance Function newPerformance(Actor dancer, ObjectReference pole=None, float duration=-1.0)
	spdPerformance th = Registry._allocatePerformance()
	if !th
		_addError(10, "No Performances available", "PoleDancesFramework", "newPerformance")
		return None
	endIf
	th.setBasicOption(dancer, pole, duration)
	return th
endFunction

spdPerformance Function getPerformanceById(int performanceId)
	return registry.getPerformanceById(performanceId)
endFunction

spdPerformance Function getGlobalPerformanceById(int performanceId) Global
	spdPoleDances mySelf = Game.GetFormFromFile(0x0012C4, "Skyrim Pole Dances.esp") as spdPoleDances
	return mySelf.registry.getPerformanceById(performanceId)
endFunction


; -))


; ****************************************************************************************************************************************************************
; ************                                                                                                                                        ************
; ************                                                   Poles                                                                                ************
; ************                                                                                                                                        ************
; ****************************************************************************************************************************************************************
; ((-

ObjectReference Function placePole(ObjectReference loc = None, float distance = 0.0, float rotation = 0.0, int whichPole = 0)
	ObjectReference ref = loc
	if !ref
		ref = PlayerRef
	endIf
	
	float zAngle = ref.getAngleZ()
	Static poleS
	if whichPole==0
		poleS = spdWoodPole
	else
		poleS = spdWoodPole ; Fallback
	endIf
	ObjectReference res = loc.placeAtMe(poleS, 1, false, false)
	float newAngle = zAngle + rotation
	if newAngle>360.0
		newAngle-=360.0
	endIf
	res.moveTo(loc, Math.sin(newAngle) * distance, Math.cos(newAngle) * distance, 0.0, false)
	res.setAngle(0.0, 0.0, ref.getAngleZ())
	return res
endFunction

Function removePole(ObjectReference pole)
	if !pole
		return
	endIf
	pole.disable(true)
	pole.delete()
endFunction

; -))

; ****************************************************************************************************************************************************************
; ************                                                                                                                                        ************
; ************                                             Errors management                                                                          ************
; ************                                                                                                                                        ************
; ****************************************************************************************************************************************************************
; ((-


int Property logMode Auto ; 0=Don't show anything, 1=show only errors in traces, 2=show logs and errors in traces, 3=MsgBox errors and traces for logs


string[] Property errors Auto
string[] Property errorSources Auto
string[] Property errorMethods Auto
int[] Property errorIDs Auto
int numErrors

Function _addError(int id, string error, string source, string method)
	; In case the errors go to the log, do a trace
	; In case the errors for MsgBox, do it
	; In case of just tracing (id==-1 or id==0), put them in traces just if we really need them (option on MCM)

	if logMode==0
		return
	elseIf logMode==1
		if id>0
			debug.trace("SPD: [" + id + "] " + error + " [" + source + "]." + method)
		endIf
	elseIf logMode==2
		debug.trace("SPD: [" + id + "] " + error + " [" + source + "]." + method)
	elseIf logMode==3
		if id>0
			debug.messagebox("SPD: [" + id + "]\n" + error + "\n[" + source + "]." + method)
		else
			debug.trace("SPD: [" + id + "] " + error + " [" + source + "]." + method)
		endIf
	endIf
endFunction


; -))

; ****************************************************************************************************************************************************************
; ************                                                                                                                                        ************
; ************                                             Hooks Definition                                                                           ************
; ************                                                                                                                                        ************
; ****************************************************************************************************************************************************************

; FIXME get the ones from the docs, and update the spdPerformance




int Property woodPole
	int Function get()
		return 0
	endFunction
endProperty

