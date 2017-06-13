Scriptname spdPoleDances Extends Quest


; ((- Properties

spdRegistry Property registry Auto
Static Property spdMainPole Auto
Actor Property PlayerRef Auto
Package Property spdDoNothingPackage Auto
Faction Property spdDancingFaction Auto

int currentVersion


; -))

; ((- Main functions

int Function getVersion()
	return 1
endFunction

Function _doInit()
debug.trace("SPD: init doInit")
	errors = new string[32]
	errorSources = new string[32]
	errorMethods = new string[32]
	numErrors = 0
	
	if currentVersion != getVersion()
debug.trace("SPD: doUpdate")
		_doUpdate()
	endIf
	currentVersion = getVersion()
	
	
debug.trace("SPD: reInit registry")
	registry._doInit(Self) ; This will just check stuff, and call the mod event to have other mods to add their own dances
debug.trace("SPD: sending mod event")
	
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


; -))


; ****************************************************************************************************************************************************************
; ************                                                                                                                                        ************
; ************                                                   Poles                                                                                ************
; ************                                                                                                                                        ************
; ****************************************************************************************************************************************************************
; ((-

ObjectReference Function placePole(ObjectReference loc = None, float distance = 0.0, float rotation = 0.0)
	ObjectReference ref = loc
	if !ref
		ref = PlayerRef
	endIf
	
	float zAngle = ref.getAngleZ()
	ObjectReference res = loc.placeAtMe(spdMainPole, 1, false, true)
	res.moveTo(loc, Math.cos(zAngle + rotation) * distance, Math.sin(zAngle + rotation) * distance, 0.0, true)
	res.enable(true)
	return res
endFunction

Function removePole(ObjectReference pole)
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

string[] Property errors Auto
string[] Property errorSources Auto
string[] Property errorMethods Auto
int[] Property errorIDs Auto
int numErrors

Function _addError(int id, string error, string source, string method)
	if !errors
		debug.trace("SPD: [" + id + "] " + error + " [" + source + "]." + method)
		return
	endIf
	if numErrors == errors.length
		dumpErrors()
	endIf
	errors[numErrors] = error
	errorSources[numErrors] = source
	errorMethods[numErrors] = method
	errorIDs[numErrors] = id
	numErrors+=1
endFunction

Function dumpErrors()
	int i = 0
	while i<numErrors
		debug.trace("SPD: [" + errorIDs[i] + "] " + errors[i] + " [" + errorSources[i] + "]." + errorMethods[i])
		i+=1
	endWhile
	while numErrors
		numErrors-=1
		errors[numErrors] = ""
		errorSources[numErrors] = ""
		errorMethods[numErrors] = ""
	endWhile
endFunction

string function getLastError()
	if numErrors==0
		return ""
	endIf
	return errors[numErrors - 1]
endFunction

int function getLastErrorID()
	if numErrors==0
		return 0 ; no error
	endIf
	return errorIDs[numErrors - 1]
endFunction

; -))

; ****************************************************************************************************************************************************************
; ************                                                                                                                                        ************
; ************                                             Hooks Definition                                                                           ************
; ************                                                                                                                                        ************
; ****************************************************************************************************************************************************************

; FIXME get the ones from the docs, and update the spdPerformance
