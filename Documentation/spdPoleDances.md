# Pole Dances Framework (spdPoleDances)
Main framework APIs


## QuickStart
```Papyrus
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

```Papyrus
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


```Papyrus
spdThread Function newThreadDances(Actor dancer, ObjectReference pole=None, float duration=-1.0, string dances)
```
Allocates a new thread and initilize it with the dancer, a pole, the duration, and a set of dances (as comma separated list of dance names.)

**_Parameters_**
* _Actor_ dancer: is the actor that will perform the dance (_mandatory_)
* _ObjectReference_ pole: it can be a static object, representing a pole, that will be used by the actor. In casse it is missing a temporary one will be generated in the location of the actor.
* _Float_ duration: the time in seconds the full pole dance performance should last. In case it is not specified it will be defaulted to 60 seconds.
* _String_ dances: a set of dance names, comma separated (e.g. "SoftMove,Twist,Twist,SoftMove,BendDown,SpeadLegs,BendUp,SoftMove")

**_Returns_**
An allocated and initialized _spdThread_ that can be used to start the Pole Dance performance.
_None_ in case the thread cannot be allocated or initialized.


```Papyrus
spdThread Function newThreadDancesArray(Actor dancer, ObjectReference pole=None, float duration=-1.0, string[] dances)
```
Allocates a new thread and initilize it with the dancer, a pole, the duration, and a set of dances (as array of strings of dance names.)

**_Parameters_**
* `_Actor_ dancer`: is the actor that will perform the dance (_mandatory_)
* `_ObjectReference_ pole`: it can be a static object, representing a pole, that will be used by the actor. In casse it is missing a temporary one will be generated in the location of the actor.
* `_Float_ duration`: the time in seconds the full pole dance performance should last. In case it is not specified it will be defaulted to 60 seconds.
* `_String[]_ dances`: a set of dance names, one for each entry of the array
```Papyrus
String[] dances = new String[8]
dances[0] = "SoftMove"
dances[1] = "Twist"
dances[2] = "Twist"
dances[3] = "SoftMove"
dances[4] = "BendDown"
dances[5] = "SpeadLegs"
dances[6] = "BendUp"
dances[7] = "SoftMove"
```

**_Returns_**
An allocated and initialized _spdThread_ that can be used to start the Pole Dance performance.
_None_ in case the thread cannot be allocated or initialized.










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


