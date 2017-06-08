This GITHub repository is to store the code and animations for a Skyrim project for Pole Dance animations.

![Pole Dance Framework Logo](https://github.com/CPULL/Skyrim-Pole-Dances/blob/master/PoleDanceIcon.png)

Members of te project are, right now:
* CPU
* Komotor
* Anubis
* Rydin
* FunnyBizness

The mod is a framework for Pole Dances.
A set of sub-animations will be defined, and the framework will allow playing them in the game with limited Papyrus actions.

# Skyrim Pole Dances Framework
This mod is a framework to implement (complex) pole dances in Skyrim.<br>
Its identification code (three letters for all objects and scripts) is _spd_

It provides APIs (similar to SexLab APIs) to handle the dances with just a few calls.

## APIs
The APIs are available in this document: [Skyrim Pole Dances APIs](Documentation/APIs.md)

:dancer: :dancers: :dancer:

## Features
* Allows playing complex pole dance performances in a completely automated way
* Handles the control of involved actors
* Provides three different ways to define how the performance will be done:
    * By start pose and sequence of poses
	* By a list of dances
	* By tags
* Has the ability to control stripping and redressing for each body slot
* Provides mod events and hooks to integrate with other mods
* Provides a registry to query for data and add your own poses and dances
* Dances inside a performance have a soft transition by design and allow fluid animations


## General structure of the mod
The mod has a set of animations (made by many talented Skyrim animators) and some code.
The animations are done in a way that enables them to be sequenced.

An important concept for the mod is the _Pose_<br>
A _Pose_ is a single frame animation that can be used in the dances. All animations will start from a specific pose and will end with another pose.
The set of poses is pre-defined (but new poses and animations can be added.)

A pose has also two sub-animations connected to it.
The sub-animations (called _enterPose_ and _exitPose_) are used to have an actor to begin and end the animation by going to the pose (and quitting the animation from a pose that was reached.)

Sub-dances will always start and end with an animation frame that will be one of the poses.

## How animations work
Using the APIs to start a dance with an Actor (player or NPC) will have these consequences:

1. The actor will be allocated and controlled
2. A pole will be placed (in case it is not passed as reference)
3. The actor will walk close to the pole on a specific location to start the animation
4. A start pose is selected (the pose can be passed as parameter, or come from a list of dances, or found by tags)
5. The _enterPose_ animation from the pose is played, the actor will now be in the pose
6. A sub-dance that starts with the current pose is selected and played
7. When the sub-animation ends, it will reach another pose, another sub-dance animation, that starts with the pose that is the end pose of the previous animation, is selected
8. The next animation is played, and the cycle will continue until the time specified is completed (or the set of dances is completed)
9. The actor will be in the end pose of the last animation, the _exitPose_ animation is played
10. The actor is released (and the pole may be removed in case it was added automatically)

Something like:
[_Play enterPose anim for_ __Pose A__] --> <br>
[_Play one anim that starts with_ __Pose A__] --> <br>
[_Animation ends with_ __Pose B__, find new animation starting with __Pose B__] --> <br>
[_Play the animation_] --> <br>
  [...] --> <br>
[_reach the end pose of the last animation_ (__Pose Z__)] --> <br>
[_Play exitPose anim for_ __Pose Z__]

