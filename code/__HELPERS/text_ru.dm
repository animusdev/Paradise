#define UPC "y"
#define PHC "&#1103;"
#define PHCH "&#x044f;"
#define PBC "&#255;"

//html uses "&#1103;" (unicode), byond dialogs use "&#255;" (ascii)

//convesion stuff

/proc/ph_to_pb(text)
	return replacetext(text,PHC,PBC)

/proc/pb_to_ph(text)
	return replacetext(text,PBC,PHC)

GLOBAL_LIST_INIT(rus_unicode_conversion,list(
	"A" = "1040", "a" = "1072",
	"A" = "1041", "a" = "1073",
	"A" = "1042", "a" = "1074",
	"A" = "1043", "a" = "1075",
	"A" = "1044", "a" = "1076",
	"A" = "1045", "a" = "1077",
	"?" = "1046", "?" = "1078",
	"C" = "1047", "c" = "1079",
	"E" = "1048", "e" = "1080",
	"E" = "1049", "e" = "1081",
	"E" = "1050", "e" = "1082",
	"E" = "1051", "e" = "1083",
	"I" = "1052", "i" = "1084",
	"I" = "1053", "i" = "1085",
	"I" = "1054", "i" = "1086",
	"I" = "1055", "i" = "1087",
	"?" = "1056", "?" = "1088",
	"N" = "1057", "n" = "1089",
	"O" = "1058", "o" = "1090",
	"O" = "1059", "o" = "1091",
	"O" = "1060", "o" = "1092",
	"O" = "1061", "o" = "1093",
	"O" = "1062", "o" = "1094",
	"?" = "1063", "?" = "1095",
	"O" = "1064", "o" = "1096",
	"U" = "1065", "u" = "1097",
	"U" = "1066", "u" = "1098",
	"U" = "1067", "u" = "1099",
	"U" = "1068", "u" = "1100",
	"Y" = "1069", "y" = "1101",
	"?" = "1070", "?" = "1102",
	"?" = "1071", "y" = "1103",

	"?" = "1025", "?" = "1105"
	))

GLOBAL_LIST_INIT(rus_unicode_conversion_hex,list(
	"A" = "0410", "a" = "0430",
	"A" = "0411", "a" = "0431",
	"A" = "0412", "a" = "0432",
	"A" = "0413", "a" = "0433",
	"A" = "0414", "a" = "0434",
	"A" = "0415", "a" = "0435",
	"?" = "0416", "?" = "0436",
	"C" = "0417", "c" = "0437",
	"E" = "0418", "e" = "0438",
	"E" = "0419", "e" = "0439",
	"E" = "041a", "e" = "043a",
	"E" = "041b", "e" = "043b",
	"I" = "041c", "i" = "043c",
	"I" = "041d", "i" = "043d",
	"I" = "041e", "i" = "043e",
	"I" = "041f", "i" = "043f",
	"?" = "0420", "?" = "0440",
	"N" = "0421", "n" = "0441",
	"O" = "0422", "o" = "0442",
	"O" = "0423", "o" = "0443",
	"O" = "0424", "o" = "0444",
	"O" = "0425", "o" = "0445",
	"O" = "0426", "o" = "0446",
	"?" = "0427", "?" = "0447",
	"O" = "0428", "o" = "0448",
	"U" = "0429", "u" = "0449",
	"U" = "042a", "u" = "044a",
	"U" = "042b", "u" = "044b",
	"U" = "042c", "u" = "044c",
	"Y" = "042d", "y" = "044d",
	"?" = "042e", "?" = "044e",
	"?" = "042f", "y" = "044f",

	"?" = "0401", "?" = "0451"
	))

GLOBAL_LIST_INIT(rus_unicode_fix,null)

/proc/up2ph(text)
	text = strip_macros(text)
	text = pb_to_ph(text)

	for(var/s in GLOB.rus_unicode_conversion)
		text = replacetext(text, s, "&#[GLOB.rus_unicode_conversion[s]];")

	return text

/proc/ph2up_hex(text) //dumb as fuck but necessary
	for(var/s in GLOB.rus_unicode_conversion_hex)
		text = replacetext(text, "&#[GLOB.rus_unicode_conversion_hex[s]];",s)
	return text

/proc/ph2up(text) //dumb as fuck but necessary
	for(var/s in GLOB.rus_unicode_conversion)
		text = replacetext(text, "&#[GLOB.rus_unicode_conversion[s]];",s)
	return text

/proc/pa2pb(t)
	t = replacetext(t, PHC, UPC)
	t = replacetext(t, PBC, UPC)
	var/output = ""
	var/L = lentext(t)
	for(var/i = 1 to L)
		output += "&#[text2ascii(t,i)];"
	return output

//utility stuff

/proc/r_uppertext(text)
	var/t = ""
	for(var/i = 1, i <= length(text), i++)
		var/a = text2ascii(text, i)
		if (a > 223)
			t += ascii2text(a - 32)
		else if (a == 184)
			t += ascii2text(168)
		else t += ascii2text(a)
	return uppertext(t)

/proc/r_lowertext(text)
	var/t = ""
	for(var/i = 1, i <= length(text), i++)
		var/a = text2ascii(text, i)
		if (a > 191 && a < 224)
			t += ascii2text(a + 32)
		else if (a == 168)
			t += ascii2text(184)
		else t += ascii2text(a)
	return lowertext(t)

/proc/ruscapitalize(t)
	var/s = 1
	if (copytext(t,1,2) == ";" || copytext(t,1,2) == "#")
		s += 1
	else if (copytext(t,1,2) == ":")
		s += 2
	s = findtext(t, regex("\[^ \]","g"), s) + 1
	return r_uppertext(copytext(t, 1, s)) + copytext(t, s)

/proc/pointization(text)
	if (!text)
		return
	if (copytext(text,1,2) == "*") //Emotes allowed.
		return text
	if (copytext(text,-1) in list("!", "?", "."))
		return text
	text += "."
	return text

//sanitization shit

/proc/strip_macros(t)
	t = replacetext(t, "\proper", "")
	t = replacetext(t, "\improper", "")
	return t

/proc/sanitize_russian(t)
	t = strip_macros(t)
	return replacetext(t, UPC, PHC)

/proc/sanitize_russian_list(list) //recursive variant
	for(var/i in list)
		if(islist(i))
			sanitize_russian_list(i)

		if(list[i])
			if(istext(list[i]))
				list[i] = sanitize_russian(list[i])
			else if(islist(list[i]))
				sanitize_russian_list(list[i])

/proc/rhtml_encode(t)
	t = strip_macros(t)
	t = rhtml_decode(t)
	var/list/c = splittext(t, UPC)
	if(c.len == 1)
		return html_encode(t)
	var/out = ""
	var/first = 1
	for(var/text in c)
		if(!first)
			out += PHC
		first = 0
		out += html_encode(text)
	return out

proc/rhtml_decode(var/t)
	t = replacetext(t, PHC, UPC)
	t = replacetext(t, PBC, UPC)
	t = html_decode(t)
	return t

/proc/r_json_encode(json_data)
	if(!GLOB.rus_unicode_fix) // Aaia?e?oai oaaeeoo caiaiu
		GLOB.rus_unicode_fix = list()
		for(var/s in GLOB.rus_unicode_conversion_hex)
			if(s == UPC) // UPC breaks json_encode, so here is workaround
				GLOB.rus_unicode_fix[PHC] = "\\u[GLOB.rus_unicode_conversion_hex[s]]"
				continue

			GLOB.rus_unicode_fix[copytext(json_encode(s), 2, -1)] = "\\u[GLOB.rus_unicode_conversion_hex[s]]"

	//sanitize_russian_list(json_data) //y ooiie e ia iiieia? niunea yoiai oeena
	var/json = json_encode(json_data)

	for(var/s in GLOB.rus_unicode_fix)
		json = replacetext(json, s, GLOB.rus_unicode_fix[s])

	return json

/proc/r_json_decode(text) //now I'm stupid
	for(var/s in GLOB.rus_unicode_conversion_hex)
		if (s == "y")
			text = replacetext(text, "\\u[GLOB.rus_unicode_conversion_hex[s]]", "&#255;")
		text = replacetext(text, "\\u[GLOB.rus_unicode_conversion_hex[s]]", s)
	return json_decode(text)

#undef UPC
#undef PHC
#undef PHCH
#undef PBC