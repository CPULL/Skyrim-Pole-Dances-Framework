# Using tags (spdTag)
Tags are associated to the dances, and they can be used to define the performance.

Tags can add many different informations and they are _pre-defined_ (you cannot add your own tags.)

* XXX: [XXX](spdTag.md#XXX)

<br><br><hr><br><br>


## Type of tags
A tag may have a column ( `:` ) inside to define a specific type.

### Author tags
These tags are used to define the author of the dance.<br>
They have the format `Auth:komotor` or `Auth:FunnyBizness` .

### Dance tags
They are used to specify what the dance will be<br>
They use just the name without any column ( `:` ).

### Stripping tags
These tags are specific and not associated with dances.<br>
They are used to specify a strip during a performance.<br>
TODO define how to do them... `Strip:body` `Strip:All` `Strip:32` `Srtip:32+34+35+38`
TODO nd redress... `Dress:body` `Dress:All` `Dress:32` `Dress:32+34+35+38`


<br><br><hr><br><br>


## Use of tags
Considering that the tags are associated to [Dances](spdDance.md) many of them can be possible for a single dance (and this is a group), and multiple groups can be used to define the full sequence.

A group of tags is a string with all the tags inside, separated by comma ( `,`)

Example: " `Auth:Anubis,Standing,Skill:2` (grabs all dances from Anubis of type standing and skill level equal to 2) `Auth:FunnyBizness,Brutal` (all FunyBizness' Dances of type Bruta;l.)
`!Auth:Rydin,Spreading` (Grabs the dances of type Spreadin where the author is NOT Rydin)

When setting the tags for a Performace you can pass them as array of strings (in this case each element is a group), or all as a single string.<br>
Multiple groups have to be joined using the semicolon character ( `;` )

To say that a tag _should not_ be in the dance, you can prepend it with an exclamation point ( `!` )<br>
For example `!Standing` will match all dances that ___do not___ have the `Standing` tag.

<br><br><hr><br><br>


## List of tags
Be aware that tags are not case sensitive, so `TAG` , `Tag` , and `tag` are all equivalent.

### Auth:\<name\>
These tags are used to specify the author of the dance.<br>
E.g. `Auth:komotor` , `Auth:FunnyBizaness` , `Auth:Anubiss` , `Auth:Rydin` , `Auth:MadMansGun` , `Auth:Leito`

### Standing
The dance will have the dancer on his/her feet

### Kneeling
The dance will have the dancer on the floor with one or two legs bended and kneeled

### Front
The dancer will face the specator

### Back
The specator will see the shoulders/back of the dancer

### Grab
The dancer will have one or two hands on the pole

### DoubleGrab
The dancer will have both hands on the pole

### Floating
The dancer will not touch the ground

### Spreading
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
