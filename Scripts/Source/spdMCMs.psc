Scriptname spdMCMs extends SKI_ConfigBase

event OnPageReset(string page)
	if page==""
		LoadCustomContent("Skyrim Pole Dances/Skyrim Pole Dances.dds", 0.0, 0.0)
		return
	endIf
	UnloadCustomContent()
	if page=="Debug"
		if PapyrusUtil.GetVersion()
			AddTextOption("PapyrusUtil", "Ok", OPTION_FLAG_DISABLED)
		else
			AddTextOption("PapyrusUtil", "BAD!", OPTION_FLAG_DISABLED)
		endIf
	elseIf page=="Dances"
		SetCursorFillMode(TOP_TO_BOTTOM)
		spdPoleDances spd = spdPoleDances.getInstance()
		spdRegistry reg = spd.registry
		AddHeaderOption("Dances: " + reg._getDancesNum(false) + "/" + reg._getDancesNum(true))
		int i = 0
		while i<reg._getDancesNum(true)
			spdDance d = reg._getDanceByIndex(i)
			if d.inUse
				AddTextOption(d.name, "", OPTION_FLAG_DISABLED)
			endIf
			i+=1
		endWhile
		SetCursorPosition(1)
		AddHeaderOption("Poses: " + reg._getPosesNum(false) + "/" + reg._getPosesNum(true))
		i = 0
		while i<reg._getPosesNum(true)
			spdPose p = reg._getPoseByIndex(i)
			if p.inUse
				AddTextOption(p.name, "", OPTION_FLAG_DISABLED)
			endIf
			i+=1
		endWhile
	endIf
endEvent
