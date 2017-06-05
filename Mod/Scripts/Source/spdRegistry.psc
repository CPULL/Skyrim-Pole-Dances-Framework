Scriptname spdRegistry

; Init function (DoInit, called by OnGameStart and OnInit of main quest)
function doInit()
	; TODO init the arrays
	; Register the ones we know (DancesDefaults)
	; Call the events to register further dances and poses
	
	; Init all actors (if there is any, just free it quickly)
	
	quest.getAliases
	resize the array
	for each alias set it with a progressive id and initialize it
	
endFunction

Faction Property spdDancingFaction Auto

; Actors
spdActor[] actors
actor[] refActors

bool function allocateActor(Actor a)
	if !a || a.isOnMout() || a.isSwimming() || a.isFlying() || a.getActorbase().isChild() || a.isChild || a.isInCombat() || a.isDead() || a.IsUnconscious() || a.isInFaction(spdDancingFaction)
		return true ; Bad actor
	endIf
	if refActors.find(a)!=-1
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

function releaseActor(Actor a)
	int pos = refActors.find(a)
	if a==-1
		return
	endIf
	
	actors[pos].clear()
	refActors[pos] = none
endFunction


; Poses
spdPose[] poses

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






; Dance Anims
spdDance[] dances

spdDance[] Function findDance(spdPose pose)
	int count = 0
	int i = dances.length
	while i
		i-=1
		if dances[i].startPose==pose
			count += 1
		endIf
	endWhile
	
	; Allocate the array (damn, a SKSE plugin will be beneficial here)
	spdDance res = allocateDances(count)
	count = 0
	i = dances.length
	while i && count<res.length
		i-=1
		if dances[i].startPose==pose
			res[count] = dances[i]
			count += 1
		endIf
	endWhile
	
	return res
endFunction





; registration functions



; TODO


bool Function useGlobalHook(string eventName)
	; check if the hook is global and return yes/no
endFunction

Function registerForGlobalHooks(string eventName)
	; just add a yes/no for each known event
endFunction


spdDaces[] Function allocateDances(int count)
	if count<10
		if count==0
			return new spdDances[0]
		elseIf count==1
			return new spdDances[1]
		elseIf count==2
			return new spdDances[2]
		elseIf count==3
			return new spdDances[3]
		elseIf count==4
			return new spdDances[4]
		elseIf count==5
			return new spdDances[5]
		elseIf count==6
			return new spdDances[6]
		elseIf count==7
			return new spdDances[7]
		elseIf count==8
			return new spdDances[8]
		elseIf count==9
			return new spdDances[9]
		endIf
	elseIf count<20
		if count==10
			return new spdDances[10]
		elseIf count==11
			return new spdDances[11]
		elseIf count==12
			return new spdDances[12]
		elseIf count==13
			return new spdDances[13]
		elseIf count==14
			return new spdDances[14]
		elseIf count==15
			return new spdDances[15]
		elseIf count==16
			return new spdDances[16]
		elseIf count==17
			return new spdDances[17]
		elseIf count==18
			return new spdDances[18]
		elseIf count==19
			return new spdDances[19]
		endIf
	elseIf count<30
		if count==20
			return new spdDances[20]
		elseIf count==21
			return new spdDances[21]
		elseIf count==22
			return new spdDances[22]
		elseIf count==23
			return new spdDances[23]
		elseIf count==24
			return new spdDances[24]
		elseIf count==25
			return new spdDances[25]
		elseIf count==26
			return new spdDances[26]
		elseIf count==27
			return new spdDances[27]
		elseIf count==28
			return new spdDances[28]
		elseIf count==29
			return new spdDances[29]
		endIf
	else
		return new spdDances[30] ; FIXME in future handle more dances, right now it is nonsense
	endIf
endFunction
