Scriptname spdTag extends ReferenceAlias

spdPoleDances spdF
spdRegistry registry
int numTags
String[] tags
bool[] tagNegatives
string[] authors
string[] dances
bool authorsNegative
bool dancesNegative
int[] strip ; -1 to dress, 0 to ignore, 1 to strip
int[] sexys ; -1 to avoid, 0 to ignore, 1 to have
int[] skills ; -1 to avoid, 0 to ignore, 1 to have
bool andMode
bool _inUse

bool Property inUse
	bool Function get()
		return _inUse
	endFunction
endProperty

Function _doInit(spdPoleDances spd)
	spdF = spd
	registry = spd.registry
endFunction



; String tag format
;
; [^][!][tagname[:value]],[!][tagname[:value]],...
;
; ^ at begin means all values are in AND mod (all tags have to be there), it applies to all tags except "dance:" and "strip"
; ! means that the tag is in negative form, so !auth:cpu menas "not CPU as author", for stripping, "!strip:body" means "dress the body"
;

string Function _tryToParseTags(string tagCode, string[] validTags, string[] bodyParts, spdRegistry reg) global
	bool tryAndMode = false
	bool alreadyAuthor = false
	bool alreadyDance = false

	; Empty string "" if the tag can be parsed and is valid (does not create the tag), a string with te error if any
	if tagCode==""
		return "Empty tag"
	endIf
	
	; Check if the items have to be in AND or OR mode
	if StringUtil.subString(tagCode, 0, 1)=="^"
		tryAndMode = true
		tagCode = StringUtil.subString(tagCode, 1)
		if tagCode==""
			return "Empty tag"
		endIf
	endIf

	string[] parts = StringUtil.Split(tagCode, ",")
	int i=parts.length
	while i
		i-=1
		string theTag = parts[i]
		if theTag==""
			return "Empty tag"
		endIf
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
			; in case we are in andMode we can have only one author, but authors can be separated by | (and are in OR mode)
			if tryAndMode && alreadyAuthor
				return "Only one author is possible in case the tags are in AND mode"
			endIf
			alreadyAuthor = true
			
		elseIf theTag=="Dance"
			; The value should be a known dance, but dances can be separated by | (and are in OR mode)
			if reg.findDanceByName(theValue)==None
				return "Unknow dance for the tag: " + theValue;
			endIf
			; in case we are in andMode we can have only one author
			if tryAndMode && alreadyDance
				return "Only one dance is possible in case the tags are in AND mode"
			endIf
			alreadyDance = true
			
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
bool Function _init(string tagCode, string[] validTags, string[] bodyParts, spdPoleDances spd)
	tags = new string[1]
	tagNegatives = new Bool[1]
	strip = new int[32]
	sexys = new int[6]
	skills = new int[6]
	numTags = 0
	authors = new string[8]
	authorsNegative = false
	dances = new string[8]
	dancesNegative = false
	andMode = false
	bool doneAuthors = false
	bool doneDances = false
	registry = spdF.registry
	spdF = spd

	if tagCode==""
		spdF._addError(50, "Empty tag", "spdTag", "init")
		return true
	endIf
	
	; Check if the items have to be in AND or OR mode
	if StringUtil.subString(tagCode, 0, 1)=="^"
		andMode = true
		tagCode = StringUtil.subString(tagCode, 1)
		if tagCode==""
			spdF._addError(50, "Empty tag", "spdTag", "init")
			return true
		endIf
	endIf

	string[] parts = StringUtil.Split(tagCode, ",")
	int i=parts.length
	int j=0
	while i
		i-=1
		
		string theTag = parts[i]
		bool negative = false
		if StringUtil.subString(theTag, 0, 1)=="!"
			theTag = StringUtil.subString(theTag, 1)
			negative = true
		endIf
		; Has to start with a known tag, in case the tag has values we need to check that the vaues are good
		bool isGood=(validTags.Find(theTag)!=-1)
		bool isValue=false
		if !isGood
			spdF._addError(51, "Unknow tag (" + theTag + ")", "spdTag", "init")
			return true
		endIf
		string theValue = ""
		isValue = (StringUtil.find(theTag, ":")!=-1)
		if isValue
			theValue = StringUtil.subString(theValue, StringUtil.find(theTag, ":") + 1)
			if theValue==""
				spdF._addError(52, "Invalid tag (" + theTag + "), value is missing", "spdTag", "init")
				return true
			endIf
			theTag = StringUtil.subString(theTag, 0, StringUtil.find(theTag, ":") - 1)
		endIf
		
		bool needToSave = true
		if theTag=="Auth"
			if andMode
				; If we are in AND mode then only one author is possible (but multiple authors can be in OR mode separated by |)
				if doneAuthors
					spdF._addError(53, "Not possible to specify multiple authors for a tag in AND mode, separate them with | wo have them in OR mode (" + theTag + ")", "spdTag", "init")
					return true
				endIf
				authors = StringUtil.split(theValue, "|")
				doneAuthors = true
			else
				; In normal OR mode we can have up to 8 authors
				string[] auths = StringUtil.split(theValue, "|")
				int a = auths.length
				while a
					a-=1
					if authors.find(auths[a])==-1
						int pos = authors.find("")
						if pos==-1
							spdF._addError(54, "[WARNING] Too many authors specified", "spdTag", "init")
						else
							authors[pos] = auths[a]
						endIf
					endIf
				endWhile
				doneAuthors = true
			endIf
			needToSave = false
			authorsNegative = negative
			
		elseIf theTag=="Dance"
			if andMode
				; If we are in AND mode then only one dance is possible (but multiple dances can be in OR mode separated by |)
				if doneDances
					spdF._addError(55, "Not possible to specify multiple dances for a tag in AND mode, separate them with | wo have them in OR mode (" + theTag + ")", "spdTag", "init")
					return true
				endIf
				dances = StringUtil.split(theValue, "|")
				int a = dances.length
				while a
					a-=1
					if registry.findDanceByName(dances[a])==None ; The value should be a known dance
						spdF._addError(56, "Unknow dance for the tag: " + dances[a], "spdTag", "init")
						return true
					endIf
				endWhile
				doneDances = true
			else
				; In normal OR mode we can have up to 8 dances
				string[] dans = StringUtil.split(theValue, "|")
				int a = dans.length
				while a
					a-=1
					if registry.findDanceByName(dans[a])==None ; The value should be a known dance
						spdF._addError(56, "Unknow dance for the tag: " + dans[a], "spdTag", "init")
						return true
					endIf
					if authors.find(dans[a])==-1
						int pos = authors.find("")
						if pos==-1
							spdF._addError(57, "[WARNING] Too many dances specified", "spdTag", "init")
						else
							authors[pos] = dans[a]
						endIf
					endIf
				endWhile
				doneDances = true
			endIf
			needToSave = false
			dancesNegative = negative
			
		elseIf theTag=="Strip"
			if theValue==""
				spdF._addError(68, "Part not specified for stripping tag", "spdTag", "init")
				return true
			endIf
			; Can be body location(s) or a set of body slots (numbers)
			string[] slots = StringUtil.Split(theValue, "|")
			j = slots.length
			while j
				j-=1
				if bodyParts.find(slots[j])==-1
					spdF._addError(59, "Unknown part \"" + slots[j] + "\" for stripping tag", "spdTag", "init")
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
			needToSave = false
		
		elseIf theTag=="Sexy"
			; Sexy:0|1|2|3|4|5
			int k = StringUtil.getLength(theValue)
			j = 0
			while j<k
				string item = StringUtil.subString(theValue, j, 1)
				if item=="0"
					if negative
						sexys[0]=-1
					else
						sexys[0]=1
					endIf
				elseIf item=="1"
					if negative
						sexys[1]=-1
					else
						sexys[1]=1
					endIf
				elseIf item=="2"
					if negative
						sexys[2]=-1
					else
						sexys[2]=1
					endIf
				elseIf item=="3"
					if negative
						sexys[3]=-1
					else
						sexys[3]=1
					endIf
				elseIf item=="4"
					if negative
						sexys[4]=-1
					else
						sexys[4]=1
					endIf
				elseIf item=="5"
					if negative
						sexys[4]=-1
					else
						sexys[4]=1
					endIf
				elseIf item!="|"
					spdF._addError(60, "[WARNING] Invalid tag (" + theTag + ":" + theValue + "), a part of the value is unkwnon: " + item, "spdTag", "init")
				endIf 
				j+=1
			endWhile
			needToSave = false
		
		elseIf theTag=="Skill"
			; Skill:0|1|2|3|4|5
			int k = StringUtil.getLength(theValue)
			j = 0
			while j<k
				string item = StringUtil.subString(theValue, j, 1)
				if item=="0"
					if negative
						skills[0]=-1
					else
						skills[0]=1
					endIf
				elseIf item=="1"
					if negative
						skills[1]=-1
					else
						skills[1]=1
					endIf
				elseIf item=="2"
					if negative
						skills[2]=-1
					else
						skills[2]=1
					endIf
				elseIf item=="3"
					if negative
						skills[3]=-1
					else
						skills[3]=1
					endIf
				elseIf item=="4"
					if negative
						skills[4]=-1
					else
						skills[4]=1
					endIf
				elseIf item=="5"
					if negative
						skills[4]=-1
					else
						skills[4]=1
					endIf
				elseIf item!="|"
					spdF._addError(60, "[WARNING] Invalid tag (" + theTag + ":" + theValue + "), a part of the value is unkwnon: " + item, "spdTag", "init")
				endIf 
				j+=1
			endWhile
			needToSave = false
		
		endIf
		
		if needToSave
			; Save the actual tag
			numTags+=1
			tags = Utility.resizeStringArray(tags, numTags)
			if tagNegatives.length!=numTags
				tagNegatives = Utility.resizeBoolArray(tagNegatives, numTags)
			endIf
			tags[numTags - 1] = theTag
			tagNegatives[numTags - 1] = negative
		endIf
			
	endWhile

	return false
endFunction

string Function print()
	string res = ""
	
	int i=0
	while i<numTags
		if tagNegatives[i]
			res+="!"
		endIf
		res+=tags[i]
		
		if i<numTags - 1
			if andMode
				res+="^"
			else
				res+=","
			endIf
		endIf
	
		i+=1
	endWhile
	
	if authors[0]!=""
		res+="^"
		if authorsNegative
			res+="!"
		endIf
		res+="authors:"
		i = 0
		bool doneOne = false
		while i<8
			if authors[i]!=""
				if doneOne
					res+="|"
				endIf
				doneOne=true
				res+=authors[i]
			endIf
		endWhile
	endIf
	
	if dances[0]!=""
		res+="^"
		if dancesNegative
			res+="!"
		endIf
		res+="dances:"
		i = 0
		bool doneOne = false
		while i<8
			if dances[i]!=""
				if doneOne
					res+="|"
				endIf
				doneOne=true
				res+=dances[i]
			endIf
		endWhile
	endIf
	
	bool asNeg = false
	bool asPos = false
	i=0
	while i<strip.length
		if strip[i]<0
			asNeg=true
		elseIf strip[i]>0
			asPos=true
		endIf
		i+=1
	endWhile
	if asNeg
		res+=",!strip:"
		i=0
		bool doneOne=false
		while i<strip.length
			if strip[i]<0
				if doneOne
					res+="|"
				endIf
				doneOne=true
				res += (30+i)
			endIf
			i+=1
		endWhile
	endIf
	if asPos
		res+=",strip:"
		i=0
		bool doneOne=false
		while i<strip.length
			if strip[i]<0
				if doneOne
					res+="|"
				endIf
				doneOne=true
				res += (30+i)
			endIf
			i+=1
		endWhile
	endIf
	
	bool needed = false
	i=0
	while i<sexys.length && !needed
		if sexys[i]!=0
			needed=true
		endIf
		i+=1
	endWhile
	if needed
		res+=",Sexy:"
		i=0
		bool doneOne=false
		while i<sexys.length
			if sexys[i]<0
				if doneOne
					res+="|"
				endIf
				doneOne=true
				res += "!" + i
			elseIf sexys[i]>0
				if doneOne
					res+="|"
				endIf
				doneOne=true
				res += i
			endIf
			i+=1
		endWhile
	endIf
	
	needed = false
	i=0
	while i<skills.length && !needed
		if skills[i]!=0
			needed=true
		endIf
		i+=1
	endWhile
	if needed
		res+=",Skill:"
		i=0
		bool doneOne=false
		while i<skills.length
			if skills[i]<0
				if doneOne
					res+="|"
				endIf
				doneOne=true
				res += "!" + i
			elseIf skills[i]>0
				if doneOne
					res+="|"
				endIf
				doneOne=true
				res += i
			endIf
			i+=1
		endWhile
	endIf
	
	return res
endFunction
