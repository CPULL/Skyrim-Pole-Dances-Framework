Scriptname spdActor extends ReferenceAlias

int id
Actor dancer
Package doNothingPackage

Function init(int theID)
	id = theID
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
		ActorUtils.removePackageOverride(dancer, spdDoNothingPackage)
		if Self.getActorRef()
			Self.getActorRef().removeFromFaction(spdDancingFaction)
			ActorUtils.removePackageOverride(Self.getActorRef(), spdDoNothingPackage)
		endIf
	endIf
	dancer = none
	clear()
endFunction