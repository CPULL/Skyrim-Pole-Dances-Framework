Scriptname spdMCMs extends SKI_ConfigBase

int[] opts
int[] ids
int currentPose
string thePage
spdPoleDances spdF
spdRegistry reg

event OnConfigInit()
	opts = new int[128]
	ids = new int[128]
	spdF = spdPoleDances.getInstance()
	reg = spdF.registry
endEvent

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
		thePage = "Dances"
		generateDances()
	elseIf page=="Poses"
		thePage = "Poses"
		generatePoses()
	endIf
endEvent


Function generateDances()
	cleanOptions()
	SetCursorFillMode(LEFT_TO_RIGHT)
	AddHeaderOption("Dances: " + reg._getDancesNum(false) + "/" + reg._getDancesNum(true))
	SetCursorPosition(2)
	int i = 0
	int num = 0
	while i<reg._getDancesNum(true)
		spdDance d = reg._getDanceByIndex(i)
		if d && d.inUse
			opts[num] = AddTextOption(d.name, "")
			ids[num] = i
			num+=1
		endIf
		i+=1
	endWhile
endFunction

Function generatePoses()
	cleanOptions()
	SetCursorFillMode(LEFT_TO_RIGHT)
	AddHeaderOption("Poses: " + reg._getPosesNum(false) + "/" + reg._getPosesNum(true))
	SetCursorPosition(2)
	int i = 0
	int num = 0
	while i<reg._getPosesNum(true)
		spdPose p = reg._getPoseByIndex(i)
		if p && p.inUse
			opts[num] = AddTextOption(p.name, "", OPTION_FLAG_DISABLED)
			ids[num] = i
			num+=1
		endIf
		i+=1
	endWhile
endFunction


Function cleanOptions()
	int i = opts.length
	while i
		i-=1
		opts[i]=-1
		ids[i]=-1
	endWhile
endFunction

Event OnOptionHighlight(int opt)
	if thePage=="Dances"
		int pos = opts.Find(opt)
		if pos!=-1
			spdDance d = reg._getDanceByIndex(ids[pos])
			String msg = "Dance: " + d.name + " StartPose: " + d.startPose.name + " EndPose: " + d.endPose.name + " Duration: " + d.duration + "\n"
			if d.danceTags
				msg += d.danceTags.print()
			else
debug.trace("SPD SPD: no tag")
			endIf
			SetInfoText (msg)
		endIf
	
	elseIf thePage=="Poses"
	endIf
endEvent

