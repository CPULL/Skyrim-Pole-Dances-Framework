# Pole Dances Framework (spdPoleDances)
Main framework APIs


## QuickStart

### quickStart()
```Papyrus
bool Function quickStart(Actor dancer, ObjectReference pole=None, float duration=-1.0, string startingPose="")
```
This function is used to quickly start a pole dance with an actor.

**_Parameters_**
* _Actor_ `dancer`: is the actor that will perform the dance (_mandatory_)
* _ObjectReference_ `pole`: it can be a static object, representing a pole, that will be used by the actor. In casse it is missing a temporary one will be generated in the location of the actor.
* _Float_ `duration`: the time in seconds the full pole dance performance should last. In case it is not specified it will be defaulted to 60 seconds.
* _String_ `startingPose`: a name of a known pose that should be used to start the performance

**_Returns_**
**True** In case there were errors.


## Threads
Threads give you the full control of the Pole Dance performance.
See [spdThread](spdThread.md) for further details.
Threads can be initialized in three different ways, depending on how to find the sub-animations.

### newThreadPose()
```Papyrus
spdThread Function newThreadPose(Actor dancer, ObjectReference pole=None, float duration=-1.0, string startingPose="")
```
Allocates a new thread and initilize it with the dancer, a pole, the duration, and a starting pose. The sub-animations will be chosen randomly, starting from the starting pose (if any.)

**_Parameters_**
* _Actor_ `dancer`: is the actor that will perform the dance (_mandatory_)
* _ObjectReference_ `pole`: it can be a static object, representing a pole, that will be used by the actor. In casse it is missing a temporary one will be generated in the location of the actor.
* _Float_ `duration`: the time in seconds the full pole dance performance should last. In case it is not specified it will be defaulted to 60 seconds.
* _String_ `startingPose`: a name of a known pose that should be used to start the performance

**_Returns_**
An allocated and initialized _spdThread_ that can be used to start the Pole Dance performance.
_None_ in case the thread cannot be allocated or initialized.

### newThreadDances()
```Papyrus
spdThread Function newThreadDances(Actor dancer, ObjectReference pole=None, float duration=-1.0, string dances)
```
Allocates a new thread and initilize it with the dancer, a pole, the duration, and a set of dances (as comma separated list of dance names.)

**_Parameters_**
* _Actor_ `dancer`: is the actor that will perform the dance (_mandatory_)
* _ObjectReference_ `pole`: it can be a static object, representing a pole, that will be used by the actor. In casse it is missing a temporary one will be generated in the location of the actor.
* _Float_ `duration`: the time in seconds the full pole dance performance should last. In case it is not specified it will be defaulted to 60 seconds.
* _String_ `dances`: a set of dance names, comma separated (e.g. "SoftMove,Twist,Twist,SoftMove,BendDown,SpeadLegs,BendUp,SoftMove")

**_Returns_**
An allocated and initialized _spdThread_ that can be used to start the Pole Dance performance.
_None_ in case the thread cannot be allocated or initialized.

### newThreadDancesArray()
```Papyrus
spdThread Function newThreadDancesArray(Actor dancer, ObjectReference pole=None, float duration=-1.0, string[] dances)
```
Allocates a new thread and initilize it with the dancer, a pole, the duration, and a set of dances (as array of strings of dance names.)

**_Parameters_**
* _Actor_ `dancer`: is the actor that will perform the dance (_mandatory_)
* _ObjectReference_ `pole`: it can be a static object, representing a pole, that will be used by the actor. In casse it is missing a temporary one will be generated in the location of the actor.
* _Float_ `duration`: the time in seconds the full pole dance performance should last. In case it is not specified it will be defaulted to 60 seconds.
* _String[]_ `dances`: a set of dance names, one for each entry of the array
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
An allocated and initialized [spdThread](spdThread.md) that can be used to start the Pole Dance performance.
_None_ in case the thread cannot be allocated or initialized.







## Poles
TODO...

### placePole()
Adds a pole static object close to the location specified.
```Papyrus
ObjectReference Function placePole(ObjectReference location = None, float distance = 0.0, float rotation = 0.0)
```
**_Parameters_**
* _ObjectReference_ `location`: where to place the pole, usually close to an actor or a static or a marker. In case it is missing, the Player will be used.
* _Float_ `distance`: how far the pole will be from the current position of the `location`, in game units (128 is about the height of an actor 6ft/1.82cm)
* _Float_ `rotation`: the vertical angle, in degrees, for the destination position of the pole, 0 will be just in front of the `location`, 90.0 will be on the right of the `location`, 180.0 will be on the back of the `location`.


### removePole()
Removes a previously created pole.
```Papyrus
Function removePole(ObjectReference pole)
```

