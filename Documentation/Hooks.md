# Pole Dance Hooks
Hooks are used to send `ModEvents` to your code when something happen.

To receive the events is important to subscribe to them, and to register for Mod Events.

## Events Definition (by Hooks)

### \<Hook\>\_DanceStarting(tid, dancer, pose)
Event sent when the pole Dance is being initialized and just started, and the actor begins to walk to the pole.
* To receive this event you need to subscribe to it.
* The subscription is done inside the [spdThread](spdThread.md) object.
```
myThread.addHook("MyHookForMyMod", "DanceStarting")
RegisterForModEvent("MyHookForMyMod_DanceStarting", "HandleTheEvent")

...

Event HandleTheEvent(int threadId, Form dancer, string startPose)
	debug.trace("The actor " + ((Actor)dancer).getDisplayName() + " is going to the pole and will start with the pose named " + startPose + ". The Pole Dance Thread has the id " + threadId)
endEvent
```
This is a hook event, so you have to define your own Hook name. The event to register for will have as name `<your hook name>`_`DanceStarting`.
The event is sent only if someone registered for it.

If Global Events are registered, also the event `GlobalDanceStarting` is sent.


### \<Hook\>\_DanceStarted(tid, dancer, dance, pose)
Event sent when the actor reached the pole and start the actual dance.
* To receive this event you need to subscribe to it.
* The subscription is done inside the [spdThread](spdThread.md) object.
```
myThread.addHook("MyHookForMyMod", "DanceStarted")
RegisterForModEvent("MyHookForMyMod_DanceStarted", "HandleTheEvent")

...

Event HandleTheEvent(int threadId, Form dancer, string danceName, string startPose)
	debug.trace("The actor " + ((Actor)dancer).getDisplayName() + " reached the pole and with the pose " + startPose + " will do the first dance named " + dance + ". The Pole Dance Thread has the id " + threadId)
endEvent
```
This is a hook event, so you have to define your own Hook name. The event to register for will have as name `<your hook name>`_`DanceStarted`.
The event is sent only if someone registered for it

If Global Events are registered, also the event `GlobalDanceStarted` is sent.


### \<Hook\>\_DanceChanged(tid, dancer, dance)
Event sent every time an actor that is dancing will begin a new dance sub-animation (stage.)
* To receive this event you need to subscribe to it.
* The subscription is done inside the [spdThread](spdThread.md) object.
```
myThread.addHook("MyHookForMyMod", "DanceChanged")
RegisterForModEvent("MyHookForMyMod_DanceChanged", "HandleTheEvent")

...

Event HandleTheEvent(int threadId, Form dancer, string danceName)
	debug.trace("The actor " + ((Actor)dancer).getDisplayName() + " is performing the dance " + dance + " in the Thread " + threadId)
endEvent
```
This is a hook event, so you have to define your own Hook name. The event to register for will have as name `<your hook name>`_`DanceChanged`.
The event is sent only if someone registered for it

If Global Events are registered, also the event `GlobalDanceChanged` is sent.


### \<Hook\>\_PoseUsed(tid, dancer, prevDance, pose, nextDance)
Event sent every time an actor that is dancing will pass through a pose (usually at the very begin of the performance, and at the end of all sub-dances.
* To receive this event you need to subscribe to it.
* The subscription is done inside the [spdThread](spdThread.md) object.
* The parameters `prevDance` and `nextDance` may be an empty strings in case the pose is the very first one or the very last one.
```
myThread.addHook("MyHookForMyMod", "PoseUsed")
RegisterForModEvent("MyHookForMyMod_PoseUsed", "HandleTheEvent")

...

Event HandleTheEvent(int threadId, Form dancer, string prevDanceName, string poseName, string nextDanceName)
	if prevDanceName=="" ; No previous dance, it is the very first pose
		debug.trace("The actor " + ((Actor)dancer).getDisplayName() + " is starting with the pose " + poseName)
	endIf
	if nextDanceName=="" ; No next dance, it is the very last one
		debug.trace("The actor " + ((Actor)dancer).getDisplayName() + " is completing with the pose " + poseName)
	endIf
	if prevDanceName!="" && nextDanceName!=""
		debug.trace("The actor " + ((Actor)dancer).getDisplayName() + " is changing from the dance " + prevDanceName + " to the dance " + nextDanceName + " by passing through the pose " + poseName)
	endIf
endEvent
```
This is a hook event, so you have to define your own Hook name. The event to register for will have as name `<your hook name>`_`PoseUsed`.
The event is sent only if someone registered for it

If Global Events are registered, also the event `GlobalPoseUsed` is sent.


### \<Hook\>\_DanceEnding(tid, dancer, endPose, endPoseTime)
Event sent when the dance is completed and the actor is leaving the pole. The performance itself is still active and the actor is not yet free.
* To receive this event you need to subscribe to it.
* The subscription is done inside the [spdThread](spdThread.md) object.
```
myThread.addHook("MyHookForMyMod", "DanceEnding")
RegisterForModEvent("MyHookForMyMod_DanceEnding", "HandleTheEvent")

...

Event HandleTheEvent(int threadId, Form dancer, string poseName, float endPoseTime)
	debug.trace("The actor " + ((Actor)dancer).getDisplayName() + " is ending the performance with the pose " + poseName + " that should last for " + endPoseTime + " seconds.")
endEvent
```
This is a hook event, so you have to define your own Hook name. The event to register for will have as name `<your hook name>`_`DanceEnding`.
The event is sent only if someone registered for it

If Global Events are registered, also the event `GlobalDanceEnding` is sent.


### \<Hook\>\_DanceEnded(tid, dancer)
Event sent when the whole performance is compelted and the actor has been released.
* To receive this event you need to subscribe to it.
* The subscription is done inside the [spdThread](spdThread.md) object.
```
myThread.addHook("MyHookForMyMod", "DanceEnded")
RegisterForModEvent("MyHookForMyMod_DanceEnded", "HandleTheEvent")

...

Event HandleTheEvent(int threadId, Form dancer)
	debug.trace("The actor " + ((Actor)dancer).getDisplayName() + " completed the performance and now it is free.")
endEvent
```
This is a hook event, so you have to define your own Hook name. The event to register for will have as name `<your hook name>`_`DanceEnded`.
The event is sent only if someone registered for it

If Global Events are registered, also the event `GlobalDanceEnded` is sent.



## Events Definition (Global events)
Global events are similar to Hooks, but they are sent to all mods and all mods can use them.
* It is still necessary to tell the framework that your mod needs the global events.
* Global events are sent only if there is at least one mod receiving the events.

### GlobalDanceStarting(tid, dancer, pose)
Event sent when the pole Dance is being initialized and just started, and the actor begins to walk to the pole.
* To receive this event you need to tell the framework to send this global event.
* The subscription is done inside the [spdPoleDances](spdPoleDances.md) main object.
```
spd.requireGlobalEvent("DanceStarting")
RegisterForModEvent("GlobalDanceStarting", "HandleTheEvent")

...

Event HandleTheEvent(int threadId, Form dancer, string startPose)
	debug.trace("The actor " + ((Actor)dancer).getDisplayName() + " is going to the pole and will start with the pose named " + startPose + ". The Pole Dance Thread has the id " + threadId)
endEvent
```



### GlobalDanceStarted(tid, dancer, dance, pose)
Event sent when the actor reached the pole and start the actual dance.
* To receive this event you need to tell the framework to send this global event.
* The subscription is done inside the [spdPoleDances](spdPoleDances.md) main object.
```
spd.requireGlobalEvent("DanceStarted")
RegisterForModEvent("GlobalDanceStarted", "HandleTheEvent")

...

Event HandleTheEvent(int threadId, Form dancer, string danceName, string startPose)
	debug.trace("The actor " + ((Actor)dancer).getDisplayName() + " reached the pole and with the pose " + startPose + " will do the first dance named " + dance + ". The Pole Dance Thread has the id " + threadId)
endEvent
```


### GlobalDanceChanged(tid, dancer, dance)
Event sent every time an actor that is dancing will begin a new dance sub-animation (stage.)
* To receive this event you need to tell the framework to send this global event.
* The subscription is done inside the [spdPoleDances](spdPoleDances.md) main object.
```
spd.requireGlobalEvent("DanceChanged")
RegisterForModEvent("GlobalDanceChanged", "HandleTheEvent")

...

Event HandleTheEvent(int threadId, Form dancer, string danceName)
	debug.trace("The actor " + ((Actor)dancer).getDisplayName() + " is performing the dance " + dance + " in the Thread " + threadId)
endEvent
```


### GlobalPoseUsed(tid, dancer, prevDance, pose, nextDance)
Event sent every time an actor that is dancing will pass through a pose (usually at the very begin of the performance, and at the end of all sub-dances.
* To receive this event you need to tell the framework to send this global event.
* The subscription is done inside the [spdPoleDances](spdPoleDances.md) main object.
* The parameters `prevDance` and `nextDance` may be an empty strings in case the pose is the very first one or the very last one.
```
spd.requireGlobalEvent("PoseUsed")
RegisterForModEvent("GlobalDPoseUsed", "HandleTheEvent")

...

Event HandleTheEvent(int threadId, Form dancer, string prevDanceName, string poseName, string nextDanceName)
	if prevDanceName=="" ; No previous dance, it is the very first pose
		debug.trace("The actor " + ((Actor)dancer).getDisplayName() + " is starting with the pose " + poseName)
	endIf
	if nextDanceName=="" ; No next dance, it is the very last one
		debug.trace("The actor " + ((Actor)dancer).getDisplayName() + " is completing with the pose " + poseName)
	endIf
	if prevDanceName!="" && nextDanceName!=""
		debug.trace("The actor " + ((Actor)dancer).getDisplayName() + " is changing from the dance " + prevDanceName + " to the dance " + nextDanceName + " by passing through the pose " + poseName)
	endIf
endEvent
```


### GlobalDanceEnding(tid, dancer, endPose, endPoseTime)
Event sent when the dance is completed and the actor is leaving the pole. The performance itself is still active and the actor is not yet free.
* To receive this event you need to tell the framework to send this global event.
* The subscription is done inside the [spdPoleDances](spdPoleDances.md) main object.
```
spd.requireGlobalEvent("DanceEnding")
RegisterForModEvent("GlobalDanceEnding", "HandleTheEvent")

...

Event HandleTheEvent(int threadId, Form dancer, string poseName, float endPoseTime)
	debug.trace("The actor " + ((Actor)dancer).getDisplayName() + " is ending the performance with the pose " + poseName + " that should last for " + endPoseTime + " seconds.")
endEvent
```


### GlobalDanceEnded(tid, dancer)
Event sent when the whole performance is compelted and the actor has been released.
* To receive this event you need to tell the framework to send this global event.
* The subscription is done inside the [spdPoleDances](spdPoleDances.md) main object.
```
spd.requireGlobalEvent("DanceEnded")
RegisterForModEvent("GlobalDanceEnded", "HandleTheEvent")

...

Event HandleTheEvent(int threadId, Form dancer)
	debug.trace("The actor " + ((Actor)dancer).getDisplayName() + " completed the performance and now it is free.")
endEvent
```


## System Events
System events are global events that are sent no matter what and are unrelated to dances.

### SkyrimPoleDancesInitialized(version)
Sent when the mod is fully initialized and can be used.
```
RegisterForModEvent("SkyrimPoleDancesInitialized", "HandleTheInit"

...

Event HandleTheInit(int version)
	debug.trace("Skyrim Pole Dances is now utilizable. The version of the framework is: " + version)
endEvent
```

### SkyrimPoleDancesRegistryUpdated(version, registry)
Sent when the registry is being updated (to allow to add further dances)
* This event is really important in case you want to add extra dances and poses.
```
RegisterForModEvent("SkyrimPoleDancesRegistryUpdated", "AddMyDances")

...

Event AddMyDances(int version, Form registry)
	spdRegistry reg = (spdRegistry)registry
	if reg.findDance("MyDance")==None
		reg.addDance("MyDance", "MyHKXEvent", 12.2, "Pose A", "Pose B", false, "MF")
	endIf
endEvent
```
