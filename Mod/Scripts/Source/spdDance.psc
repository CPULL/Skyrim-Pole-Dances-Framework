Scriptname spdDance Extends ReferenceAlias

string _name
string _animEvent
string _startPoseName
spdPose _startPose
spdPose _endPose
float _length
bool _cyclic

string Property name
	int function get()
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
		return _lengtht
	endFunction
endProperty

float Property endHKX
	float function get()
		return _endPose
	endFunction
endProperty

float Property startHKX
	float function get()
		return _startPose
	endFunction
endProperty

spdPose Property startPose
	float function get()
		return _startPose
	endFunction
endProperty



Function init(string name, string hkx, string sp, string ep, float len, bool cyclic)
	_name = name
	_animEvent = hkx
	_startPose = sp
	_endPose = ep
	_length = len
	_cyclic = cyclic	
endFunction

