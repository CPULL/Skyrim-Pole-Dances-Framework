# Skyrim Pole Dances Framework - APIs

## How to get the APIs

**Method 1**:
Add a Property in your script like
```
spdPoleDances Property spd Auto
```

It should auto-fill (spd is the actual name of the Quest holding the APIs.)


**Method 2**:
Write the following code:
```
spdPoleDances spd = spdPoleDances.getInstance()
```


## Structure of the files

[spdPoleDances](spdPoleDances.md) (** (quest **spd**): it is the main framework

[spdRegistry](spdRegistry.md) (quest **spd**): it contains the registry for all items used by the framework, it is passed if you register for initialization events (to add your own poses and dances)

[spdPose](spdPose.md) (_internal_): it is use to define the _Poses_

[spdDance](spdDance.md) (_internal_): it is used to define the sub-dances

[spdThread](spdThread.md) (ReferenceAlias of quest **spd**): it is used to play a Pole Dance, handling all the actions and the events

[spdActor](spdActor.md) (_internal_): it used to track extra information about an actor, to simplify the control of NPCs



### Recommendations

***Do not call functions from internal components***
They may be changed without any notice.

***Do not use any method or variable that strarts with an underscore \_***
Whatever starts with an underscore is internal. If you use it, your mod may stop working when the framework will be updated.