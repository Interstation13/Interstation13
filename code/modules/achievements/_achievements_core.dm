//Defines for client.
/client
	var/datum/achievements/achievement_holder = null

//The achievement holder datum
/datum/achievements
	var/list/achievements = list()

/client/New()
	achievement_holder = new
	..()

//The actual achievements
/datum/achievement
	var/name = "Default Achievement"
	var/description = "Default Description"
	var/difficulty = DIFF_EASY
	var/announced = FALSE


/mob/proc/unlock_achievement(var/datum/achievement/A)// use is 	mob.unlock_achievement(new/datum/achievement/achievement())
	if(IsGuestKey(src.key))
		return
	if(ismob(src) && src.key && client)
		for(var/datum/achievement/AA in client.achievement_holder.achievements)
			if(A.name == AA.name)
				return
		client.achievement_holder.achievements |= A
		var/savefile/F = new /savefile("data/player_saves/[copytext(ckey, 1, 2)]/[ckey]/achievements.sav")
		client.achievement_holder.Write(F)
		var/H
		switch(A.difficulty)
			if (DIFF_MEDIUM)
				H = "#EE9A4D"
			if (DIFF_EASY)
				H = "green"
			if (DIFF_HARD)
				H = "red"
		if (A.announced)
			world << "<b>Achievement Unlocked! [src.key] unlocked the '<font color = [H]>[A.name]</font color>' achievement.</b></font>"
		else
			to_chat(src, "<b>Achievement Unlocked! You unlocked the '<font color = [H]>[A.name]</font color>' achievement.</b></font>")
		if(A.description)
			to_chat(src, "<i>[A.description]</i>")

/mob/verb/show_achievements()
	set name = "Show Achievements"
	set category = "OOC"

	if(!client)//How they check achievements without client? No idea. But I'm staying sane.
		return

	if(IsGuestKey(src.key))
		to_chat(src, "<b>Guests don't get achievements.</b>")
		return

	var/count = 0
	to_chat(src, "\n<b>Achievements:</b>\n")

	for(var/datum/achievement/A in client.achievement_holder.achievements)
		var/H
		count++
		switch(A.difficulty)
			if (DIFF_MEDIUM)
				H = "#EE9A4D"
			if (DIFF_EASY)
				H = "green"
			if (DIFF_HARD)
				H = "red"
		to_chat(src, "<b>[count]:<font color = [H]> [A.name]</font color></b></font>")
		if(A.description)
			to_chat(src, "<i>[A.description]</i>\n\n")
		else
			to_chat(src, "\n")
	if(count)
		to_chat(src, "---\n<b>TOTAL ACHIEVEMENTS: [count]</b>")