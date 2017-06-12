Scriptname spdRegistry extends Quest

spdPoleDances spdF

package Property spdWalkPackage Auto
package Property spdDoNothingPackage Auto

string[] bodyParts
spdPerformance[] performances
spdDance[] dances
spdPose[] poses
spdTag[] tags
int[] tagRegistry
string[] validTags


; ****************************************************************************************************************************************************************
; ************                                                                                                                                        ************
; ************                                           Init Functions                                                                               ************
; ************                                                                                                                                        ************
; ****************************************************************************************************************************************************************

; Init function (DoInit, called by OnGameStart and OnInit of main quest)
function _doInit(int version, spdPoleDances spd)
	; TODO init the arrays
	; Register the ones we know (DancesDefaults)
	; Call the events to register further dances and poses
	
	spdF = spd
	
	
	; Init all actors (if there is any, just free it quickly)
	
	; FIXME
;	quest.getAliases
;	resize the array
;	for each alias set it with a progressive id and initialize it
	
	reInit(version, spd)
endFunction

; This will just check stuff, and call the mod event to have other mods to add their own dances
Function reInit(int version, spdPoleDances spd)
	; TODO

debug.trace("SPD: Registry reInit")
	
	spdF = spd
	; Load all known poses and dances
	editing = true
	
	
	; ((- Body Parts
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

	; -))
	
	
	; Performances TODO
debug.trace("SPD: Registry init of performances")
	int i = performances.length
	while i
		i-=1
		performances[i]._doInit(spdF)
	endWhile

	performances = new spdPerformance[8]
	dances = new spdDance[16]
	poses = new spdPose[16]
	tags = new spdTag[64]
	
	; Dances TODO
	int countPerformances = 0
	int countDances = 0
	int countPoses = 0
	int countTags = 0
	Alias[] allAliases = GetAliases()
	i = allAliases.length
	while i
		i-=1
		if StringUtil.Find(allAliases[i].GetName(), "spdPerformance")!=-1
			performances[countPerformances] = allAliases[i] as spdPerformance
			countPerformances += 1
		elseIf StringUtil.Find(allAliases[i].GetName(), "spdDance")!=-1
			dances[countDances] = allAliases[i] as spdDance
			countDances += 1
		elseIf StringUtil.Find(allAliases[i].GetName(), "spdPose")!=-1
			poses[countPoses] = allAliases[i] as spdPose
			countPoses += 1
		elseIf StringUtil.Find(allAliases[i].GetName(), "spdTag")!=-1
			tags[countTags] = allAliases[i] as spdTag
			countTags += 1
		endIf
	endWhile
	
debug.trace("SPD: Found " + countDances + " Dances")
debug.trace("SPD: Found " + countPoses + " poses")
debug.trace("SPD: Found " + countTags + " tags")
	
	
	; Poses TODO
	
	; Tags TODO
	
	
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



; ****************************************************************************************************************************************************************
; ************                                                                                                                                        ************
; ************                                             Performances                                                                               ************
; ************                                                                                                                                        ************
; ****************************************************************************************************************************************************************
; ((-

spdPerformance Function _allocatePerformance()
	int i = 0
	while i<performances.length
		if !performances[i].isInUse()
			if !performances[i].use(spdF)
				return performances[i]
			endIf
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

Faction Property spdDancingFaction Auto

; Actors
spdActor[] actors
actor[] refActors

bool function _allocateActor(Actor a)
	if !a
		spdF._addError(2, "Trying to allocate a null actor", "Registry", "allocateActor")
		return true ; Bad actor
	endIf
	
	if a.isOnMount() || a.isSwimming() || a.isFlying() || a.getRace().IsChildRace() || a.isChild() || a.isInCombat() || a.isDead() || a.IsUnconscious()
		spdF._addError(3, "Trying to allocate a non valid actor: " + a.getDisplayName(), "Registry", "allocateActor")
		return true ; Bad actor
	endIf
	if a.isInFaction(spdDancingFaction) && refActors.find(a)!=-1
		spdF._addError(4, "The actor " + a.getDisplayName() + " is already allocated and dancing", "Registry", "allocateActor")
		return true ; Already used
	endIf
	
	; OK, set the actor and lock it
	int pos = refActors.find(None)
	if pos==-1
		return true ; Too many actors
	endIf
	
	refActors[pos] = a
	actors[pos].set(a) ; This will lock the actor effectively
	return false
endFunction

function _releaseDancer(Actor a)
	int pos = refActors.find(a)
	if pos==-1
		return
	endIf
	
	actors[pos].clear()
	refActors[pos] = none
endFunction

Function _lockActor(Actor a, Package pkg, ObjectReference pole)
	; Remove the controls in case is the player
	; Set the package
	; Associate with the pole
	; FIXME
endFunction

Function _unlockActor(Actor a)
	; Give back controls if player
	; Remove the package
	; FIXME
endFunction

; -))

; ****************************************************************************************************************************************************************
; ************                                                                                                                                        ************
; ************                                           Poses                                                                                        ************
; ************                                                                                                                                        ************
; ****************************************************************************************************************************************************************

; ((- Poses

spdPose Function findRandomStartPose()
	return poses[Utility.randomInt(0, poses.length - 1)]
endFunction


spdPose Function findPose(string poseName)
	int i=poses.length
	while i
		i-=1
		if poses[i].name==poseName
			return poses[i]
		endIf
	endWhile
	return none
endFunction


; -))

; ****************************************************************************************************************************************************************
; ************                                                                                                                                        ************
; ************                                            Dances                                                                                      ************
; ************                                                                                                                                        ************
; ****************************************************************************************************************************************************************

; ((-

; Dance Anims

spdDance Function findDanceByPose(spdPose pose)
	int count = 0
	int i = dances.length
	while i
		i-=1
		if dances[i].startPose==pose
			count += 1
		endIf
	endWhile
	
	; Allocate the array (damn, a SKSE plugin will be beneficial here)
	spdDance[] res = allocateDances(count)
	count = 0
	i = dances.length
	while i && count<res.length
		i-=1
		if dances[i].startPose==pose
			res[count] = dances[i]
			count += 1
		endIf
	endWhile
	
	return res[Utility.randomInt(0, res.length - 1)]
endFunction

spdDance Function findDanceByName(string name)
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
	; FIXME find all dances that are respecting the tag and return a random one
	return dances[0]
endFunction

spdDance Function findRandomDance()
	; FIXME pick one randomly
	return dances[0]
endFunction

spdDance Function findTransitionDance(spdPose prev, spdPose next)
	; FIXME check in all dances the ones that start with the prev and ends with next, then give one back randomly
	return dances[0]
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


string Function tryToParseTags(string tagCode)
	return spdTag._tryToParseTags(tagCode, validTags, bodyParts, Self)
endFunction

; FIXME do a way to release the used tags

spdTag Function parseTags(string tagCode)
	; Allocate one of the tags
	int pos = tagRegistry.find(0)
	if pos==-1
		spdF._addError(99, "No more available tags!", "Registry", "parseTag") ; FIXME change the error code
		return none
	endIf

	spdTag res = tags[pos]
	tagRegistry[pos] = 1
	
	if res._init(tagCode, validTags, bodyParts, spdF)
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
			return none
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





