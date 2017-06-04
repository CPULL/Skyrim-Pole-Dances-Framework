Scriptname spdThread

Actor dancer

state waiting
	function start(Actor a, float time = -1.0)
		dancer = a
	endFunction
	
	functtion setStartPose(string pose)
	
	endFunction
endState

state playing

	function stop()
		; Release the actor
		
		
		goToState(waiting)
	endFunction
endState
