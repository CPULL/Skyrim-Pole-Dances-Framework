Scriptname spdDance Extends ReferenceAlias

string _name
string _animEvent
string _startPose
string _endPose
float _length
bool _cyclic

string Property name
	int function get()
		return _name
	endFunction
endProperty

string Property hkx
	int function get()
		return _animEvent
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

