//HUD styles.  Index order defines how they are cycled in F12.
/// Standard hud
#define HUD_STYLE_STANDARD 1
/// Reduced hud (just hands and intent switcher)
#define HUD_STYLE_REDUCED 2
/// No hud (for screenshots)
#define HUD_STYLE_NOHUD 3

/// Used in show_hud(); Please ensure this is the same as the maximum index.
#define HUD_VERSIONS 3

// Consider these images/atoms as part of the UI/HUD (apart of the appearance_flags)
/// Used for progress bars and chat messages
#define APPEARANCE_UI_IGNORE_ALPHA (RESET_COLOR|RESET_TRANSFORM|NO_CLIENT_COLOR|RESET_ALPHA|PIXEL_SCALE|TILE_BOUND) // monkestation edit
/// Used for HUD objects
#define APPEARANCE_UI (RESET_COLOR|RESET_TRANSFORM|NO_CLIENT_COLOR|PIXEL_SCALE|TILE_BOUND) // monkestation edit

/*
	These defines specificy screen locations.  For more information, see the byond documentation on the screen_loc var.

	The short version:

	Everything is encoded as strings because apparently that's how Byond rolls.

	"1,1" is the bottom left square of the user's screen.  This aligns perfectly with the turf grid.
	"1:2,3:4" is the square (1,3) with pixel offsets (+2, +4); slightly right and slightly above the turf grid.
	Pixel offsets are used so you don't perfectly hide the turf under them, that would be crappy.

	In addition, the keywords NORTH, SOUTH, EAST, WEST and CENTER can be used to represent their respective
	screen borders. NORTH-1, for example, is the row just below the upper edge. Useful if you want your
	UI to scale with screen size.

	The size of the user's screen is defined by client.view (indirectly by world.view), in our case "15x15".
	Therefore, the top right corner (except during admin shenanigans) is at "15,15"
*/

/proc/ui_hand_position(i) //values based on old hand ui positions (CENTER:-/+16,SOUTH:10)
	var/x_off = i % 2 ? 0 : -1
	var/y_off = round((i-1) / 2)
	return"CENTER+[x_off]:16,SOUTH+[y_off]:5"

/proc/ui_equip_position(mob/M)
	var/y_off = round((M.held_items.len-1) / 2) //values based on old equip ui position (CENTER: +/-16,SOUTH+1:5)
	return "CENTER:-16,SOUTH+[y_off+1]:5"

/proc/ui_swaphand_position(mob/M, which = 1) //values based on old swaphand ui positions (CENTER: +/-16,SOUTH+1:5)
	var/x_off = which == 1 ? -1 : 0
	var/y_off = round((M.held_items.len-1) / 2)
	return "CENTER+[x_off]:16,SOUTH+[y_off+1]:5"

//Lower left, persistent menu
#define ui_inventory "WEST:6,SOUTH:10"

//Middle left indicators
#define ui_lingchemdisplay "WEST,CENTER-1:30"
#define ui_lingstingdisplay "WEST:12,CENTER-3:22"

//Lower center, persistent menu
#define ui_sstore1 "CENTER-5:20,SOUTH:10"
#define ui_id "CENTER-4:24,SOUTH:10"
#define ui_belt "CENTER-3:28,SOUTH:10"
#define ui_back "CENTER-2:28,SOUTH:10"
#define ui_storage1 "CENTER+1:36,SOUTH:10"
#define ui_storage2 "CENTER+2:40,SOUTH:10"
#define ui_combo "CENTER+4:48,SOUTH+1:14" //combo meter for martial arts

//Lower right, persistent menu
#define ui_drop_throw "EAST-1:56,SOUTH+1:14"
#define ui_above_movement "EAST-2:52,SOUTH+1:14"
#define ui_above_intent "EAST-3:48, SOUTH+1:14"
#define ui_movi "EAST-2:52,SOUTH:10"
#define ui_acti "EAST-3:48,SOUTH:10"
#define ui_combat_toggle "EAST-3:48,SOUTH:10"
#define ui_zonesel "EAST-1:56,SOUTH:10"
#define ui_acti_alt "EAST-1:56,SOUTH:10" //alternative intent switcher for when the interface is hidden (F12)
#define ui_crafting "EAST-4:44,SOUTH:10"
#define ui_building "EAST-4:44,SOUTH:42"
#define ui_language_menu "EAST-4:24,SOUTH:42"
#define ui_navigate_menu "EAST-4:24,SOUTH:10"

//Upper-middle right (alerts)
#define ui_alert1 "EAST-1:56,CENTER+5:54"
#define ui_alert2 "EAST-1:56,CENTER+4:50"
#define ui_alert3 "EAST-1:56,CENTER+3:46"
#define ui_alert4 "EAST-1:56,CENTER+2:42"
#define ui_alert5 "EAST-1:56,CENTER+1:38"

//Upper left (action buttons)
#define ui_action_palette "WEST+0:46,NORTH-1:10"
#define ui_action_palette_offset(north_offset) ("WEST+0:23,NORTH-[1+north_offset]:5")

#define ui_palette_scroll "WEST+1:16,NORTH-6:56"
#define ui_palette_scroll_offset(north_offset) ("WEST+1:8,NORTH-[6+north_offset]:28")

//Middle right (status indicators)
#define ui_healthdoll "EAST-1:56,CENTER-2:34"
#define ui_health "EAST-1:56,CENTER-1:38"
#define ui_internal "EAST-1:56,CENTER+1:42"
#define ui_mood "EAST-1:56,CENTER:42"
#define ui_spacesuit "EAST-1:56,CENTER-4:28"
#define ui_stamina "EAST-1:56,CENTER-3:28"

//Pop-up inventory
#define ui_shoes "WEST+1:16,SOUTH:10"
#define ui_iclothing "WEST:12,SOUTH+1:14"
#define ui_oclothing "WEST+1:16,SOUTH+1:14"
#define ui_gloves "WEST+2:20,SOUTH+1:14"
#define ui_glasses "WEST:12,SOUTH+3:22"
#define ui_mask "WEST+1:16,SOUTH+2:18"
#define ui_ears "WEST+2:20,SOUTH+2:18"
#define ui_neck "WEST:12,SOUTH+2:18"
#define ui_head "WEST+1:16,SOUTH+3:22"

//Generic living
#define ui_living_pull "EAST-1:56,CENTER-3:30"
#define ui_living_healthdoll "EAST-1:56,CENTER-1:30"

//Monkeys
#define ui_monkey_head "CENTER-5:26,SOUTH:10"
#define ui_monkey_mask "CENTER-4:28,SOUTH:10"
#define ui_monkey_neck "CENTER-3:30,SOUTH:10"
#define ui_monkey_back "CENTER-2:32,SOUTH:10"

//Drones
#define ui_drone_drop "CENTER+1:36,SOUTH:10"
#define ui_drone_pull "CENTER+2:4,SOUTH:10"
#define ui_drone_storage "CENTER-2:28,SOUTH:10"
#define ui_drone_head "CENTER-3:28,SOUTH:10"

//Cyborgs
#define ui_borg_health "EAST-1:56,CENTER-1:30"
#define ui_borg_pull "EAST-2:52,SOUTH+1:14"
#define ui_borg_radio "EAST-1:56,SOUTH+1:14"
#define ui_borg_intents "EAST-2:52,SOUTH:10"
#define ui_borg_lamp "CENTER-3:32, SOUTH:10"
#define ui_borg_tablet "CENTER-4:32, SOUTH:10"
#define ui_inv1 "CENTER-2:32,SOUTH:10"
#define ui_inv2 "CENTER-1 :32,SOUTH:10"
#define ui_inv3 "CENTER :32,SOUTH:10"
#define ui_borg_module "CENTER+1:32,SOUTH:10"
#define ui_borg_store "CENTER+2:32,SOUTH:10"
#define ui_borg_camera "CENTER+3:42,SOUTH:10"
#define ui_borg_alerts "CENTER+4:42,SOUTH:10"
#define ui_borg_language_menu "CENTER+4:38,SOUTH+1:12"
#define ui_borg_navigate_menu "CENTER+4:38,SOUTH+1:12"

//Aliens
#define ui_alien_health "EAST,CENTER-1:30"
#define ui_alienplasmadisplay "EAST,CENTER-2:30"
#define ui_alien_queen_finder "EAST,CENTER-3:30"
#define ui_alien_storage_r "CENTER+1:36,SOUTH:10"
#define ui_alien_language_menu "EAST-4:40,SOUTH:10"
#define ui_alien_navigate_menu "EAST-4:40,SOUTH:10"

//AI
#define ui_ai_core "BOTTOM:12,RIGHT-8"
#define ui_ai_shuttle "BOTTOM:12,RIGHT-6"
#define ui_ai_announcement "BOTTOM:12,RIGHT-4"
#define ui_ai_state_laws "BOTTOM:12,RIGHT-2"
#define ui_ai_mod_int "BOTTOM:12,RIGHT"
#define ui_ai_language_menu "BOTTOM+1:16,RIGHT-1:60"

#define ui_ai_crew_monitor "BOTTOM:12,CENTER-2"
#define ui_ai_crew_manifest "BOTTOM:12,CENTER"
#define ui_ai_alerts "BOTTOM:12,CENTER+2"

#define ui_ai_view_images "BOTTOM:12,LEFT+8"
#define ui_ai_camera_list "BOTTOM:12,LEFT+6"
#define ui_ai_track_with_camera "BOTTOM:12,LEFT+4"
#define ui_ai_camera_light "BOTTOM:12,LEFT+2"
#define ui_ai_sensor "BOTTOM:12,LEFT"
#define ui_ai_multicam "BOTTOM+1:12,LEFT+2"
#define ui_ai_add_multicam "BOTTOM+1:12,LEFT"
#define ui_ai_take_picture "BOTTOM+2:12,LEFT"


//pAI
#define ui_pai_software "SOUTH:12,WEST"
#define ui_pai_shell "SOUTH:12,WEST+2"
#define ui_pai_chassis "SOUTH:12,WEST+4"
#define ui_pai_rest "SOUTH:12,WEST+6"
#define ui_pai_light "SOUTH:12,WEST+8"
#define ui_pai_state_laws "SOUTH:12,WEST+10"
#define ui_pai_crew_manifest "SOUTH:12,WEST+12"
#define ui_pai_host_monitor "SOUTH:12,WEST+14"
#define ui_pai_internal_gps "SOUTH:12,WEST+16"
#define ui_pai_mod_int "SOUTH:12,WEST+18"
#define ui_pai_newscaster "SOUTH:12,WEST+20"
#define ui_pai_take_picture "SOUTH:12,WEST+22"
#define ui_pai_view_images "SOUTH:12,WEST+24"
#define ui_pai_radio "SOUTH:12,WEST+26"
#define ui_pai_language_menu "SOUTH+1:16,WEST+12:62"
#define ui_pai_navigate_menu "SOUTH+1:16,WEST+12:62"

//Ghosts
#define ui_ghost_spawners_menu "SOUTH:12,CENTER-3:48"
#define ui_ghost_orbit "SOUTH:12,CENTER-2:48"
#define ui_ghost_reenter_corpse "SOUTH:12,CENTER-1:48"
#define ui_ghost_teleport "SOUTH:12,CENTER:48"
#define ui_ghost_pai "SOUTH: 12, CENTER+1:48"
#define ui_ghost_minigames "SOUTH: 12, CENTER+2:48"
#define ui_ghost_language_menu "SOUTH: 44, CENTER+3:16"

//Team finder

#define ui_team_finder "CENTER,CENTER"

//Blobbernauts
#define ui_blobbernaut_overmind_health "EAST-1:56,CENTER+0:38"

// Defines relating to action button positions

/// Whatever the base action datum thinks is best
#define SCRN_OBJ_DEFAULT "default"
/// Floating somewhere on the hud, not in any predefined place
#define SCRN_OBJ_FLOATING "floating"
/// In the list of buttons stored at the top of the screen
#define SCRN_OBJ_IN_LIST "list"
/// In the collapseable palette
#define SCRN_OBJ_IN_PALETTE "palette"
///Inserted first in the list
#define SCRN_OBJ_INSERT_FIRST "first"

// Plane group keys, used to group swaths of plane masters that need to appear in subwindows
/// The primary group, holds everything on the main window
#define PLANE_GROUP_MAIN "main"
/// A secondary group, used when a client views a generic window
#define PLANE_GROUP_POPUP_WINDOW(screen) "popup-[REF(screen)]"

/// The filter name for the hover outline
#define HOVER_OUTLINE_FILTER "hover_outline"
