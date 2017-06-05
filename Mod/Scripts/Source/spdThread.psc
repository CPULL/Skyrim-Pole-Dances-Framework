Scriptname spdThread

int id
Actor dancer
spdPose startPose
spdRegistry Property registry Auto
float startTime
float duration
float totalTime
spdDance[] nextDances
spdDance currentDance
float currentAnimSpentTime
bool currentAnimStarted
ObjectReference refPole
bool poleCreated

string[] danceInitHooks
string[] danceStartingHooks
string[] danceStartedHooks
string[] danceChangedHooks
string[] poseUsedHooks
string[] danceEndingHooks
string[] danceEndedHooks


event OnUpdate()
	goToState("waiting")
endEvent

state waiting

	; Split the start and the init functions

	string function start(Actor a, ObjectReference pole = none, float time = -1.0)
		dancer = a
		; validate the actor and lock the actor and add it to the actors registry
		if  registry.allocateActor(dancer)
			return "The actor is not good: " + a
		endIf
		
		; Find a start position if missing
		if startPose==none
			startPose = registry.findRandomStartPose()
		endIf
		
		; Make it walk close to the pole (add a temporary marker)
		; TODO we may need to split this in a new state, not sure
		
		
		; Find all anims that can start with the specified position
		nextDances = registry.findDance(startPose)
		if nextDances==none || nextDances.length==0
			if startPose
				return "Could not find any valid Pole Dance (start position " + startPose.name + ")"
			else
				return "Could not find any valid Pole Dance (start position not defined)"
			endIf
		endIf
		
		if time==-1
			totalTime = Utility.randomFloat(30.0, 60.0)
		else
			totalTime = time
		endIf
		
		; Set the pole, or create one on the fly where the actor is
		if pole==none
			refPole = a.placeAtMe(spdPole)
			poleCreated = true
		else
			refPole = pole
			poleCreated = false
		endIf
		
		startTime = utility.getSystemRealTime()
		duration = 0.0
		currentAnimStarted = false
		RegisterForSingleUpdate(0.1)
		goToState("playing")
		
		sendEvent("PoleDanceStarted")
		
		return ""
	endFunction
	
	string function setStartPose(string pose)
		spdPose res = registry.findPose(pose)
		if res==none
			return "Could not find pose with name \"" + pose + "\"."
		endIf
		startPose = res
	endFunction
	
	float function setDancesAsString(string sPose="", string dances)
		; Split by commas then call the other function
		string[] dcs = StringUtil.split(dances, ",")
		return setDancesAsArray(dcs)
	endFunction

	float function setDancesAsArray(string sPose="", string[] dances)
		; Check if every single dance is known, and then generate the list (array) of all dances to be used. Return the total length of the dance
	endFunction
	
	event OnUpdate()
		goToState("waiting")
	endEvent
	
	string function addHook(string hookName, string eventName)
		; Check if the event name is valid, in case add the Hook to the specific event
		; 	<Hook>_DanceInit(tid, dance, actor)				--> Sent when the Dance is being initialized and the actor begins to walk to the pole
		; 	<Hook>_DanceStarting(tid, dance, actor, pose)	--> Sent when the Dance is starting and the initial animation is being played
		; 	<Hook>_DanceStarted(tid, dance, actor)			--> Sent when the very first dance is played
		; 	<Hook>_DanceChanged(tid, dance, actor)			--> Sent every time a dance is played
		;	<Hook>_PoseUsed(tid, dance, actor, pose)		--> Sent every time a pose is being used by an actor
		;	<Hook>_DanceEnding(tid, dance, actor, pose)		--> Sent when the last dance is completed and the ending anim is being played
		;	<Hook>_DanceEnded(tid, actor)					--> Sent when the dance is fully completed an dthe actor has been released

		string[] hooks
		if eventName=="DanceInit"
			hooks = danceInitHooks
		elseIf eventName=="DanceStarting"
			hooks = danceStartingHooks
		elseIf eventName=="DanceStarted"
			hooks = danceStartedHooks
		elseIf eventName=="DanceChanged"
			hooks = danceChangedHooks
		elseIf eventName=="PoseUsed"
			hooks = poseUsedHooks
		elseIf eventName=="DanceEnding"
			hooks = danceEndingHooks
		elseIf eventName=="DanceEnded"
			hooks = danceEndedHooks
		else
			return "Unkow event to register: " + eventName
		endIf
		if !hooks || hooks.length
			hooks = new String[1]
			hooks[0] = hookName
		elseIf hooks.find(hookName)==-1
			hooks = Utility.resizeStringArray(hooks, hooks.length + 1)
			hooks[hooks.length - 1] = hookName
		endIf
		
		return none
	endFunction
endState





state playing

	envent OnUpdate()
		; Do the progresses, currentAnimStarted checks if we already played the anim or not
		if nextDances==none || nextDances.length == 0
			; No more dances, we need to end
			goToState("ending")
			return;
		endIf

		float remainingTime = Utility.getSystemRealTime() - currentAnimStartTime
		if remainingTime<0.05
			; Calculate the next anim
			nextDances = registry.findDance(currentDance.startPose)
			if nextDances==none || nextDances.length==0
				; We need to end
				Utility.wait(dance.duration)
				goToState("ending")
			endIf
			currentAnimStarted = false
		
		endIf
		
		
		if currentAnimStarted
			; Just wait
			if remainingTime>5.0
				RegisterForSingleUpdate(5.0)
			else
				RegisterForSingleUpdate(remainingTime)
			endIf
			return
		
		else
			; pick one of the anim
			currentDance = nextDances[Utility.randomInt(0, nextDances.length - 1]
			
			; send the anim event
			debug.sendAnimationEvent(dancer, currentDance.hkx)
			currentAnimSpentTime = 0.0
			currentAnimStarted = true
			currentAnimStartTime = Utility.getSystemRealTime()
		
			sendEvent("PoleDanceDance" currentDance.name)
		endIf

		; Check if we have to end (depending on the expected time)
		durantion = Utility.getSystemRealTime() - startTime
		if duration + currentDance.duration > totalTime
			; We need to end
			Utility.wait(dance.duration)
			RegisterForSingleUpdate(0.05)
			goToState("ending")
		endIf
			
		RegisterForSingleUpdate(5.0)
	endEvent


	function stop()
		goToState("ending")
	endFunction
endState




state ending
	; Do what is needed to end the animation
	
	event OnUpdate()
		; Stop the anim
		
		; Get the endAnim that starts with the endPose of the curretn anim (if any)
		if currentDance
			if currentDance.endPose
				; Play it
				Debug.sendAnimationEvent(dancer, currentDance.endPose.endHKX)
				; Wait for the length
				Utility.wait(currentDance.endPose.endTime)
			endIf
		endIf
		
		; Release the actor
		registry.releaseActor(dancer)
	
		sendEvent("PoleDanceEnded")
		if poleCreated
			refPole.disable(true)
			Utility.wait(0.2)
			refPole.Delete(true)
		endIf
		
		dancer = none
		startPose = none
		startTime = 0.0
		duration = 0.0
		totalTime = 0.0
		nextDances = new spdDance[0]
		currentDance = none
		currentAnimSpentTime = 0.0
		currentAnimStarted = false
		refPole = none
		poleCreated = false
		
		goToState(waiting)
	endEvent
	
	
	function stop()
		UnregisterForUpdates()
		
		sendEvent("PoleDanceStopped")
		; Release the actor
		registry.releaseActor(dancer)
		
		if poleCreated
			refPole.disable(true)
			Utility.wait(0.2)
			refPole.Delete(true)
		endIf
		
		dancer = none
		startPose = none
		startTime = 0.0
		duration = 0.0
		totalTime = 0.0
		nextDances = new spdDance[0]
		currentDance = none
		currentAnimSpentTime = 0.0
		currentAnimStarted = false
		refPole = none
		poleCreated = false
		
		goToState(waiting)
	endFunction

endState






Function sendEvent(string eventName, string pose="")
	if eventName=="DanceInit"
		if danceInitHooks && danceInitHooks.length>0
			int i = danceInitHooks.length
			while i
				i-=1
				int modEvId = ModEvent.create(danceInitHooks[i] + "_DanceInit")
				ModEvent.pushInt(modEvId, id)
				ModEvent.pushForm(modEvId, dancer)
				if startPose
					ModEvent.pushString(modEvId, startPose.name)
				else
					ModEvent.pushString(modEvId, "")
				endIf
				ModEvent.send(modEvId)
			endWhile
		endIf
		if registry.useGlobalHook("DanceInit")
			int modEvId = ModEvent.create("GlobalDanceInit")
			ModEvent.pushInt(modEvId, id)
			ModEvent.pushForm(modEvId, dancer)
			if startPose
				ModEvent.pushString(modEvId, startPose.name)
			else
				ModEvent.pushString(modEvId, "")
			endIf
			ModEvent.send(modEvId)
		endIf
		
	elseIf eventName=="DanceStarting"
		if danceStartingHooks && danceStartingHooks.length>0
			int i = danceStartingHooks.length
			while i
				i-=1
				int modEvId = ModEvent.create(danceStartingHooks[i] + "_DanceStarting")
				ModEvent.pushInt(modEvId, id)
				ModEvent.pushForm(modEvId, dancer)
				if currentDance
					ModEvent.pushString(modEvId, currentDance.name)
				else
					ModEvent.pushString(modEvId, "")
				endIf
				if startPose
					ModEvent.pushString(modEvId, startPose.name)
				else
					ModEvent.pushString(modEvId, "")
				endIf
				ModEvent.send(modEvId)
			endWhile
		endIf
		if registry.useGlobalHook("DanceStarting")
			int modEvId = ModEvent.create("GlobalDanceStarting")
			ModEvent.pushInt(modEvId, id)
			ModEvent.pushForm(modEvId, dancer)
			if currentDance
				ModEvent.pushString(modEvId, currentDance.name)
			else
				ModEvent.pushString(modEvId, "")
			endIf
			if startPose
				ModEvent.pushString(modEvId, startPose.name)
			else
				ModEvent.pushString(modEvId, "")
			endIf
			ModEvent.send(modEvId)
		endIf
		
	elseIf eventName=="DanceStarted"
		if danceStartedHooks && danceStartedHooks.length>0
			int i = danceStartedHooks.length
			while i
				i-=1
				int modEvId = ModEvent.create(danceStartedHooks[i] + "_DanceStarted")
				ModEvent.pushInt(modEvId, id)
				ModEvent.pushForm(modEvId, dancer)
				if currentDance
					ModEvent.pushString(modEvId, currentDance.name)
				else
					ModEvent.pushString(modEvId, "")
				endIf
				ModEvent.send(modEvId)
			endWhile
		endIf
		if registry.useGlobalHook("DanceStarted")
			int modEvId = ModEvent.create("GlobalDanceChanged")
			ModEvent.pushInt(modEvId, id)
			ModEvent.pushForm(modEvId, dancer)
			if currentDance
				ModEvent.pushString(modEvId, currentDance.name)
			else
				ModEvent.pushString(modEvId, "")
			endIf
			ModEvent.send(modEvId)
		endIf
		
	elseIf eventName=="DanceChanged"
		if danceChangedHooks && danceChangedHooks.length>0
			int i = danceChangedHooks.length
			while i
				i-=1
				int modEvId = ModEvent.create(danceChangedHooks[i] + "_DanceChanged")
				ModEvent.pushInt(modEvId, id)
				ModEvent.pushForm(modEvId, dancer)
				if currentDance
					ModEvent.pushString(modEvId, currentDance.name)
				else
					ModEvent.pushString(modEvId, "")
				endIf
				ModEvent.send(modEvId)
			endWhile
		endIf
		if registry.useGlobalHook("DanceChanged")
			int modEvId = ModEvent.create("GlobalDanceChanged")
			ModEvent.pushInt(modEvId, id)
			ModEvent.pushForm(modEvId, dancer)
			if currentDance
				ModEvent.pushString(modEvId, currentDance.name)
			else
				ModEvent.pushString(modEvId, "")
			endIf
			ModEvent.send(modEvId)
		endIf
		
	elseIf eventName=="PoseUsed"
		if poseUsedHooks && poseUsedHooks.length>0
			int i = poseUsedHooks.length
			while i
				i-=1
				int modEvId = ModEvent.create(poseUsedHooks[i] + "_PoseUsed")
				ModEvent.pushInt(modEvId, id)
				ModEvent.pushForm(modEvId, dancer)
				if currentDance
					ModEvent.pushString(modEvId, currentDance.name)
				else
					ModEvent.pushString(modEvId, "")
				endIf
				ModEvent.pushString(modEvId, pose)
				ModEvent.send(modEvId)
			endWhile
		endIf
		if registry.useGlobalHook("DanceEnding")
			int modEvId = ModEvent.create("GlobalDanceEnding")
			ModEvent.pushInt(modEvId, id)
			ModEvent.pushForm(modEvId, dancer)
			if currentDance
				ModEvent.pushString(modEvId, currentDance.name)
			else
				ModEvent.pushString(modEvId, "")
			endIf
			ModEvent.pushString(modEvId, pose)
			ModEvent.send(modEvId)
		endIf
		
	elseIf eventName=="DanceEnding"
		if danceEndingHooks && danceEndingHooks.length>0
			int i = danceEndingHooks.length
			while i
				i-=1
				int modEvId = ModEvent.create(danceEndingHooks[i] + "_DanceEnding")
				ModEvent.pushInt(modEvId, id)
				ModEvent.pushForm(modEvId, dancer)
				if currentDance
					ModEvent.pushString(modEvId, currentDance.name)
				else
					ModEvent.pushString(modEvId, "")
				endIf
				ModEvent.pushString(modEvId, pose)
				ModEvent.send(modEvId)
			endWhile
		endIf
		if registry.useGlobalHook("DanceEnding")
			int modEvId = ModEvent.create("GlobalDanceEnding")
			ModEvent.pushInt(modEvId, id)
			ModEvent.pushForm(modEvId, dancer)
			if currentDance
				ModEvent.pushString(modEvId, currentDance.name)
			else
				ModEvent.pushString(modEvId, "")
			endIf
			ModEvent.pushString(modEvId, pose)
			ModEvent.send(modEvId)
		endIf
		
	elseIf eventName=="DanceEnded"
		if danceEndedHooks && danceEndedHooks.length>0
			int i = danceEndedHooks.length
			while i
				i-=1
				int modEvId = ModEvent.create(danceEndedHooks[i] + "_DanceEnded")
				ModEvent.pushInt(modEvId, id)
				ModEvent.pushForm(modEvId, dancer)
				ModEvent.send(modEvId)
			endWhile
		endIf
		if registry.useGlobalHook("DanceEnded")
			int modEvId = ModEvent.create("GlobalDanceEnded")
			ModEvent.pushInt(modEvId, id)
			ModEvent.pushForm(modEvId, dancer)
			ModEvent.send(modEvId)
		endIf
		
	else
		Debug.Trace("SPD: generated internally a non valid event: " + eventName)
		return
	endIf
endFunction

; Thread Hooks:
; 	<Hook>_DanceInit(tid, actor, pose)				--> Sent when the Dance is being initialized and the actor begins to walk to the pole
; 	<Hook>_DanceStarting(tid, actor, dance, pose)	--> Sent when the Dance is starting and the initial animation is being played
; 	<Hook>_DanceStarted(tid, actor, dance)			--> Sent when the very first dance is played
; 	<Hook>_DanceChanged(tid, actor, dance)			--> Sent every time a dance is played
;	<Hook>_PoseUsed(tid, actor, dance, pose)		--> Sent every time a pose is being used by an actor
;	<Hook>_DanceEnding(tid, actor, dance, pose)		--> Sent when the last dance is completed and the ending anim is being played
;	<Hook>_DanceEnded(tid, actor)					--> Sent when the dance is fully completed an dthe actor has been released
