Scriptname spdMCMs extends SKI_ConfigBase

int[] opts
int[] ids
int currentPose
int currentDance
string thePage
spdPoleDances spdF
spdRegistry reg

event OnConfigInit()
	opts = new int[128]
	ids = new int[128]
endEvent

event OnConfigOpen()
	currentDance=-1
	currentPose=-1
	thePage=""
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
	elseIf page=="Preview"
		thePage = "Preview"
		generatePreview()
	endIf
endEvent


Function generateDances()
	if currentDance!=-1
		spdDance d = reg._getDanceByIndex(ids[currentDance])
		if d
			LoadCustomContent("Skyrim Pole Dances/DancesPreview/" + d.name + ".swf", 0.0, 0.0)
			Utility.waitMenuMode(3.0)
			currentDance=-1
			ForcePageReset()
			return
		endIf
	endIf
	
	UnloadCustomContent()
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
	if currentPose!=-1
		spdPose p = reg._getPoseByIndex(ids[currentPose])
		if p
			LoadCustomContent("Skyrim Pole Dances/PosesPreview/" + p.name + ".dds", 0.0, 0.0)
			Utility.waitMenuMode(3.0)
			currentPose=-1
			ForcePageReset()
			return
		endIf
	endIf
	
	UnloadCustomContent()
	cleanOptions()
	SetCursorFillMode(LEFT_TO_RIGHT)
	AddHeaderOption("Poses: " + reg._getPosesNum(false) + "/" + reg._getPosesNum(true))
	SetCursorPosition(2)
	int i = 0
	int num = 0
	while i<reg._getPosesNum(true)
		spdPose p = reg._getPoseByIndex(i)
		if p && p.inUse
			opts[num] = AddTextOption(p.name, "")
			ids[num] = i
			num+=1
		endIf
		i+=1
	endWhile
endFunction


Function generatePreview()
	if currentPose==-1
		UnloadCustomContent()
		AddTextOption("Select a Pose for the preview", "", OPTION_FLAG_DISABLED)
		return
	endIf
	spdPose p = reg._getPoseByIndex(ids[currentPose])
	if p
		LoadCustomContent("Skyrim Pole Dances/PosesPreview/" + p.name + ".dds", 0.0, 0.0)
	endIf
endFunction

Function cleanOptions()
	int i = opts.length
	while i
		i-=1
		opts[i]=-1
		ids[i]=-1
	endWhile
	currentPose=-1
endFunction

Event OnOptionHighlight(int opt)
	if thePage=="Dances"
		int pos = opts.Find(opt)
		if pos!=-1
			spdDance d = reg._getDanceByIndex(ids[pos])
			String msg = "Dance: " + d.name + " StartPose: " + d.startPose.name + " EndPose: " + d.endPose.name + " Duration: " + d.duration + "\n"
			if d.danceTags
				msg += d.danceTags.print()
			endIf
			SetInfoText(msg)
		endIf
	
	elseIf thePage=="Poses"
		SetInfoText("Click on a pose to see a preview of it for 3 seconds.")
	endIf
endEvent

Event OnOptionSelect(int option)
	currentPose=-1
	if thePage=="Dances"
		currentDance = opts.find(option)
		if currentDance!=-1
			ForcePageReset()
			return
		endIf
	elseIf thePage=="Poses"
		currentPose = opts.find(option)
		if currentPose!=-1
			ForcePageReset()
			return
		endIf
	endIf
endEvent

