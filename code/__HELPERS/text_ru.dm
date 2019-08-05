#define UPC "ÿ"
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
	"À" = "1040", "à" = "1072",
	"Á" = "1041", "á" = "1073",
	"Â" = "1042", "â" = "1074",
	"Ã" = "1043", "ã" = "1075",
	"Ä" = "1044", "ä" = "1076",
	"Å" = "1045", "å" = "1077",
	"Æ" = "1046", "æ" = "1078",
	"Ç" = "1047", "ç" = "1079",
	"È" = "1048", "è" = "1080",
	"É" = "1049", "é" = "1081",
	"Ê" = "1050", "ê" = "1082",
	"Ë" = "1051", "ë" = "1083",
	"Ì" = "1052", "ì" = "1084",
	"Í" = "1053", "í" = "1085",
	"Î" = "1054", "î" = "1086",
	"Ï" = "1055", "ï" = "1087",
	"Ð" = "1056", "ð" = "1088",
	"Ñ" = "1057", "ñ" = "1089",
	"Ò" = "1058", "ò" = "1090",
	"Ó" = "1059", "ó" = "1091",
	"Ô" = "1060", "ô" = "1092",
	"Õ" = "1061", "õ" = "1093",
	"Ö" = "1062", "ö" = "1094",
	"×" = "1063", "÷" = "1095",
	"Ø" = "1064", "ø" = "1096",
	"Ù" = "1065", "ù" = "1097",
	"Ú" = "1066", "ú" = "1098",
	"Û" = "1067", "û" = "1099",
	"Ü" = "1068", "ü" = "1100",
	"Ý" = "1069", "ý" = "1101",
	"Þ" = "1070", "þ" = "1102",
	"ß" = "1071", "ÿ" = "1103",

	"¨" = "1025", "¸" = "1105"
	))

GLOBAL_LIST_INIT(rus_unicode_conversion_hex,list(
	"À" = "0410", "à" = "0430",
	"Á" = "0411", "á" = "0431",
	"Â" = "0412", "â" = "0432",
	"Ã" = "0413", "ã" = "0433",
	"Ä" = "0414", "ä" = "0434",
	"Å" = "0415", "å" = "0435",
	"Æ" = "0416", "æ" = "0436",
	"Ç" = "0417", "ç" = "0437",
	"È" = "0418", "è" = "0438",
	"É" = "0419", "é" = "0439",
	"Ê" = "041a", "ê" = "043a",
	"Ë" = "041b", "ë" = "043b",
	"Ì" = "041c", "ì" = "043c",
	"Í" = "041d", "í" = "043d",
	"Î" = "041e", "î" = "043e",
	"Ï" = "041f", "ï" = "043f",
	"Ð" = "0420", "ð" = "0440",
	"Ñ" = "0421", "ñ" = "0441",
	"Ò" = "0422", "ò" = "0442",
	"Ó" = "0423", "ó" = "0443",
	"Ô" = "0424", "ô" = "0444",
	"Õ" = "0425", "õ" = "0445",
	"Ö" = "0426", "ö" = "0446",
	"×" = "0427", "÷" = "0447",
	"Ø" = "0428", "ø" = "0448",
	"Ù" = "0429", "ù" = "0449",
	"Ú" = "042a", "ú" = "044a",
	"Û" = "042b", "û" = "044b",
	"Ü" = "042c", "ü" = "044c",
	"Ý" = "042d", "ý" = "044d",
	"Þ" = "042e", "þ" = "044e",
	"ß" = "042f", "ÿ" = "044f",

	"¨" = "0401", "¸" = "0451"
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
	if(!GLOB.rus_unicode_fix) // Ãåíåðèðóåì òàáèëöó çàìåíû
		GLOB.rus_unicode_fix = list()
		for(var/s in GLOB.rus_unicode_conversion_hex)
			if(s == UPC) // UPC breaks json_encode, so here is workaround
				GLOB.rus_unicode_fix[PHC] = "\\u[GLOB.rus_unicode_conversion_hex[s]]"
				continue

			GLOB.rus_unicode_fix[copytext(json_encode(s), 2, -1)] = "\\u[GLOB.rus_unicode_conversion_hex[s]]"

	//sanitize_russian_list(json_data) //ÿ òóïîé è íå ïîíèìàþ ñìûñëà ýòîãî ôèêñà
	var/json = json_encode(json_data)

	for(var/s in GLOB.rus_unicode_fix)
		json = replacetext(json, s, GLOB.rus_unicode_fix[s])

	return json

/proc/r_json_decode(text) //now I'm stupid
	for(var/s in GLOB.rus_unicode_conversion_hex)
		if (s == "ÿ")
			text = replacetext(text, "\\u[GLOB.rus_unicode_conversion_hex[s]]", "&#255;")
		text = replacetext(text, "\\u[GLOB.rus_unicode_conversion_hex[s]]", s)
	return json_decode(text)

#undef UPC
#undef PHC
#undef PHCH
#undef PBC
