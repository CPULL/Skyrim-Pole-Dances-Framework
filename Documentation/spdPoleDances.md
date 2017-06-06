# Pole Dances Framework (spdPoleDances)
Main framework APIs


## QuickStart
```
bool Function quickStart(Actor dancer, ObjectReference pole=None, float duration=-1.0, string startingPose="")
```
This function is used to quickly start a pole dance with an actor.

**_Parameters_**
* _Actor_ dancer: is the actor that will perform the dance (_mandatory_)
* _ObjectReference_ pole: it can be a static object, representing a pole, that will be used by the actor. In casse it is missing a temporary one will be generated in the location of the actor.
* _Float_ duration: the time in seconds the full pole dance performance should last. In case it is not specified it will be defaulted to 60 seconds.
* _String_ startingPose: a name of a known pose that should be used to start the performance

**_Returns_**
**True** In case there were errors.


## Threads
Threads give you the full control of the Pole Dance performance.
See [spdThread](spdThread.md) for further details.
Threads can be initialized in three different ways, depending on how to find the sub-animations.

```
spdThread Function newThreadPose(Actor dancer, ObjectReference pole=None, float duration=-1.0, string startingPose="")
```
Allocates a new thread and initilize it with the dancer, a pole, the duration, and a starting pose. The sub-animations will be chosen randomly, starting from the starting pose (if any.)

**_Parameters_**
* _Actor_ dancer: is the actor that will perform the dance (_mandatory_)
* _ObjectReference_ pole: it can be a static object, representing a pole, that will be used by the actor. In casse it is missing a temporary one will be generated in the location of the actor.
* _Float_ duration: the time in seconds the full pole dance performance should last. In case it is not specified it will be defaulted to 60 seconds.
* _String_ startingPose: a name of a known pose that should be used to start the performance

**_Returns_**
An allocated and initialized _spdThread_ that can be used to start the Pole Dance performance.
_None_ in case the thread cannot be allocated or initialized.


```
spdThread Function newThreadDances(Actor dancer, ObjectReference pole=None, float duration=-1.0, string dances)
```
Descr

**_Parameters_**

**_Returns_**


```
spdThread Function newThreadDancesArray(Actor dancer, ObjectReference pole=None, float duration=-1.0, string[] dances)
```
Descr

**_Parameters_**

**_Returns_**










; ****************************************************************************************************************************************************************
; ************                                                                                                                                        ************
; ************                                                Poles                                                                                   ************
; ************                                                                                                                                        ************
; ****************************************************************************************************************************************************************

Static Property mainPole
Actor Property PlayerRef Auto

ObjectReference Function placePole(ObjectReference location = None, float distance = 0.0, float rotation = 0.0)
	ObjectRef re = location
	if !ref
		ref = PlayerRef
	endIf
	
	float zAngle = ref.getAngleZ()
	return location.placeAtMe(mainPole, Math.cos(zAngle + rotation) * distance, Math.sin(zAngle + rotation) * distance, ref.z, true)
endFunction

Function removePole(ObjectReference pole)
	pole.disable(true)
	pole.delete(true)
endFunction


; ****************************************************************************************************************************************************************
; ************                                                                                                                                        ************
; ************                                             Hooks Definition                                                                           ************
; ************                                                                                                                                        ************
; ****************************************************************************************************************************************************************

; Thread Hooks:
; 	<Hook>_DanceInit(tid, actor, pose)				--> Sent when the Dance is being initialized and the actor begins to walk to the pole
; 	<Hook>_DanceStarting(tid, actor, dance, pose)	--> Sent when the Dance is starting and the initial animation is being played
; 	<Hook>_DanceStarted(tid, actor, dance)			--> Sent when the very first dance is played
; 	<Hook>_DanceChanged(tid, actor, dance)			--> Sent every time a dance is played
;	<Hook>_PoseUsed(tid, actor, dance, pose)		--> Sent every time a pose is being used by an actor
;	<Hook>_DanceEnding(tid, actor, dance, pose)		--> Sent when the last dance is completed and the ending anim is being played
;	<Hook>_DanceEnded(tid, actor)					--> Sent when the dance is fully completed an dthe actor has been released
; Global Hooks:
; 	GlobalDanceInit(tid, actor, pose)				--> Sent when the Dance is being initialized and the actor begins to walk to the pole
; 	GlobalDanceStarting(tid, actor, dance, pose)	--> Sent when the Dance is starting and the initial animation is being played
; 	GlobalDanceStarted(tid, actor, dance)			--> Sent when the very first dance is played
; 	GlobalDanceChanged(tid, actor, dance)			--> Sent every time a dance is played
;	GlobalPoseUsed(tid, actor, dance, pose)			--> Sent every time a pose is being used by an actor
;	GlobalDanceEnding(tid, actor, dance, pose)		--> Sent when the last dance is completed and the ending anim is being played
;	GlobalDanceEnded(tid, actor)					--> Sent when the dance is fully completed an dthe actor has been released
; System hooks
;	SkyrimPoleDancesRegistryUpdated(version, registry)	--> Sent when the registry is being updated (to allow to add further dances)
;	SkyrimPoleDancesInitialized(version)				--> Sent when the mod is fully initialized and can be used
