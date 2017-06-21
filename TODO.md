# TODO
- [ ] **TAGS**
    - [X] Define how to use them and the list of them (all **contributors**)
    - [X] Add code for tags and use them for Performances (**CPU**)
    - [X] Add "dance:<name>" type of tag
    - [X] Add "strip:<values>" type of tag
	- [X] Add to the Dance definition its tags, and add a function in the init to add the tags to the anim
	- [ ] Implement the Pose tag
- [X] **Framework**
    - [X] Add a newPerformance() function (**CPU**)
- [X] **Performances**
    - [X] Alter the performance to play with the different modes to define the animation (**CPU**)
	    - [X] Only start pose and duration
	    - [X] Sequence of Dances
	    - [X] Sequence of Tags
	- [x] Destroy the performance after it ends and return it to the pool
    - [X] Rename everywhere "Thread" with "Performance" (**CPU**)
    - [X] Implement the Stop method (**CPU**)
- [ ] **Stripping**
    - [X] Add a way to control stripping during pole dances (**CPU**)
    - [X] Add some strip keyword to define when to strip during a step of a pole dance (animated or not, and defining the body slots to alter) (**CPU**)
	    - [X] Tags
		- [X] Dances
	- [X] Add strip functions inside the spdActor
	- [X] Call spdActor's strip functions inside the performances
	- [ ] Create stripping anims, also with the use of just the OFA system to move just the hands while dancing
- [ ] **Documentation**
    - [ ] Complete the documentation of APIs (**CPU**, **Rydin**)
	    - [ ] Main framework
	    - [ ] Hooks
	    - [ ] Dances
	    - [ ] Poses
	    - [ ] Tags
	    - [ ] Examples
    - [ ] For all doc pages, add an index at begin, and use a single line (not two) to split the sections (**CPU**)
- [ ] **MCM**
    - [X] Add a MCM to the framework (**CPU**)
    - [ ] Complete the MCM with all the options (**CPU**)
    - [X] Add a way to preview poses in the Framework MCM (**CPU**)
    - [X] Add a way to preview dances in the Framework MCM (**CPU**)
- [ ] **Hooks**
    - [X] Add events in the playing of the performance
    - [ ] Add global events register functions
- [ ] **Errors Management**
	- [X] Complete errors documentation (**CPU**)
	- [X] Probably errors on tags need more slots, some errors are using the same slot (authors and dances, and numbers for Sexy and Skill)
	- [X] Remove the errors in the array, and print them right away, but keep the "debug" option to avoid to spam the log
	- [ ] Fix all IDs that are at 99
- [ ] **Registry**
    - [X] Add code to find dances by name (**CPU**)
    - [ ] Add code to find dances by tags (**CPU**)
    - [X] Add code to find poses by name (**CPU**)
    - [X] Add code to get a strip by a special dance name (**CPU**)
    - [ ] Add code to get a pose (animated) by a special pose name (**CPU**)
- [ ] **Animations**
    - [ ] Convert the dances from 3DS format to HKX files (**Komotor**)
	- [ ] Build at least one test dance anim (3DS and HKX) (**Komotor**)
- [ ] **Actors**
    - [X] Remove the local properties and call always the property from the main framework
- [ ] **Test Tool**
    - [ ] Add a test mod (__DanceMaker__) to test the dances (**CPU**)
    - [X] Build a small test tool _Pole Dance Maker_ to quickly start a pole dance on actors or player (like MatchMaker)
	- [ ] Add another spell to set a specific dance to be tested
	- [ ] Add a MCM to set up the dance to be played
- [ ] **Remote Future**
    - [ ] Add music
    - [ ] Add dances without a pole

	
	
	
```
FIXME Mode (just for CPU)
; FIXME Add a method to specify the next dance on the fly (to be used during events)
; FIXME Make private all functions that should be private
; FIXME (spdActors) Add face expressions?
; FIXME 
; FIXME Add function to registry to set a custom pole (requires a Static object)
; FIXME 
; FIXME 
; FIXME 
; FIXME 




```