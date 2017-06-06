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

**spdDoleDances** (quest **spd**): it is the main framework

<<<<<<< HEAD
**spdRegistry** (quest **spd**): it contains the registry for all items used by the framework, it is passed if you register for initialization events (to add your own poses and dances)

**spdPose**: it is use to define the _Poses_

**spdDance**: it is used to define the sub-dances
=======
**spdRegistry** (quest **spd**): it contains the registry for all items used by the framework, it is passed if you register for initialization events (to add your own poses and dances.)

**spdPose**: it is use to define the _Poses_

**spdDance**: it is used to define the sub-dances.
>>>>>>> 51927ea03783e58b068a01fa041a9add56a29520

**spdThread**: it is used to play a Pole Dance, handling all the actions and the events

**spdActor**: it used to track extra information about an actor, to simplify the control of NPCs


<<<<<<< HEAD


=======
>>>>>>> 51927ea03783e58b068a01fa041a9add56a29520
***Do not call functions from internal components***

***Do not use any method or variable that strarts with an underscore \_***
