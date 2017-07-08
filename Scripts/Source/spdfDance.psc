Scriptname spdfDance Extends spdfBase

; ******************************************************************************************************************
; ****                                                                                                          ****
; ****    spdfDance - Object used to define a Dance (used as stage of a Performance)                            ****
; ****                                                                                                          ****
; ****                                                                                                          ****
; ****                                                                                                          ****
; ******************************************************************************************************************

; ((- ---------------------------------------------------------------- Dance Properties, getters and setters ---------------------------------------------------------------

spdfPose _startPose
spdfPose _endPose
string _animEventToStart
float _startDuration
string _animEventToEnd
float _endDuration
bool _cyclic
bool _isTransition



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

bool Property isCyclic
	bool Function get()
		return _cyclic
	endFunction
endProperty

string Property startHKX
	string Function get()
		return _animEventToStart
	endFunction
endProperty

float Property startDuration
	float Function get()
		return _startDuration
	endFunction
endProperty

string Property endHKX
	string Function get()
		return _animEventToEnd
	endFunction
endProperty

float Property endDuration
	float Function get()
		return _endDuration
	endFunction
endProperty

bool Property isTransition
	bool Function get()
		return _isTransition
	endFunction
endProperty

Function _init(string dname, string animEvent, spdfPose sp, spdfPose ep, float len, bool asTransition=false)
	_baseInit(dname, 1, animEvent, len, 1)
	_startPose = sp
	_endPose = ep
	_cyclic = false
	_isTransition = asTransition
endFunction

Function setCycle(bool isCyclic, string preAnimEvent="", float preAnimDuration=0.0, string postAnimEvent="", float postAnimDuration=0.0)
	if isCyclic
		_animEventToStart = preAnimEvent
		_animEventToEnd = postAnimEvent
		_startDuration = preAnimDuration
		_endDuration = postAnimDuration
		_cyclic = true
	else
		_animEventToStart = ""
		_animEventToEnd = ""
		_startDuration = 0.0
		_endDuration = 0.0
		_cyclic = false
	endIf
endFunction

; -))







