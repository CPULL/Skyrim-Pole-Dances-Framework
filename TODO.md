# TODO
- [ ] **TAGS**
    - [X] Define how to use them and the list of them (all **contributors**)
    - [X] Add code for tags and use them for Performances (**CPU**)
    - [X] Add "dance:<name>" type of tag
    - [X] Add "strip:<values>" type of tag
	- [X] Add to the Dance definition its tags, and add a function in the init to add the tags to the anim
	- [ ] Implement the Pose tag
- [ ] **Framework**
    - [X] Add a newThreadTags() function (**CPU**)
- [ ] **Performances**
    - [ ] Alter the thread to play with the different modes to define the animation (**CPU**)
	    - [ ] Only start pose and duration
	    - [ ] Sequence of Dances
	    - [ ] Sequence of Tags
	- [ ] Destroy the thread after it ends and return it to the pool
    - [X] Rename everywhere "Thread" with "Performance" (**CPU**)
- [ ] **Stripping**
    - [ ] Add a way to control stripping during pole dances (**CPU**)
    - [ ] Add some strip keyword to define when to strip during a step of a pole dance (animated or not, and defining the body slots to alter) (**CPU**)
	    - [X] Tags
		- [ ] Dances
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
    - [ ] Add a MCM to the framework (**CPU**)
    - [ ] Add a way to preview-poses in the Framework MCM (**CPU**)
    - [ ] Add a test mod (__DanceMaker__) to test the dances (**CPU**)
- [ ] **Hooks**
    - [ ] Add events in the playing of the performance
- [ ] **Errors Management**
	- [X] Complete errors documentation (**CPU**)
	- [X] Probably errors on tags need more slots, some errors are using the same slot (authors and dances, and numbers for Sexy and Skill)
- [ ] **Registry**
    - [X] Add code to find dances by name (**CPU**)
    - [ ] Add code to find dances by tags (**CPU**)
    - [X] Add code to find poses by name (**CPU**)
- [ ] **Animations**
    - [ ] Convert the poses from 3DS format to HKX files (**Komotor**)
	- [ ] Build at least one test dance anim (3DS and HKX) (**Komotor**)

	
	
	
```
FIXME Mode (just for CPU)
; FIXME Re-set the events, right now they are not perfect in timing and parameters
; FIXME Add functions to strip and redress
; FIXME Add a method to specify the next dance on the fly (to be used during events)
; FIXME Add stop() function
; FIXME Make private all functions that should be private
; FIXME Build the tool to test
; FIXME 
; FIXME 
; FIXME 




```