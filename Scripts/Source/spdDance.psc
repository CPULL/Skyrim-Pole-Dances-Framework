Scriptname spdDance Extends ReferenceAlias

string _name
string _animEvent
string _startPoseName
spdPose _startPose
spdPose _endPose
float _length
bool _cyclic
bool _inUse
spdTag _tag

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

Function _init(string dname, string animEvent, spdPose sp, spdPose ep, float len, bool cyclic)
	_name = dname
	_animEvent = animEvent
	_startPose = sp
	_endPose = ep
	_length = len
	_cyclic = cyclic	
	_inUse = true
	_tag = None
endFunction

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

