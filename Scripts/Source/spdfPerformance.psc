Scriptname spdfPerformance extends ReferenceAlias

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


spdfPoleDances spdF
spdfRegistry registry
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
		spdF._addError(0, "Performance of " + dancer.getDisplayName() + " ended", "Performance", "Release")
	elseIf inUse
		spdF._addError(0, "Performance ended, the dancer was not here", "Performance", "Release")
	endIf
	dancer = none
	if pole && poleCreated
		spdF.removePole(pole)
		pole = None
	endIf
	ObjectReference marker = poleRef.getReference()
	if marker
		marker.delete()
	endIf
	
	pole = None
	poleCreated = false
	needPoleCreated = false
	int i=dances.length
	while i
		i-=1
		if dances[i] && dances[i].inUse==1 && dances[i].isStrip
			(dances[i] as spdfStrip)._releaseStrip()
		endIf
		dances[i] = none
		dancesTime[i] = 0.0
	endWhile
	numDances = 0
	i=tags.length
	while i
		i-=1
		tags[i] = none
	endWhile
	numTags = 0
	registry.cleanUpTags()
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
spdfActor dancerC
ObjectReference pole
bool needPoleCreated
bool poleCreated
float duration
float startTime
spdfPose startingPose
spdfBase[] dances
float[] dancesTime
int numDances
spdfTag[] tags
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

ReferenceAlias poleRef
Package walkPackage

Function _doInit(spdfPoleDances s, ReferenceAlias refPole, Package refWalkPkg)
	spdF = s
	registry = s.registry
	startingPose = None
	currentDance = -1
	if dancer
		registry._releaseDancer(dancer)
	endIf
	dancer = none
	if pole && poleCreated
		debug.trace("SPDF: removed pole by Init")
		spdF.removePole(pole)
		pole = None
	endIf
	pole = None
	poleCreated = false
	needPoleCreated = false
	dances = new spdfBase[32]
	dancesTime = new Float[32]
	numDances = 0
	tags = new spdfTag[32]
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
	ofasList = new spdfStrip[8]
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
	dancerC = registry._allocateActor(refDancer)
	if !dancerC
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
		spdfBase d = registry.findDanceByName(parts[i]) ; It will get both actual Dances and Strips
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
		spdfBase d = registry.findDanceByName(parts[i]) ; It will get both actual dances and strips
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
		spdfBase d = registry.findDanceByName(refDances[i]) ; It will get both actual dances and strips
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
		spdfBase d = registry.findDanceByName(refDances[i]) ; It will get both actual dances and strips
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

bool Function setDancesObject(spdfBase[] refDances)
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
		spdfBase d = refDances[i]
		if d!=None
			count+=1
		endIf
		i+=1
	endWhile
	if count==0
		spdF._addError(22, "No one of the requested dances is valid", "Performance", "setDancesArray")
		return true
	endIf
	; Now allocate the array and fill it
	numDances = count
	i = 0
	count = 0
	while i<numDances
		spdfBase d = refDances[i]
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


bool Function setTimersString(string timers)
	; Do nothing in case the performance is playing
	if isPerformancePlaying
		spdF._addError(11, "Cannot change a performance while it is playing", "spdPerformance", "setTimersString")
		return true
	endIf
	string[] parts = StringUtil.Split(timers, ",")
	if parts.length==0
		spdF._addError(99, "The requested timers are not valid", "Performance", "setTimersString") ; FIXME
		return true
	endIf
	int count = 0
	int i = 0
	string errs = ""
	if numDances!=parts.length
		spdF._addError(99, "The number of timers does not match the number of dances", "Performance", "setTimersString") ; FIXME
		return true
	endIf
	
	while i<parts.length
		if parts[i]==""
			spdF._addError(99, "The timer requested in position " + (i+1) + " is empty", "Performance", "setTimersString") ; FIXME
		endIf
		dancesTime[i] = 0.0
		dancesTime[i] = parts[i] as float
		i+=1
	endWhile
	return false
endFunction

bool Function setTimersArray(float[] timers)
	; Do nothing in case the performance is playing
	if isPerformancePlaying
		spdF._addError(11, "Cannot change a performance while it is playing", "spdPerformance", "setTimersArray")
		return true
	endIf
	int i = 0
	while i<numDances
		dancesTime[i] = 0.0
		if i<timers.length
			dancesTime[i] = timers[i]
		endIf
		if dancesTime[i] < 0.0
			dancesTime[i] = 0.0
		endIf
		i+=1
	endWhile
	return false
endFunction

bool Function setTimer(int index, float timer)
	; Do nothing in case the performance is playing
	if isPerformancePlaying
		spdF._addError(11, "Cannot change a performance while it is playing", "spdPerformance", "setTimer")
		return true
	endIf
	if index<0 || index>=numDances
		spdF._addError(99, "The timer cannot be set, because there is no dance in position " + index, "Performance", "setTimer") ; FIXME
		return true
	endIf
	if timer<0.0
		spdF._addError(99, "The timer cannot be set, only positive or zero durations are allowed (" + timer + ")", "Performance", "setTimer") ; FIXME
		return true
	endIf
	dancesTime[index] = timer
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
	ObjectReference marker = dancer.placeAtMe(spdF.spdfMarker, 1, false, false)
	float newAngle = pole.GetAngleZ() - 12.26
	if newAngle<0.0
		newAngle+=360.0
	endIf
	marker.moveTo(pole, Math.sin(newAngle) * -100.0, Math.cos(newAngle) * -100.0, 0.0, true)
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
		; Case startPose -> Find randomly dances (respect the sequence of poses) until the expected time is completed
		spdfDance d = registry.findDanceByPose(startingPose)
		if !d
			spdF._addError(44, "Could not find a dance starting with pose \"" + startingPose.name + "\"", "Performance", "start")
			_release()
			return true
		endIf
		dances[0] = d
		numDances = 1
		float calculatedDuration = d.duration
		while calculatedDuration<duration && numDances<dances.length
			spdfPose endPose = d.endPose
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
		
	elseIf startingPose==None && numDances>0 && numTags==0
		; Case dances -> Add transitions in case the dances are not in sequence and the param is true
		
		if forceTransitions
			int i = numDances
			while i>1
				i-=1
				spdfBase next = dances[i]
				spdfBase prev = dances[i - 1]
				if next && prev && next.isDance && prev.isDance
					if (next as spdfDance).startPose != (prev as spdfDance).endPose && !prev.isStrip && !next.isStrip
						; Check if we have a transition dance
						spdfDance d = registry.findTransitionDance((prev as spdfDance).endPose, (next as spdfDance).startPose)
						if d
							numDances+=1
							int j = numDances
							while j > i+1
								j-=1
								dances[j] = dances[j - 1]
								dancesTime[j] = dancesTime[j - 1]
							endWhile
							dances[i] = d
							dancesTime[i] = d.duration
						else
							if (prev as spdfDance).endPose && (next as spdfDance).startPose
								spdF._addError(45, "Could not find an intermediate dance starting with pose \"" + (prev as spdfDance).endPose.name + "\" and starting with pose \"" + (next as spdfDance).startPose.name + "\"", "Performance", "start")
							elseIf (prev as spdfDance).endPose
								spdF._addError(45, "Could not find an intermediate dance starting with pose \"" + (prev as spdfDance).endPose.name + "\" and starting with pose from dance \"" + next.name + "\"", "Performance", "start")
							elseIf (next as spdfDance).startPose
								spdF._addError(45, "Could not find an intermediate dance starting with pose from dance \"" + prev.name + "\" and starting with pose \"" + (next as spdfDance).startPose.name + "\"", "Performance", "start")
							else
								spdF._addError(45, "Could not find an intermediate dance starting with pose from dance \"" + prev.name + "\" and starting with pose from dance \"" + next.name + "\"", "Performance", "start")
							endIf
						endIf
					endIf
				endIf
			endWhile
		endIf
		; Find the start pose of the first anim and calculate the resulting duration
		int i = 0
		while i<numDances && !startingPose
			if dances[i] && dances[i].isDance
				startingPose = (dances[i] as spdfDance).startPose
			endIf
			i+=1
		endWhile
		if duration==-1.0
			duration=0.0
			i=dances.length
			while i
				i-=1
				if dances[i] && dances[i].inUse==1
					if dancesTime[i]!=0.0
						duration += dancesTime[i]
					else
						duration += dances[i].duration
					endIf
				endIf
			endWhile
		endIf
		
	elseIf startingPose==None && numDances==0 && numTags>0
		; Case tags -> Find the dances (try to respect the transitions in case the param is true)
		int i=0
		while i<numTags
			spdfBase d = registry.findDanceByTags(tags[i])
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
				spdfBase next = dances[i]
				spdfBase prev = dances[i - 1]
				if next.isDance && prev.isDance && (next as spdfDance).startPose != (prev as spdfDance).endPose
					; Check if we have a transition dance
					spdfDance d = registry.findTransitionDance((prev as spdfDance).endPose, (next as spdfDance).startPose)
					if d
						int j = numDances
						while j > i+1
							j-=1
							dances[j] = dances[j - 1]
						endWhile
						dances[i] = d
						numDances+=1
					else
						spdF._addError(45, "Could not find an intermediate dance starting with pose \"" + (prev as spdfDance).endPose.name + "\" and starting with pose \"" + (next as spdfDance).startPose.name + "\"", "Performance", "start")
					endIf
				endIf
			endWhile
		endIf
		; Find the start pose of the first anim and calculate the resulting duration
		i = 0
		while i<numDances && !startingPose
			if dances[i] && dances[i].isDance
				startingPose = (dances[i] as spdfDance).startPose
			endIf
			i+=1
		endWhile
		if duration==-1.0
			duration=0.0
			i=dances.length
			while i
				i-=1
				if dances[i] && dances[i].inUse==1
					if dancesTime[i]!=0.0
						duration += dancesTime[i]
					else
						duration += dances[i].duration
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
	
	; fill the timers with the default in case they are zero
	int i = dances.length
	while i
		i-=1
		spdfBase b = dances[i]
		if b && dancesTime[i] == 0.0
			dancesTime[i] = b.duration
		endIf
	endWhile

	sendEvent("PerformanceStarting")
	
	; Allocate the actor (block it) and start walking to the pole
	registry._lockActor(dancer, walkPackage)
	stoppedTimes = 0
	prevWalkX = 0.0
	prevWalkY = 0.0
	isPerformancePlaying = true

debug.trace("SPDF: the pole dance should be starting")

	GoToState("Walking")
	return false
endFunction



Function abort(bool rightNow=false)
	if rightNow || GetState()!="Playing"
		_release()
		return
	endIf
	; Stop the current dance, and play the ending anim (all will be done in the Ending state)
	
debug.tracestack("SPDF aborting performance")	
	GoToState("Ending")
endFunction


state walking
	Event OnBeginState()
debug.trace("SPDF: walking begin state")
		if dancer.getDistance(pole)<50
			RegisterForSingleUpdate(0.2)
		else
			RegisterForSingleUpdate(2.0)
		endIf
	endEvent
	
	Event OnUpdate()
		if stoppedTimes>5
debug.trace("SPDF: teleporting " + dancer.getDisplayName())
			; Teleport in case there are no movements
			float zAngle = dancer.getAngleZ()
			GoToState("Playing")
			return
		endIf

debug.trace("SPDF: " + dancer.getDisplayName() + " has distance = " + dancer.getDistance(pole) as int)
		; Wait until the actor is close, then remove the package, then start the intro anim
		if dancer.getDistance(pole) > 75.0
			if Math.abs(prevWalkX - dancer.x) < 2 && Math.abs(prevWalkY - dancer.y) < 2
				stoppedTimes+=1
				debug.trace("SPDF: stopped " + stoppedTimes)
			endIf
			prevWalkX = dancer.x
			prevWalkY = dancer.y
		else
			GoToState("Playing")
			return
		endIf
		RegisterForSingleUpdate(0.25)
	endEvent
endState

float totalExpectedPerformanceTime
float performanceStartTime
float currentDanceExpectedTime
float currentDanceStartTime


; ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

spdfBase Function getNextStep(spdfBase from=None) ; Will return it without changing the current one
	if from
		int i = currentDance
		while i<dances.length - 1
			spdfBase b = dances[i]
			if b==from
				return dances[i+1]
			endIf
			i+=1
		endWhile
		return None
	
	else
		return dances[nextDance]
	endIf
endFunction

spdfBase Function moveToNextStep() ; Return the next step and move the current to the next
debug.trace("moveToNextStep=" + nextDance + " d[n]=" + dances[nextDance] + " all=" + dances)
	currentDance=nextDance
	return dances[currentDance]
endFunction

Function addToOFAs(spdfStrip s)
	int i=0
	while i<ofasList.length
		if !ofasList[i]
			ofasList[i] = s
			return
		endIf
		i+=1
	endWhile
endFunction

spdfStrip Function getFirstOFA()
	spdfStrip res = ofasList[0]
	if !res
		return None
	endIf
	int i=0
	while i<ofasList.length - 1
		ofasList[i] = ofasList[i + 1]
		i+=1
	endWhile
	ofasList[ofasList.length - 1] = None
	return res
endFunction

Function insertNextStep(spdfBase toInsert)
	; FIXME to be implemented for real only in Playing state
	spdF._addError(99, "Cannot insert a step in a Performance that is not playing", "spdPerformance", "insertNextStep") ; FIXME
endFunction

Function replaceNextStep(spdfBase toInsert)
	; FIXME to be implemented for real only in Playing state
	spdF._addError(99, "Cannot replace a step in a Performance that is not playing", "spdPerformance", "replaceNextStep") ; FIXME
endFunction

spdfDance Function getLastDance()
	int i = dances.length
	while i
		i-=1
		if dances[i] && dances[i].isDance
			return dances[i] as spdfDance
		endIf
	endWhile
	return None
endFunction

bool Function isLastDance()
	; no one of the remaining base objects should be a dance or a pose
	bool isLast = true
	int i = currentDance + 1
	while i<dances.length
		spdfBase b = dances[i]
		if b && (b.isDance || b.isPose)
			isLast = false
			i = 1000
		endIf
		i+=1
	endWhile
	
if isLast
	debug.trace("Found SPDF last dance in pos=" + currentDance + " b="+dances[currentDance].name)
endIf
	
	return isLast
endFunction


float currentStepStartTime
int currentStatus
spdfStrip[] ofasList
int nextDance
bool wasFirstEvent
; ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




state Playing
	Event OnBeginState()
		sendEvent("PerformanceStarted")
		registry._lockActor(dancer, spdF.spdfDoNothingPackage)
		currentDance = -1
		currentStatus = -1 ; -1=not defined, 0=playing start pose anim, 1=playing pre of dance, 2=playing main dance, 3=playing end of dance, 4=playing end pose anim
		nextDance = 0
		wasFirstEvent = true
		RegisterForSingleUpdate(0.05)
	endEvent

	Function insertNextStep(spdfBase toInsert)
		if !toInsert
			return
		endIf
		int i = dances.length
		while i>currentDance + 1
			i-=1
			dances[i] = dances[i + 1]
		endWhile
		dances[currentDance + 1] = toInsert
	endFunction

	Function replaceNextStep(spdfBase toInsert)
		if !toInsert
			return
		endIf
		dances[currentDance + 1] = toInsert
	endFunction
	
	Event OnUpdate()
		; If the current dance and the next dance are the same we are playing and we just need to check the time and wait
		; If the current dance and the next dance are different we need to pick the next one
		; next one can be:
		; - Dance: play it, but check if we have an OFA stip just after
		; - Pose: play and check for OFA strips
		; - Strip:
		; - - if OFA and preceeded by a Dance or Pose, ignore
		; - - if !OFA play it

		if currentDance!=nextDance
			
			; Grab the new one
			spdfBase b = moveToNextStep() ; This will do "currentDance=nextDance"
if b
debug.trace("currD="+currentDance + " b=" + b+ " D="+b.isDance + " S=" + b.isStrip + " P=" + b.isPose)
endIf
			if b && b.isDance
				spdfDance d = b as spdfDance
				String animEvent = ""
				; We need to send the animevent, it can be a pre or also a startPose
				if wasFirstEvent
					if d.startPose
						Debug.SendAnimationEvent(dancer, d.startPose.startHKX)
						currentStatus=0
						Utility.waitMenuMode(0.4)
					endIf
					dancer.moveTo(pole, 0.0, 0.0, 0.0, false)
					dancer.setAngle(0.0, 0.0, pole.getAngleZ())
					spdfActor._removeWeapons(dancer)
					wasFirstEvent = false
				elseIf d.startHKX && d.startDuration!=0.0
					animEvent=d.startHKX
					currentStatus=1
				else
					animEvent=d.HKX
					currentStatus=2
				endIf
				
				; We need to check if the next (can be many) is a OFA strip, in this case we should play them during the anim
				spdfBase n = getNextStep()
				while n && n.isStrip && (n as spdfStrip).isOFA
					addToOFAs(n as spdfStrip)
					n = getNextStep(n)
				endWhile
				
				; Send the event and init the time
				currentStepStartTime = Utility.getCurrentRealTime()
				Debug.SendAnimationEvent(dancer, animEvent)
				RegisterForSingleUpdate(0.1)
				
			elseIf b && b.isStrip
				spdfStrip s = b as spdfStrip
				if s.isOFA
debug.trace("SPDF SPDF ----> OFA")				
					; Skip it, and get the next one. But we have to put it in the OFAs or it will be skipped
					addToOFAs(s)
					nextDance+=1
					RegisterForSingleUpdate(0.01)
				else
					; Play it (sync mode)
					dancerC.strip(s)
					currentStatus=-1
					nextDance+=1
					RegisterForSingleUpdate(0.01)
				endIf
				
			elseIf b && b.isPose
				spdfPose p = b as spdfPose
				; We need to check if the next (can be many) is a OFA strip, in this case we should play them during the anim
				spdfBase n = getNextStep()
				while n && n.isStrip && (n as spdfStrip).isOFA
					addToOFAs(n as spdfStrip)
					n = getNextStep(n)
				endWhile
				
				; Play the pose for the specified amount of time, and consider OFAs after this step
				currentStepStartTime = Utility.getCurrentRealTime()
				Debug.SendAnimationEvent(dancer, p.HKX)
				currentStatus = 2 ; Poses do not have intro
				if wasFirstEvent
					dancer.moveTo(pole, 0.0, 0.0, 0.0, false)
					dancer.setAngle(0.0, 0.0, pole.getAngleZ())
					spdfActor._removeWeapons(dancer)
					wasFirstEvent = false
				endIf
				RegisterForSingleUpdate(0.1)

			else
				; If we are here there is nothing more to play
debug.trace("SPDF SPDF SPDF ending because nothing to do currD=" + currentDance)
				GoToState("Ending")
			endIf
			
		
		else
			; Just the normal advancement
			spdfBase b = dances[currentDance]
			if b && b.isDance
				spdfDance d = b as spdfDance
			
debug.trace("SPDF d=\"" + d.name + "\" stat="+currentStatus + " step=" + currentDance)
				if currentStatus==0 ; We are playing a start pose anim
					float timeToDo = d.startPose.startDuration - (Utility.getCurrentRealTime() - currentStepStartTime)
					if timeToDo<0.1
						; Switch
						if d.startHKX && d.startDuration!=0.0
							Debug.sendAnimationEvent(dancer, d.startHKX)
							currentStatus=1
						else
							Debug.sendAnimationEvent(dancer, d.HKX)
							currentStatus=2
						endIf
						currentStepStartTime = Utility.getCurrentRealTime()
						RegisterForSingleUpdate(0.1)
					elseIf timeToDo<1.0
						; Wait remaining time
						RegisterForSingleUpdate(timeToDo - 0.05)
					else
						RegisterForSingleUpdate(1.0)
					endIf
				
				elseIf currentStatus==1 ; We are playing a pre dance
					float timeToDo = d.startDuration - (Utility.getCurrentRealTime() - currentStepStartTime)
					if timeToDo<0.1
						; Switch
						currentStatus=2
						Debug.sendAnimationEvent(dancer, d.HKX)
						currentStepStartTime = Utility.getCurrentRealTime()
						RegisterForSingleUpdate(0.1)
					elseIf timeToDo<1.0
						; Wait remaining time
						RegisterForSingleUpdate(timeToDo - 0.05)
					else
						RegisterForSingleUpdate(1.0)
					endIf
					
				elseIf currentStatus==2 ; We are playing the main dance
					float timeToDo = dancesTime[currentDance] - (Utility.getCurrentRealTime() - currentStepStartTime)
					if timeToDo<0.1
						; Switch if needed, or jump to the next step
						if d.endHKX!="" && d.endDuration!=0.0
							currentStatus=3
							Debug.sendAnimationEvent(dancer, d.endHKX)
							currentStepStartTime = Utility.getCurrentRealTime()
						elseIf isLastDance()
							; Play the anim and then end pose anim, then play the strips
							currentStatus=4
							Debug.sendAnimationEvent(dancer, d.endPose.endHKX)
							currentStepStartTime = Utility.getCurrentRealTime()
							RegisterForSingleUpdate(0.05)
						else
							nextDance+=1
						endIf
						RegisterForSingleUpdate(0.01)
					elseIf timeToDo<1.0
						; Wait remaining time
						RegisterForSingleUpdate(timeToDo - 0.05)
					else
						RegisterForSingleUpdate(1.0)
					endIf
				
				elseIf currentStatus==3 ; We are playing the post dance
					float timeToDo = d.endDuration - (Utility.getCurrentRealTime() - currentStepStartTime)
					if timeToDo<0.1
						if isLastDance()
							; Play the anim and then end pose anim, then play the strips
							currentStatus=4
	debug.trace("SPDF: " + dancer.getDisplayName() + " sending End -> " + d.endPose.endHKX)
							Debug.sendAnimationEvent(dancer, d.endPose.endHKX)
							currentStepStartTime = Utility.getCurrentRealTime()
							RegisterForSingleUpdate(0.05)
						else
							nextDance+=1
						endIf
						RegisterForSingleUpdate(0.01)
					elseIf timeToDo<1.0
						; Wait remaining time
						RegisterForSingleUpdate(timeToDo - 0.05)
					else
						RegisterForSingleUpdate(1.0)
					endIf
					
				elseIf currentStatus==4 ; We are playing the exit pose (probaly not here)
	debug.trace("Playing end pose anim exp="+d.endPose.name)
					float timeToDo = d.endPose.endDuration - (Utility.getCurrentRealTime() - currentStepStartTime)
					if timeToDo<0.1
						nextDance+=1
						RegisterForSingleUpdate(0.01)
						dancer.moveTo(poleRef.getReference(), 0.0, 0.0, 0.0, false)
						dancer.setAngle(0.0, 0.0, poleRef.getReference().getAngleZ())
					elseIf timeToDo<1.0
						; Wait remaining time
						RegisterForSingleUpdate(timeToDo - 0.05)
					else
						RegisterForSingleUpdate(1.0)
					endIf
				endIf
				
				spdfStrip s = getFirstOFA()
				if s
					dancerC.strip(s) ; This will play in async mode
				endIf
				
			elseIf b && b.isStrip
				spdfStrip s = b as spdfStrip
				if !s.isOFA
						dancerC.strip(s)
				endIf
				nextDance+=1
				RegisterForSingleUpdate(0.01)
				
			elseIf b && b.isPose
				spdfPose p = b as spdfPose
				if currentStatus == 2
					float timeToDo = dancesTime[currentDance] - (Utility.getCurrentRealTime() - currentStepStartTime)
					if timeToDo<0.1
						; Switch if needed, or jump to the next step
						if isLastDance()
							; Play the anim and then end pose anim, then play the strips
							currentStatus=4
							Debug.sendAnimationEvent(dancer, p.endHKX)
							currentStepStartTime = Utility.getCurrentRealTime()
							RegisterForSingleUpdate(0.05)
						else
							nextDance+=1
						endIf
						RegisterForSingleUpdate(0.01)
					elseIf timeToDo<1.0
						; Wait remaining time
						RegisterForSingleUpdate(timeToDo - 0.05)
					else
						RegisterForSingleUpdate(1.0)
					endIf
				elseIf currentStatus==4
	debug.trace("Playing end pose anim")
					float timeToDo = p.endDuration - (Utility.getCurrentRealTime() - currentStepStartTime)
					if timeToDo<0.1
						nextDance+=1
						RegisterForSingleUpdate(0.01)
						dancer.moveTo(poleRef.getReference(), 0.0, 0.0, 0.0, false)
					elseIf timeToDo<1.0
						; Wait remaining time
						RegisterForSingleUpdate(timeToDo - 0.05)
					else
						RegisterForSingleUpdate(1.0)
					endIf
				endIf
				
				spdfStrip s = getFirstOFA()
				if s
					dancerC.strip(s) ; This will play in async mode
				endIf
			
			else
				; Ending because nothing else to do
debug.trace("SPDF SPDF SPDF ending because nothing to do currD=" + currentDance)
				GoToState("Ending")
			endIf
		endIf
	endEvent

endState

state Ending
	Event OnBeginState()
		sendEvent("PerformanceEnding")
		int i = currentDance
		while i<dances.length
			spdfBase b = dances[i]
			if b && b.isStrip && !(b as spdfStrip).isOFA
				dancerC.strip(b as spdfStrip)
			endIf
			i+=1
		endWhile
		RegisterForSingleUpdate(0.1)
	endEvent
	
	Event OnUpdate()
		; Move back to the marker
		dancer.moveTo(poleRef.getReference(), 0.0, 0.0, 0.0, false)
		if poleCreated
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
		Debug.Trace("SPDF: generated internally a non valid event: " + eventName)
		return
	endIf
endFunction


bool Function _isTagUsed(spdfTag theTag)
	if !tags
		return false
	endIf
	return tags.find(theTag)!=-1
endFunction
