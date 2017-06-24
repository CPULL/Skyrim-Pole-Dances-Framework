Scriptname spdfActor extends ReferenceAlias

; FIXME 
; FIXME 

Actor dancer
spdfPoleDances spdF
Package currentPkg
Form[] slots
bool _inUse

Function _doInit(spdfPoleDances spd)
	spdF = spd
	slots = new Form[34]
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
	clear()
	_inUse = false
endFunction

; toStrip: -1 to dress, 0 to ignore, 1 to strip
Function strip(bool animate, int[] toStrip, float time=0.0)
	Float startT = Utility.getCurrentRealTime()
	if animate
		Debug.SendAnimationEvent(dancer, "Arrok_Undress_G1") ; FIXME use some better strip anims
	endIf

	Form item
	; Strip weapons
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
	; Strip armors
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
	if time!=0.0
		float toWait = time - (Utility.getCurrentRealTime() - startT)
		if toWait>0.0
			Utility.waitMenuMode(toWait)
		endIf
	else
		Utility.waitMenuMode(1.0)
	endIf
endFunction

Function redress(bool animate)
	if animate
		Debug.SendAnimationEvent(dancer, "Arrok_Undress_G1") ; FIXME use some better strip anims
	endIf

	Form item
	; Re-get Right weapon
	item = slots[33]
	if item
		slots[33] = None
		dancer.equipItemEX(item, 1, false)
	endIf
	; Re-get Left weapon
	item = slots[32]
	if item
		slots[32] = None
		dancer.equipItemEX(item, 2, false)
	endIf
	; Re-equip armors
	int i = 32
	while i
		i -= 1
		if slots[i]
			dancer.equipItem(item, false, true)
			slots[i] = None
		endIf
	endWhile
endFunction

Function doStripByDance(spdfDance d, float time)
	strip(d._AnimatedStrips(), d._stripSlots(), time)
endFunction
