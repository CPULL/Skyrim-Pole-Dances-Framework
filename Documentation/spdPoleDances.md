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
* 11 -> (Performances) Cannot update a playing performance
* 12 -> (Performances) Trying to use a performance that is already being used
* 20 -> (Performances) Requested start pose does not exist
* 21 -> (Performances) The requested dances are not valid (empty string to declare dances)
* 22 -> (Performances) No one of the requested dances is valid
* 23 -> [WARNING] Some of the dances are not valid: \<_list of dance names_\> (this is just a warning and will not stop the Performance)
* 30 -> (Registry) No more slots available for Poses \<_Pose name_\>
* 31 -> (Registry) No more slots available for Dances \<_Dance name_\>
* 32 -> (Registry) Start pose \<_Pose name_\> for Dance \<_Dance name_\> does not exist!
* 33 -> (Registry) End pose \<_Pose name_\> for Dance \<_Dance name_\> does not exist!
* 34 -> (Registry) No more space available for tags!
* 35 -> (Registry)
* 40 -> (Performances) Generic error on playing performances
* 41 -> (Performances) The performance is already playing, it cannot be started again
* 42 -> (Performances) The performance is not valid, it cannot be started
* 43 -> (Performances) The performance seems to be not valid, it is not specifed what to perform
* 44 -> (Performances) Could not find a dance starting with pose \<_pose name_\>
* 45 -> (Performances) Could not find an intermediate dance starting with pose \<_pose name_\>
* 46 -> (Performances) Could not find a dance for tags \<_tag_\>
* 50 -> (Tags) The requested Tags is empty and not valid (empty string to declare tags)
* 51 -> (Tags) Unknow tag \<_tag_\>
* 52 -> (Tags) Invalid tag \<_tag_\>, the value is missing
* 53 -> (Tags) Not possible to specify multiple authors for a tag \<_tag_\>
* 54 -> (Tags) [WARNING] Too many authors specified
* 55 -> (Tags) Not possible to specify multiple dances for a tag in AND mode, separate them with | wo have them in OR mode (\<_tag_\>)
* 56 -> (Tags) Unknow dance for the tag \<_tag_\> (applies to tags of the form "dance\<_dance name_\>")
* 57 -> (Tags) [WARNING] Too many dances specified
* 58 -> (Tags) Part not specified for stripping tag \<_tag_\>
* 59 -> (Tags) Unknown part \<_body slot name or number_\> for stripping tag
* 60 -> (Tags) [WARNING] Invalid tag (\<_tag_\>), a part of the value is unkwnon: \<_value\> (applies to Sexy and Skill tags)
* 61 -> (Tags) The requested Tags are not valid (generated inside a Performance)
* 62 -> (Tags) No one of the requested Tags is valid (generated inside a Performance)
* 62 -> (Tags) [WARNING] Some of the Tags are not valid: \<_errors_\> (generated inside a Performance)



<br><br><hr><br><br>

## Registry

### getRegistry()
Give you back the instance of the Registry (Poses, Dances, Actors, Threads, Tags, etc.)

**_Parameters_**
Nothing

**_Returns_**
The _spdRegistry_ that can be used to call Registry functions.
