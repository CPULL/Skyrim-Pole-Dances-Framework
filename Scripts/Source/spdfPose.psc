Scriptname spdfPose Extends spdfBase

; ******************************************************************************************************************
; ****                                                                                                          ****
; ****    spdfPose - Object used to store the definition of a Pose, it is used by Dances                        ****
; ****                                                                                                          ****
; ****                                                                                                          ****
; ****                                                                                                          ****
; ******************************************************************************************************************


; ((- ---------------------------------------------------------------- Pose specific Properties, getters and setters ----------------------------------------------------------------

string _animEventToStart
string _animEventToEnd
float _startDuration
float _endDuration


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

float Property startDuration
	float function get()
		return _startDuration
	endFunction
endProperty

float Property endDuration
	float function get()
		return _endDuration
	endFunction
endProperty


Function _init(string pname, string animEvent, float len, string startAnimEvent, string endAnimEvent, float startTime, float endTime)
	_baseInit(pname, 2, animEvent, len, 1)
	_animEventToStart = startAnimEvent
	_animEventToEnd = endAnimEvent
	_startDuration = startTime
	_endDuration = endTime
endFunction

