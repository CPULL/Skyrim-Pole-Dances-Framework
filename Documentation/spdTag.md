# Using tags (spdTag)
Tags are associated to the dances, and they can be used to define the performance.

Tags can add many different informations and they are _pre-defined_ (you cannot add your own tags.)

* [Type of tags](spdTag.md#type-of-tags)
    * [Author tags](spdTag.md#author-tags)
    * [Dance tags](spdTag.md#dance-tags)
    * [Stripping tags](spdTag.md#stripping-tags)
    * [Tags with values](spdTag.md#tags-with-values)
* [Usage of tags](spdTag.md#usage-of-tags)
* [List of tags](spdTag.md#list-of-tags)
	* [XXX](spdTag.md#XXX)
* [Example of tags](spdTag.md#example-of-tags)

<br><br><hr><br><br>


## Type of tags
A tag may have a column (`:`) inside to define a specific type.

### Author tags
These tags are used to define the author of the dance.<br>
They have the format `Auth:komotor` or `Auth:FunnyBizness` .

### Dance tags
They are used to specify what the dance will be<br>
They use just the name without any column (`:`).

### Stripping tags
These tags are specific and not associated with dances.<br>
They are used to specify a strip during a performance.<br>
**TODO** define how to do them... `Strip:body` `Strip:All` `Strip:32` `Srtip:32+34+35+38` <br>
**TODO** need redress... `Dress:body` `Dress:All` `Dress:32` `Dress:32+34+35+38`

### Tags with values
These tags are used to specify a level (`Skill`, `Sexy`, etc.)<br>
They are done by the name of the tag, a column (`:`), and a numeric value:<br>
`Skill:2`, `Sexy:4`, `duration:1`


<br><br><hr><br><br>


## Usage of tags
Considering that the tags are associated to [Dances](spdDance.md) many of them can be possible for a single dance (and this is a group), and multiple groups can be used to define the full sequence.

A group of tags is a string with all the tags inside, separated by comma (`,`)

Example: `Auth:Anubis,Standing,Skill:2` (grabs all dances from Anubis of type standing and skill level equal to 2) `Auth:FunnyBizness,Brutal` (all FunyBizness' Dances of type Bruta;l.)
`!Auth:Rydin,Spreading` (Grabs the dances of type Spreadin where the author is NOT Rydin)

When setting the tags for a Performace you can pass them as array of strings (in this case each element is a group), or all as a single string.<br>
Multiple groups have to be joined using the semicolon character (`;`)

To say that a tag _should not_ be in the dance, you can prepend it with an exclamation point (`!`)<br>
For example `!Standing` will match all dances that ___do not___ have the `Standing` tag.

<br><br><hr><br><br>


## List of tags
Be aware that tags are not case sensitive, so `TAG`, `Tag`, and `tag` are all equivalent.

### Auth:\<name\>
These tags are used to specify the author of the dance.<br>
E.g. `Auth:komotor`, `Auth:FunnyBizaness`, `Auth:Anubiss`, `Auth:Rydin`, `Auth:MadMansGun`, `Auth:Leito`

### Stand
The dance will have the dancer on his/her feet

### Kneel
The dance will have the dancer on the floor with one or two legs bended and kneeled

### Sit
The dancer will sit on the floor

### Front
The dancer will face the specator

### Back
The specator will see the shoulders/back of the dancer

### Grab
The dancer will have one or two hands on the pole

### SingleGrab
The dancer will have only one hand on the pole

### DoubleGrab
The dancer will have both hands on the pole

### Float
The dancer will not touch the ground

### Spread
The dancer will spread the legs

### Bend
The dancer will bend

### LegsUp
The dancer will have the legs up

### Duration:\<number\>
Specifies the length of the dance
- 0: Very short, usually less than a second
- 1: Short, usually a quick move (just two or three seconds)
- 2: Short, usually a transition (3-5 seconds)
- 3: Medium, normal with possibly more than one action (3-10 seconds)
- 4: Long, used for very long dances (about 15 seconds)
- 5: Huge, for really long dances (more than 20 seconds)

### Skill:\<number\>
Specifies how complex the movement should be (and so the pole dance skill level of the dancer)
- 0: everybody can do it
- 1: beginner, very simple moves
- 2: amateur, simple moves
- 3: trained, professional moves
- 4: pro, complex moves, something that not everybody will be able to do
- 5: master, something just impossible for normal people

### Sexy:\<number\>
Specifies how sexually oriented the dance will be
- 0: not at all
- 1: just a little
- 2: little, you didn't pay enough
- 3: definitly sexual
- 4: you may have an orgasm by watching it
- 5: you will have an orgasm for sure, and probably the dancer too


### Dance:\<dance name\>
Specifies that the tag will refer to a specific dance (all other tags will be ignored.)<br>
This tag cannot be added to dances, it can only be used in performances.

### Strip:[[!]\<body part\>|...][[!]\<slot number\>|...]|...
This spefici tag is used to tell that a strip will occur during a performance. The items that will be stripped are the ones specified as _Body parts_ or as _Body slots_.<br>
This tag cannot be added to dances, it can only be used in performances.

In case a _body part_ or a _body slot_ starts with the exlamation point (_!_) then the item will be dressed (but only if it was undressed before, for the current version of the framework.)<br>
In case the full tag starts with an exclamation point (_!_) then all the items will be redressed (and local excalmations in the parts will be ignored.)<br>

**Examples**:
* Strip:Body|Hands|Forearms|Calves -> will remove the items
* Strip:30|33|34|38 -> will do the same using body slots
* Strip:Body|!Head -> will remove the armor but will wear an helmet

+---+---+
| Body Part | Body Slot |
+---+---+
| Head | 30 |
| Hair | 31 |
| Body | 32 |
| Hands | 33 |
| Forearms | 34 |
| Amulet | 35 |
| Ring | 36 |
| Feet | 37 |
| Calves | 38 |
| Shield | 39 |
| Tail | 40 |
| LongHair | 41 |
| Circlet | 42 |
| Ears | 43 |
| Mouth | 44 |
| Neck | 45 |
| Chest | 46 |
| Wings | 47 |
| Strapon | 48 |
| Pelvis | 49 |
| DecapitatedHead | 50 |
| DecapitatedBody | 51 |
| Pelvis2 | 52 |
| RightLeg | 53 |
| LeftLeg | 54 |
| Jewelry | 55 |
| Undergarment | 56 |
| Shoulders | 57 |
| LeftArm | 58 |
| RightArm | 59 |
| Shclong | 60 |
| FX01 | 61 |
+---+---+

### StripAn:[[!]\<_body part_\>|...][[!]\<_slot number_\>|...]|...
This tag will work like **Strip** but the strip will be animated.


### Pose:\<_start pose name_\>[|\<_end pose name_\>]
This tag is similar to **Dance** but will grab any dance that starts with the specified pose.<br>
In case a second pose is specified then the dance will be chosen between the ones that will start with the first pose and end with the second.<br>
It is possible to omit the _start pose_ by keeping it empty. In this case the dance will one that will just end with the specified _end pose. E.g. **Pose:|MyEndPose**


## Example of tags
Here some example of tags (as array and simple string)<br>
Remember that all tags you put in a tring are used together, and they are separated by commas (`,`). If you want to say that you ___don't___ want a dance to contain a tag, just add an exclamation point at the begin (`!`).

### Examples for tags for a single dance (single Group)

`Sit,Spread`<br>
This will get all dances with bot `Sitting` and `Spreading` tags.

`Auth:komotor`<br>
This will get all dances made by komotor.

`Auth:komotor,!Legsup`
This will get all dances made by komotor, excluding the ones that have the `Legsup` tag.

`Skill:1|2|3'<br>
Grabs all dances that have the tags Skill:1 or Skill:2 or Skill:3<br>
The character `|` can be used to use a set of values for tags that support numeric values.

`!Auth:AP,Bend,Back,Sexy:3|4,!DoubleGrab`<br>
Gets the dances NOT from AP, that have Bending and Back, do NOT have DoubleGrab, and have the Sexy tag with values 3 OR 4.


### Examples for tags for multiple dances (multiple Groups)
To join together multiple groups, just put them together separated by a semicolon (`;`).

`Sexy:0,Stand,Grab;Sexy:1,Stand,Grab;Sexy:2|3;Strip:body|feet;Dance:komDance33;Pose:Pose1;Float,Grab;Sexy:3|4,Float;Bend;Spread`<br>
This will define 6 groups (there are 5 `;`).<br>
The first group (`Sexy:0,Stand,Grab`) will get animations not really sexy, that are standing and the dancer will grab the pole.<br>
The second group (`Sexy:1,Stand,Grab`) is very similar to the previous, but the level of sexuality is a little bit higher.<br>
The third group (`Sexy:2|3`) will get all the dances that have the sexuality level set to 2 OR 3. (tags with values can use a range of values.)
And so on.

This format is used by the function [setTagsString](spdThread.md#setTagsString) defined in [spdThread](spdThread.md).


