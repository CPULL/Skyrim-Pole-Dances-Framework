Scriptname spdPerformance extends ReferenceAlias

; FIXME Re-set the events, right now they are not perfect in timing and parameters
; FIXME Add functions to strip and redress
; FIXME Add a specific "Dance Name" to strip and redress (use the same way we do tags)
; FIXME Add a method to specify the next dance on the fly (to be used during events)
; FIXME Add stop() function
; FIXME Make private all functions that should be private
; FIXME 
; FIXME 
; FIXME 
; FIXME 
; FIXME 


spdPoleDances spdF
spdRegistry registry
bool _inUse

bool Property inUse
	bool Function get()
		return _inUse
	endFunction
endProperty

Function _allocate()
	_inUse = true
endFunction

Function _release()
	; Stop it, release actors if any
	startingPose = None
	currentDance = -1
	if dancer
		registry._releaseDancer(dancer)
		debug.trace("SPD: Performance of " + dancer.getDisplayName() + " ended")
	else
		debug.trace("SPD: Performance ended, the dancer was not here")
	endIf
	dancer = none
	if pole && poleCreated
		debug.trace("SPD: removed pole by Release")
		spdF.removePole(pole)
		pole = None
	endIf
	ObjectReference marker = poleRef.getReference()
	marker.delete()
	
	sentAnimEvent = ""
	pole = None
	poleCreated = false
	needPoleCreated = false
	int i=dances.length
	while i
		i-=1
		dances[i] = none
	endWhile
	numDances = 0
	i=tags.length
	while i
		i-=1
		tags[i] = none
	endWhile
	numTags = 0
	isPerformancePlaying = false
	isPerformanceValid = false
	i = performanceStartingHooks.length
	while i
		i-=1
		performanceStartingHooks[i]=""
		performanceBeginsHooks[i]=""
		performanceStartedHooks[i]=""
		danceChangingHooks[i]=""
		danceChangedHooks[i]=""
		poseUsedHooks[i]=""
		performanceEndingHooks[i]=""
		performanceEndedHooks[i]=""
	endWhile
	_inUse = false
	GoToState("")
endFunction


bool isPerformanceValid = false
bool isPerformancePlaying = false
Actor dancer
ObjectReference pole
bool needPoleCreated
bool poleCreated
float duration
float startTime
spdPose startingPose
spdDance[] dances
int numDances
spdTag[] tags
int numTags

string[] performanceStartingHooks
string[] performanceBeginsHooks
string[] performanceStartedHooks
string[] danceChangingHooks
string[] danceChangedHooks
string[] poseUsedHooks
string[] performanceEndingHooks
string[] performanceEndedHooks

int stoppedTimes
float prevWalkX
float prevWalkY

int currentDance
int prevDance
float timeToWait
float danceStartTime
float performaceStartTime
String sentAnimEvent

ReferenceAlias poleRef
Package walkPackage

Function _doInit(spdPoleDances s, ReferenceAlias refPole, Package refWalkPkg)
	spdF = s
	registry = s.registry
	startingPose = None
	currentDance = -1
	if dancer
		registry._releaseDancer(dancer)
	endIf
	dancer = none
	if pole && poleCreated
		debug.trace("SPD: removed pole by Init")
		spdF.removePole(pole)
		pole = None
	endIf
	pole = None
	poleCreated = false
	needPoleCreated = false
	dances = new spdDance[32]
	numDances = 0
	tags = new spdTag[32]
	numTags = 0
	_inUse = false
	isPerformancePlaying = false
	isPerformanceValid = false
	; Set the RefAlias and the package, they go together
	poleRef = refPole
	walkPackage = refWalkPkg
	performanceStartingHooks = new string[4]
	performanceBeginsHooks = new string[4]
	performanceStartedHooks = new string[4]
	performanceStartedHooks = new string[4]
	danceChangingHooks = new string[4]
	danceChangedHooks = new string[4]
	poseUsedHooks = new string[4]
	performanceEndingHooks = new string[4]
	performanceEndedHooks = new string[4]
endFunction


bool function isPlaying()
	return isPerformancePlaying
endFunction

bool function isValid()
	; Recalculate
	isPerformanceValid = (dancer!=None && pole!=none && (duration!=-1.0 || numDances>0 || numTags>0))
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
	duration = refDuration
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
	startingPose = registry.findPoseByName(refStartingPose)
	if startingPose==None
		spdF._addError(20, "The requested starting pose \"" + refStartingPose + "\" does not exist", "Performance", "setStartPose")
		return true
	endIf
	; Clean the other stuff
	while numDances
		numDances-=1
		dances[numDances] = None
	endWhile
	while numTags
		numTags-=1
		tags[numTags] = None
	endWhile
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
	
	numDances = count
	i = 0
	count = 0
	while i<numDances
		spdDance d = registry.findDanceByName(parts[i]) ; It will get both actual dances and strips
		if d!=None
			dances[count] = d
			count+=1
		endIf
		i+=1
	endWhile
	; Clean the other stuff
	startingPose = None
	while numTags
		numTags-=1
		tags[numTags] = None
	endWhile
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
	numDances = count
	i = 0
	count = 0
	while i<numDances
		spdDance d = registry.findDanceByName(refDances[i]) ; It will get both actual dances and strips
		if d!=None
			dances[count] = d
			count+=1
		endIf
		i+=1
	endWhile
	; Clean the other stuff
	startingPose = None
	while numTags
		numTags-=1
		tags[numTags] = None
	endWhile
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
	numTags = count
	i = 0
	while i<numTags
		tags[i] = registry.parseTags(parts[i])
		i+=1
	endWhile
	; Clean the other stuff
	startingPose = None
	while numDances
		numDances-=1
		dances[numDances] = None
	endWhile
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
		spdF._addError(61, "The requested Tags are not valid", "Performance", "setDancesArray")
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
		spdF._addError(62, "No one of the requested Tags is valid", "Performance", "setDancesArray")
		return true
	endIf
	if errs!=""
		spdF._addError(63, "[WARNING] Some of the Tags are not valid: " + errs, "Performance", "setDancesArray")
	endIf
	numTags = count
	i = 0
	while i<numTags
		tags[i] = registry.parseTags(refTags[i])
		i+=1
	endWhile
	; Clean the other stuff
	startingPose = None
	while numDances
		numDances-=1
		dances[numDances] = None
	endWhile
	isValid() ; To recalculate
	return false
endFunction



bool function start(bool forceTransitions = true)
	; If we miss the pole, create one
	if needPoleCreated
		pole = spdF.placePole(dancer, 190, 0)
		poleCreated = true
	else
		poleCreated = false
	endIf
	; Create the marker for the pole
	
	ObjectReference marker = dancer.placeAtMe(spdF.spdMarker, 1, false, false)
	float newAngle = pole.GetAngleZ() - 18.237
	if newAngle<0.0
		newAngle+=360.0
	endIf
	marker.moveTo(pole, Math.sin(newAngle) * -60.0, Math.cos(newAngle) * -60.0, 0.0, true)
	marker.setAngle(0.0, 0.0, pole.getAngleZ())
	poleRef.forceRefTo(marker)

	if !isValid()
		spdF._addError(42, "The performance is not valid, it cannot be started", "Performance", "start")
		_release()
		return true
	endIf
	if isPlaying()
		spdF._addError(41, "The performance is already playing, it cannot be started again", "Performance", "start")
		_release()
		return true
	endIf

	if startingPose && duration!=-1.0 && numDances==0 && numTags==0
debug.trace("SPD: --> case start pose -> init")
	
		; Case startPose -> Find randomly dances (respect the sequence of poses) until the expected time is completed
		spdDance d = registry.findDanceByPose(startingPose)
		if !d
			spdF._addError(44, "Could not find a dance starting with pose \"" + startingPose.name + "\"", "Performance", "start")
			_release()
			return true
		endIf
		dances[0] = d
		numDances = 1
		float calculatedDuration = d.duration
		while calculatedDuration<duration && numDances<dances.length
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
			dances[numDances] = d
			numDances+=1
		endWhile
		duration = calculatedDuration
debug.trace("SPD: --> case start pose -> end numDances=" + numDances)
		
	elseIf startingPose==None && numDances>0 && numTags==0
		; Case dances -> Add transitions in case the dances are not in sequence and the param is true
		if forceTransitions
			int i = numDances
			while i>0
				spdDance next = dances[i]
				spdDance prev = dances[i - 1]
				if next.startPose != prev.endPose
					; Check if we have a transition dance
					spdDance d = registry.findTransitionDance(prev.endPose, next.startPose)
					if d
						int j = numDances
						while j > i+1
							j-=1
							dances[j] = dances[j - 1]
						endWhile
						dances[i] = d
						numDances+=1
					else
						spdF._addError(45, "Could not find an intermediate dance starting with pose \"" + prev.endPose.name + "\" and starting with pose \"" + next.startPose.name + "\"", "Performance", "start")
					endIf
				endIf
			endWhile
		endIf
		
	elseIf startingPose==None && numDances==0 && numTags>0
		; Case tags -> Find the dances (try to respect the transitions in case the param is true)
		int i=0
		while i<numTags
			spdDance d = registry.findDanceByTags(tags[i])
			if !d
				spdF._addError(46, "Could not find a dance for tags \"" + tags[i].print() + "\"", "Performance", "start")
				return true
			endIf
			dances[numDances] = d
			numDances+=1
		endWhile
		if forceTransitions
			i = numDances
			while i>0
				spdDance next = dances[i]
				spdDance prev = dances[i - 1]
				if next.startPose != prev.endPose
					; Check if we have a transition dance
					spdDance d = registry.findTransitionDance(prev.endPose, next.startPose)
					if d
						int j = numDances
						while j > i+1
							j-=1
							dances[j] = dances[j - 1]
						endWhile
						dances[i] = d
						numDances+=1
					else
						spdF._addError(45, "Could not find an intermediate dance starting with pose \"" + prev.endPose.name + "\" and starting with pose \"" + next.startPose.name + "\"", "Performance", "start")
					endIf
				endIf
			endWhile
		endIf
		
	else
		; Something wrong
		spdF._addError(43, "The performance seems to be not valid, it is not specifed what to perform", "Performance", "start")
		_release()
		return true
	endIf

	sendEvent("PerformanceStarting")
	
	; Allocate the actor (block it) and start walking to the pole
	registry._lockActor(dancer, walkPackage)
	stoppedTimes = 0
	prevWalkX = 0.0
	prevWalkY = 0.0
	isPerformancePlaying = true

debug.trace("SPD: the pole dance should be starting")
	GoToState("Walking")
	return false
endFunction



Function abort(bool rightNow=false)
	if rightNow || GetState()!="Playing"
		_release()
		return
	endIf
	; TODO
	; Stop the current dance, and play the ending anim
	GoToState("Ending")
endFunction


state walking
	Event OnBeginState()
debug.trace("SPD: walking begin state")
		if dancer.getDistance(pole)<50
			RegisterForSingleUpdate(0.2)
		else
			RegisterForSingleUpdate(2.0)
		endIf
	endEvent
	
	Event OnUpdate()
		if stoppedTimes>5
debug.trace("SPD: teleporting " + dancer.getDisplayName())
			; Teleport in case there are no movements
			float zAngle = dancer.getAngleZ()
			GoToState("Playing")
			return
		endIf

debug.trace("SPD: " + dancer.getDisplayName() + " has distance = " + dancer.getDistance(pole) as int)
		; Wait until the actor is close, then remove the package, then start the intro anim
		if dancer.getDistance(pole) > 50
			if Math.abs(prevWalkX - dancer.x) < 2 && Math.abs(prevWalkY - dancer.y) < 2
				stoppedTimes+=1
				debug.trace("SPD: stopped " + stoppedTimes)
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
	debug.trace("SPD: " + dancer.getDisplayName() + " is dancing now")
		sendEvent("PerformanceStarted")
		registry._lockActor(dancer, registry.spdDoNothingPackage)
		currentDance = 0
		sendEvent("DanceChanging")
		prevDance = -1 ; This will play right now the first dance
debug.trace("SPD: " + dancer.getDisplayName() + " sending Start -> " + startingPose.startHKX)
		Debug.SendAnimationEvent(dancer, startingPose.startHKX)
		spdActor._removeWeapons(dancer)
		RegisterForSingleUpdate(startingPose.startTime - 0.1)
		performaceStartTime = Utility.getCurrentRealTime()
		sendEvent("DanceChanged")
		sendEvent("PerformanceStarted")
		Utility.wait(0.1)
		dancer.moveTo(pole, 0.0, 0.0, 0.0, false)
	endEvent
	
	Event OnUpdate()
		; Play the current dance and wait a little between re-checking
		if currentDance!=prevDance && currentDance!=-1
			; FIXME we should not resend the same animevent in case the previous one was cyclic
			if sentAnimEvent && dances[currentDance].hkx!=sentAnimEvent && dances[currentDance].isCyclic
				sentAnimEvent = dances[currentDance].hkx
			else
				sentAnimEvent = ""
			endIf
			if !sentAnimEvent
	debug.trace("SPD: " + dancer.getDisplayName() + " sending Dance -> " + dances[currentDance].hkx)
				Debug.sendAnimationEvent(dancer, dances[currentDance].hkx)
				spdActor._removeWeapons(dancer)
				prevDance = currentDance
				sendEvent("DanceChanged")
			endIf
			timeToWait = dances[currentDance].duration
			danceStartTime = Utility.getCurrentRealTime()
		endIf
		if timeToWait - timeSpentD < 0.1 && currentDance!=-1
			timeToWait = dances[currentDance].duration
			danceStartTime = Utility.getCurrentRealTime()
		endIf
		
		float timeSpentP = Utility.getCurrentRealTime() - performaceStartTime
		float timeSpentD = Utility.getCurrentRealTime() - danceStartTime
		if timeToWait - timeSpentD < 0.1
			timeToWait=0.0
			timeSpentD=0.0
		endIf
		
		if duration - timeSpentP < 0.5
			; Do the next dance
			if currentDance==numDances - 1
				GoToState("Ending")
				return
			endIf
			currentDance += 1
			sendEvent("DanceChanging")
			RegisterForSingleUpdate(0.1)
		elseIf duration - timeSpentP < 1.0
			RegisterForSingleUpdate(duration - timeSpentP - 0.1)
		elseIf timeToWait - timeSpentD < 0.1
			RegisterForSingleUpdate(0.1)
		elseIf timeToWait - timeSpentD < 1.0
			RegisterForSingleUpdate(timeToWait - timeSpentD - 0.2)
		else
			RegisterForSingleUpdate(1.0)
		endIf
	endEvent

endState

state Ending
	Event OnBeginState()
		sendEvent("PerformanceEnding")
		if dances[numDances - 1] && dances[numDances - 1].endPose
debug.trace("SPD: " + dancer.getDisplayName() + " sending End -> " + dances[numDances - 1].endPose.endHKX)
			Debug.SendAnimationEvent(dancer, dances[numDances - 1].endPose.endHKX)
			spdActor._removeWeapons(dancer)
			RegisterForSingleUpdate(dances[numDances - 1].endPose.endTime - 0.1)
		else
			RegisterForSingleUpdate(0.5) ; Quickly end in case of errors
		endIf
	endEvent
	
	Event OnUpdate()
		if poleCreated
			debug.trace("SPD: removed pole by Ending")
			spdF.removePole(pole)
			pole = None
		endIf
		registry._unlockActor(dancer)
		isPerformancePlaying = false
		sendEvent("PerformanceEnded")
		_release()
	endEvent
endState



; --------------------------------------------------------------------------------------------------------------------------------------------
; --------------------------------------------------------------------------------------------------------------------------------------------
; --------------------------------------------------------------------------------------------------------------------------------------------
; --------------------------------------------------------------------------------------------------------------------------------------------
	

	
string function addHook(string hookName, string eventName)
	; Check if the event name is valid, in case add the Hook to the specific event
	; 	<Hook>_PerformanceBegins(tid, actor)				--> Sent when the Dance is being initialized and the actor begins to walk to the pole
	; 	<Hook>_PerformanceStarting(tid, actor)	--> Sent when the Dance is starting and the initial animation is being played
	; 	<Hook>_PerformanceStarted(tid, actor)			--> Sent when the very first dance is played
	; 	<Hook>_DanceChanging(tid, actor, newDance)			--> Sent every time a dance is played
	; 	<Hook>_DanceChanged(tid, dance, actor)			--> Sent every time a dance is played
	;	<Hook>_PoseUsed(tid, dance, actor, pose)		--> Sent every time a pose is being used by an actor
	;	<Hook>_DanceEnding(tid, dance, actor, pose)		--> Sent when the last dance is completed and the ending anim is being played
	;	<Hook>_DanceEnded(tid, actor)					--> Sent when the dance is fully completed an dthe actor has been released

	string[] hooks
	if eventName=="PerformanceBegins"
		hooks = performanceBeginsHooks
	elseIf eventName=="PerformanceStarting"
		hooks = performanceStartingHooks
	elseIf eventName=="PerformanceStarted"
		hooks = performanceStartedHooks
	elseIf eventName=="DanceChanging"
		hooks = danceChangingHooks
	elseIf eventName=="DanceChanged"
		hooks = danceChangedHooks
	elseIf eventName=="PerformanceEnding"
		hooks = performanceEndingHooks
	elseIf eventName=="PerformanceEnded"
		hooks = performanceEndedHooks
	else
		return "Unknow event to register: " + eventName
	endIf
	if hooks.find(hookName)==-1
		int pos = hooks.find("")
		if pos!=-1
			hooks[pos] = hookName
		endIf
	endIf
	
	return none
endFunction


Function sendEvent(string eventName)

"PerformanceBegins"

	if eventName=="PerformanceStarting"
		if performanceStartingHooks && performanceStartingHooks.length>0
			int i = performanceStartingHooks.length
			while i
				i-=1
				int modEvId = ModEvent.create(performanceStartingHooks[i] + "_PerformanceStarting")
				ModEvent.pushInt(modEvId, getID())
				ModEvent.pushForm(modEvId, dancer)
				ModEvent.send(modEvId)
			endWhile
		endIf
		if registry.useGlobalHook("PerformanceStarting")
			int modEvId = ModEvent.create("GlobalPerformanceStarting")
			ModEvent.pushInt(modEvId, getID())
			ModEvent.pushForm(modEvId, dancer)
			ModEvent.send(modEvId)
		endIf
		
	elseIf eventName=="PerformanceStarted"
		if performanceStartedHooks && performanceStartedHooks.length>0
			int i = performanceStartedHooks.length
			while i
				i-=1
				int modEvId = ModEvent.create(performanceStartedHooks[i] + "_PerformanceStarted")
				ModEvent.pushInt(modEvId, getID())
				ModEvent.pushForm(modEvId, dancer)
				ModEvent.send(modEvId)
			endWhile
		endIf
		if registry.useGlobalHook("PerformanceStarted")
			int modEvId = ModEvent.create("GlobalPerformanceStarted")
			ModEvent.pushInt(modEvId, getID())
			ModEvent.pushForm(modEvId, dancer)
			ModEvent.send(modEvId)
		endIf
		
	elseIf eventName=="DanceChanging"
		if danceChangingHooks && danceChangingHooks.length>0
			int i = danceChangingHooks.length
			while i
				i-=1
				if currentDance!=-1 && dances[currentDance]
					int modEvId = ModEvent.create(danceChangingHooks[i] + "_DanceChanging")
					ModEvent.pushInt(modEvId, getID())
					ModEvent.pushForm(modEvId, dancer)
					ModEvent.pushString(modEvId, dances[currentDance].name)
					ModEvent.send(modEvId)
				endIf
			endWhile
		endIf
		if registry.useGlobalHook("DanceChanging") && currentDance!=-1 && dances[currentDance]
			int modEvId = ModEvent.create("GlobalDanceChanging")
			ModEvent.pushInt(modEvId, getID())
			ModEvent.pushForm(modEvId, dancer)
			ModEvent.pushString(modEvId, dances[currentDance].name)
			ModEvent.send(modEvId)
		endIf

	elseIf eventName=="DanceChanged"
		if danceChangedHooks && danceChangedHooks.length>0
			if currentDance!=-1 && dances[currentDance]
				int i = danceChangedHooks.length
				while i
					i-=1
					int modEvId = ModEvent.create(danceChangedHooks[i] + "_DanceChanged")
					ModEvent.pushInt(modEvId, getID())
					ModEvent.pushForm(modEvId, dancer)
					ModEvent.pushString(modEvId, dances[currentDance].name)
					ModEvent.send(modEvId)
				endWhile
			endIf
		endIf
		if registry.useGlobalHook("DanceChanged") && currentDance!=-1 && dances[currentDance]
			int modEvId = ModEvent.create("GlobalDanceChanged")
			ModEvent.pushInt(modEvId, getID())
			ModEvent.pushForm(modEvId, dancer)
			ModEvent.pushString(modEvId, dances[currentDance].name)
			ModEvent.send(modEvId)
		endIf

	elseIf eventName=="PerformanceEnding"
		if performanceEndingHooks && performanceEndingHooks.length>0
			int i = performanceEndingHooks.length
			while i
				i-=1
				int modEvId = ModEvent.create(performanceEndingHooks[i] + "_PerformanceEnding")
				ModEvent.pushInt(modEvId, getID())
				ModEvent.pushForm(modEvId, dancer)
				ModEvent.send(modEvId)
			endWhile
		endIf
		if registry.useGlobalHook("PerformanceEnding")
			int modEvId = ModEvent.create("GlobalPerformanceEnding")
			ModEvent.pushInt(modEvId, getID())
			ModEvent.pushForm(modEvId, dancer)
			ModEvent.send(modEvId)
		endIf
		
	elseIf eventName=="PerformanceEnded"
		if performanceEndedHooks && performanceEndedHooks.length>0
			int i = performanceEndedHooks.length
			while i
				i-=1
				int modEvId = ModEvent.create(performanceEndedHooks[i] + "_PerformanceEnded")
				ModEvent.pushInt(modEvId, getID())
				ModEvent.pushForm(modEvId, dancer)
				ModEvent.send(modEvId)
			endWhile
		endIf
		if registry.useGlobalHook("PerformanceEnded")
			int modEvId = ModEvent.create("GlobalPerformanceEnded")
			ModEvent.pushInt(modEvId, getID())
			ModEvent.pushForm(modEvId, dancer)
			ModEvent.send(modEvId)
		endIf
		
	else
		Debug.Trace("SPD: generated internally a non valid event: " + eventName)
		return
	endIf
endFunction


bool Function _isTagUsed(spdTag theTag)
	if !tags
		return false
	endIf
	return tags.find(theTag)!=-1
endFunction
