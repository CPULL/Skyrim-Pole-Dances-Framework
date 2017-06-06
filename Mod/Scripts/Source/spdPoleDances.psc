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
	spdThread th = newThread(dancer, pole, duration, startingPose)
	if !th
		Debug.Trace("SPD: problems initializing a Pole Dance Thread.")
		return true
	endIf
	if th.start()
		Debug.Trace("SPD: problems starting a Pole Dance Thread.")
		return true
	endIf
	return false
endFunction

spdThread Function newThreadPose(Actor dancer, ObjectReference pole=None, float duration=-1.0, string startingPose="")
	spdThread th = registry.getThread()
	th.initThread(dancer, pole, duration)
	th.setStartPose(startingPose)
	return th
endFunction

spdThread Function newThreadDances(Actor dancer, ObjectReference pole=None, float duration=-1.0, string dances)
	spdThread th = registry.getThread()
	th.initThread(dancer, pole, duration)
	
	string[] dcs = StringUtil.Split(dances, ",")
	int count = 0
	int i = 0
	while i<dcs.length
		spdDance d = registry.getDance(dcs[i])
		if d
			count+=1
		endIf
		i+=1
	endWhile
	if count==0
		Debug.Trace("SPD: could not find any valid dance in: " + dances)
		return none
	endIf
	string[] dtu = Utility.CreateStringArray(count)
	i=0
	count=0
	while i<dcs.length
		spdDance d = registry.getDance(dcs[i])
		if d
			dtu[count] = d.name
			count+=1
		endIf
		i+=1
	endWhile
	th.setDances(dtu)
	return th
endFunction

spdThread Function newThreadDancesArray(Actor dancer, ObjectReference pole=None, float duration=-1.0, string[] dances)
	spdThread th = registry.getThread()
	th.initThread(dancer, pole, duration)
	th.setDances(dances)
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
; ************                                             Hooks Definition                                                                           ************
; ************                                                                                                                                        ************
; ****************************************************************************************************************************************************************

; get the ones from the docs, and update the spdThread
