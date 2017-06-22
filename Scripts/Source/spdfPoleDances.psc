Scriptname spdfPoleDances Extends Quest


; ((- Properties

spdfRegistry Property registry Auto
Static[] Property spdfPoles Auto
Actor Property PlayerRef Auto
Package Property spdfDoNothingPackage Auto
Faction Property spdfDancingFaction Auto
Keyword Property spdfNoStrip Auto
MiscObject Property spdfMarker Auto

int currentVersion

int Property logMode Auto ; 0=Don't show anything, 1=show only errors in traces, 2=show logs and errors in traces, 3=MsgBox errors and traces for logs


; -))

; ((- Main functions

int Function getVersion()
	return 1
endFunction

Function _doInit()
debug.trace("SPDF: init doInit")
	if currentVersion != getVersion()
		_doUpdate()
	endIf
	currentVersion = getVersion()
	
	
	registry._doInit(Self) ; This will just check stuff, and call the mod event to have other mods to add their own dances
	registerPole(None) ; To clean up no more valid poles
	
	int modEvId = ModEvent.Create("SkyrimPoleDancesInitialized")
	ModEvent.pushInt(modEvId, currentVersion)
	ModEvent.send(modEvId)
debug.trace("SPDF: init completed")
endFunction

Function _doUpdate()
	; Nothing to do yet
endFunction

spdfPoleDances Function getInstance() Global
	return Game.GetFormFromFile(0x0012C4, "Skyrim Pole Dances Framework.esp") as spdfPoleDances
endFunction

; -))

; ****************************************************************************************************************************************************************
; ************                                                                                                                                        ************
; ************                                             Performances and QuickStart                                                                ************
; ************                                                                                                                                        ************
; ****************************************************************************************************************************************************************
; ((-

bool Function quickStart(Actor dancer, ObjectReference pole=None, float duration=-1.0, string startingPose="")
	spdfPerformance th = Registry._allocatePerformance()
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
		Debug.Trace("SPDF: problems starting a Pole Dance Performance.") ; FIXME
		return true
	endIf
	return false
endFunction

spdfPerformance Function newPerformance(Actor dancer, ObjectReference pole=None, float duration=-1.0)
	spdfPerformance th = Registry._allocatePerformance()
	if !th
		_addError(10, "No Performances available", "PoleDancesFramework", "newPerformance")
		return None
	endIf
	th.setBasicOption(dancer, pole, duration)
	return th
endFunction

spdfPerformance Function getPerformanceById(int performanceId)
	return registry.getPerformanceById(performanceId)
endFunction

spdfPerformance Function getGlobalPerformanceById(int performanceId) Global
	spdfPoleDances mySelf = Game.GetFormFromFile(0x0012C4, "Skyrim Pole Dances.esp") as spdfPoleDances
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
	
	if whichPole==-1
		; -1 : get it random
		int pos = spdfPoles.find(None)
		poleS = spdfPoles[Utility.randomInt(0, pos - 1)]
		if !poleS
			poleS = spdfPoles[0]
		endIf
	else
		; 0<max : get it but only if existing (not null)
		if whichPole<0 || whichPole>=spdfPoles.length
			whichPole = 0
		endIf
		poleS = spdfPoles[whichPole]
		if !poleS
			poleS = spdfPoles[0]
		endIf
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

Function registerPole(Static pole)
	; First, check for non valid poles, and clean them up
	int i=0
	while i<spdfPoles.length
		if !spdfPoles[i]
			Static p = none
			int j=i+1
			while j<spdfPoles.length
				if spdfPoles[j]
					p = spdfPoles[j]
					spdfPoles[j] = None
					j=1000
				endIf
				j+=1
			endWhile
			spdfPoles[i] = p
		endIf
		i+=1
	endWhile
	if !pole || spdfPoles.find(pole)!=-1
		return
	endIf
	int pos = spdfPoles.find(None)
	if pos==-1
		return
	endIf
	spdfPoles[pos] = pole
endFunction


; -))

; ****************************************************************************************************************************************************************
; ************                                                                                                                                        ************
; ************                                             Errors management                                                                          ************
; ************                                                                                                                                        ************
; ****************************************************************************************************************************************************************
; ((-




Function _addError(int id, string error, string source, string method)
	; In case the errors go to the log, do a trace
	; In case the errors for MsgBox, do it
	; In case of just tracing (id==-1 or id==0), put them in traces just if we really need them (option on MCM)

	if logMode==0
		return
	elseIf logMode==1
		if id>0
			debug.trace("SPDF: [" + id + "] " + error + " [" + source + "]." + method)
		endIf
	elseIf logMode==2
		debug.trace("SPDF: [" + id + "] " + error + " [" + source + "]." + method)
	elseIf logMode==3
		if id>0
			debug.messagebox("SPDF: [" + id + "]\n" + error + "\n[" + source + "]." + method)
		else
			debug.trace("SPDF: [" + id + "] " + error + " [" + source + "]." + method)
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

