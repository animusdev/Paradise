//location of the rust-g library
#define RUST_G "rust_g"

// On Linux/Unix systems the line endings are LF, on windows it's CRLF, admins that don't use notepad++
// will get logs that are one big line if the system is Linux and they are using notepad.  This solves it by adding CR to every line ending
// in the logs.  ascii character 13 = CR

/var/global/log_end = world.system_type == UNIX ? ascii2text(13) : ""

#define DIRECT_OUTPUT(A, B) A << B
#define SEND_IMAGE(target, image) DIRECT_OUTPUT(target, image)
#define SEND_SOUND(target, sound) DIRECT_OUTPUT(target, sound)
#define SEND_TEXT(target, text) DIRECT_OUTPUT(target, text)
#define WRITE_FILE(file, text) DIRECT_OUTPUT(file, text)
#define WRITE_LOG(log, text) return 0//call(RUST_G, "log_write")(log, text)

/proc/error(msg)
	WRITE_FILE(GLOB.world_game_log, "\[[time_stamp()]]: ## ERROR: [msg]")

//print a warning message to world.log
#define WARNING(MSG) warning("[MSG] in [__FILE__] at line [__LINE__] src: [src] usr: [usr].")
/proc/warning(msg)
	WRITE_FILE(GLOB.world_game_log, "\[[time_stamp()]]: ## WARNING: [msg]")

//print a testing-mode debug message to world.log and world
#ifdef TESTING
#define testing(msg) log_world("## TESTING: [msg]"); to_chat(world, "## TESTING: [msg]")
#else
#define testing(msg)
#endif

/proc/log_admin(text)
	admin_log.Add(text)
	if(config.log_admin)
		WRITE_FILE(GLOB.world_game_log, "\[[time_stamp()]]: ADMIN: [text][log_end]")

/proc/log_debug(text)
	if(config.log_debug)
		WRITE_FILE(GLOB.world_game_log, "\[[time_stamp()]]: DEBUG: [text][log_end]")

	for(var/client/C in GLOB.admins)
		if(check_rights(R_DEBUG, 0, C.mob) && (C.prefs.toggles & CHAT_DEBUGLOGS))
			to_chat(C, "DEBUG: [text]")

/proc/log_game(text)
	if(config.log_game)
		WRITE_FILE(GLOB.world_game_log, "\[[time_stamp()]]: GAME: [text][log_end]")

/proc/log_vote(text)
	if(config.log_vote)
		WRITE_FILE(GLOB.world_game_log, "\[[time_stamp()]]: VOTE: [text][log_end]")

/proc/log_access_in(client/new_client)
	if(config.log_access)
		var/message = "[key_name(new_client)] - IP:[new_client.address] - CID:[new_client.computer_id] - BYOND v[new_client.byond_version]"
		WRITE_FILE(GLOB.world_game_log, "\[[time_stamp()]]: ACCESS IN: [message][log_end]")

/proc/log_access_out(mob/last_mob)
	if(config.log_access)
		var/message = "[key_name(last_mob)] - IP:[last_mob.lastKnownIP] - CID:[last_mob.computer_id] - BYOND Logged Out"
		WRITE_FILE(GLOB.world_game_log, "\[[time_stamp()]]: ACCESS OUT: [message][log_end]")

/proc/log_say(text, mob/speaker)
	if(config.log_say)
		WRITE_FILE(GLOB.world_game_log, "\[[time_stamp()]]: SAY: [speaker.simple_info_line()]: [rhtml_decode(text)][log_end]")

/proc/log_whisper(text, mob/speaker)
	if(config.log_whisper)
		WRITE_FILE(GLOB.world_game_log, "\[[time_stamp()]]: WHISPER: [speaker.simple_info_line()]: [rhtml_decode(text)][log_end]")

/proc/log_ooc(text, client/user)
	if(config.log_ooc)
		WRITE_FILE(GLOB.world_game_log, "\[[time_stamp()]]: OOC: [user.simple_info_line()]: [rhtml_decode(text)][log_end]")

/proc/log_aooc(text, client/user)
	if(config.log_ooc)
		WRITE_FILE(GLOB.world_game_log, "\[[time_stamp()]]: AOOC: [user.simple_info_line()]: [rhtml_decode(text)][log_end]")

/proc/log_looc(text, client/user)
	if(config.log_ooc)
		WRITE_FILE(GLOB.world_game_log, "\[[time_stamp()]]: LOOC: [user.simple_info_line()]: [rhtml_decode(text)][log_end]")

/proc/log_emote(text, mob/speaker)
	if(config.log_emote)
		WRITE_FILE(GLOB.world_game_log, "\[[time_stamp()]]: EMOTE: [speaker.simple_info_line()]: [rhtml_decode(text)][log_end]")

/proc/log_attack(attacker, defender, message)
	if(config.log_attack)
		WRITE_FILE(GLOB.world_game_log, "\[[time_stamp()]]: ATTACK: [attacker] against [defender]: [message][log_end]") //Seperate attack logs? Why?

/proc/log_adminsay(text, mob/speaker)
	if(config.log_adminchat)
		WRITE_FILE(GLOB.world_game_log, "\[[time_stamp()]]: ADMINSAY: [speaker.simple_info_line()]: [rhtml_decode(text)][log_end]")

/proc/log_qdel(text)
	WRITE_FILE(GLOB.world_qdel_log, "\[[time_stamp()]]: QDEL: [text]")

/proc/log_mentorsay(text, mob/speaker)
	if(config.log_adminchat)
		WRITE_FILE(GLOB.world_game_log, "\[[time_stamp()]]: MENTORSAY: [speaker.simple_info_line()]: [rhtml_decode(text)][log_end]")

/proc/log_ghostsay(text, mob/speaker)
	if(config.log_say)
		WRITE_FILE(GLOB.world_game_log, "\[[time_stamp()]]: DEADCHAT: [speaker.simple_info_line()]: [rhtml_decode(text)][log_end]")

/proc/log_ghostemote(text, mob/speaker)
	if(config.log_emote)
		WRITE_FILE(GLOB.world_game_log, "\[[time_stamp()]]: DEADEMOTE: [speaker.simple_info_line()]: [rhtml_decode(text)][log_end]")

/proc/log_adminwarn(text)
	if(config.log_adminwarn)
		WRITE_FILE(GLOB.world_game_log, "\[[time_stamp()]]: ADMINWARN: [rhtml_decode(text)][log_end]")

/proc/log_pda(text, mob/speaker)
	if(config.log_pda)
		WRITE_FILE(GLOB.world_game_log, "\[[time_stamp()]]: PDA: [speaker.simple_info_line()]: [rhtml_decode(text)][log_end]")

/proc/log_chat(text, mob/speaker)
	if(config.log_pda)
		WRITE_FILE(GLOB.world_game_log, "\[[time_stamp()]]: CHAT: [speaker.simple_info_line()] [rhtml_decode(text)][log_end]")

/proc/log_misc(text)
	WRITE_FILE(GLOB.world_game_log, "\[[time_stamp()]]: MISC: [text][log_end]")

/proc/log_world(text)
	SEND_TEXT(world.log, text)
	if(config && config.log_world_output)
		WRITE_FILE(GLOB.world_game_log, "\[[time_stamp()]]: WORLD: [rhtml_decode(text)][log_end]")

/proc/log_runtime_txt(text) // different from /tg/'s log_runtime because our error handler has a log_runtime proc already that does other stuff
	WRITE_FILE(GLOB.world_runtime_log, "\[[time_stamp()]]: [text]")

/proc/log_config(text)
	WRITE_FILE(GLOB.config_error_log, "\[[time_stamp()]]: [text]")
	SEND_TEXT(world.log, text)

/proc/log_href(text)
	WRITE_FILE(GLOB.world_href_log, "\[[time_stamp()]]: HREF: [rhtml_decode(text)]")

/proc/log_asset(text)
	WRITE_FILE(GLOB.world_asset_log, "\[[time_stamp()]]: ASSET: [text]")

/**
 * Standardized method for tracking startup times.
 */
/proc/log_startup_progress(var/message)
	to_chat(world, "<span class='danger'>[message]</span>")
	log_world(message)

// A logging proc that only outputs after setup is done, to
// help devs test initialization stuff that happens a lot
/proc/log_after_setup(var/message)
	if(SSticker && SSticker.current_state > GAME_STATE_SETTING_UP)
		to_chat(world, "<span class='danger'>[message]</span>")
		log_world(message)

/* For logging round startup. */
/proc/start_log(log)
	WRITE_FILE(log, "\[[time_stamp()]]: Starting up.\n-------------------------")

/* Close open log handles. This should be called as late as possible, and no logging should hapen after. */
/proc/shutdown_logging()
	//call(RUST_G, "log_close_all")()
	return 1

// Helper procs for building detailed log lines

/proc/datum_info_line(var/datum/d)
	if(!istype(d))
		return
	if(!istype(d, /mob))
		return "[d] ([d.type])"
	var/mob/m = d
	return "[m] ([m.ckey]) ([m.type])"

/proc/atom_loc_line(var/atom/a)
	if(!istype(a))
		return
	var/turf/t = get_turf(a)
	if(istype(t))
		return "[a.loc] ([t.x],[t.y],[t.z]) ([a.loc.type])"
	else if(a.loc)
		return "[a.loc] (0,0,0) ([a.loc.type])"

/mob/proc/simple_info_line()
	return "[key_name(src)] ([x],[y],[z])"

/client/proc/simple_info_line()
	return "[key_name(src)] ([mob.x],[mob.y],[mob.z])"

//this is only used here (for now)
#undef RUST_G
