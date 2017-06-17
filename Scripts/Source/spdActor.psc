Scriptname spdActor extends ReferenceAlias

; FIXME 
; FIXME 

Actor dancer
spdPoleDances spdF
Form[] slots


Function _doInit(spdPoleDances spd)
	spdF = spd
	slots = new Form[34]
	free()
endFunction

Function setTo(Actor a)
	if !a
		return
	endIf
	dancer = a
	ForceRefTo(a)
	a.addToFaction(spdF.spdDancingFaction)
endFunction


Function free()
	if dancer
		dancer.removeFromFaction(spdF.spdDancingFaction)
		ActorUtil.removePackageOverride(dancer, spdF.spdDoNothingPackage)
		if Self.getActorRef()
			Self.getActorRef().removeFromFaction(spdF.spdDancingFaction)
			ActorUtil.removePackageOverride(Self.getActorRef(), spdF.spdDoNothingPackage)
		endIf
	endIf
	dancer = none
	clear()
endFunction

; toStrip: -1 to dress, 0 to ignore, 1 to strip
Function strip(bool animate, int[] toStrip)
	if animate
		Debug.SendAnimationEvent(dancer, "anims") ; FIXME use some better strip anims
	endIf

	Form item
	; Strip weapons
	; Right hand
	item = dancer.GetEquippedObject(1)
	if !item.hasKeyword(spdF.spdNoStrip)
		slots[33] = item
		dancer.UnequipItemEX(item, 1, false)
	endIf
	; Left hand
	item = dancer.GetEquippedObject(0)
	if !item.hasKeyword(spdF.spdNoStrip)
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
			if !item.hasKeyword(spdF.spdNoStrip)
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

Function redress(bool animate)
	if animate
		Debug.SendAnimationEvent(dancer, "anims") ; FIXME use some better strip anims
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
