Scriptname spdDance Extends ReferenceAlias

string _name
string _animEvent
string _animEventBeforeCycle
string _animEventAfterCycle
string _startPoseName
spdPose _startPose
spdPose _endPose
float _length
float _lengthBeforeCycle
float _lengthAfterCycle
bool _cyclic
bool _inUse
spdTag _tag
bool _isAStrip
bool _animateStrip
int[] _strips ; -1 to dress, 0 to ignore, 1 to strip

string Property name
	string function get()
		return _name
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


spdPose Property startPose
	spdPose function get()
		return _startPose
	endFunction
endProperty

spdPose Property endPose
	spdPose function get()
		return _endPose
	endFunction
endProperty

bool Property inUse
	bool Function get()
		return _inUse
	endFunction
endProperty

spdTag Property danceTags
	spdTag Function get()
		return _tag
	endFunction
endProperty

Function _init(string dname, string animEvent, spdPose sp, spdPose ep, float len)
	_name = dname
	_animEvent = animEvent
	_startPose = sp
	_endPose = ep
	_length = len
	_cyclic = false
	_inUse = true
	_tag = None
endFunction

Function _initCycle(string preAnimEvent, float preAnimDuration, string postAnimEvent, float postAnimDuration)
	_animEventBeforeCycle = preAnimEvent
	_animEventAfterCycle = postAnimEvent
	_lengthBeforeCycle = preAnimDuration
	_lengthAfterCycle = postAnimDuration
	_cyclic = true
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
	spdPoleDances spdF = spdPoleDances.getInstance()
	spdRegistry reg = spdF.registry

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

bool Function hasTags(spdTag tag)
	; Check if what is specified in the tag is compatible with the defined tag for the dance
endFunction

bool Function _isTag(spdTag t)
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

bool Function _AnimatedStrips()
	return _animateStrip
endFunction

int[] Function _stripSlots()
	return _strips
endFunction

Function parseStrips(spdPoleDances spdF, String stripCode)
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
			_animateStrip = true
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
endFunction

bool Function compareStrip(spdDance tmp)
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

Function copyStripFrom(spdDance tmp)
	_animateStrip=tmp._AnimatedStrips()
	_inUse = true
	int[] tmpS = tmp._stripSlots()
	int i=tmpS.length
	while i
		i-=1
		_strips[i] = tmpS[i]
	endWhile
endFunction