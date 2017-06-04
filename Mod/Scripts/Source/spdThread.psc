Scriptname spdThread

Actor dancer
spdPose startPose
spdRegistry Property registry Auto
float startTime
float duration
float totalTime
spdDance[] nextDances
spdDance currentDance
ObjectReference refPole
bool poleCreated


event OnUpdate()
	goToState("waiting")
endEvent

state waiting
	function start(Actor a, ObjectReference pole = none, float time = -1.0)
		dancer = a
		; TODO validate the actor
		; TODO lock the actor
		; TODO add it to the actors registry
		; TODO make it walk close to the pole (add a temporary marker)
		
		; TODO Find all anims that can start with the specified position
		if startPose==none
			startPose = registry.findRandomStartPose()
		endIf
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
		RegisterForSingleUpdate(0.1)
		goToState("playing")
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
		; Do the progresses
		
		
		; TODO we need to cycle way faster than the full lenght, we need some bool to understand if we completed the anim or not
		
		
		; pick one of the anim
		if nextDances==none || nextDances.lenght == 0
			; No more dances, we need to end
			goToState("ending")
			return;
		endIf
		
		currentDance = nextDances[Utility.randomInt(0, nextDances.length - 1]
		
		; send the anim event
		debug.sendAnimationEvent(dancer, currentDance.hkx)
		
		; Check if we have to end (depending on the expected time)
		durantion = Utility.getSystemRealTime() - startTime
		if duration + currentDance.duration > totalTime
			; We need to end
			Utility.wait(dance.duration)
			goToState("ending")
		endIf
			
		; Calculate the next anim
		nextDances = registry.findDance(currentDance.startPose)
		if nextDances==none || nextDances.lenght==0
			; We need to end
			Utility.wait(dance.duration)
			goToState("ending")
		endIf
			
		
		; wait for the lenght by invoking again the RegisterForSingleUpdate
		RegisterForSingleUpdate(min(5.0, remainingTime))
	endEvent


	function stop()
		goToState("ending")
	endFunction
endState

state ending
	; Do what is needed to end the animation
	
	function stop()
		; Release the actor
		
		startPose = none
		dancer = none
		
		goToState(waiting)
	endFunction

endState
