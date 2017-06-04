Scriptname spdPose Extends ReferenceAlias

string _name
string _animEvent

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

Function init(string name, string hkx)
	_name = name
	_animEvent = hkx
endFunction

