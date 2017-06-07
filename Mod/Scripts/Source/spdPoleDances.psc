Scriptname spdPoleDances Extends Quest

; FIXME add the startThread with tags
; FIXME add a global way to report errors


; ((- Properties

spdRegistry Property registry Auto
Static Property mainPole
Actor Property PlayerRef Auto
Package Property spdDoNothingPackage Auto
Faction Property spdDancingFaction Auto

int currentVersion


; -))


int Function getVersion()
	return 1
endFunction

Function _doInit()
	if currentV != getVersion()
		_doUpdate()
	endIf
	currentVersion = getVersion()
	
	registry.reInit(currentVersion, Self) ; This will just check stuff, and call the mod event to have other mods to add their own dances
	
	errors = new string[32]
	errorSources = new string[32]
	errorMethods = new string[32]
	numErrors = 0
	
	int modEvId = ModEvent.Create("SkyrimPoleDancesInitialized")
	ModEvent.pushInt(modEvId, currentVersion)
	ModEvent.send(modEvId)
endFunction

Function _doUpdate()
	; Nothing to do yet
	registry._doInit(getVersion(), Self) ; This will initialize all arrays
endFunction


; ****************************************************************************************************************************************************************
; ************                                                                                                                                        ************
; ************                                             Threads and QuickStart                                                                     ************
; ************                                                                                                                                        ************
; ****************************************************************************************************************************************************************
; ((-

bool Function quickStart(Actor dancer, ObjectReference pole=None, float duration=-1.0, string startingPose="")
	spdThread th = Registry._allocateThread()
	if !th
		_addError(10, "No threads available", "PoleDancesFramework", "QuickStart")
		return true
	endIf
	th._doInit()
	th.setBasicOption(dancer, pole, duration)
	th.setStartingPose(startingPose)
	if th.start()
		Debug.Trace("SPD: problems starting a Pole Dance Thread.") ; FIXME
		return true
	endIf
	return false
endFunction

spdThread Function newThread(Actor dancer, ObjectReference pole=None, float duration=-1.0)
	spdThread th = Registry._allocateThread(dancer, pole, duration)
	if !th
		_addError(10, "No threads available", "PoleDancesFramework", "QuickStart")
		return None
	endIf
	th._doInit()
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

ObjectReference Function placePole(ObjectReference location = None, float distance = 0.0, float rotation = 0.0)
	ObjectRef re = location
	if !ref
		ref = PlayerRef
	endIf
	
	float zAngle = ref.getAngleZ()
	return location.placeAtMe(mainPole, Math.cos(zAngle + rotation) * distance, Math.sin(zAngle + rotation) * distance, ref.z, true)
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

string[] errors
string[] errorSources
string[] errorMethods
int[] errorIDs
int numErrors

Function _addError(int id, string error, string source, string method)
	if numErrors == errors.length
		dumpErrors()
	endIf
	errors[numErrors] = error
	errorSources[numErrors] = source
	errorMethods[numErrors] = method
	errorIDs[numErrors] = id
	numErrors+=1
endFunction

; ((- Error IDs
; 0 not an error
; 1 not valid actor (generic, as fallback)
; 2 the actor is "None"
; 3 the actor is performing an activity that will make impossible to dance, or is a child
; 4 an actor is already used for another dance
; 10 No more threads available
; -))

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

; get the ones from the docs, and update the spdThread
