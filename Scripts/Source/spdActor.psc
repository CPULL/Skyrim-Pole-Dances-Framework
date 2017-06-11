Scriptname spdActor extends ReferenceAlias

; FIXME Add some items to store the clothes (used for stripping and redressing)
; FIXME Add face expressions?
; FIXME 
; FIXME 

int id
Actor dancer
Package spdDoNothingPackage
Faction spdDancingFaction

Function init(int theID, Package pkg, Faction fac)
	id = theID
	spdDoNothingPackage = pkg
	spdDancingFaction = fac
	clear()
endFunction

Function set(Actor a)
	if !a
		return
	endIf
	dancer = a
	ForceRefTo(a)
	a.addToFaction(spdDancingFaction)
endFunction


Function clear()
	if dancer
		dancer.removeFromFaction(spdDancingFaction)
		ActorUtil.removePackageOverride(dancer, spdDoNothingPackage)
		if Self.getActorRef()
			Self.getActorRef().removeFromFaction(spdDancingFaction)
			ActorUtil.removePackageOverride(Self.getActorRef(), spdDoNothingPackage)
		endIf
	endIf
	dancer = none
	clear()
endFunction