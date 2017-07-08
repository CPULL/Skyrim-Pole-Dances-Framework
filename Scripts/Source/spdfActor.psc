Scriptname spdfActor extends ReferenceAlias

Actor dancer
spdfPoleDances spdF
Package currentPkg
Form[] slots
string ofaHKX
spdfStrip ofaS
bool _inUse

Function _doInit(spdfPoleDances spd)
	spdF = spd
	slots = new Form[34]
	ofaHKX=""
	ofaS = None
	free()
endFunction

bool Property inUse
	bool Function get()
		return _inUse
	endFunction
endProperty

Function setTo(Actor a)
	if !a
		return
	endIf
	_inUse = true
	dancer = a
	ForceRefTo(a)
	a.addToFaction(spdF.spdfDancingFaction)
	currentPkg = None
endFunction

Function _lock(Package pkg)
	if !dancer
		return
	endIf
	; Remove the controls in case is the player
	if dancer==spdF.PlayerRef
		Game.SetPlayerAIDriven(true)
		Game.forceThirdPerson()
	endIf
	; Set the package
	if currentPkg
		ActorUtil.removePackageOverride(dancer, currentPkg)
	endIf
	dancer.stopCombat()
	_removeWeapons(dancer)
	currentPkg = pkg
	ActorUtil.addPackageOverride(dancer, pkg)
	dancer.evaluatePackage()
endFunction

Function _removeWeapons(Actor a) Global
	Form item = a.GetEquippedObject(1)
	if item
		a.UnequipItemEX(item, 1, false)
	endIf
	item = a.GetEquippedObject(0)
	if item
		a.UnequipItemEX(item, 2, false)
	endIf
endFunction

Function free()
	if dancer
		Debug.SendAnimationEvent(dancer, "IdleForceDefaultState")
		dancer.removeFromFaction(spdF.spdfDancingFaction)
		if currentPkg
			ActorUtil.removePackageOverride(dancer, currentPkg) ; Remove the package
			dancer.evaluatePackage()
			currentPkg = None
		endIf
		if Self.getActorRef() && Self.getActorRef()!=dancer
			Debug.SendAnimationEvent(Self.getActorRef(), "IdleForceDefaultState")
			Self.getActorRef().removeFromFaction(spdF.spdfDancingFaction)
			if currentPkg
				ActorUtil.removePackageOverride(Self.getActorRef(), currentPkg) ; Remove the package
				currentPkg = None
			endIf
		endIf
		; Give back controls if player
		if dancer==spdF.PlayerRef || Self.getActorRef()==spdF.PlayerRef
			Game.SetPlayerAIDriven(false)
		endIf
	endIf
	dancer = none
	ofaHKX=""
	ofaS = None
	clear()
	_inUse = false
endFunction

; toStrip: -1 to dress, 0 to ignore, 1 to strip
Function strip(spdfStrip s)
	float startT = Utility.getCurrentRealTime()
	float toWait = 0.0
	if s.isOFA
		; In case we receive many, we should wait until we complete the prev one (at least the pre-strip part)
		while ofaHKX!=""
			Utility.wait(0.1)
		endWhile
	
		; In case it is OFA, send the event, but don't do the actual strip
		ofaS = s
		Debug.SendAnimationEvent(dancer, s.hkx)
		toWait = s.preStripDuration - (Utility.getCurrentRealTime() - startT)
debug.trace("Sending strip anim event: " + s.HKX + " toWait=" + toWait)
		if toWait>0.0
			ofaHKX = s.hkx
			RegisterForSingleUpdate(toWait)
			return
		endIf
		ofaHKX = ""
		executeStrip(s)
		
	else
		; In case is !OFA, do the strip (and stop active)
		ofaHKX = ""
		if s.hkx
			Debug.SendAnimationEvent(dancer, s.hkx)
		endIf
		if s.preStripDuration>0.0
			toWait = s.preStripDuration - (Utility.getCurrentRealTime() - startT)
			if toWait>0.0
				Utility.waitMenuMode(toWait)
			endIf
		endIf
		executeStrip(s)
		; Now wait for the remaining time
		toWait = s.duration - s.preStripDuration - (Utility.getCurrentRealTime() - startT)
		if toWait>0.0
			Utility.waitMenuMode(toWait)
		endIf
	endIf
endFunction

function executeStrip(spdfStrip s)
	Form item
	; Strip weapons
	if s.stripWeapons
		; Right hand
		item = dancer.GetEquippedObject(1)
		if item && !item.hasKeyword(spdF.spdfNoStrip)
			slots[33] = item
			dancer.UnequipItemEX(item, 1, false)
		endIf
		; Left hand
		item = dancer.GetEquippedObject(0)
		if item && !item.hasKeyword(spdF.spdfNoStrip)
			slots[32] = item
			dancer.UnequipItemEX(item, 2, false)
		endIf
	endIf
	
	; Strip armors
	int[] toStrip = s.stripSlots()
	int i = 32
	while i
		i -= 1
		if toStrip[i]>0
			; Grab item in slot and strip it
			item = dancer.GetWornForm(Armor.GetMaskForSlot(i + 30))
			if item && !item.hasKeyword(spdF.spdfNoStrip)
				dancer.UnequipItem(item, false, true)
				slots[i] = item
			endIf
		elseIf toStrip[i]<0
			; Grab item in storage and re-equip
			item = slots[i]
			if item
				dancer.equipItem(item, false, true)
				slots[i] = None
			endIf
		endIf
	endWhile
endFunction
	

Event OnUpdate()
	executeStrip(ofaS)
	ofaS = None
	ofaHKX = ""
	; No need to wait more for the OFA anims
endEvent
