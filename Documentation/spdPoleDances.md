# Pole Dances Framework (spdPoleDances)
Main framework APIs

* QuickStart: [QuickStart](spdPoleDances.md#quickstart)
* Threads: [NewThread](spdPoleDances.md#newthread)
* Poles: [PlacePole](spdPoleDances.md#placepole)
* Poles: [RemovePole](spdPoleDances.md#removepole)
* Errors Management: [DumpErrors](spdPoleDances.md#dumperrors)
* Errors Management: [GetLastError](spdPoleDances.md#getlasterror)
* Errors Management: [GetLastErrorID](spdPoleDances.md#getlasterrorid)
* Registry: [GetRegistry](spdPoleDances.md#getregistry)

<br><br><hr><br><br>

** _Conventions_ **<br>
**Performance** : Is the whole animations, composed of a set of dances
**Dance** : It is a single animation that will be performed during a performance
**Pose** : It is a specific pose that is used to join animations

<br><br><hr><br><br>


## QuickStart

### quickStart()
```Papyrus
bool quickStart(Actor dancer, ObjectReference pole=None, float duration=-1.0, string startingPose="")
```
This function is used to quickly start a pole dance with an actor.

**_Parameters_**
* _Actor_ `dancer`(_mandatory_): is the actor that will perform the dance
* _ObjectReference_ `pole`: it can be a static object, representing a pole, that will be used by the actor. In casse it is missing a temporary one will be generated in the location of the actor.
* _Float_ `duration`: the time in seconds the full pole dance performance should last. In case it is not specified it will be defaulted to 60 seconds.
* _String_ `startingPose`: a name of a known pose that should be used to start the performance

**_Returns_**
**True** In case there were errors.
If there were errors, a detailed error is added to the error list. Use `getLastError()` to get the long description.


<br><br><hr><br><br>



## Performances
Performances give you the full control of the Pole Dance performance.
See [spdPerformance](spdPerformances.md) for further details.
Threads can be initialized in three different ways, depending on how to find the sub-animations.

### newThreadPose()
```Papyrus
spdThread newThreadPose(Actor dancer, ObjectReference pole=None, float duration=-1.0, string startingPose="")
```
Allocates a new thread and initilize it with the dancer, a pole, the duration, and a starting pose. The sub-animations will be chosen randomly, starting from the starting pose (if any.)

**_Parameters_**
* _Actor_ `dancer`(_mandatory_): is the actor that will perform the dance
* _ObjectReference_ `pole`: it can be a static object, representing a pole, that will be used by the actor. In casse it is missing a temporary one will be generated in the location of the actor.
* _Float_ `duration`: the time in seconds the full pole dance performance should last. In case it is not specified it will be defaulted to 60 seconds.
* _String_ `startingPose`: a name of a known pose that should be used to start the performance

**_Returns_**
An allocated and initialized _spdThread_ that can be used to start the Pole Dance performance.
_None_ in case the thread cannot be allocated or initialized.
If there were errors, a detailed error is added to the error list. Use `getLastError()` to get the long description.

### newThreadDances()
```Papyrus
spdThread newThreadDances(Actor dancer, ObjectReference pole=None, float duration=-1.0, string dances)
```
Allocates a new thread and initilize it with the dancer, a pole, the duration, and a set of dances (as comma separated list of dance names.)

**_Parameters_**
* _Actor_ `dancer` (_mandatory_): is the actor that will perform the dance
* _ObjectReference_ `pole`: it can be a static object, representing a pole, that will be used by the actor. In casse it is missing a temporary one will be generated in the location of the actor.
* _Float_ `duration`: the time in seconds the full pole dance performance should last. In case it is not specified it will be defaulted to 60 seconds.
* _String_ `dances` (_mandatory_): a set of dance names, comma separated (e.g. "SoftMove,Twist,Twist,SoftMove,BendDown,SpeadLegs,BendUp,SoftMove")

**_Returns_**
An allocated and initialized _spdThread_ that can be used to start the Pole Dance performance.
_None_ in case the thread cannot be allocated or initialized.
If there were errors, a detailed error is added to the error list. Use `getLastError()` to get the long description.

### newThreadDancesArray()
```Papyrus
spdThread newThreadDancesArray(Actor dancer, ObjectReference pole=None, float duration=-1.0, string[] dances)
```
Allocates a new thread and initilize it with the dancer, a pole, the duration, and a set of dances (as array of strings of dance names.)

**_Parameters_**
* _Actor_ `dancer` (_mandatory_): is the actor that will perform the dance
* _ObjectReference_ `pole`: it can be a static object, representing a pole, that will be used by the actor. In casse it is missing a temporary one will be generated in the location of the actor.
* _Float_ `duration`: the time in seconds the full pole dance performance should last. In case it is not specified it will be defaulted to 60 seconds.
* _String[]_ `dances` (_mandatory_): a set of dance names, one for each entry of the array
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
If there were errors, a detailed error is added to the error list. Use `getLastError()` to get the long description.




<br><br><hr><br><br>




## Poles
TODO...

### placePole()
Adds a pole static object close to the location specified.
```Papyrus
ObjectReference placePole(ObjectReference location = None, float distance = 0.0, float rotation = 0.0)
```
* The z position will be the same as the `location`, the X and Y positions will be based on the `location` with a given distance and angle.

**_Parameters_**
* _ObjectReference_ `location`: where to place the pole, usually close to an actor or a static or a marker. In case it is missing, the Player will be used.
* _Float_ `distance`: how far the pole will be from the current position of the `location`, in game units (128 is about the height of an actor 6ft/1.82cm)
* _Float_ `rotation`: the vertical angle, in degrees, for the destination position of the pole, 0 will be just in front of the `location`, 90.0 will be on the right of the `location`, 180.0 will be on the back of the `location`.

**_Returns_**
An _ObjectReference_ of the newly created and placed pole.

### removePole()
Removes a previously created pole.
```Papyrus
removePole(ObjectReference pole)
```
**_Parameters_**
* _ObjectReference_ `pole`(_mandatory_): the pole to remove

**_Returns_**
Nothing



<br><br><hr><br><br>



## Errors management
Every time a function has an error, a detail of the error is tracked. Errors can be dumped to the Papyrus.log or can be retrieved as strings and ID

### dumpErrors()
Dumps all recorded errors in the Papyrus.log, and clean up the error list.

**_Parameters_**
Nothing

**_Returns_**
Nothing

### getLastError()
Returns the description for the las error that happened.

**_Parameters_**
Nothing

**_Returns_**
A _String_ with the last error. An empty string in case there were no errors.

### getLastErrorID()
Returns an _int_ corresponding to the type of error happened.

**_Parameters_**
None

**_Returns_**
An _int_ that is the ID of the type of error.
* 0 -> no error
* 1 -> (Actors) not valid actor (generic, as fallback)
* 2 -> (Actors) the actor is "None"
* 3 -> (Actors) the actor is performing an activity that will make impossible to dance, or is a child
* 4 -> (Actors) an actor is already used for another dance
* 10 -> (Performances) No more performances available
* 11 -> Cannot update a playing performance

20 (dances)
20 start pose does not exist
21 dances are empty

30 (tags)
31 Empty tag
32 Unknow tag
33 Invalid tag values


<br><br><hr><br><br>

## Registry

### getRegistry()
Give you back the instance of the Registry (Poses, Dances, Actors, Threads, Tags, etc.)

**_Parameters_**
Nothing

**_Returns_**
The _spdRegistry_ that can be used to call Registry functions.
