Scriptname spdfRegistry extends Quest

spdfPoleDances spdF
string[] Property bodyParts Auto
spdfPerformance[] Property performances Auto
ReferenceAlias[] Property poleAliases Auto
Package[] Property walkPackages Auto
spdfDance[] dances
spdfStrip[] strips
spdfPose[] poses
spdfTag[] tags
string[] validTags
spdfActor[] actors
actor[] refActors
spdfStrip Property tmpStrip Auto
Static[] Property spdfPoles Auto


; ****************************************************************************************************************************************************************
; ************                                                                                                                                        ************
; ************                                           Init Functions                                                                               ************
; ************                                                                                                                                        ************
; ****************************************************************************************************************************************************************

; ((-

Function _stopAll()
	; Stop all performances
	int i = performances.length
	while i
		i-=1
		spdfPerformance p = performances[i]
		if p
			p.abort(true)
		endIf
	endWhile
	; Clean all temporary strips and tags ( TODO )
endFunction

Function reInit(spdfPoleDances spd)
	_doInit(spd, true)
endFunction

; Init function (DoInit, called by OnGameStart and OnInit of main quest)
; This will just check stuff, and call the mod event to have other mods to add their own dances
function _doInit(spdfPoleDances spd, bool force=false)
	; TODO

debug.trace("SPDF: Registry Init")
	
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
	bodyParts[40] = "38"
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
	if !dances || force
		; Full init
		dances = new spdfDance[16]
		strips = new spdfStrip[16]
		poses = new spdfPose[16]
		tags = new spdfTag[64]
		actors = new spdfActor[16]
		refActors = new actor[16]
	endIf
	
	; Count the items, in case the num is not what was expected (is less) then scan the aliases
	Alias[] allAliases = spdF.GetAliases()
	int count = getDancesNum(0) + getStripsNum(0) + getPosesNum(0) +  getTagsNum(0) + getActorsNum(0)
	if force || allAliases.length > count + 2 ; PlayerRef and tmpStrip
		; Some of the items can be already there, do not re-init them
		int countPerformances = 0
		int countDances = 0
		int countStrips = 0
		int countPoses = 0
		int countTags = 0
		int countActors = 0
		int i = allAliases.length
		float progT = i / 9.9
		float incr = i / 100.0
		float prog = 0.0
		int tot = 0
		while i
			i-=1

			
			prog+=incr
			if prog>progT
				tot+=1
				if tot<11
					spdF._addError(0, "Init Progress " + tot*10 + "%", "Registry", "Init")
				endIf
				prog=0.0
			endIf
			
			if StringUtil.Find(allAliases[i].GetName(), "spdfDance")!=-1
				spdfDance d = allAliases[i] as spdfDance
				int pos = dances.Find(None)
				if dances.Find(d)==-1 && pos!=-1
					dances[pos] = d
					countDances += 1
					d._preInit(1)
				endIf
			elseIf StringUtil.Find(allAliases[i].GetName(), "spdfStrip")!=-1
				spdfStrip s = allAliases[i] as spdfStrip
				int pos = strips.Find(None)
				if strips.Find(s)==-1 && pos!=-1
					strips[pos] = s
					s._preInit(3)
					countStrips += 1
				endIf
			elseIf StringUtil.Find(allAliases[i].GetName(), "spdfPose")!=-1
				spdfPose p = allAliases[i] as spdfPose
				int pos = poses.Find(None)
				if poses.Find(p)==-1 && pos!=-1
					poses[pos] = p
					p._preInit(2)
					countPoses += 1
				endIf
			elseIf StringUtil.Find(allAliases[i].GetName(), "spdfTag")!=-1
				spdfTag t = allAliases[i] as spdfTag
				int pos = tags.Find(None)
				if tags.Find(t)==-1 && pos!=-1
					tags[countTags] = t
					tags[countTags]._doInit(spdF)
					countTags += 1
				endIf
			elseIf StringUtil.Find(allAliases[i].GetName(), "spdfActor")!=-1
				spdfActor t = allAliases[i] as spdfActor
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
		
		if tot<10
			spdF._addError(0, "Init Progress 100%", "Registry", "Init")
		endIf
	
		spdF._addError(0, "Found " + countPerformances + "/" + performances.length + " Performances", "Registry", "doInit")
		spdF._addError(0, "Found " + countDances + "/" + dances.length + " Dances", "Registry", "doInit")
		spdF._addError(0, "Found " + countStrips + "/" + strips.length + " Strip slots", "Registry", "doInit")
		spdF._addError(0, "Found " + countPoses + "/" + poses.length + " poses", "Registry", "doInit")
		spdF._addError(0, "Found " + countTags + "/" + tags.length + " tags", "Registry", "doInit")
		spdF._addError(0, "Found " + countActors + "/" + actors.length + " actors", "Registry", "doInit")
	endIf
	
	; Send the event to register other poses and dances from mods
	editing = false
	spdF._addError(0, "Sending event to register Dances, Strips, and Poses", "Registry", "Init")
	int modEvId = ModEvent.Create("SkyrimPoleDancesRegistryUpdated")
	ModEvent.pushInt(modEvId, spdF.getVersion())
	ModEvent.pushForm(modEvId, Self)
	ModEvent.send(modEvId)
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

; -))

; ****************************************************************************************************************************************************************
; ************                                                                                                                                        ************
; ************                                             Performances                                                                               ************
; ************                                                                                                                                        ************
; ****************************************************************************************************************************************************************
; ((-

spdfPerformance Function getPerformanceById(int id)
	int i = performances.length
	while i
		i-=1
		if performances[i].getID()==id
			return performances[i]
		endIf
	endWhile
	return None
endFunction

spdfPerformance Function _allocatePerformance()
	int i = 0
	while i<performances.length
		if performances[i].inUse==0
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

spdfActor function _allocateActor(Actor a)
	if !a
		spdF._addError(2, "Trying to allocate a null actor", "Registry", "allocateActor")
		return none ; Bad actor
	endIf
	
	if a.isOnMount() || a.isSwimming() || a.isFlying() || a.getRace().IsChildRace() || a.isChild() || a.isInCombat() || a.isDead() || a.IsUnconscious()
		spdF._addError(3, "Trying to allocate a non valid actor: " + a.getDisplayName(), "Registry", "allocateActor")
		return none ; Bad actor
	endIf
	if a.isInFaction(spdF.spdfDancingFaction) && refActors.find(a)!=-1
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
	; Find the spdfActor
	int pos = refActors.find(a)
	if pos==-1
		return
	endIf
	actors[pos]._lock(pkg)
endFunction

Function _unlockActor(Actor a)
	; Find the spdfActor
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

spdfPose Function _getPoseByIndex(int index)
	return poses[index]
endFunction

spdfPose Function findRandomStartPose()
	return poses[Utility.randomInt(0, poses.length - 1)]
endFunction

spdfPose Function findPoseByName(string poseName)
	if !poseName
		return None
	endIf
	int i=poses.length
	while i
		i-=1
		if poses[i] && poses[i].inUse>0 && poses[i].name==poseName
			return poses[i]
		endIf
	endWhile
	return none
endFunction

spdfPose Function registerPose(string name, string poseAnimEvent, float len, string startingAnimEvent, string endingAnimEvent, float startTime, float endTime)
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
			if poses[i] && poses[i].inUse==0
				pos = i
				i = 0
			endIf
		endWhile
	endIf
	if pos==-1
		spdF._addError(30, "No more slots available for Poses! (" + name + ")", "Registry", "registerPose")
		return none
	endIf
	spdfPose p = poses[pos]
	p._init(name, poseAnimEvent, len, startingAnimEvent, endingAnimEvent, startTime, endTime)
	return p
endFunction

; -))

; ****************************************************************************************************************************************************************
; ************                                                                                                                                        ************
; ************                                            Dances                                                                                      ************
; ************                                                                                                                                        ************
; ****************************************************************************************************************************************************************

; ((-

spdfDance Function _getDanceByIndex(int index)
	return dances[index]
endFunction

spdfDance Function registerDance(string name, string animEvent, string startPose, string endPose, float duration, string tag="", bool asTransition=false)
	; Allocate one, but check if we already have the name
	int pos = -1
	int i = dances.length
	while i
		i-=1
		if dances[i] && dances[i].inUse>0 && dances[i].name==name
			pos = i
			i=0
		endIf
	endWhile
	if pos==-1
		i = dances.length
		while i
			i-=1
			if dances[i] && dances[i].inUse==0
				pos = i
				i = 0
			endIf
		endWhile
	endIf
	if pos==-1
		spdF._addError(31, "No more slots available for Dances! (" + name + ")", "Registry", "registerDance")
		return None
	endIf
	
	spdfDance d = dances[pos]
	spdfPose sp = findPoseByName(startPose)
	if sp==none
		spdF._addError(32, "Start pose \"" + startPose + "\" for Dance \"" + name + "\" does not exist!", "Registry", "registerDance")
		return None
	endIf
	spdfPose ep = findPoseByName(endPose)
	if ep==none
		spdF._addError(33, "End pose \"" + endPose + "\" for Dance \"" + name + "\" does not exist!", "Registry", "registerDance")
		return None
	endIf
	d._init(name, animEvent, sp, ep, duration, asTransition)
	if tag
		if d.setTags(tag)
			return None
		endIf
	endIf
	return d
endFunction

spdfDance Function findDanceByPose(spdfPose pose)
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
	spdfDance[] res = allocateDances(count)
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

spdfBase Function findDanceByName(string name)
	; Strip dances: "Strip:<[!]parts,...>,A"
	if StringUtil.Find(name, "Strip:")!=-1
		; It a strip
		tmpStrip._parseStrips(spdF, name)
		; Check if it is equal to one we have already
		int i = strips.length
		while i
			i-=1
			spdfStrip s = strips[i]
			if s && s.inUse>0 && s.compareStrip(tmpStrip)
				; this one is already good
				return s
			endIf
		endWhile
		; Not found, allocate one
		i=0
		while i<strips.length
			spdfStrip s = strips[i]
			if s && s.inUse==0
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
		if dances[i] && dances[i].inUse>0 && dances[i].name==name
			return dances[i]
		endIf
	endWhile
	return none
endFunction

spdfDance Function findDanceByTags(spdfTag tag)
	; find all dances that are respecting the tag and return a random one
	spdfDance[] res = new spdfDance[16]
	int numValid = 0
	int i=dances.length
	while i
		i-=1
		if dances[i] && dances[i].inUse>0 && dances[i].hasTags(tag)
			res[numValid] = dances[i]
			numValid+=1
		endIf
	endWhile
	if numValid==0
		return None
	endIf
	return res[Utility.randomInt(0, numValid - 1)]
endFunction

spdfDance Function findRandomDance()
	; Just be sure the used dances are at the begin...
	int i=0
	while i<dances.length
		spdfDance d = dances[i]
		if !d || d.inUse==0
			; Grab the next valid one and swap
			int j=i+1
			while j<dances.length
				if dances[j] && dances[j].inUse==1
					spdfDance tmp = d
					dances[i] = dances[j]
					dances[j] = tmp
					j = 100000
				endIf
				j+=1
			endWhile
		endIf
		i+=1
	endWhile
	int numValid = getDancesNum(1)
	; Pick one randomly
	if numValid == 0
		return None
	endIf
	return dances[Utility.randomInt(0, numValid - 1)]
endFunction

spdfDance Function findTransitionDance(spdfPose prev, spdfPose next)
	int num=0
	int i=0
	while i<dances.length && num<16
		spdfDance d = dances[i]
		if d && d.inUse==1 && d.startPose==prev && d.endPose==next
			num+=1
		endIf
		i+=1
	endWhile
	if num==0
		return none
	endIf
	spdfDance[] valids = allocateDances(num)
	i=0
	while i<dances.length && num<16
		spdfDance d = dances[i]
		if d && d.inUse==1 && d.startPose==prev && d.endPose==next
			num-=1
			valids[num] = d
		endIf
		i+=1
	endWhile	
	return valids[Utility.randomInt(0, valids.length - 1)]
endFunction


spdfStrip Function allocateStrip()
	int i = strips.length
	while i
		i-=1
		spdfStrip s = strips[i]
		if s && s.inUse==0
			s.copyStripFrom(s) ; Just to set it in use
			return s
		endIf
	endWhile
	return none ; no strips available
endFunction

; -))

; ****************************************************************************************************************************************************************
; ************                                                                                                                                        ************
; ************                                         Counting Functions                                                                             ************
; ************                                                                                                                                        ************
; ****************************************************************************************************************************************************************

; ((-
; Mode: 0=All, 1=In use, -1=Not used


int function getPerformancesNum(int mode=0)
	int count=0
	int i=performances.length
	while i
		i-=1
		if mode==0 && performances[i]
			count+=1
		elseIf mode==1 && performances[i] && performances[i].inUse
			count+=1
		elseIf mode==-1 && performances[i] && !performances[i].inUse
			count+=1
		endIf
	endWhile
	return count
endFunction

int function getActorsNum(int mode=0)
	int count=0
	int i=actors.length
	while i
		i-=1
		if mode==0 && actors[i]
			count+=1
		elseIf mode==1 && actors[i] && actors[i].inUse
			count+=1
		elseIf mode==-1 && actors[i] && !actors[i].inUse
			count+=1
		endIf
	endWhile
	return count
endFunction

int function getDancesNum(int mode=0)
	int count=0
	int i=dances.length
	while i
		i-=1
		if mode==0 && dances[i]
			count+=1
		elseIf mode==1 && dances[i] && dances[i].inUse
			count+=1
		elseIf mode==-1 && dances[i] && !dances[i].inUse
			count+=1
		endIf
	endWhile
	return count
endFunction

int function getPosesNum(int mode=0)
	int count=0
	int i=poses.length
	while i
		i-=1
		if mode==0 && poses[i]
			count+=1
		elseIf mode==1 && poses[i] && poses[i].inUse
			count+=1
		elseIf mode==-1 && poses[i] && !poses[i].inUse
			count+=1
		endIf
	endWhile
	return count
endFunction

int function getStripsNum(int mode=0)
	int count=0
	int i=strips.length
	while i
		i-=1
		if mode==0 && strips[i]
			count+=1
		elseIf mode==1 && strips[i] && strips[i].inUse
			count+=1
		elseIf mode==-1 && strips[i] && !strips[i].inUse
			count+=1
		endIf
	endWhile
	return count
endFunction

int function getPolesNum(int mode=0)
	if mode==0
		return spdfPoles.length
	endIf
	int count=0
	int i=spdfPoles.length
	while i
		i-=1
		if mode==1 && spdfPoles[i]
			count+=1
		elseIf mode==-1 && !spdfPoles[i]
			count+=1
		endIf
	endWhile
	return count
endFunction

int function getTagsNum(int mode=0)
	int count=0
	int i=tags.length
	while i
		i-=1
		if mode==0 && tags[i]
			count+=1
		elseIf mode==1 && tags[i] && tags[i].inUse
			count+=1
		elseIf mode==-1 && tags[i] && !tags[i].inUse
			count+=1
		endIf
	endWhile
	return count
endFunction

; -))

; ****************************************************************************************************************************************************************
; ************                                                                                                                                        ************
; ************                                             Strips                                                                                     ************
; ************                                                                                                                                        ************
; ****************************************************************************************************************************************************************

; ((- Strips

spdfStrip Function _getStripByIndex(int index)
	return strips[index]
endFunction

spdfStrip Function registerStrip(string name, string animEvent="", float len=0.0, float preLen=0.0, string poseName="", bool isOFA=false)
	; Allocate one, but check if we already have the name, in case replace
	int pos = -1
	int i = strips.length
	while i
		i-=1
		if strips[i] && strips[i].inUse>0 && !strips[i].isTemporary && strips[i].name==name
			pos = i
			i=0
		endIf
	endWhile
	if pos==-1
		i = strips.length
		while i
			i-=1
			if strips[i] && strips[i].inUse==0
				pos = i
				i = 0
			endIf
		endWhile
	endIf
	if pos==-1
		spdF._addError(99, "No more slots available for Strips! (" + name + ")", "Registry", "registerStrip")
		return None
	endIf
	
	spdfStrip s = strips[pos]
	s._init(name, animEvent, len, preLen, poseName, isOFA)
	return s
endFunction




; -))

; ****************************************************************************************************************************************************************
; ************                                                                                                                                        ************
; ************                                             Tags                                                                                       ************
; ************                                                                                                                                        ************
; ****************************************************************************************************************************************************************

; ((- tags

Function cleanUpTags()
	; Go for all tags
	int i = tags.length
	while i
		i-=1
		spdfTag t = tags[i]
		if t && t.inUse
			bool used = false
			; Check if a tag is referenced in a dance or an active performance
			int j = dances.length
			while j && !used
				j-=1
				spdfDance d = dances[j]
				if d && d.inUse
					if d._isTagExactly(t)
						used = true
						j=0
					endIf
				endIf
			endWhile
			j = performances.length
			while j && !used
				j-=1
				spdfPerformance p = performances[j]
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
	return spdfTag._tryToParseTags(tagCode, validTags, bodyParts, Self)
endFunction

spdfTag Function parseTags(string tagCode)
	; Allocate one of the tags
	spdfTag res = none
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
; ************                                             Poles                                                                                      ************
; ************                                                                                                                                        ************
; ****************************************************************************************************************************************************************

; ((-
Function _registerPole(Static pole)
	; First, check for non valid poles, and clean them up
	int i=0
	while i<spdfPoles.length
		if !spdfPoles[i]
			Static p = none
			int j=i+1
			while j<spdfPoles.length
				if spdfPoles[j]
					p = spdfPoles[j]
					spdfPoles[j] = None
					j=1000
				endIf
				j+=1
			endWhile
			spdfPoles[i] = p
		endIf
		i+=1
	endWhile
	if !pole || spdfPoles.find(pole)!=-1
		return
	endIf
	int pos = spdfPoles.find(None)
	if pos==-1
		return
	endIf
	spdfPoles[pos] = pole
endFunction

Function _unregisterPole(Static pole)
	if pole==spdfPoles[0]
		return ; Cannot remove the basic pole
	endIf
	int pos = spdfPoles.find(pole)
	if pos!=-1
		int i=pos
		while i<spdfPoles.length - 1
			spdfPoles[i] = spdfPoles[i + 1]
			i+=1
		endWhile
		spdfPoles[spdfPoles.length - 1] = None
	endIf
endFunction


Static Function getRandomPole()
	int num = getPolesNum(1)
	Static p = spdfPoles[Utility.randomInt(0, num - 1)]
	if !p
		p = spdfPoles[0]
	endIf
	return p
endFunction

Static Function _getPoleByIndex(int index)
	Static p = none
	if index>-1 && index<spdfPoles.length
		p = spdfPoles[index]
	endIf
	if !p
		p = spdfPoles[0]
	endIf
	return p
endFunction


; -))

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


; ****************************************************************************************************************************************************************
; ************                                                                                                                                        ************
; ************                                            Utilities                                                                                   ************
; ************                                                                                                                                        ************
; ****************************************************************************************************************************************************************
; ((-


spdfDance[] Function allocateDances(int count)
	if count<10
		if count==0
			debug.tracestack("SPDF: warning asked to allocate an array of zero dances!")
			return new spdfDance[1]
		elseIf count==1
			return new spdfDance[1]
		elseIf count==2
			return new spdfDance[2]
		elseIf count==3
			return new spdfDance[3]
		elseIf count==4
			return new spdfDance[4]
		elseIf count==5
			return new spdfDance[5]
		elseIf count==6
			return new spdfDance[6]
		elseIf count==7
			return new spdfDance[7]
		elseIf count==8
			return new spdfDance[8]
		elseIf count==9
			return new spdfDance[9]
		endIf
	elseIf count<20
		if count==10
			return new spdfDance[10]
		elseIf count==11
			return new spdfDance[11]
		elseIf count==12
			return new spdfDance[12]
		elseIf count==13
			return new spdfDance[13]
		elseIf count==14
			return new spdfDance[14]
		elseIf count==15
			return new spdfDance[15]
		elseIf count==16
			return new spdfDance[16]
		elseIf count==17
			return new spdfDance[17]
		elseIf count==18
			return new spdfDance[18]
		elseIf count==19
			return new spdfDance[19]
		endIf
	elseIf count<30
		if count==20
			return new spdfDance[20]
		elseIf count==21
			return new spdfDance[21]
		elseIf count==22
			return new spdfDance[22]
		elseIf count==23
			return new spdfDance[23]
		elseIf count==24
			return new spdfDance[24]
		elseIf count==25
			return new spdfDance[25]
		elseIf count==26
			return new spdfDance[26]
		elseIf count==27
			return new spdfDance[27]
		elseIf count==28
			return new spdfDance[28]
		elseIf count==29
			return new spdfDance[29]
		endIf
	else
		return new spdfDance[30] ; FIXME in future handle more dances, right now it is nonsense
	endIf
endFunction

string Function getVersionString()
	; MM.mm.bbp
	string res = ""
	int v = spdF.getVersion()
	String patch = StringUtil.AsChar(64 + v % 10)
	if patch!="@"
		res = patch
	endIf
	string build = (v / 10) % 100
	res = build+res
	string min = (v / 1000) % 100
	res = min+"."+res
	string maj = (v / 100000) % 100
	res = maj+"."+res
	return "V" + res
endFunction





; -))





