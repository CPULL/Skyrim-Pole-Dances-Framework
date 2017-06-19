Scriptname spdRegistry extends Quest

spdPoleDances spdF

package Property spdDoNothingPackage Auto

string[] Property bodyParts Auto
spdPerformance[] Property performances Auto
ReferenceAlias[] Property poleAliases Auto
Package[] Property walkPackages Auto
spdDance[] dances
spdDance[] strips
spdPose[] poses
spdTag[] tags
string[] validTags
spdActor[] actors
actor[] refActors
spdDance Property tmpStrip Auto


; ****************************************************************************************************************************************************************
; ************                                                                                                                                        ************
; ************                                           Init Functions                                                                               ************
; ************                                                                                                                                        ************
; ****************************************************************************************************************************************************************

; ((-

Function reInit(spdPoleDances spd)
	_doInit(spd)
endFunction

; Init function (DoInit, called by OnGameStart and OnInit of main quest)
; This will just check stuff, and call the mod event to have other mods to add their own dances
function _doInit(spdPoleDances spd)
	; TODO

debug.trace("SPD: Registry Init")
	
	spdF = spd
	; Load all known poses and dances
	editing = true
	
	
	; ((- Body Parts and Tags
	bodyParts = new String[64]
	bodyParts[0] = "Head"
	bodyParts[1] = "Hair"
	bodyParts[2] = "Body"
	bodyParts[3] = "Hands"
	bodyParts[4] = "Forearms"
	bodyParts[5] = "Amulet"
	bodyParts[6] = "Ring"
	bodyParts[7] = "Feet"
	bodyParts[8] = "Calves"
	bodyParts[9] = "Shield"
	bodyParts[10] = "Tail"
	bodyParts[11] = "LongHair"
	bodyParts[12] = "Circlet"
	bodyParts[13] = "Ears"
	bodyParts[14] = "Mouth"
	bodyParts[15] = "Neck"
	bodyParts[16] = "Chest"
	bodyParts[17] = "Wings"
	bodyParts[18] = "Strapon"
	bodyParts[19] = "Pelvis"
	bodyParts[20] = "DecapitatedHead"
	bodyParts[21] = "DecapitatedBody"
	bodyParts[22] = "Pelvis2"
	bodyParts[23] = "RightLeg"
	bodyParts[24] = "LeftLeg"
	bodyParts[25] = "Jewelry"
	bodyParts[26] = "Undergarment"
	bodyParts[27] = "Shoulders"
	bodyParts[28] = "LeftArm"
	bodyParts[29] = "RightArm"
	bodyParts[30] = "Shclong"
	bodyParts[31] = "FX01"
	
	bodyParts[32] = "30"
	bodyParts[33] = "31"
	bodyParts[34] = "32"
	bodyParts[35] = "33"
	bodyParts[36] = "34"
	bodyParts[37] = "35"
	bodyParts[38] = "36"
	bodyParts[39] = "37"
	bodyParts[30] = "38"
	bodyParts[41] = "39"
	bodyParts[42] = "40"
	bodyParts[43] = "41"
	bodyParts[44] = "42"
	bodyParts[45] = "43"
	bodyParts[46] = "44"
	bodyParts[47] = "45"
	bodyParts[48] = "46"
	bodyParts[49] = "47"
	bodyParts[50] = "48"
	bodyParts[51] = "49"
	bodyParts[52] = "50"
	bodyParts[53] = "51"
	bodyParts[54] = "52"
	bodyParts[55] = "53"
	bodyParts[56] = "54"
	bodyParts[57] = "55"
	bodyParts[58] = "56"
	bodyParts[59] = "57"
	bodyParts[60] = "58"
	bodyParts[61] = "59"
	bodyParts[62] = "60"
	bodyParts[63] = "61"

	validTags = new string[20]
	validTags[0] = "Auth"
	validTags[1] = "Stand"
	validTags[2] = "Kneel"
	validTags[3] = "Sit"
	validTags[4] = "Front"
	validTags[5] = "Back"
	validTags[6] = "Grab"
	validTags[7] = "SingleGrab"
	validTags[8] = "DoubleGrab"
	validTags[9] = "Float"
	validTags[10] = "Spread"
	validTags[11] = "Bend"
	validTags[12] = "LegsUp"
	validTags[13] = "Duration"
	validTags[14] = "Skill"
	validTags[15] = "Sexy"
	validTags[16] = "Strip"
	validTags[17] = "StripAn"
	validTags[18] = "Dance"
	validTags[19] = "Pose"
	
	; -))
	
	
	; Poses, Dances, Tags initialization
	if !dances
debug.trace("SPD: Registry full init of performances, poses, dances, and tags")
		; Full init
		dances = new spdDance[16]
		strips = new spdDance[16]
		poses = new spdPose[16]
		tags = new spdTag[64]
		actors = new spdActor[16]
		refActors = new actor[16]
	endIf
	
	; Some of the items can be already there, do not re-init them
	int countPerformances = 0
	int countDances = 0
	int countStrips = 0
	int countPoses = 0
	int countTags = 0
	int countActors = 0
	Alias[] allAliases = GetAliases()
	int i = allAliases.length
	while i
		i-=1
		if StringUtil.Find(allAliases[i].GetName(), "spdDance")!=-1
			spdDance d = allAliases[i] as spdDance
			int pos = dances.Find(None)
			if dances.Find(d)==-1 && pos!=-1
				dances[pos] = d
				countDances += 1
			endIf
		elseIf StringUtil.Find(allAliases[i].GetName(), "spdStrip")!=-1
			spdDance d = allAliases[i] as spdDance
			int pos = strips.Find(None)
			if strips.Find(d)==-1 && pos!=-1
				strips[pos] = d
				d._setAsStrip()
				countDances += 1
			endIf
		elseIf StringUtil.Find(allAliases[i].GetName(), "spdPose")!=-1
			spdPose p = allAliases[i] as spdPose
			int pos = poses.Find(None)
			if poses.Find(p)==-1 && pos!=-1
				poses[pos] = p
				countPoses += 1
			endIf
		elseIf StringUtil.Find(allAliases[i].GetName(), "spdTag")!=-1
			spdTag t = allAliases[i] as spdTag
			int pos = tags.Find(None)
			if tags.Find(t)==-1 && pos!=-1
				tags[countTags] = t
				tags[countTags]._doInit(spdF)
				countTags += 1
			endIf
		elseIf StringUtil.Find(allAliases[i].GetName(), "spdActor")!=-1
			spdActor t = allAliases[i] as spdActor
			int pos = actors.Find(None)
			if actors.Find(t)==-1 && pos!=-1
				actors[countActors] = t
				actors[countActors]._doInit(spdF)
				countActors += 1
			endIf
		endIf
	endWhile
	
	; Re-init performances
	i = performances.length
	while i
		i-=1
		if performances[i]
			performances[i]._doInit(spdF, poleAliases[i], walkPackages[i])
			countPerformances += 1
		endIf
	endWhile
	
debug.trace("SPD: Found " + countPerformances + "/" + performances.length + " Performances")
debug.trace("SPD: Found " + countDances + "/" + dances.length + " Dances")
debug.trace("SPD: Found " + countPoses + "/" + poses.length + " poses")
debug.trace("SPD: Found " + countTags + "/" + tags.length + " tags")
debug.trace("SPD: Found " + countActors + "/" + actors.length + " actors")
	
	; Send the event to register other poses and dances from mods
	editing = false
	int modEvId = ModEvent.Create("SkyrimPoleDancesRegistryUpdated")
	ModEvent.pushInt(modEvId, spdF.getVersion())
	ModEvent.pushForm(modEvId, Self)
	ModEvent.send(modEvId)
debug.trace("SPD: Registry end")
endFunction

bool editing = false
string editor = ""

Function beginEdit(string mod)
	int tries = 0
	while editing && tries<100
		Utility.waitMenuMode(1.0)
		tries+=1
	endWhile
	editing = true
	editor = mod
endFunction

Function completeEdit()
	editor = ""
	editing = false
endFunction

Function dumpErrors()
	spdF.dumpErrors()
endFunction

; -))

; ****************************************************************************************************************************************************************
; ************                                                                                                                                        ************
; ************                                             Performances                                                                               ************
; ************                                                                                                                                        ************
; ****************************************************************************************************************************************************************
; ((-

spdPerformance Function getPerformanceById(int id)
	int i = performances.length
	while i
		i-=1
		if performances[i].getID()==id
			return performances[i]
		endIf
	endWhile
	return None
endFunction

spdPerformance Function _allocatePerformance()
	int i = 0
	while i<performances.length
		if !performances[i].inUse
			performances[i]._allocate()
			return performances[i]
		endIf
		i+=1
	endWhile
	return None
endFunction



; -))

; ****************************************************************************************************************************************************************
; ************                                                                                                                                        ************
; ************                                            Actors                                                                                      ************
; ************                                                                                                                                        ************
; ****************************************************************************************************************************************************************
; ((-

spdActor function _allocateActor(Actor a)
	if !a
		spdF._addError(2, "Trying to allocate a null actor", "Registry", "allocateActor")
		return none ; Bad actor
	endIf
	
	if a.isOnMount() || a.isSwimming() || a.isFlying() || a.getRace().IsChildRace() || a.isChild() || a.isInCombat() || a.isDead() || a.IsUnconscious()
		spdF._addError(3, "Trying to allocate a non valid actor: " + a.getDisplayName(), "Registry", "allocateActor")
		return none ; Bad actor
	endIf
	if a.isInFaction(spdF.spdDancingFaction) && refActors.find(a)!=-1
		spdF._addError(4, "The actor " + a.getDisplayName() + " is already allocated and dancing", "Registry", "allocateActor")
		return none ; Already used
	endIf
	
	; OK, set the actor and lock it
	int pos = refActors.find(None)
	if pos==-1
		return none ; Too many actors
	endIf
	
	refActors[pos] = a
	actors[pos].setTo(a) ; The actor will be locked with the _lockActor call later
	return actors[pos]
endFunction

function _releaseDancer(Actor a)
	int pos = refActors.find(a)
	if pos==-1
		return
	endIf
	
	_unlockActor(a)
	actors[pos].free()
	refActors[pos] = none
endFunction

Function _lockActor(Actor a, Package pkg)
	; Find the spdActor
	int pos = refActors.find(a)
	if pos==-1
		return
	endIf
	actors[pos]._lock(pkg)
endFunction

Function _unlockActor(Actor a)
	; Find the spdActor
	int pos = refActors.find(a)
	if pos==-1
		return
	endIf
	actors[pos].free()
endFunction

; -))

; ****************************************************************************************************************************************************************
; ************                                                                                                                                        ************
; ************                                           Poses                                                                                        ************
; ************                                                                                                                                        ************
; ****************************************************************************************************************************************************************

; ((- Poses

int Function _getPosesNum(bool all)
	if all
		return poses.length
	endIf
	int num = 0
	int i = poses.length
	while i
		i-=1
		if poses[i] && poses[i].inUse
			num+=1
		endIf
	endWhile
	return num
endFunction

spdPose Function _getPoseByIndex(int index)
	return poses[index]
endFunction


spdPose Function findRandomStartPose()
	return poses[Utility.randomInt(0, poses.length - 1)]
endFunction


spdPose Function findPoseByName(string poseName)
	if !poseName
		return poses[0] ; Fixme get a random one
	endIf
	int i=poses.length
	while i
		i-=1
		if poses[i] && poses[i].name==poseName
			return poses[i]
		endIf
	endWhile
	return none
endFunction

; Returns 1 in case there were errors
int Function registerPose(string name, string poseAnimEvent, string startingAnimEvent, string endingAnimEvent, float startTime, float endTime)
	; Allocate one, but check if we already have the name
	int pos = -1
	int i = poses.length
	while i
		i-=1
		if poses[i] && poses[i].name==name
			pos = i
			i=0
		endIf
	endWhile
	if pos==-1
		i = poses.length
		while i
			i-=1
			if poses[i] && !poses[i].inUse
				pos = i
				i = 0
			endIf
		endWhile
	endIf
	if pos==-1
		spdF._addError(30, "No more slots available for Poses! (" + name + ")", "Registry", "registerPose")
		return 1
	endIf
	spdPose p = poses[pos]
	p._init(name, poseAnimEvent, startingAnimEvent, endingAnimEvent, startTime, endTime)
	return 0
endFunction

; -))

; ****************************************************************************************************************************************************************
; ************                                                                                                                                        ************
; ************                                            Dances                                                                                      ************
; ************                                                                                                                                        ************
; ****************************************************************************************************************************************************************

; ((-


int Function _getDancesNum(bool all)
	if all
		return dances.length
	endIf
	int num = 0
	int i = dances.length
	while i
		i-=1
		if dances[i] && dances[i].inUse
			num+=1
		endIf
	endWhile
	return num
endFunction

spdDance Function getDanceByIndex(int index)
	return dances[index]
endFunction


; Returns 1 in case there were errors
int Function registerDance(string name, string animEvent, string startPose, string endPose, float duration, string tag="", string preAnimEvent="", float preAnimDuration=0.0, string postAnimEvent="", float postAnimDuration=0.0)
	; Allocate one, but check if we already have the name
	int pos = -1
	int i = dances.length
	while i
		i-=1
		if dances[i] && dances[i].name==name
			pos = i
			i=0
		endIf
	endWhile
	if pos==-1
		i = dances.length
		while i
			i-=1
			if dances[i] && !dances[i].inUse
				pos = i
				i = 0
			endIf
		endWhile
	endIf
	if pos==-1
		spdF._addError(31, "No more slots available for Dances! (" + name + ")", "Registry", "registerDance")
		return 1
	endIf
	spdDance d = dances[pos]
	spdPose sp = findPoseByName(startPose)
	if sp==none
		spdF._addError(32, "Start pose \"" + startPose + "\" for Dance \"" + name + "\" does not exist!", "Registry", "registerDance")
		return 1
	endIf
	spdPose ep = findPoseByName(endPose)
	if ep==none
		spdF._addError(33, "End pose \"" + endPose + "\" for Dance \"" + name + "\" does not exist!", "Registry", "registerDance")
		return 1
	endIf
	d._init(name, animEvent, sp, ep, duration)
	if preAnimEvent!="" && preAnimDuration!=0.0 && postAnimEvent!="" && postAnimDuration!=0.0
		d._initCycle(preAnimEvent, preAnimDuration, postAnimEvent, postAnimDuration)
	elseIf preAnimEvent!="" || preAnimDuration!=0.0 || postAnimEvent!="" || postAnimDuration!=0.0
		spdF._addError(33, "Not possible to specify only a sub-set of the cycle for a dance: \"" + name + "\"", "Registry", "registerDance") ; FIXME fix the ID
	endIf
	if tag
		if d.setTags(tag)
			return 1
		endIf
	endIf
	return 0
endFunction

spdDance Function findDanceByPose(spdPose pose)
	int count = 0
	int i = dances.length
	while i
		i-=1
		if dances[i] && dances[i].startPose==pose
			count += 1
		endIf
	endWhile
	if count==0
		debug.trace("Could not find a dance starting with pose: " + pose.name)
		return dances[0]
	endIf
	
	; Allocate the array (damn, a SKSE plugin will be beneficial here)
	spdDance[] res = allocateDances(count)
	count = 0
	i = dances.length
	while i && count<res.length
		i-=1
		if dances[i] && dances[i].startPose==pose
			res[count] = dances[i]
			count += 1
		endIf
	endWhile
	
	return res[Utility.randomInt(0, res.length - 1)]
endFunction

spdDance Function findDanceByName(string name)
	; Strip dances: "Strip:<[!]parts,...>,A"
	if StringUtil.Find(name, "Strip:")!=-1
		; It a strip
		tmpStrip.parseStrips(spdF, name)
		; Check if it is equal to one we have already
		int i = strips.length
		while i
			i-=1
			spdDance s = strips[i]
			if s && s.inUse && s.compareStrip(tmpStrip)
				; this one is already good
				return s
			endIf
		endWhile
		; Not found, allocate one
		i=0
		while i<strips.length
			spdDance s = strips[i]
			if s && !s.inUse
				s.copyStripFrom(tmpStrip)
				return s
			endIf
			i+=1
		endWhile
		spdF._addError(99, "No more strip slots available for performances", "Registry", "getDanceByName") ; FIXME fix the ID
		return None
	endIf

	int i=dances.length
	while i
		i-=1
		if dances[i] && dances[i].name==name
			return dances[i]
		endIf
	endWhile
	return none
endFunction

spdDance Function findDanceByTags(spdTag tag)
	; find all dances that are respecting the tag and return a random one
	spdDance[] res = new spdDance[16]
	int numValid = 0
	int i=dances.length
	while i
		i-=1
		if dances[i] && dances[i].inUse && dances[i].hasTags(tag)
			res[numValid] = dances[i]
			numValid+=1
		endIf
	endWhile
	if numValid==0
		return None
	endIf
	return res[Utility.randomInt(0, numValid - 1)]
endFunction

spdDance Function findRandomDance()
	; Just be sure the used dances are at the begin...
	int i=0
	while i<dances.length
		spdDance d = dances[i]
		if !d || !d.inUse
			; Grab the next valid one and swap
			int j=i+1
			while j<dances.length
				spdDance o = dances[j]
				if d && d.inUse
					spdDance tmp = d
					dances[i] = dances[j]
					dances[j] = tmp
					j = 100000
				endIf
			endWhile
		endIf
		i+=1
	endWhile
	int numValid = _getDancesNum(false)
	; Pick one randomly
	if numValid == 0
		return None
	endIf
	return dances[Utility.randomInt(0, numValid - 1)]
endFunction

spdDance Function findTransitionDance(spdPose prev, spdPose next)
	int num=0
	int i=0
	while i<dances.length && num<16
		spdDance d = dances[i]
		if d && d.inUse && d.startPose==prev && d.endPose==next
			num+=1
		endIf
		i+=1
	endWhile
	if num==0
		return none
	endIf
	spdDance[] valids = allocateDances(num)
	i=0
	while i<dances.length && num<16
		spdDance d = dances[i]
		if d && d.inUse && d.startPose==prev && d.endPose==next
			num-=1
			valids[num] = d
		endIf
		i+=1
	endWhile	
	return valids[Utility.randomInt(0, valids.length - 1)]
endFunction


; -))

; ****************************************************************************************************************************************************************
; ************                                                                                                                                        ************
; ************                                                                                                                                        ************
; ************                                                                                                                                        ************
; ****************************************************************************************************************************************************************

; registration functions



; ****************************************************************************************************************************************************************
; ************                                                                                                                                        ************
; ************                                             Tags                                                                                       ************
; ************                                                                                                                                        ************
; ****************************************************************************************************************************************************************

; ((- tags

Function cleanUpTags() ; FIXME call this when releasing a performance
	; Go for all tags
	int i = tags.length
	while i
		i-=1
		spdTag t = tags[i]
		if t && t.inUse
			bool used = false
			; Check if a tag is referenced in a dance or an active performance
			int j = dances.length
			while j && !used
				j-=1
				spdDance d = dances[i]
				if d && d.inUse
					if d._isTag(t)
						used = true
						j=0
					endIf
				endIf
			endWhile
			j = performances.length
			while j && !used
				j-=1
				spdPerformance p = performances[i]
				if p && p.inUse && p._isTagUsed(t)
					used = true
					j=0
				endIf
			endWhile
			; if not remove it (make it not used)
			if !used
				t._release()
			endIf
		endIf
	endWhile
endFunction

string Function tryToParseTags(string tagCode)
	return spdTag._tryToParseTags(tagCode, validTags, bodyParts, Self)
endFunction

spdTag Function parseTags(string tagCode)
	; Allocate one of the tags
	spdTag res = none
	int pos = tags.length
	while pos
		pos-=1
		if tags[pos] && !tags[pos].inUse
			res = tags[pos]
			pos=0
		endIf
	endWhile
	if res==none
		spdF._addError(34, "No more space available for tags!", "Registry", "parseTag")
		return none
	endIf

	if res._init(tagCode, validTags, spdF)
		return none
	endIf
	return res
endFunction



; -))
; TODO

; ****************************************************************************************************************************************************************
; ************                                                                                                                                        ************
; ************                                                   Hooks                                                                                ************
; ************                                                                                                                                        ************
; ****************************************************************************************************************************************************************


bool Function useGlobalHook(string eventName)
	; check if the hook is global and return yes/no
	; TODO
	return false
endFunction

Function registerForGlobalHooks(string eventName)
	; just add a yes/no for each known event
	; TODO
	return
endFunction


spdDance[] Function allocateDances(int count)
	if count<10
		if count==0
			debug.tracestack("SPD: warning asked to allocate an array of zero dances!")
			return new spdDance[1]
		elseIf count==1
			return new spdDance[1]
		elseIf count==2
			return new spdDance[2]
		elseIf count==3
			return new spdDance[3]
		elseIf count==4
			return new spdDance[4]
		elseIf count==5
			return new spdDance[5]
		elseIf count==6
			return new spdDance[6]
		elseIf count==7
			return new spdDance[7]
		elseIf count==8
			return new spdDance[8]
		elseIf count==9
			return new spdDance[9]
		endIf
	elseIf count<20
		if count==10
			return new spdDance[10]
		elseIf count==11
			return new spdDance[11]
		elseIf count==12
			return new spdDance[12]
		elseIf count==13
			return new spdDance[13]
		elseIf count==14
			return new spdDance[14]
		elseIf count==15
			return new spdDance[15]
		elseIf count==16
			return new spdDance[16]
		elseIf count==17
			return new spdDance[17]
		elseIf count==18
			return new spdDance[18]
		elseIf count==19
			return new spdDance[19]
		endIf
	elseIf count<30
		if count==20
			return new spdDance[20]
		elseIf count==21
			return new spdDance[21]
		elseIf count==22
			return new spdDance[22]
		elseIf count==23
			return new spdDance[23]
		elseIf count==24
			return new spdDance[24]
		elseIf count==25
			return new spdDance[25]
		elseIf count==26
			return new spdDance[26]
		elseIf count==27
			return new spdDance[27]
		elseIf count==28
			return new spdDance[28]
		elseIf count==29
			return new spdDance[29]
		endIf
	else
		return new spdDance[30] ; FIXME in future handle more dances, right now it is nonsense
	endIf
endFunction



; FIXME add better formatting





