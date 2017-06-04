Scriptname spdThread

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


event OnUpdate()
	goToState("waiting")
endEvent

state waiting
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
	
	string functtion setStartPose(string pose)
		spdPose res = registry.findPose(pose)
		if res==none
			return "Could not find pose with name \"" + pose + "\"."
		endIf
		startPose = res
	endFunction
	
	event OnUpdate()
		goToState("waiting")
	endEvent
endState





state playing

	envent OnUpdate()
		; Do the progresses, currentAnimStarted checks if we already played the anim or not
		if nextDances==none || nextDances.lenght == 0
			; No more dances, we need to end
			goToState("ending")
			return;
		endIf

		float remainingTime = Utility.getSystemRealTime() - currentAnimStartTime
		if remainingTime<0.05
			; Calculate the next anim
			nextDances = registry.findDance(currentDance.startPose)
			if nextDances==none || nextDances.lenght==0
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
				; Wait for the lenght
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






Function sendEvent(string eventName, string danceName = "")
	; Check if we have global hooks
	; Send the global event with the id of the thread and the name of the dance and the actor
	; Check if we have local hooks
	; Send the local event with the id of the thread and the name of the dance and the actor
endFunction
