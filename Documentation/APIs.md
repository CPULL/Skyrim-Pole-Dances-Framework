# Skyrim Pole Dances Framework - APIs

## How to get the APIs

**Method 1**:
Add a Property into your script:
```
spdPoleDances Property spd Auto
```

It should auto-fill the properties ('spd' is the actual name of the Quest holding the APIs.)


**Method 2**:
Write the following code:
```
spdPoleDances spd = spdPoleDances.getInstance()
```


## Structure of the files

[spdPoleDances](spdPoleDances.md) (quest **spd**): this is the main framework<br>
[spdRegistry](spdRegistry.md) (quest **spd**): this contains the registry for all items used by the framework. It is passed if you register for initialization events (to add your own poses and dances)<br>
[spdPose](spdPose.md) (_internal_): this is used to define the _Poses_<br>
[spdDance](spdDance.md) (_internal_): this is used to define the sub-dances<br>
[spdThread](spdThread.md) (ReferenceAlias of quest **spd**): this is used to play a Pole Dance, handling all the actions and events<br>
[spdActor](spdActor.md) (_internal_): this is used to track extra information about an actor, to simplify the control of NPCs<br>
[Hooks and Events](Hooks.md): this document contains all the information for the Hooks and Events, is is not an actual ```psc``` file.<br>
[spdTag](spdTag.md) (_internal_): Used to handle the tag system. Inside there is a full reference of all possible tags

### Recommendations

***Do not call functions from internal components***
They may be changed without notice.

***Do not use any method or variable that strarts with an underscore \_***
Whatever starts with an underscore is internal. If you use it, your mod may stop working when the framework is updated.
