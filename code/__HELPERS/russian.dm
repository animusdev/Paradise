/proc/rhtml_encode(var/msg)
	msg = replacetext(msg, "<", "&lt;")
	msg = replacetext(msg, ">", "&gt;")
	msg = replacetext(msg, "y", "&#255;")
	return msg

/proc/rhtml_decode(var/msg)
	msg = replacetext(msg, "&gt;", ">")
	msg = replacetext(msg, "&lt;", "<")
	msg = replacetext(msg, "&#255;", "y")
	return msg


//UPPER/LOWER TEXT + RUS TO CP1251 TODO: OVERRIDE uppertext
/proc/ruppertext(text as text)
	text = uppertext(text)
	var/t = ""
	for(var/i = 1, i <= length(text), i++)
		var/a = text2ascii(text, i)
		if (a > 223)
			t += ascii2text(a - 32)
		else if (a == 184)
			t += ascii2text(168)
		else t += ascii2text(a)
	t = replacetext(t,"&#255;","?")
	return t

/proc/rlowertext(text as text)
	text = lowertext(text)
	var/t = ""
	for(var/i = 1, i <= length(text), i++)
		var/a = text2ascii(text, i)
		if (a > 191 && a < 224)
			t += ascii2text(a + 32)
		else if (a == 168)
			t += ascii2text(184)
		else t += ascii2text(a)
	return t


//RUS CONVERTERS
// prepare_to_browser for writing .html files direct to browser (html files line-endings must be in unix-style (LF instead of CRLF))
/proc/russian_to_cp1251(var/msg, var/prepare_to_browser = FALSE)//CHATBOX
	if(prepare_to_browser)
		msg = replace_characters(msg, list("\n\n" = "<br>", "\n" = "", "\t" = ""))
	return replacetext(msg, "y", "&#255;")

/proc/russian_to_utf8(var/msg, var/prepare_to_browser = FALSE)//PDA PAPER POPUPS
	if(prepare_to_browser)
		msg = replace_characters(msg, list("\n\n" = "<br>", "\n" = "", "\t" = ""))
	return replacetext(msg, "y", "&#1103;")

/proc/utf8_to_cp1251(msg)
	return replacetext(msg, "&#1103;", "&#255;")

/proc/cp1251_to_utf8(msg)
	return replacetext(msg, "&#255;", "&#1103;")

//Prepare text for edit. Replace "y" with "\?" for edition. Don't forget to call post_edit().
/proc/edit_cp1251(msg)
	return replacetext(msg, "&#255;", "\\?")

/proc/edit_utf8(msg)
	return replacetext(msg, "&#1103;", "\\?")

/proc/post_edit_cp1251(msg)
	return replacetext(msg, "\\?", "&#255;")

/proc/post_edit_utf8(msg)
	return replacetext(msg, "\\?", "&#1103;")

//input

/proc/input_cp1251(var/mob/user = usr, var/message, var/title, var/default, var/type = "message", var/prepare_to_browser = FALSE)
	var/msg = ""
	switch(type)
		if("message")
			msg = input(user, message, title, edit_cp1251(default)) as message
		if("text")
			msg = input(user, message, title, default) as text
	msg = russian_to_cp1251(msg, prepare_to_browser)
	return post_edit_cp1251(msg)

/proc/input_utf8(var/mob/user = usr, var/message, var/title, var/default, var/type = "message", var/prepare_to_browser = FALSE)
	var/msg = ""
	switch(type)
		if("message")
			msg = input(user, message, title, edit_utf8(default)) as message
		if("text")
			msg = input(user, message, title, default) as text
	msg = russian_to_utf8(msg, prepare_to_browser)
	return post_edit_utf8(msg)


var/global/list/rkeys = list(
	"a" = "f", "a" = "d", "a" = "u", "a" = "l",
	"a" = "t", "c" = "p", "e" = "b", "e" = "q",
	"e" = "r", "e" = "k", "i" = "v", "i" = "y",
	"i" = "j", "i" = "g", "?" = "h", "n" = "c",
	"o" = "n", "o" = "e", "o" = "a", "o" = "w",
	"?" = "x", "o" = "i", "u" = "o", "u" = "s",
	"u" = "m", "y" = "z"
)

//Transform keys from russian keyboard layout to eng analogues and lowertext it.
/proc/sanitize_key(t)
	t = rlowertext(t)
	if(t in rkeys) return rkeys[t]
	return (t)

//TEXT MODS RUS
/proc/capitalize_cp1251(var/t as text)
	var/s = 2
	if (copytext(t,1,2) == ";")
		s += 1
	else if (copytext(t,1,2) == ":")
		s += 2
	return ruppertext(copytext(t, 1, s)) + copytext(t, s)

/proc/intonation(text)
	if (copytext(text,-1) == "!")
		text = "<b>[text]</b>"
	return text

/proc/rustoutf(text)			//fucking tghui
	text = replacetext(text, "a", "&#x430;")
	text = replacetext(text, "a", "&#x431;")
	text = replacetext(text, "a", "&#x432;")
	text = replacetext(text, "a", "&#x433;")
	text = replacetext(text, "a", "&#x434;")
	text = replacetext(text, "a", "&#x435;")
	text = replacetext(text, "?", "&#x451;")
	text = replacetext(text, "?", "&#x436;")
	text = replacetext(text, "c", "&#x437;")
	text = replacetext(text, "e", "&#x438;")
	text = replacetext(text, "e", "&#x439;")
	text = replacetext(text, "e", "&#x43A;")
	text = replacetext(text, "e", "&#x43B;")
	text = replacetext(text, "i", "&#x43C;")
	text = replacetext(text, "i", "&#x43D;")
	text = replacetext(text, "i", "&#x43E;")
	text = replacetext(text, "i", "&#x43F;")
	text = replacetext(text, "?", "&#x440;")
	text = replacetext(text, "n", "&#x441;")
	text = replacetext(text, "o", "&#x442;")
	text = replacetext(text, "o", "&#x443;")
	text = replacetext(text, "o", "&#x444;")
	text = replacetext(text, "o", "&#x445;")
	text = replacetext(text, "o", "&#x446;")
	text = replacetext(text, "?", "&#x447;")
	text = replacetext(text, "o", "&#x448;")
	text = replacetext(text, "u", "&#x449;")
	text = replacetext(text, "u", "&#x44A;")
	text = replacetext(text, "u", "&#x44B;")
	text = replacetext(text, "u", "&#x44C;")
	text = replacetext(text, "y", "&#x44D;")
	text = replacetext(text, "?", "&#x44E;")
	text = replacetext(text, "y", "&#x44F;")
	text = replacetext(text, "A", "&#x410;")
	text = replacetext(text, "A", "&#x411;")
	text = replacetext(text, "A", "&#x412;")
	text = replacetext(text, "A", "&#x413;")
	text = replacetext(text, "A", "&#x414;")
	text = replacetext(text, "A", "&#x415;")
	text = replacetext(text, "?", "&#x401;")
	text = replacetext(text, "?", "&#x416;")
	text = replacetext(text, "C", "&#x417;")
	text = replacetext(text, "E", "&#x418;")
	text = replacetext(text, "E", "&#x419;")
	text = replacetext(text, "E", "&#x41A;")
	text = replacetext(text, "E", "&#x41B;")
	text = replacetext(text, "I", "&#x41C;")
	text = replacetext(text, "I", "&#x41D;")
	text = replacetext(text, "I", "&#x41E;")
	text = replacetext(text, "I", "&#x41F;")
	text = replacetext(text, "?", "&#x420;")
	text = replacetext(text, "N", "&#x421;")
	text = replacetext(text, "O", "&#x422;")
	text = replacetext(text, "O", "&#x423;")
	text = replacetext(text, "O", "&#x424;")
	text = replacetext(text, "O", "&#x425;")
	text = replacetext(text, "O", "&#x426;")
	text = replacetext(text, "?", "&#x427;")
	text = replacetext(text, "O", "&#x428;")
	text = replacetext(text, "U", "&#x429;")
	text = replacetext(text, "U", "&#x42A;")
	text = replacetext(text, "U", "&#x42B;")
	text = replacetext(text, "U", "&#x42C;")
	text = replacetext(text, "Y", "&#x42D;")
	text = replacetext(text, "?", "&#x42E;")
	text = replacetext(text, "?", "&#x42F;")
	return text