Scriptname spdPerformance extends ReferenceAlias

; FIXME Re-set the events, right now they are not perfect in timing and parameters
; FIXME Add functions to strip and redress
; FIXME Add a method to specify the next dance on the fly (to be used during events)
; FIXME Add stop() function
; FIXME Make private all functions that should be private
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
spdDance[] dances
spdTag[] tags

string[] danceInitHooks
string[] danceStartingHooks
string[] danceStartedHooks
string[] danceChangedHooks
string[] poseUsedHooks
string[] danceEndingHooks
string[] danceEndedHooks

int stoppedTimes
float prevWalkX
float prevWalkY

int currentDance
int prevDance
float timeToWait
float danceStartTime


Function _doInit(spdPoleDances s)
	spdF = s
	registry = s.registry
	startingPose = None
	currentDance = -1
	if dancer
		registry._releaseDancer(dancer)
	endIf
	dancer = none
	if pole && poleCreated
		spdF.removePole(pole)
	endIf
	pole = None
	poleCreated = false
	needPoleCreated = false
	dances = none ; new spdDance[0]
	tags = none ; new spdTag[0]
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
	isPerformanceValid = (dancer!=None && pole!=none && (duration!=-1.0 || (dances!=None && dances.length>0) || (tags!=None && tags.length>0)))
	return isPerformanceValid
endFunction

Bool Function setBasicOption(Actor refDancer, ObjectReference refPole=none, float refDuration=-1.0)
	; Do nothing in case the performance is playing
	if isPerformancePlaying
		spdF._addError(11, "Cannot change a performance while it is playing", "spdPerformance", "setBasicOptions")
		return true
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
		return true
	endIf
	startingPose = registry.findPose(refStartingPose)
	if startingPose==None
		spdF._addError(20, "The requested starting pose \"" + refStartingPose + "\" does not exist", "Performance", "setStartPose")
		return true
	endIf
	; Clean the other stuff
	dances = none
	tags = none
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
		return true
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
		if parts[i]==""
			spdF._addError(21, "The requested dances are not valid", "Performance", "setDancesString")
			return true
		endIf
		spdDance d = registry.findDanceByName(parts[i]) ; It will get both actual dances and strips
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
	dances = _reAllocateDances(dances, count)
	i = 0
	count = 0
	while i<parts.length
		spdDance d = registry.findDanceByName(parts[i]) ; It will get both actual dances and strips
		if d!=None
			dances[count] = d
			count+=1
		endIf
		i+=1
	endWhile
	; Clean the other stuff
	startingPose = None
	tags = None
	isValid() ; To recalculate
	return false
endFunction

bool Function setDancesArray(string[] refDances)
	; Do nothing in case the performance is playing
	if isPerformancePlaying
		spdF._addError(11, "Cannot change a performance while it is playing", "spdPerformance", "setDancesArray")
		return true
	endIf
	if !refDances || refDances.length==0
		spdF._addError(21, "The requested dances are not valid", "Performance", "setDancesArray")
		return true
	endIf
	int count = 0
	int i = 0
	string errs = ""
	while i<refDances.length
		spdDance d = registry.findDanceByName(refDances[i]) ; It will get both actual dances and strips
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
	dances = _reAllocateDances(dances, count)
	i = 0
	count = 0
	while i<refDances.length
		spdDance d = registry.findDanceByName(refDances[i]) ; It will get both actual dances and strips
		if d!=None
			dances[count] = d
			count+=1
		endIf
		i+=1
	endWhile
	; Clean the other stuff
	startingPose = None
	tags = none
	isValid() ; To recalculate
	return false
endFunction

bool Function setTagsString(string refTags)
	; Do nothing in case the performance is playing
	if isPerformancePlaying
		spdF._addError(11, "Cannot change a performance while it is playing", "spdPerformance", "setTagsString")
		return true
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
		if registry.tryToParseTags(parts[i])
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
	tags = _allocateTags(count)
	i = 0
	count = 0
	while i<parts.length
		spdTag t = registry.parseTags(parts[i])
		if t!=None
			tags[count] = t
			count+=1
		endIf
		i+=1
	endWhile
	; Clean the other stuff
	startingPose = None
	dances = none
	isValid() ; To recalculate
	return false
endFunction

bool Function setTagsArray(string[] refTags)
	; Do nothing in case the performance is playing
	if isPerformancePlaying
		spdF._addError(11, "Cannot change a performance while it is playing", "spdPerformance", "setTagsArray")
		return true
	endIf
	if !refTags || refTags.length==0
		spdF._addError(31, "The requested Tags are not valid", "Performance", "setDancesArray")
		return true
	endIf
	
	int count = 0
	int i = 0
	string errs = ""
	while i<refTags.length
		if registry.tryToParseTags(refTags[i])
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
	tags = _allocateTags(count)
	i = 0
	count = 0
	while i<refTags.length
		spdTag t = registry.parseTags(refTags[i])
		if t!=None
			tags[count] = t
			count+=1
		endIf
		i+=1
	endWhile
	; Clean the other stuff
	startingPose = None
	dances = none
	isValid() ; To recalculate
	return false
endFunction



bool function start(bool forceTransitions = true)
	if !isValid()
		spdF._addError(42, "The performance is not valid, it cannot be started", "Performance", "start")
		return true
	endIf
	if isPlaying()
		spdF._addError(41, "The performance is already playing, it cannot be started again", "Performance", "start")
		return true
	endIf

	if startingPose && duration!=-1.0 && dances.length==0 && tags.length==0
		; Case startPose -> Find randomly dances (respect the sequence of poses) until the expected time is completed
		spdDance d = registry.findDanceByPose(startingPose)
		if !d
			spdF._addError(44, "Could not find a dance starting with pose \"" + startingPose.name + "\"", "Performance", "start")
			return true
		endIf
		dances = _addDance(dances, d)
		float calculatedDuration = d.duration
		while calculatedDuration<duration
			spdPose endPose = d.endPose
			d = registry.findDanceByPose(endPose)
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
			startingPose = dances[0].startPose
			int i=1
			while i<dances.length
				spdDance next = dances[i]
				spdDance prev = reDances[reDances.length - 1]
				if prev.endPose != next.startPose
					; Add a transition
					spdDance d = registry.findTransitionDance(prev.endPose, next.startPose)
					if !d
						spdF._addError(45, "Could not find an intermediate dance starting with pose \"" + prev.endPose.name + "\" and starting with pose \"" + next.startPose.name + "\"", "Performance", "start")
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
		dances = none ; new spdDance[0]
		spdDance d = registry.findDanceByTags(tags[0])
		if !d && forceTransitions
			spdF._addError(46, "Could not find a dance for tags \"" + tags[i].print() + "\"", "Performance", "start")
			return true
		endIf
		_addDance(dances, d)
		startingPose = dances[0].startPose
		int i = 1
		while i<tags.length
			spdDance prev = dances[dances.length - 1]
			spdDance next = registry.findDanceByTags(tags[i])
			if next==none
				; missing dance, trace but don't stop
				spdF._addError(46, "Could not find a dance for tags \"" + tags[i].print() + "\"", "Performance", "start")
			else
				if prev.endPose != next.startPose && forceTransitions
					; Add a transition
					d = registry.findTransitionDance(prev.endPose, next.startPose)
					if !d
						spdF._addError(45, "Could not find an intermediate dance starting with pose \"" + prev.endPose.name + "\" and starting with pose \"" + next.startPose.name + "\"", "Performance", "start")
					endIf
					if d
						dances = _addDance(dances, d)
					endIf
				endIf
				_addDance(dances, next)
			endIf
		endWhile
		
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
	registry._lockActor(dancer, registry.spdWalkPackage, pole)
	if _calculateDistance(dancer, pole)<50
		RegisterForSingleUpdate(0.2)
	else
		RegisterForSingleUpdate(2.0)
	endIf
	stoppedTimes = 0
	prevWalkX = 0.0
	prevWalkY = 0.0
	isPerformancePlaying = true

	GoToState("Walking")
	return false
endFunction


spdDance[] Function _addDance(spdDance[] orig, spdDance d)
	int num = 0
	if orig
		num = orig.length
	endIf
	orig = _reAllocateDances(orig, num + 1)
	orig[num] = d
	return orig
endFunction

spdDance[] Function _reAllocateDances(spdDance[] origDances, int num)
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
	if origDances
		int i = origDances.length
		while i
			i-=1
			newDances[i] = origDances[i]
		endWhile
	endIf
	return newDances
endFunction

spdTag[] Function _allocateTags(int num)
	if num==0
		return none
	endIf
	spdTag[] newTags
	if num==1
		newTags = new spdTag[1]
	elseIf num==2
		newTags = new spdTag[2]
	elseIf num==3
		newTags = new spdTag[3]
	elseIf num==4
		newTags = new spdTag[4]
	elseIf num==5
		newTags = new spdTag[5]
	elseIf num==6
		newTags = new spdTag[6]
	elseIf num==7
		newTags = new spdTag[7]
	elseIf num==8
		newTags = new spdTag[8]
	elseIf num==9
		newTags = new spdTag[9]
	elseIf num==10
		newTags = new spdTag[10]
	elseIf num==11
		newTags = new spdTag[11]
	elseIf num==12
		newTags = new spdTag[12]
	elseIf num==13
		newTags = new spdTag[13]
	elseIf num==14
		newTags = new spdTag[14]
	elseIf num==15
		newTags = new spdTag[15]
	else
		newTags = new spdTag[16]
	endIf
	return newTags
endFunction



Function abort(bool rightNow=false)
	; TODO
endFunction


state walking
	Event OnUpdate()
		if stoppedTimes>5
			; Teleport in case there are no movements
			float zAngle = dancer.getAngleZ()
			dancer.moveTo(pole, Math.cos(zAngle) * 50.0, Math.sin(zAngle) * 50.0, 0, true)
			GoToState("Playing")
			return
		endIf
			
		; Wait until the actor is close, then remove the package, then start the intro anim
		if _calculateDistance(dancer, pole) > 50
			if Math.abs(prevWalkX - dancer.x) < 2 && Math.abs(prevWalkY - dancer.y) < 2
				stoppedTimes+=1
			endIf
			prevWalkX = dancer.x
			prevWalkY = dancer.y
		else
			GoToState("Playing")
			return
		endIf
		RegisterForSingleUpdate(0.5)
	endEvent
endState

state Playing
	Event OnBeginState()
		registry._lockActor(dancer, registry.spdDoNothingPackage, pole)
		currentDance = 0
		prevDance = -1 ; This will play right now the first dance
		Debug.SendAnimationEvent(dancer, startingPose.startHKX)
		RegisterForSingleUpdate(startingPose.startTime - 0.1)
	endEvent
	
	Event OnUpdate()
		; Play the current dance and wait a little between re-checking
		if currentDance!=prevDance
			Debug.sendAnimationEvent(dancer, dances[currentDance].hkx)
			timeToWait = dances[currentDance].duration
			danceStartTime = Utility.getCurrentRealTime()
			prevDance = currentDance
		endIf
		
		float timeToDo = Utility.getCurrentRealTime() - danceStartTime
		if timeToWait - timeToDo < 0.2
			; Do the next dance
			if currentDance==dances.length - 1
				GoToState("Ending")
				return
			endIf
			currentDance += 1
			RegisterForSingleUpdate(0.1)
		elseIf timeToWait - timeToDo < 1.0
			RegisterForSingleUpdate(timeToWait - timeToDo - 0.2)
		else
			RegisterForSingleUpdate(1.0)
		endIf
	endEvent

endState

state Ending
	Event OnBeginState()
		Debug.SendAnimationEvent(dancer, dances[dances.length - 1].endPose.endHKX)
		RegisterForSingleUpdate(dances[dances.length - 1].endPose.endTime - 0.1)
	endEvent
	
	Event OnUpdate()
		if poleCreated
			spdF.removePole(pole)
		endIf
		registry._unlockActor(dancer)
		isPerformancePlaying = false
		GoToState("")
	endEvent
endState



; --------------------------------------------------------------------------------------------------------------------------------------------
; --------------------------------------------------------------------------------------------------------------------------------------------
; --------------------------------------------------------------------------------------------------------------------------------------------
; --------------------------------------------------------------------------------------------------------------------------------------------
	

	
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


Function sendEvent(string eventName, string pose="")
	if eventName=="DanceInit"
		if danceInitHooks && danceInitHooks.length>0
			int i = danceInitHooks.length
			while i
				i-=1
				int modEvId = ModEvent.create(danceInitHooks[i] + "_DanceInit")
				ModEvent.pushInt(modEvId, id)
				ModEvent.pushForm(modEvId, dancer)
				if startingPose
					ModEvent.pushString(modEvId, startingPose.name)
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
			if startingPose
				ModEvent.pushString(modEvId, startingPose.name)
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
				if currentDance!=-1
					ModEvent.pushString(modEvId, dances[currentDance].name)
				else
					ModEvent.pushString(modEvId, "")
				endIf
				if startingPose
					ModEvent.pushString(modEvId, startingPose.name)
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
			if currentDance!=-1
				ModEvent.pushString(modEvId, dances[currentDance].name)
			else
				ModEvent.pushString(modEvId, "")
			endIf
			if startingPose
				ModEvent.pushString(modEvId, startingPose.name)
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
				if currentDance!=-1
					ModEvent.pushString(modEvId, dances[currentDance].name)
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
			if currentDance!=-1
				ModEvent.pushString(modEvId, dances[currentDance].name)
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
				if currentDance!=-1
					ModEvent.pushString(modEvId, dances[currentDance].name)
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
			if currentDance!=-1
				ModEvent.pushString(modEvId, dances[currentDance].name)
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
				if currentDance!=-1
					ModEvent.pushString(modEvId, dances[currentDance].name)
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
			if currentDance!=-1
				ModEvent.pushString(modEvId, dances[currentDance].name)
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
				if currentDance!=-1
					ModEvent.pushString(modEvId, dances[currentDance].name)
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
			if currentDance!=-1
				ModEvent.pushString(modEvId, dances[currentDance].name)
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


float Function _calculateDistance(ObjectReference a, ObjectReference b)
	return a.getDistance(b)
endFunction
