Scriptname spdfStrip Extends spdfBase

; ******************************************************************************************************************
; ****                                                                                                          ****
; ****    spdfStrip - Object used to store a strip definition and play it during a Performance                  ****
; ****                                                                                                          ****
; ****    Strips are managed like Dances, but they can be not pre-allocated.                                    ****
; ****    They may be dynamically allocated and released when needed during a performance                       ****
; ****                                                                                                          ****
; ******************************************************************************************************************

; ((- ---------------------------------------------------------------- Strip Properties, getters and setters ---------------------------------------------------------------


bool _animatedStrip
bool _stripWeapons
bool _isTemporary
float _preStripDuration
bool _isOFA
int[] _strips ; -1 to dress, 0 to ignore, 1 to strip
spdfPose _forPose


Function _preInit(int unUsed)
	Parent._baseInit("Empty", 3, "Nope", -1.0, 0)
	_strips = new int[32]
	_animatedStrip = false
	_isTemporary = true
endFunction

Function _init(string n, string animEvent, float len=0.0, float preLen=0.0, string poseName="", bool ofa)
	_baseInit(n, 3, animEvent, len, 1)
	_strips = new int[32]
	_animatedStrip = (animEvent!="" && len!=0.0)
	_preStripDuration = preLen
	_isOFA = ofa
	_isTemporary = false
	if poseName
		spdfPoleDances spdF=spdfPoleDances.getInstance()
		_forPose = spdF.registry.findPoseByName(poseName)
	endIf
endFunction

Bool Property isTemporary
	Bool Function get()
		return _isTemporary
	endFunction
endProperty

Bool Property animatedStrip
	Bool Function get()
		return _animatedStrip
	endFunction
endProperty

Bool Property isOFA
	Bool Function get()
		return _isOFA
	endFunction
endProperty

Bool Property stripWeapons
	Bool Function get()
		return _stripWeapons
	endFunction
endProperty

Function _releaseStrip()
	; To be released only if temporary
	if isTemporary
		Parent._release()
	endIf
endFunction

int[] Function stripSlots()
	return _strips
endFunction

float Property preStripDuration
	float Function get()
		return _preStripDuration
	endFunction
endProperty

spdfPose Property pose
	spdfPose Function get()
		return _forPose
	endFunction
endProperty


Function parseStrips(String stripCode, bool setName=true)
	spdfPoleDances spdF=spdfPoleDances.getInstance()
	_parseStrips(spdF, stripCode, setName)
endFunction
	
	

Function _parseStrips(spdfPoleDances spdF, String stripCode, bool setName=true)
	; "Strip:" [!]slot/bodypart| [!]slot/bodypart| ...| [!]slot/bodypart| [Animated]
	int pos = StringUtil.find(stripCode, ":")
	if pos==-1
		return
	endIf
	
	String[] parts = StringUtil.split(StringUtil.subString(stripCode, pos + 1), "|")
	int i = parts.length
	while i
		i-=1
		bool dress = false
		if StringUtil.substring(parts[i], 0, 1)=="!"
			dress=true
			parts[i] = StringUtil.substring(parts[i], 1)
		endIf
		if parts[i]=="Animated"
			_animatedStrip = true
		elseIf parts[i]=="OFA"
			_isOFA = true
		elseIf StringUtil.find(parts[i], "Duration:")!=-1
			string ts = StringUtil.subString(parts[i], StringUtil.find(parts[i], "Duration:") + 9)
			float t = ts as float
			if t!=0.0
				Parent._setLength(t)
			endIf
		elseIf StringUtil.find(parts[i], "HKX:")!=-1
			string hs = StringUtil.subString(parts[i], StringUtil.find(parts[i], "HKX:") + 4)
			if hs
				Parent._setAnimEvent(hs)
			endIf
		elseIf StringUtil.find(parts[i], "preTime:")!=-1
			string ts = StringUtil.subString(parts[i], StringUtil.find(parts[i], "preTime:") + 8)
			float t = ts as float
			if t!=0.0
				_preStripDuration = t
			endIf
		elseIf parts[i]=="All"
			int slot =_strips.length
			while slot
				slot-=1
				if dress
					_strips[slot]=-1
				else
					_strips[slot]=1
				endIf
			endWhile
		else
			int slot = spdF.registry.bodyParts.find(parts[i])
			if slot==-1
				spdF._addError(59, "Unknown part \"" + parts[i] + "\" for stripping dance", "spdDance", "parseStrips")
			else
				if slot>31
					slot-=32
				endIf
				if dress
					_strips[slot]=-1
				else
					_strips[slot]=1
				endIf
			endIf
		endIf
	endWhile

	if setName
		Parent._setName(generateStripName())
	endIf
endFunction

Function setStripValues(int[] vals, bool asAnimated, float time)
	Parent._preInit(3)

	int i = vals.length
	while i
		i-=1
		if vals[i]==0
			_strips[i] = 0
		elseIf vals[i]==1
			_strips[i] = 1
		elseIf vals[i]==2
			_strips[i] = -1
		endIf
	endWhile
	
	if asAnimated
		Parent._baseInit(generateStripName(), 3, "Arrok_Undress_G1", time, 1)
	else
		Parent._baseInit(generateStripName(), 3, "Nope", time, 1)
	endIf
	_animatedStrip = asAnimated
endFunction


bool Function compareStrip(spdfStrip tmp)
	if _animatedStrip!=tmp.animatedStrip || hkx!=tmp.hkx || duration!=tmp.duration || preStripDuration!=tmp.preStripDuration || _isOFA!=tmp.isOFA
		return false
	endIf
	int[] tmpS = tmp.stripSlots()
	int i=tmpS.length
	while i
		i-=1
		if tmpS[i]!=_strips[i]
			return false
		endIf
	endWhile
	return true
endFunction

Function copyStripFrom(spdfStrip tmp)
	_animatedStrip=tmp.animatedStrip
	_preStripDuration=tmp.preStripDuration
	_isOFA=tmp.isOFA
	int[] tmpS = tmp.stripSlots()
	int i=tmpS.length
	while i
		i-=1
		_strips[i] = tmpS[i]
	endWhile
	Parent._baseInit(generateStripName(), 3, tmp.hkx, tmp.duration, 1)
endFunction


string Function generateStripName()
	; Check if we have a full strip or a full redress
	bool fullStrip=true
	bool fullDress=true
	int i=_strips.length
	while i
		i-=1
		if _strips[i]!=1
			fullStrip=false
		elseIf _strips[i]!=-1
			fullDress=false
		endIf
	endWhile
	if fullStrip
		if _animatedStrip
			return "Strip all,Animated"
		else
			return "Strip all"
		endIf
	elseIf fullDress
		if _animatedStrip
			return "Redress all,Animated"
		else
			return "Redress all"
		endIf
	endIf
	
	spdfPoleDances spdF = spdfPoleDances.getInstance()
	string res="Strip:"
	i=0
	bool doneOne=false
	while i<_strips.length
		if _strips[i]==1
			if doneOne
				res+=","
			endIf
			res+=spdF.registry.bodyParts[i]
			doneOne=true
		elseIf _strips[i]==-1
			if doneOne
				res+=","
			endIf
			res+="!"+spdF.registry.bodyParts[i]
		endIf
		i+=1
	endWhile
	if _animatedStrip
		if doneOne
			res+=","
		endIf
		res+="Animated"
	endIf
	return res
endFunction

Function getStrips(int[] dest)
	int i=_strips.length
	while i
		i-=1
		if _strips[i]==1
			dest[i] = 1
		elseIf _strips[i]==-1
			dest[i] = 2
		elseIf _strips[i]==0
			dest[i] = 0
		endIf
	endWhile
endFunction

