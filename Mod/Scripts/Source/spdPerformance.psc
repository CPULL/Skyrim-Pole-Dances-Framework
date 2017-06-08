Scriptname spdPerformance

; FIXME Re-set the events, right now they are not perfect in timing and parameters
; FIXME Add the intro anim and the exit anim
; FIXME Add the walking to the pole
; FIXME Handle the sequence of dances by poses or dances or tags
; FIXME Add the code to handle the stripping
; FIXME Add a method to specify the next dance on the fly (to be used during events)
; FIXME Change the error generation by using the new way
; FIXME 
; FIXME 
; FIXME 
; FIXME 
; FIXME 
; FIXME 


string[] danceList
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



; FIXME Add inUse and use it for isValid
; FIXME add all functions to set the startPose, dances (as comma string, as array), tags
; FIXME Add internal function to find the next dance (by next pose, list, tags)
; FIXME Add function to reach the pole
; FIXME Add function to play intro anim for pose
; FIXME Add function to play ending anim for pose
; FIXME Add function to play the dance anim (timed)
; FIXME Add functions to strip and redress
; FIXME Add states after the first writing of the code
; FIXME 
; FIXME 
; FIXME 
; FIXME 

int id
spdPoleDances spdF
spdRegistry registry

bool isPerformanceValid = false
bool isPerformancePlaying = false
bool isPerformanceInUse = false
Actor dancer
ObjectReference pole
bool needPoleCreated
bool poleCreated
float duration
float startTime

spdPose startingPose
spdPose currentPose
spdDance currentDance
spdDance[] dances
spdTag[] tags


Function __doInit(spdPoleDances s)
	spdF = s
	registry = s.registry
	startingPose = None
	currentPose = None
	currentDance = None
	if dancer
		registry._releaseDancer(dancer)
	endIf
	dancer = none
	if pole && poleCreated
		spdT.removePole(pole)
	endIf
	pole = None
	poleCreated = false
	needPoleCreated = false
	dances = new spdDance[0]
	tags = new spdTag[0]
	isPerformancePlaying = false
	isPerformanceValid = false
endFunction


bool function isPlaying()
	return isPerformancePlaying
endFunction

bool function isInUse()
	return isPerformanceInUse
endFunction

bool function use(spdPoleDances s)
	if isPerformanceInUse
		s._addError(12, "Trying to use a performance that is already being used (" + id + ")", "Performance", "use")
		return true
	endIf

	isPerformanceInUse = true
	_doInit(s)
	return false
endFunction

bool function isValid()
	; Recalculate
	isPerformanceValid = (dancer!=None && pole!=none && (duration!=-1.0 || (dances!=None && dances.length>0) || (tags!=None && tags.length>0))
	return isValid
endFunction

Bool Function setBasicOption(Actor refDancer, ObjectReference refPole=none, float refDuration=-1.0)
	; Do nothing in case the performance is playing
	if isPerformancePlaying
		spdF._addError(11, "Cannot change a performance while it is playing", "spdPerformance", "setBasicOptions")
		return
	endIf
	if  registry._allocateActor(refDancer)
		return true ; The error is addded by the allocateActor
	endIf
	dancer = refDancer
	duration = refDuration ; FIXME in the start function we need to check if we have a list of anims, in case we don't then we need to set a duration
	; Set the pole, or create one on the fly where the actor is
	needPoleCreated = (refPole==none)
	pole = refPole ; in case it is not valid it will be generated when the performance will start
	isValid() ; To recalculate
	isPerformancePlaying = false
	return false
endFunction

bool Function setStartPose(string refStartingPose)
	; Do nothing in case the performance is playing
	if isPerformancePlaying
		spdF._addError(11, "Cannot change a performance while it is playing", "spdPerformance", "setStartPose")
		return
	endIf
	startingPose = registry.findPose(refStartingPose)
	if startingPose==None
		spdF._addError(20, "The requested starting pose \"" + refStartingPose + "\" does not exist", "Performance", "setStartPose")
		return true
	endIf
	; Clean the other stuff
	dances = new spdDance[0]
	tags = new spdTag[0]
	isValid() ; To recalculate
	return false
endFunction

Function setDuration(float refDuration=-1.0)
	; Do nothing in case the performance is playing
	if isPerformancePlaying
		spdF._addError(11, "Cannot change a performance while it is playing", "spdPerformance", "setDuration")
		return
	endIf
	if isPerformancePlaying
		return
	endIf
	duration = refDuration
	isValid() ; To recalculate
endFunction

bool Function setDancesString(string refDances)
	; Do nothing in case the performance is playing
	if isPerformancePlaying
		spdF._addError(11, "Cannot change a performance while it is playing", "spdPerformance", "setDancesString")
		return
	endIf
	string[] parts = StringUtil.Split(refDances, ",")
	if parts.length==0
		spdF._addError(21, "The requested dances are not valid", "Performance", "setDancesString")
		return true
	endIf
	int count = 0
	int i = 0
	string errs = ""
	while i<parts.length
		spdDance d = registry.findDance(parts[i]) ; It will get both actual dances and strips
		if d!=None
			count+=1
		else
			if errs==""
				errs+=parts[i]
			else
				errs+=","+parts[i]
			endIf
		endIf
		i+=1
	endWhile
	if count==0
		spdF._addError(22, "No one of the requested dances is valid", "Performance", "setDancesString")
		return true
	endIf
	if errs!=""
		spdF._addError(23, "[WARNING] Some of the dances are not valid: " + errs, "Performance", "setDancesString")
	endIf
	; Now allocate the array and fill it
	dances = new spdDance[count]
	i = 0
	count = 0
	while i<parts.length
		spdDance d = registry.findDance(parts[i]) ; It will get both actual dances and strips
		if d!=None
			dances[count] = d
			count+=1
		endIf
		i+=1
	endWhile
	; Clean the other stuff
	startingPose = None
	tags = new spdTag[0]
	isValid() ; To recalculate
	return false
endFunction

bool Function setDancesArray(string[] refDances)
	; Do nothing in case the performance is playing
	if isPerformancePlaying
		spdF._addError(11, "Cannot change a performance while it is playing", "spdPerformance", "setDancesArray")
		return
	endIf
	if !refDances || refDances.length==0
		spdF._addError(21, "The requested dances are not valid", "Performance", "setDancesArray")
		return true
	endIf
	int count = 0
	int i = 0
	string errs = ""
	while i<refDances.length
		spdDance d = registry.findDance(refDances[i]) ; It will get both actual dances and strips
		if d!=None
			count+=1
		else
			if errs==""
				errs+=refDances[i]
			else
				errs+=","+refDances[i]
			endIf
		endIf
		i+=1
	endWhile
	if count==0
		spdF._addError(22, "No one of the requested dances is valid", "Performance", "setDancesArray")
		return true
	endIf
	if errs!=""
		spdF._addError(23, "[WARNING] Some of the dances are not valid: " + errs, "Performance", "setDancesArray")
	endIf
	; Now allocate the array and fill it
	dances = new spdDance[count]
	i = 0
	count = 0
	while i<refDances.length
		spdDance d = registry.findDance(refDances[i]) ; It will get both actual dances and strips
		if d!=None
			dances[count] = d
			count+=1
		endIf
		i+=1
	endWhile
	; Clean the other stuff
	startingPose = None
	tags = new spdTag[0]
	isValid() ; To recalculate
	return false
endFunction

bool Function setTagsString(string refTags)
	; Do nothing in case the performance is playing
	if isPerformancePlaying
		spdF._addError(11, "Cannot change a performance while it is playing", "spdPerformance", "setTagsString")
		return
	endIf
	; Split in groups, then use a registry function to parse the actual sub-tags
	string[] parts = StringUtil.Split(refTags, ";")
	if parts.length==0
		spdF._addError(31, "The requested Tags are not valid", "Performance", "setTagsString")
		return true
	endIf
	
	int count = 0
	int i = 0
	string errs = ""
	while i<parts.length
		if registry.tryParseTags(parts[i])
			count+=1
		else
			if errs==""
				errs+=parts[i]
			else
				errs+=","+parts[i]
			endIf
		endIf
		i+=1
	endWhile
	if count==0
		spdF._addError(32, "No one of the requested tags is valid", "Performance", "setTagsString")
		return true
	endIf
	if errs!=""
		spdF._addError(33, "[WARNING] Some of the tags are not valid: " + errs, "Performance", "setTagsString")
	endIf
	; Now allocate the array and fill it
	tags = new spdTag[count]
	i = 0
	count = 0
	while i<parts.length
		spdTag t = registry.parseTag(parts[i])
		if t!=None
			tags[count] = t
			count+=1
		endIf
		i+=1
	endWhile
	; Clean the other stuff
	startingPose = None
	dances = new spdDance[0]
	isValid() ; To recalculate
	return false
endFunction

bool Function setTagsArray(string[] refTags)
	; Do nothing in case the performance is playing
	if isPerformancePlaying
		spdF._addError(11, "Cannot change a performance while it is playing", "spdPerformance", "setTagsArray")
		return
	endIf
	if !refTags || refTags.length==0
		spdF._addError(31, "The requested Tags are not valid", "Performance", "setDancesArray")
		return true
	endIf
	
	int count = 0
	int i = 0
	string errs = ""
	while i<refDances.length
		if registry.tryParseTags(refTags[i])
			count+=1
		else
			if errs==""
				errs+=refTags[i]
			else
				errs+=","+refTags[i]
			endIf
		endIf
		i+=1
	endWhile
	if count==0
		spdF._addError(32, "No one of the requested Tags is valid", "Performance", "setDancesArray")
		return true
	endIf
	if errs!=""
		spdF._addError(33, "[WARNING] Some of the Tags are not valid: " + errs, "Performance", "setDancesArray")
	endIf
	; Now allocate the array and fill it
	tags = new spdTag[count]
	i = 0
	count = 0
	while i<refTags.length
		spdTag t = registry.parseTag(refTags[i])
		if t!=None
			tags[count] = t
			count+=1
		endIf
		i+=1
	endWhile
	; Clean the other stuff
	startingPose = None
	dances = new spdDance[0]
	isValid() ; To recalculate
	return false
endFunction



bool function start(bool forceTransitions = true)
	if !isValid()
		spdF._addError(42, "The performance is not valid, it cannot be started", "Performance", "start")
		return true
	endIf
	if isPlaying()
		spdF._addError(41, "The performance is already playing, it cannot be started gain", "Performance", "start")
		return true
	endIf

	if startingPose && dances.length==0 && tags.length==0
		; Case startPose -> Find randomly dances (respect the sequence of poses) until the expected time is completed
		spdDance d = registry.findDanceByStartPose(startingPose)
		if !d
			spdF._addError(44, "Could not find a dance starting with pose \"" + startingPose.name + "\"", "Performance", "start")
			return true
		endIf
		dances = _addDance(dances, d)
		float calculatedDuration = d.duration
		while calculatedDuration<durantion
			spdPose endPose = d.endPose
			d = registry.findDanceByStartPose(endPose)
			if !d
				if forceTransitions
					spdF._addError(45, "Could not find an intermediate dance starting with pose \"" + endPose.name + "\"", "Performance", "start")
					return true
				endIf
				; Get any dance
				d = registry.findRandomDance()
			endIf
			calculatedDuration += d.duration
			dances = _addDance(dances, d)
		endWhile
		
	elseIf startingPose==None && dances.length>0 && tags.length==0
		; Case dances -> Add transitions in case the dances are not in sequence and the param is true
		if forceTransitions
			spdDance[] reDances = new spdDance[1]
			reDances[0] = dances[0]
			int i=1
			while i<dances.length
				spdDance next = dances[i]
				spdDance prev = reDances[reDances.length - 1]
				if prev.endPose != next.startPose
					; Add a transition
					spdDance d = registry.findTransitionDance(prev.endPose, next.startPose)
					if !d
						spdF._addError(45, "Could not find an intermediate dance starting with pose \"" + prev.endPose.name + "\" and starting with pose \"" + next.startPose.name + "\"", "Performance", "start")
						return true
					endIf
					if d
						reDances = _addDance(reDances, d)
					endIf
				endIf
				reDances = _addDance(reDances, next)
				i+=1
			endWhile
		endIf
		
	elseIf startingPose==None && dances.length>0 && tags.length==0
		; Case tags -> Find the dances (try to respect the transitions in case the param is true)
		
		
		
		
	else
		; Something wrong
		spdF._addError(43, "The performance seems to be not valid, it is not specifed what to perform", "Performance", "start")
		return true
	endIf

	if needPoleCreated
		pole = spdF.placePole(dancer, 50, 0)
		poleCreated = true
	else
		poleCreated = false
	endIf
	
	
	; Allocate the actor (block it) and start walking to the pole
	
	; Get the first pose of the first dance and start
	

endFunction


Function _addDance(spdDance[] orig, spdDance d)
	int num = orig.length
	orig = _reAllocateDances(orig, num + 1)
	orig[num] = d
	return orig
endFunction

Function _reAllocateDances(spdDance[] origDances, int num)
	spdDance[] newDances
	if num==1
		newDances = new spdDance[1]
	elseIf num==2
		newDances = new spdDance[2]
	elseIf num==3
		newDances = new spdDance[3]
	elseIf num==4
		newDances = new spdDance[4]
	elseIf num==5
		newDances = new spdDance[5]
	elseIf num==6
		newDances = new spdDance[6]
	elseIf num==7
		newDances = new spdDance[7]
	elseIf num==8
		newDances = new spdDance[8]
	elseIf num==9
		newDances = new spdDance[9]
	elseIf num==10
		newDances = new spdDance[10]
	elseIf num==11
		newDances = new spdDance[11]
	elseIf num==12
		newDances = new spdDance[12]
	elseIf num==13
		newDances = new spdDance[13]
	elseIf num==14
		newDances = new spdDance[14]
	elseIf num==15
		newDances = new spdDance[15]
	else
		newDances = new spdDance[16]
	endIf
	int i = origDances.length
	while i
		i-=1
		newDances[i] = origDances[i]
	endWhile
	return newDances
endFunction

Function abort(bool rightNow=false)
endFunction
	
state Waiting

	
	; FIXME Set the start position
	; FIXME Set the dances
	; FIXME Set the stripping
	; FIXME Set the tags
	; FIXME Set the timing
	; FIXME Set the hooks
	
	
	
	

	
		; Find a start position if missing and there are no dances
		if startPose==none && danceList.length==0
			startPose = registry.findRandomStartPose()
		endIf
		
		; Make it walk close to the pole (add a temporary marker)
		; TODO we may need to split this in a new state, not sure
		
		
		; Find all anims that can start with the specified position, in case we have one and not a dances list
		if startPose && danceList.length==0
			nextDances = registry.findDance(startPose)
			if nextDances==none || nextDances.length==0
				if startPose
					return "Could not find any valid Pole Dance (start position " + startPose.name + ")"
				else
					return "Could not find any valid Pole Dance (start position not defined)"
				endIf
			endIf
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
	
	function setDances(string[] names)
		danceList = names
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

; Performance Hooks:
; 	<Hook>_DanceInit(tid, actor, pose)				--> Sent when the Dance is being initialized and the actor begins to walk to the pole
; 	<Hook>_DanceStarting(tid, actor, dance, pose)	--> Sent when the Dance is starting and the initial animation is being played
; 	<Hook>_DanceStarted(tid, actor, dance)			--> Sent when the very first dance is played
; 	<Hook>_DanceChanged(tid, actor, dance)			--> Sent every time a dance is played
;	<Hook>_PoseUsed(tid, actor, dance, pose)		--> Sent every time a pose is being used by an actor
;	<Hook>_DanceEnding(tid, actor, dance, pose)		--> Sent when the last dance is completed and the ending anim is being played
;	<Hook>_DanceEnded(tid, actor)					--> Sent when the dance is fully completed an dthe actor has been released
