Scriptname spdfDance Extends ReferenceAlias

string _name
string _animEvent
string _animEventBeforeCycle
string _animEventAfterCycle
string _startPoseName
spdfPose _startPose
spdfPose _endPose
float _length
float _lengthBeforeCycle
float _lengthAfterCycle
bool _cyclic
bool _inUse
spdfTag _tag
bool _isAStrip
bool _animateStrip
int[] _strips ; -1 to dress, 0 to ignore, 1 to strip
string _preview

string Property name
	string function get()
		return _name
	endFunction
endProperty

string Property previewFile
	string function get()
		return _preview
	endFunction
endProperty


string Property hkx
	string function get()
		return _animEvent
	endFunction
endProperty

float Property duration
	float function get()
		return _length
	endFunction
endProperty


spdfPose Property startPose
	spdfPose function get()
		return _startPose
	endFunction
endProperty

spdfPose Property endPose
	spdfPose function get()
		return _endPose
	endFunction
endProperty

bool Property inUse
	bool Function get()
		return _inUse
	endFunction
endProperty

spdfTag Property danceTags
	spdfTag Function get()
		return _tag
	endFunction
endProperty

Function _init(string dname, string animEvent, spdfPose sp, spdfPose ep, float len)
	_name = dname
	_animEvent = animEvent
	_startPose = sp
	_endPose = ep
	_length = len
	_cyclic = false
	_inUse = true
	_tag = None
endFunction

Function setCycle(bool isCyclic, string preAnimEvent="", float preAnimDuration=0.0, string postAnimEvent="", float postAnimDuration=0.0)
	if isCyclic
		_animEventBeforeCycle = preAnimEvent
		_animEventAfterCycle = postAnimEvent
		_lengthBeforeCycle = preAnimDuration
		_lengthAfterCycle = postAnimDuration
		_cyclic = true
	else
		_animEventBeforeCycle = ""
		_animEventAfterCycle = ""
		_lengthBeforeCycle = 0.0
		_lengthAfterCycle = 0.0
		_cyclic = false
	endIf
endFunction

Function setPreview(string file)
	if file!=""
		_preview = file
	else
		_preview = "spdfDanceNotAvailable.dds"
	endIf
endFunction




bool Property isCyclic
	bool Function get()
		return _cyclic
	endFunction
endProperty

string Property preHKX
	string Function get()
		return _animEventBeforeCycle
	endFunction
endProperty

string Property postHKX
	string Function get()
		return _animEventAfterCycle
	endFunction
endProperty

float Property preDuration
	float Function get()
		return _lengthBeforeCycle
	endFunction
endProperty

float Property postDuration
	float Function get()
		return _lengthAfterCycle
	endFunction
endProperty


bool Function setTags(string tags)
	spdfPoleDances spdF = spdfPoleDances.getInstance()
	spdfRegistry reg = spdF.registry

	; Parse the tags, and assign them to the dance. Some of the subtags should go away (like "dance:")
	if reg.tryToParseTags(tags)
		return true
	endIf
	_tag = reg.parseTags(tags)
	if _tag==None
		return true
	endIf
	; Remove the "dance:" tag, if any
	_tag.cleanTagForDance()
	return false
endFunction

bool Function hasTags(spdfTag tag)
	; Check if what is specified in the tag is compatible with the defined tag for the dance
	
;int numTags
;String[] tags
;bool[] tagNegatives
;string[] authors
;string[] dances
;bool authorsNegative
;bool dancesNegative
;int[] strip ; -1 to dress, 0 to ignore, 1 to strip
;int[] stripAn ; -1 to dress, 0 to ignore, 1 to strip
;int[] sexys ; -1 to avoid, 0 to ignore, 1 to have
;int[] skills ; -1 to avoid, 0 to ignore, 1 to have
;bool andMode

	
	
	; FIXME
	return false
endFunction

bool Function _isTag(spdfTag t)
	return _tag==t
endFunction

Function _setAsStrip()
	_isAStrip = true
	_inUse = false
	_strips = new int[32]
endFunction

bool Property isStrip
	bool Function get()
		return _isAStrip
	endFunction
endProperty

Function _releaseStrip()
	if !inUse || !_isAStrip
		return
	endIf
	_inUse = false
endFunction

bool Function _AnimatedStrips()
	return _animateStrip
endFunction

int[] Function _stripSlots()
	return _strips
endFunction

Function parseStrips(spdfPoleDances spdF, String stripCode)
	; "Strip:" [!]slot/bodypart| [!]slot/bodypart| ...| [!]slot/bodypart| [Animated]
	int pos = StringUtil.find(stripCode, ":")
	if pos==-1
		return
	endIf
	if !_strips
		_setAsStrip()
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
			_animateStrip = true
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
	
	; FIXME generate a name
	_name = "Strip..."
endFunction

bool Function compareStrip(spdfDance tmp)
	if _animateStrip!=tmp._AnimatedStrips()
		return false
	endIf
	int[] tmpS = tmp._stripSlots()
	int i=tmpS.length
	while i
		i-=1
		if tmpS[i]!=_strips[i]
			return false
		endIf
	endWhile
	return true
endFunction

Function copyStripFrom(spdfDance tmp)
	_animateStrip=tmp._AnimatedStrips()
	_inUse = true
	int[] tmpS = tmp._stripSlots()
	int i=tmpS.length
	while i
		i-=1
		_strips[i] = tmpS[i]
	endWhile
endFunction