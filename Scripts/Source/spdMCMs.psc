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
	endIf
endEvent
