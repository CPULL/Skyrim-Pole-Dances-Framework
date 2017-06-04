Scriptname spdThread

Actor dancer
spdPose startPose
spdRegistry Property registry Auto
float startTime
float duration
spdDance[] nextDances


event OnUpdate()
	goToState("waiting")
endEvent

state waiting
	function start(Actor a, float time = -1.0)
		dancer = a
		; TODO validate the actor
		; TODO lock the actor
		; TODO add it to the actors registry
		; TODO make it walk close to the pole (add a temporary marker)
		
		; TODO Find all anims that can start with the specified position
		if startPose==none
		
		endIf
			nextDances = registry.findDance(startPose)
		
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
	
	endEvent


	function stop()
		; Release the actor
		
		startPose = none
		dancer = none
		
		goToState(waiting)
	endFunction
endState
