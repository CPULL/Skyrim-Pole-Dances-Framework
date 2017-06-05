Scriptname spdPoleDances Extends Quest


spdRegistry registry

int currentVersion

int Function getVersion()
	return 1
endFunction

Function doInit()
	if currentV != getVersion()
		doUpdate()
	endIf
	currentVersion = getVersion()
	
	registry.reInit() ; This will just check stuff, and call the mod event to have other mods to add their own dances
	
	int modEvId = ModEvent.Create("SkyrimPoleDancesInitialized")
	ModEvent.pushInt(modEvId, currentVersion)
	ModEvent.send(modEvId)
endFunction

Function doUpdate()
	; Nothing to do yet
	registry.doInit() ; This will initialize all arrays
endFunction


; ****************************************************************************************************************************************************************
; ************                                                                                                                                        ************
; ************                                             Threads and QuickStart                                                                     ************
; ************                                                                                                                                        ************
; ****************************************************************************************************************************************************************

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

; ****************************************************************************************************************************************************************
; ************                                                                                                                                        ************
; ************                                                Poles                                                                                   ************
; ************                                                                                                                                        ************
; ****************************************************************************************************************************************************************

Static Property mainPole
Actor Property PlayerRef Auto

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
	pole.delete(true)
endFunction


; ****************************************************************************************************************************************************************
; ************                                                                                                                                        ************
; ************                                             Hooks Definition                                                                           ************
; ************                                                                                                                                        ************
; ****************************************************************************************************************************************************************

; Thread Hooks:
; 	<Hook>_DanceInit(tid, actor, pose)				--> Sent when the Dance is being initialized and the actor begins to walk to the pole
; 	<Hook>_DanceStarting(tid, actor, dance, pose)	--> Sent when the Dance is starting and the initial animation is being played
; 	<Hook>_DanceStarted(tid, actor, dance)			--> Sent when the very first dance is played
; 	<Hook>_DanceChanged(tid, actor, dance)			--> Sent every time a dance is played
;	<Hook>_PoseUsed(tid, actor, dance, pose)		--> Sent every time a pose is being used by an actor
;	<Hook>_DanceEnding(tid, actor, dance, pose)		--> Sent when the last dance is completed and the ending anim is being played
;	<Hook>_DanceEnded(tid, actor)					--> Sent when the dance is fully completed an dthe actor has been released
; Global Hooks:
; 	GlobalDanceInit(tid, actor, pose)				--> Sent when the Dance is being initialized and the actor begins to walk to the pole
; 	GlobalDanceStarting(tid, actor, dance, pose)	--> Sent when the Dance is starting and the initial animation is being played
; 	GlobalDanceStarted(tid, actor, dance)			--> Sent when the very first dance is played
; 	GlobalDanceChanged(tid, actor, dance)			--> Sent every time a dance is played
;	GlobalPoseUsed(tid, actor, dance, pose)			--> Sent every time a pose is being used by an actor
;	GlobalDanceEnding(tid, actor, dance, pose)		--> Sent when the last dance is completed and the ending anim is being played
;	GlobalDanceEnded(tid, actor)					--> Sent when the dance is fully completed an dthe actor has been released
; System hooks
;	SkyrimPoleDancesRegistryUpdated(version, registry)	--> Sent when the registry is being updated (to allow to add further dances)
;	SkyrimPoleDancesInitialized(version)				--> Sent when the mod is fully initialized and can be used
