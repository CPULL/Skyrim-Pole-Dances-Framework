Scriptname spdPoleDances Extends Quest

; function to set/delete a pole (as Static object)


; Hooks (global and per-thread)

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
	
	int modEvId = ModEvent.Create(SkyrimPoleDancesInitialized)
	ModEvent.pushInt(modEvId, currentVersion)
	ModEvent.send(modEvId)
endFunction

Function doUpdate()
	; Nothing to do yet
	registry.doInit() ; This will initialize all arrays
endFunction


bool Function quickStart(Actor dancer, ObjectReference pole=None, float duration=-1.0, string startingPosition="")
	spdThread = setThread(dancer, pole, duration, startingPosition)
	if !spdThread
		Debug.Trace("SPD: problems initializing a Pole Dance Thread.")
		return true
	endIf
	if spdThread.start()
		Debug.Trace("SPD: problems starting a Pole Dance Thread.")
		return true
	endIf
	return false
endFunction

spdThread Function setThread(Actor dancer, ObjectReference pole=None, float duration=-1.0, string startingPosition="")
	return blahBlahBlah
endFunction

; TODO, give the ability to provide a set of dances, identified by names (array, or comma separated list)

; ***********************************************************************************************************************************
; ************************************************************** Hooks **************************************************************
; ***********************************************************************************************************************************

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
