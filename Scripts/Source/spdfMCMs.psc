Scriptname spdfMCMs extends SKI_ConfigBase

int[] opts
int[] ids
int currentPoseIdx
int currentDanceIdx
int currentStripIdx
string thePage
spdfPoleDances spdF
spdfRegistry reg

string[] logModes






event OnConfigInit()
	opts = new int[128]
	ids = new int[128]
endEvent

event OnConfigOpen()
	currentDanceIdx=-1
	currentPoseIdx=-1
	currentStripIdx=-1
	thePage=""
	spdF = spdfPoleDances.getInstance()
	reg = spdF.registry
	if PapyrusUtil.GetVersion() >= 33
		; Scan all the files for previews and update the values of poses/dances to point to an empty one if the file is not found
		string[] allDDS
		string[] allSWF
		allDDS = MiscUtil.FilesInFolder("Data\\Interface\\Skyrim Pole Dances\\PosesPreview\\", ".dds")
		allSWF = MiscUtil.FilesInFolder("Data\\Interface\\Skyrim Pole Dances\\PosesPreview\\", ".swf")
		int i = reg.getPosesNum(0)
		while i
			i-=1
			spdfPose p = reg._getPoseByIndex(i)
			if p && p.inUse
				if p.previewFile=="" || (allDDS.find(p.previewFile)==-1 && allSWF.find(p.previewFile)==-1)
					; Preview file is missing
					p.previewFile = "" ; This will set it as the basic "unknown" one.
				endIf
			endIf
		endWhile
		
		allDDS = MiscUtil.FilesInFolder("Data\\Interface\\Skyrim Pole Dances\\DancesPreview\\", ".dds")
		allSWF = MiscUtil.FilesInFolder("Data\\Interface\\Skyrim Pole Dances\\DancesPreview\\", ".swf")
		i = reg.getDancesNum(0)
		while i
			i-=1
			spdfDance d = reg._getDanceByIndex(i)
			if d && d.inUse
				if d.previewFile=="" || (allDDS.find(d.previewFile)==-1 && allSWF.find(d.previewFile)==-1)
					; Preview file is missing
					d.previewFile = "" ; This will set it as the basic "unknown" one.
				endIf
			endIf
		endWhile
		
		allDDS = MiscUtil.FilesInFolder("Data\\Interface\\Skyrim Pole Dances\\StripsPreview\\", ".dds")
		allSWF = MiscUtil.FilesInFolder("Data\\Interface\\Skyrim Pole Dances\\StripsPreview\\", ".swf")
		i = reg.getStripsNum(0)
		while i
			i-=1
			spdfStrip s = reg._getStripByIndex(i)
			if s && s.inUse
				if s.previewFile=="" || (allDDS.find(s.previewFile)==-1 && allSWF.find(s.previewFile)==-1)
					; Preview file is missing
					s.previewFile = "" ; This will set it as the basic "unknown" one.
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
		thePage = "Debug"
		generateDebug()
	elseIf page=="Dances"
		if thePage=="Dance" && currentDanceIdx!=-1
			showDance()
		else
			thePage = "Dances"
			generateDances()
		endIf
	elseIf page=="Poses"
		if thePage=="Pose" && currentPoseIdx!=-1
			showPose()
		else
			thePage = "Poses"
			generatePoses()
		endIf
	elseIf page=="Strips"
		if thePage=="Strip" && currentStripIdx!=-1
			showStrip()
		else
			thePage = "Strips"
			generateStrips()
		endIf
	endIf
endEvent

Function generateDebug()
	SetTitleText("Pole Dances Framework - Debug page")
	SetCursorFillMode(TOP_TO_BOTTOM)
	AddTextOption("Version:", reg.getVersionString(), OPTION_FLAG_DISABLED)
	AddEmptyOption()
	AddTextOptionST("DebugModeMN", "Debug level", logModes[spdF.logMode])
	AddEmptyOption()

	if PapyrusUtil.GetVersion()
		if PapyrusUtil.GetVersion()>=32
			AddTextOption("PapyrusUtil V3.2", "Ok", OPTION_FLAG_DISABLED)
		else
			AddTextOption("PapyrusUtil V3.2", "BAD!", OPTION_FLAG_DISABLED)
		endIf
	else
		AddTextOption("PapyrusUtil V3.2", "MISSING!", OPTION_FLAG_DISABLED)
	endIf
	SetCursorPosition(1)
	AddTextOption("Performances (in use)", reg.getPerformancesNum(1) + "/" + reg.getPerformancesNum(0))
	AddTextOption("Actors (in use)", reg.getActorsNum(1) + "/" + reg.getActorsNum(0))
	AddTextOption("Dances", reg.getDancesNum(1) + "/" + reg.getDancesNum(0))
	AddTextOption("Poses", reg.getPosesNum(1) + "/" + reg.getPosesNum(0))
	AddTextOption("Strip Slots", reg.getStripsNum(1) + "/" + reg.getStripsNum(0))
	AddTextOption("Poles", reg.getPolesNum(1) + "/" + reg.getPolesNum(0))
	
	SetCursorPosition(23)
	AddTextOptionST("ReInitBN", "Re-init the framework", "Init")

endFunction

Function generateDances()
	cleanOptions()
	SetCursorFillMode(LEFT_TO_RIGHT)
	int i = 0
	int num = 0
	while i<reg.getDancesNum(0)
		spdfDance d = reg._getDanceByIndex(i)
		if d
			if d.inUse==1
				opts[num] = AddTextOption(d.name, "")
				ids[num] = i
				num+=1
			elseIf d.inUse==2
				opts[num] = AddTextOption(d.name, "DISABLED")
				ids[num] = i
				num+=1
			endIf
		endIf
		i+=1
	endWhile
endFunction

Function showDance()
	UnloadCustomContent()
	SetCursorFillMode(TOP_TO_BOTTOM)
	spdfDance d = reg._getDanceByIndex(currentDanceIdx)
	if !d
		thePage="Dances"
		currentDanceIdx=-1
		ForcePageReset()
		return
	endIf
	AddTextOption(d.name, "", OPTION_FLAG_DISABLED)
	AddTextOption("Duration", trimFloat(d.duration), OPTION_FLAG_DISABLED)
	AddTextOption("Start", d.startPose.name, OPTION_FLAG_DISABLED)
	AddTextOption("End", d.endPose.name, OPTION_FLAG_DISABLED)
	if d.isTransition
		AddTextOption("It is a Transition between poses", "", OPTION_FLAG_DISABLED)
	endIf
	if d.tags
		AddTextOption(d.tags.print(), "", OPTION_FLAG_DISABLED)
	endIf
	
	SetCursorPosition(1)
	opts[0]=AddTextOption("", "Preview")
	opts[1]=AddToggleOption("Enabled", d.inUse==1)
	SetCursorPosition(23)
	opts[2]=AddTextOption("", "Back")
endFunction


Function generatePoses()
	if currentPoseIdx!=-1 ; FIXME
		spdfPose p = reg._getPoseByIndex(currentPoseIdx)
		if p
			LoadCustomContent("Skyrim Pole Dances/PosesPreview/" + p.previewFile, 0.0, 0.0)
			Utility.waitMenuMode(3.0)
			currentPoseIdx=-1
			ForcePageReset()
			return
		endIf
	endIf
	
	UnloadCustomContent()
	cleanOptions()
	SetCursorFillMode(LEFT_TO_RIGHT)
	AddHeaderOption("Poses: " + reg.getPosesNum(1) + "/" + reg.getPosesNum(0))
	SetCursorPosition(2)
	int i = 0
	int num = 0
	while i<reg.getPosesNum(0)
		spdfPose p = reg._getPoseByIndex(i)
		if p
			if p.inUse==1
				opts[num] = AddTextOption(p.name, "")
				ids[num] = i
				num+=1
			elseIf p.inUse==2
				opts[num] = AddTextOption(p.name, "DISABLED")
				ids[num] = i
				num+=1
			endIf
		endIf
		i+=1
	endWhile
endFunction

Function showPose()
	UnloadCustomContent()
	SetCursorFillMode(TOP_TO_BOTTOM)
	spdfPose p = reg._getPoseByIndex(currentPoseIdx)
	if !p
		thePage="Poses"
		currentPoseIdx=-1
		ForcePageReset()
		return
	endIf
	AddTextOption(p.name, "", OPTION_FLAG_DISABLED)
	if p.hkx
		AddTextOption("", "Has Animation", OPTION_FLAG_DISABLED)
		AddTextOption("Duration", trimFloat(p.duration), OPTION_FLAG_DISABLED)
	else
		AddTextOption("", "No Animation", OPTION_FLAG_DISABLED)
	endIf
	if p.startHKX
		AddTextOption("Start Duration", trimFloat(p.startDuration), OPTION_FLAG_DISABLED)
	else
		AddTextOption("", "No Start Animation", OPTION_FLAG_DISABLED)
	endIf
	if p.endHKX
		AddTextOption("End Duration", trimFloat(p.endDuration), OPTION_FLAG_DISABLED)
	else
		AddTextOption("", "No End Animation", OPTION_FLAG_DISABLED)
	endIf
	
	SetCursorPosition(1)
	opts[0]=AddTextOption("", "Preview")
	opts[1]=AddToggleOption("Enabled", p.inUse==1)
	SetCursorPosition(23)
	opts[2]=AddTextOption("", "Back")
endFunction



Function generateStrips()
	UnloadCustomContent()
	cleanOptions()
	SetCursorFillMode(LEFT_TO_RIGHT)
	AddHeaderOption("Strips: " + reg.getStripsNum(1) + "/" + reg.getStripsNum(0))
	SetCursorPosition(2)
	int i = 0
	int num = 0
	while i<reg.getStripsNum(0)
		spdfStrip s = reg._getStripByIndex(i)
		if s
			if s.inUse==1
				if s.isTemporary
					opts[num] = AddTextOption(s.name, "")
				else
					opts[num] = AddTextOption(s.name, "<tmp>")
				endIf
				ids[num] = i
				num+=1
			elseIf s.inUse==2
				if s.isTemporary
					opts[num] = AddTextOption(s.name, "DISABLED")
				else
					opts[num] = AddTextOption(s.name, "DISABLED <tmp>")
				endIf
				ids[num] = i
				num+=1
			endIf
		endIf
		i+=1
	endWhile
endFunction

Function showStrip()
	UnloadCustomContent()
	SetCursorFillMode(TOP_TO_BOTTOM)
	spdfStrip s = reg._getStripByIndex(currentStripIdx)
	if !s
		thePage="Strips"
		currentStripIdx=-1
		ForcePageReset()
		return
	endIf
	
	AddTextOption(s.name, "", OPTION_FLAG_DISABLED)
	if s.pose
		AddTextOption("Pose", s.pose.name, OPTION_FLAG_DISABLED)
	endIf
	if s.isTemporary
		AddTextOption("", "TEMPORARY", OPTION_FLAG_DISABLED)
	endIf
	if s.animatedStrip
		AddTextOption("", "ANIMATED", OPTION_FLAG_DISABLED)
	endIf
	if s.isOFA
		AddTextOption("", "Uses Offset Arm Animation", OPTION_FLAG_DISABLED)
	endIf
	if s.stripWeapons
		AddTextOption("", "Strips Weapons", OPTION_FLAG_DISABLED)
	endIf
	AddTextOption("Duration", trimFloat(s.duration), OPTION_FLAG_DISABLED)
	if s.preStripDuration!=0.0
		AddTextOption("Actual strip after", trimFloat(s.preStripDuration), OPTION_FLAG_DISABLED)
	endIf
	
	SetCursorPosition(1)
	if s.isTemporary
		opts[0]=-1
		opts[1]=-1
	else
		opts[0]=AddTextOption("", "Preview")
		opts[1]=AddToggleOption("Enabled", s.inUse==1)
	endIf
	SetCursorPosition(23)
	opts[2]=AddTextOption("", "Back")
endFunction

; ((- Generic event functions

Event OnOptionHighlight(int opt)
	if thePage=="Dances"
		int pos = opts.Find(opt)
		if pos!=-1
			spdfDance d = reg._getDanceByIndex(ids[pos])
			String msg = "Dance: " + d.name + " StartPose: " + d.startPose.name + " EndPose: " + d.endPose.name + " Duration: " + d.duration + "\n"
			if d.tags
				msg += d.tags.print()
			endIf
			SetInfoText(msg+"\nClick on a pose to see a preview of it for 3 seconds.")
		endIf
	
	elseIf thePage=="Poses"
		SetInfoText("Click on a pose to see a preview of it for 3 seconds.")
		
	elseIf thePage=="Strips"
		int pos = opts.Find(opt)
		if pos!=-1
			SetInfoText(reg._getStripByIndex(ids[pos]).name)
		else
			SetInfoText("Click on a strip to see the long description and a preview of it for 3 seconds.")
		endIf
	endIf
endEvent

Event OnOptionSelect(int option)
	if thePage=="Dances"
		int pos = opts.find(option)
		if pos!=-1
			thePage="Dance"
			currentDanceIdx = ids[pos]
			ForcePageReset()
			return
		endIf
		
	elseIf thePage=="Dance"
		if option==opts[0]
			spdfDance d = reg._getDanceByIndex(currentDanceIdx)
			if d
				LoadCustomContent("Skyrim Pole Dances/DancesPreview/" + d.previewFile, 0.0, 0.0)
				Utility.waitMenuMode(3.0)
				ForcePageReset()
				return
			endIf
		elseIf option==opts[1]
			spdfDance d = reg._getDanceByIndex(currentDanceIdx)
			if d && d.inUse==1
				d.disable()
				SetToggleOptionValue(option, false)
			elseIf d && d.inUse==2
				d.enable()
				SetToggleOptionValue(option, true)
			endIf
			return
		elseIf option==opts[2]
			thePage=="Dances"
			currentDanceIdx=-1
			ForcePageReset()
			return
		endIf

	elseIf thePage=="Poses"
		int pos = opts.find(option)
		if pos!=-1
			thePage="Pose"
			currentPoseIdx = ids[pos]
			ForcePageReset()
			return
		endIf
		
	elseIf thePage=="Pose"
		if option==opts[0]
			spdfPose p = reg._getPoseByIndex(currentPoseIdx)
			if p
				LoadCustomContent("Skyrim Pole Dances/PosesPreview/" + p.previewFile, 0.0, 0.0)
				Utility.waitMenuMode(3.0)
				ForcePageReset()
				return
			endIf
		elseIf option==opts[1]
			spdfPose p = reg._getPoseByIndex(currentPoseIdx)
			if p && p.inUse==1
				; MsgBox to disable also dances
				if ShowMessage("Do you want to disable also all Dances using this pose?", true, "Yes", "No")==1
					toggleDances(p, false)
				endIf
				p.disable()
				SetToggleOptionValue(option, false)
			elseIf p && p.inUse==2
				if ShowMessage("Do you want to enable also all Dances using this pose?", true, "Yes", "No")==1
					toggleDances(p, true)
				endIf
				p.enable()
				SetToggleOptionValue(option, true)
			endIf
			return
		elseIf option==opts[2]
			thePage=="Poses"
			currentPoseIdx=-1
			ForcePageReset()
			return
		endIf
		
		
	elseIf thePage=="Strips"
		int pos = opts.find(option)
		if pos!=-1
			thePage="Strip"
			currentStripIdx = ids[pos]
			ForcePageReset()
			return
		endIf
		
	elseIf thePage=="Strip"
		if option==opts[0]
			spdfStrip s = reg._getStripByIndex(currentStripIdx)
			if s
				LoadCustomContent("Skyrim Pole Dances/StripsPreview/" + s.previewFile, 0.0, 0.0)
				Utility.waitMenuMode(3.0)
				ForcePageReset()
				return
			endIf
		elseIf option==opts[1]
			spdfStrip s = reg._getStripByIndex(currentStripIdx)
			if s && s.inUse==1
				s.disable()
				SetToggleOptionValue(option, false)
			elseIf s && s.inUse==2
				s.enable()
				SetToggleOptionValue(option, true)
			endIf
			return
		elseIf option==opts[2]
			thePage=="Strips"
			currentStripIdx=-1
			ForcePageReset()
			return
		endIf
		
	endIf
endEvent


; -))

; ((- State based event functions

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

state ReInitBN
	Event OnSelectST()
		int prevLog = spdF.logMode
		spdF.logMode = 2 ; Force the traces in this case
		; Stop all performances
		reg._stopAll()
		; Redo the init
		reg._doInit(spdF, true)
		spdF.logMode = prevLog
	endEvent
	
	Event OnHighlightST()
		SetInfoText("This will re-scan all aliases and reset the framework completely.\nAll performances playing will be stopped.")
	endEvent
endState

; -))







; ((- Support functions ********************************************************************************

Function cleanOptions()
	int i = opts.length
	while i
		i-=1
		opts[i]=-1
		ids[i]=-1
	endWhile
endFunction

string function trimFloat(float f)
	if f==0.0
		return "0.00"
	endIf
	
	bool neg = f<0.0
	if neg
		f = -f
	endIf
	
	int v = (f * 100) as int
	string r = ""+(v / 100) as int
	r += "." + ((v % 100) / 10) as int
	r += (v % 10) as int
	if neg
		return "-" + r
	endIf
	return r
endFunction


Function toggleDances(spdfPose p, bool toEnable)
	int i = reg.getDancesNum(0)
	while i
		i-=1
		spdfDance d = reg._getDanceByIndex(i)
		if d && d.inUse
			if d.startPose==p || d.endPose==p
				if toEnable
					d.enable()
				else
					d.disable()
				endIf
			endIf
		endIf
	endWhile
endFunction

; -))


