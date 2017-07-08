Scriptname spdfBase Extends ReferenceAlias

; ******************************************************************************************************************
; ****                                                                                                          ****
; ****    spdfBase - Base object used to store the basic properties for Dances, Poses, and Strips               ****
; ****                                                                                                          ****
; ****    Never use it directly                                                                                 ****
; ****                                                                                                          ****
; ******************************************************************************************************************


; ((- ---------------------------------------------------------------- Basic Properties, getters and setters ----------------------------------------------------------------

string _name ; Stores the user visible name for the object
int _inUse ; Tells if the object is used or is free and can be allocated: 0=not used, 1=in use, 2=is there but disabled
string _preview ; Stores the file name (dds or swf) for thepreview of the object that is used in the MCM
spdfTag _tag ; Stores the tags defined for the object
int _type ; Stores the actual type of the object: 1=Dance, 2=Pose, 3=Strip
string _animEvent ; Stores the hkx anim event used to play the Dance, Pose (if any), or Strip
float _length ; Stores the lenght in seconds of the anim event

Function _preInit(int myType)
	_type = myType
endFunction

Function _baseInit(String n="Nope", int myType=0, string aev="Nope", float len=-1.0, int used)
	if n!="Nope"
		_name = n
	endIf
	if myType!=0
		_type = myType
	endIf
	if aev!="Nope"
		_animEvent=aev
	endIf
	if len!=-1.0
		_length=len
	endIf
	_inUse = used
endFunction

string Property name
	string function get()
		return _name
	endFunction
endProperty

function _setName(string n)
	_name = n
endFunction

function _setLength(float t)
	_length	= t
endFunction

function _setAnimEvent(string n)
	_animEvent = n
endFunction

string Property previewFile
	string function get()
		if _preview==""
			previewFile=""
		endIf
		return _preview
	endFunction
	
	Function set(string file)
		if file!=""
			_preview = file
		else
			if isDance
				_preview = "spdfDanceNotAvailable.dds"
			elseIf isPose
				_preview = "spdfPoseNotAvailable.dds"
			elseIf isStrip
				_preview = "spdfStripNotAvailable.dds"
			else
				_preview = "spdfNotAvailable.dds"
			endIf
		endIf
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

int Property type
	int function get()
		return _type
	endFunction
endProperty

bool Property isDance
	bool function get()
		return _type==1
	endFunction
endProperty

bool Property isPose
	bool function get()
		return _type==2
	endFunction
endProperty

bool Property isStrip
	bool function get()
		return _type==3
	endFunction
endProperty

int Property inUse
	int Function get()
		return _inUse
	endFunction
endProperty

Function _release()
	if _inUse==0
		return
	endIf
	_inUse = 0
endFunction

Function enable()
	if _inUse==0
		return
	endIf
	_inUse = 1
endFunction
	
Function disable()
	if _inUse==0
		return
	endIf
	_inUse = 2
endFunction
	
; -))


; ((- ---------------------------------------------------------------- Tags Functions ----------------------------------------------------------------

bool Function setTags(string theTag, spdfPoleDances spdF = None)
	if !spdF
		spdF = spdfPoleDances.getInstance()
	endIf
	spdfRegistry reg = spdF.registry

	; Parse the tags, and assign them to the dance. Some of the subtags should go away (like "dance:")
	string err=reg.tryToParseTags(theTag)
	if err
debug.trace("SPDF: problem parsing tag (try): " + err)
		return true
	endIf
	_tag = reg.parseTags(theTag)
	if _tag==None
debug.trace("SPDF: problem parsing tag (parsing)")
		return true
	endIf
	if isDance
		; Remove the "dance:" tag, if any
		_tag.cleanTagForDance()
	endIf
	return false
endFunction


spdfTag Property tags
	spdfTag Function get()
		return _tag
	endFunction
endProperty


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

bool Function _isTagExactly(spdfTag t)
	return _tag==t
endFunction

; -))




 ; RECYCLE >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

spdfPose _startPose ; Dance
spdfPose _endPose ; Dance

bool _cyclic ; Dance

bool _isAStrip ; Remove
bool _animateStrip ; Strip
int[] _strips ; Strip -1 to dress, 0 to ignore, 1 to strip

 ; RECYCLE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<




