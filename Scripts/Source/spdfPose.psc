Scriptname spdfPose Extends ReferenceAlias

string _name
string _animEvent
string _animEventToStart
string _animEventToEnd
float _startTime
float _endTime
bool _inUse
string _preview

string Property previewFile
	string function get()
		return _preview
	endFunction
endProperty

Function setPreview(string file)
	if file!=""
		_preview = file
	else
		_preview = "spdfPoseNotAvailable.dds"
	endIf
endFunction



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

string Property startHKX
	string function get()
		return _animEventToStart
	endFunction
endProperty

string Property endHKX
	string function get()
		return _animEventToEnd
	endFunction
endProperty

float Property startTime
	float function get()
		return _startTime
	endFunction
endProperty

float Property endTime
	float function get()
		return _endTime
	endFunction
endProperty

bool Property inUse
	bool Function get()
		return _inUse
	endFunction
endProperty

Function _init(string pname, string hkx, string hkxS, string hkxE, float st, float et)
	_name = pname
	_animEvent = hkx
	_animEventToStart = hkxS
	_animEventToEnd = hkxE
	_startTime = st
	_endTime = et
	_inUse = true
endFunction

