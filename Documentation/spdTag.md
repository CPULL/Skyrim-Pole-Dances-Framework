# Using tags (spdTag)
Tags are associated to the dances, and they can be used to define the performance.

Tags can add many different informations and they are _pre-defined_ (you cannot add your own tags.)


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

## Use of tags
Considering that the tags are associated to [Dances](spdDance.md) many of them can be possible for a single dance (and this is a group), and multiple groups can be used to define the full sequence.

A group of tags is a string with all the tags inside, separated by comma ( `,`)

Example: " `Auth:Anubis,Standing,Skill:2` (grabs all dances from Anubis of type standing and skill level equal to 2) `Auth:FunnyBizness,Brutal` (all FunyBizness' Dances of type Bruta;l.)
`!Auth:Rydin,Spreading` (Grabs the dances of type Spreadin where the author is NOT Rydin)

When setting the tags for a Performace you can pass them as array of strings (in this case each element is a group), or all as a single string.<br>
Multiple groups have to be joined using the semicolon character ( `;` )


