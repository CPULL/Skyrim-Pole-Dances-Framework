Scriptname spdPlayerLoadGame extends ReferenceAlias

spdPoleDances spdF = None

Event OnInit()
	Utility.wait(2.0)
	if !spdF
		spdF = spdPoleDances.getInstance()
		spdF._doInit()
	endIf
endEvent


Event OnPlayerLoadGame()
	Utility.wait(5.0)
	if !spdF
		spdF = spdPoleDances.getInstance()
		spdF._doInit()
	endIf
endEvent
