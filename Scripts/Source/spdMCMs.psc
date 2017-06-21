Scriptname spdMCMs extends SKI_ConfigBase

int[] opts
int[] ids
int currentPose
int currentDance
string thePage
spdPoleDances spdF
spdRegistry reg

string[] logModes

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
	if PapyrusUtil.GetVersion()
		; Scan all the files for previews and update the values of poses/dances to point to an empty one if the file is not found
		string[] allDDS
		string[] allSWF
		allDDS = MiscUtil.FilesInFolder("Data\\Interface\\Skyrim Pole Dances\\PosesPreview\\", ".dds")
		allSWF = MiscUtil.FilesInFolder("Data\\Interface\\Skyrim Pole Dances\\PosesPreview\\", ".swf")
		int i = reg._getPosesNum(true)
		while i
			i-=1
			spdPose p = reg._getPoseByIndex(i)
			if p && p.inUse
				if p.previewFile=="" || (allDDS.find(p.previewFile)==-1 && allSWF.find(p.previewFile)==-1)
					; Preview file is missing
					p.setPreview("")
				endIf
			endIf
		endWhile
		
		allDDS = MiscUtil.FilesInFolder("Data\\Interface\\Skyrim Pole Dances\\DancesPreview\\", ".dds")
		allSWF = MiscUtil.FilesInFolder("Data\\Interface\\Skyrim Pole Dances\\DancesPreview\\", ".swf")
		i = reg._getDancesNum(true)
		while i
			i-=1
			spdDance d = reg._getDanceByIndex(i)
			if d && d.inUse
				if d.previewFile=="" || (allDDS.find(d.previewFile)==-1 && allSWF.find(d.previewFile)==-1)
					; Preview file is missing
					d.setPreview("")
				endIf
			endIf
		endWhile
	endIf
	logModes = new String[4]
	logModes[0] = "No one"
	logModes[1] = "Only errors in traces"
	logModes[2] = "Logs and errors in traces"
	logModes[3] = "MessageBoxes"
endEvent

event OnPageReset(string page)
	if page==""
		LoadCustomContent("Skyrim Pole Dances/Skyrim Pole Dances.dds", 0.0, 0.0)
		return
	endIf
	UnloadCustomContent()
	if page=="Debug"
		AddTextOptionST("DebugModeMN", "Debug level", logModes[spdF.logMode])
		AddEmptyOption()
	
		if PapyrusUtil.GetVersion()
			AddTextOption("PapyrusUtil", "Ok", OPTION_FLAG_DISABLED)
		else
			AddTextOption("PapyrusUtil", "BAD!", OPTION_FLAG_DISABLED)
		endIf
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
			LoadCustomContent("Skyrim Pole Dances/DancesPreview/" + d.previewFile, 0.0, 0.0)
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
			LoadCustomContent("Skyrim Pole Dances/PosesPreview/" + p.previewFile, 0.0, 0.0)
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
			SetInfoText(msg+"\nClick on a pose to see a preview of it for 3 seconds.")
		endIf
	
	elseIf thePage=="Poses"
		SetInfoText("Click on a pose to see a preview of it for 3 seconds.")
	endIf
endEvent

Event OnOptionSelect(int option)
	currentPose=-1
	currentDance=-1
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





state DebugModeMN
	event OnMenuOpenST()
		SetMenuDialogStartIndex(spdF.logMode)
		SetMenuDialogDefaultIndex(1)
		SetMenuDialogOptions(logModes)
	endEvent

	event OnMenuAcceptST(int index)
		if index>-1 && index<logModes.length
			spdF.logMode = index
			SetMenuOptionValueST(logModes[index])
		endIf
	endEvent

	event OnDefaultST()
		spdF.logMode = 1
		SetMenuOptionValueST(logModes[1])
	endEvent

	event OnHighlightST()
		SetInfoText("Define what to put in the papyrus log in case of errors.\nWarning because the option MessageBoxes is really heavy and should be used only if papyrus.logs are not available")
	endEvent
endState


