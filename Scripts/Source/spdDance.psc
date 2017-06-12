Scriptname spdDance Extends ReferenceAlias

; FIXME Add the tags
; FIXME 
; FIXME 

string _name
string _animEvent
string _startPoseName
spdPose _startPose
spdPose _endPose
float _length
bool _cyclic
bool _inUse

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

Function _init(string name, string hkx, spdPose sp, spdPose ep, float len, bool cyclic)
	_name = name
	_animEvent = hkx
	_startPose = sp
	_endPose = ep
	_length = len
	_cyclic = cyclic	
	_inUse = true
endFunction

