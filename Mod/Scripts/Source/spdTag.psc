Scriptname spdTag

int numTags
String[] tags
bool[] tagNegatives
string author
string dance
int[] strip ; -1 to dress, 0 to ignore, 1 to strip
int[] sexys
int[] skills

static string Function _tryToParseTag(string tagCode, string[] validTags, string[] bodyParts)
	; Empty string "" if the tag can be parsed and is valid (does not create the tag), a string with te error if any
	if tagCode==""
		return "Empty tag"
	endIf

	string[] parts = StringUtil.Split(tagCode, ",")
	int i=parts.length
	while i
		i-=1
		string theTag = parts[i]
		string theValue = ""
		if StringUtil.subString(theTag, 0, 1)=="!"
			theTag = StringUtil.subString(theTag, 1)
		endIf
		; Has to start with a known tag, in case the tag has values we need to check that the vaues are good
		int j = validTags.length
		bool isGood=false
		bool isValue=false
		while j
			j-=1
			if StringUtil.Find(theTag, validTags[j])!=-1
				isGood=true
				j=0
			endIf
		endWhile
		if !isGood
			return "Unknow tag (" + theTag + ")"
		endIf
		isValue = (StringUtil.find(theTag, ":")!=-1)
		if isValue
			theValue = StringUtil.subString(theValue, StringUtil.find(theTag, ":") + 1)
			theTag = StringUtil.subString(theTag, 0, StringUtil.find(theTag, ":") - 1)
		endIf
		
		if theTag=="Auth"
			; Nothing special to verify
		elseIf theTag=="Dance"
			; The value should be a known dance
			if findDance(theValue)==None
				return "Unknow dance for the tag: " + theValue;
			endIf
		elseIf theTag=="Strip"
			if theValue==""
				return "Part not specified for stripping tag"
			endIf
			; Can be body location(s) or a set of body slots (numbers)
			string[] slots = StringUtil.Split(theValue, "|")
			j = slots.length
			while j
				j-=1
				if bodyParts.find(slots[j])==-1
					return "Unknown part \"" + slots[j] + "\" for stripping tag"
				endIf
			endWhile
		
		elseIf theTag=="Sexy" || theTag=="Skill"
			; Just check we have just numbers and |
			int k=StringUtil.getLength(theValue)
			while k
				k-=1
				string char = StringUtil.subString(theValue, k, 1)
				if char!="|" && char!="0" && char!="1" && char!="2" && char!="3" && char!="4" && char!="5" && char!="6" && char!="7" && char!="8" && char!="9"
					return "Not valid value for tag: " + theTag
				endIf
			endWhile
		endIf
			
	endWhile

	return ""
endFunction



; Returns true in case of errors
bool Function _init(string tag, string[] validTags, string[] bodyParts, spdPoleDances spdF)
	tags = new string[0]
	tagNegatives = new Bool[0]
	strip = new int[32]
	sexys = new int[0]
	skills = new int[0]
	numTags = 0
	author = ""
	dance = ""

	if tagCode==""
		spdF._addError(31, "Empty tag", "spdTag", "init")
		return true
	endIf

	string[] parts = StringUtil.Split(tagCode, ",")
	int i=parts.length
	while i
		i-=1
		
		string theTag = parts[i]
		bool negative = false
		if StringUtil.subString(theTag, 0, 1)=="!"
			theTag = StringUtil.subString(theTag, 1)
			negative = true
		endIf
		; Has to start with a known tag, in case the tag has values we need to check that the vaues are good
		int j = validTags.length
		bool isGood=false
		bool isValue=false
		while j
			j-=1
			if validTags[j].Find(theTag)!=-1
				isGood=true
				j=0
			endIf
		endWhile
		if !isGood
			spdF._addError(32, "Unknow tag (" + theTag + ")", "spdTag", "init")
			return true
		endIf
		isValue = (StringUtil.find(theTag, ":")!=-1)
		if isValue
			theValue = StringUtil.subString(theValue, StringUtil.find(theTag, ":") + 1)
			theTag = StringUtil.subString(theTag, 0, StringUtil.find(theTag, ":") - 1)
		endIf
		
		if theTag=="Auth"
			; Only one author can be added
			if author!=""
				spdF._addError(33, "Not possible to specify multiple authors for a tag (" + theTag + ")", "spdTag", "init")
				return true
			endIf
			author = theValue
			
		elseIf theTag=="Dance"
			; The value should be a known dance
			if findDance(theValue)==None
				spdF._addError(34, "Unknow dance for the tag: " + theValue, "spdTag", "init")
				return true
			endIf
			dance = theValue
			
		elseIf theTag=="Strip"
			if theValue==""
				spdF._addError(35, "Part not specified for stripping tag", "spdTag", "init")
				return true
			endIf
			; Can be body location(s) or a set of body slots (numbers)
			string[] slots = StringUtil.Split(theValue, "|")
			j = slots.length
			while j
				j-=1
				if bodyParts.find(slots[j])==-1
					spdF._addError(35, "Unknown part \"" + slots[j] + "\" for stripping tag", "spdTag", "init")
				endIf
			endWhile
			; Fill all slots that should be stripped
			j = slots.length
			while j
				j-=1
				int slot = bodyParts.find(slots[j])
				if slot>31
					slot-=32
				endIf
				if negative
					strip[slot]=-1
				else
					strip[slot]=1
				endIf
			endWhile
		
		elseIf theTag=="Sexy"
			string[] nums = StringUtil.Split(theValue, "|")
			j = nums.length
			while j
				j-=1
				if nums[i]==""
					nums[j]="-1"
				endIf
			endIf
			sexys = Utility.CreateIntArray(nums.length)
			j = nums.length
			while j
				j-=1
				sexys[j] = nums[i] as int
			endWhile
		
		elseIf theTag=="Skill"
			string[] nums = StringUtil.Split(theValue, "|")
			j = nums.length
			while j
				j-=1
				if nums[i]==""
					nums[j]="-1"
				endIf
			endIf
			skills = Utility.CreateIntArray(nums.length)
			j = nums.length
			while j
				j-=1
				skills[j] = nums[i] as int
			endWhile
		
		endIf
		
		; Save the actual tag
		numTags+=1
		tags = Utility.resizeStringArray(tags, numTags)
		tagNegatives = Utility.resizeBoolArray(tagNegatives, numTags)
		tags[numTags - 1] = theTag
		tagNegatives[numTags - 1] = negative
			
	endWhile

	return false
endFunction

