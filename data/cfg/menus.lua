-- Standard menu definitions
-- do not modify

-- Cubescript ugliness to replace
console.binds.add("ESCAPE", [[
	CAPI.menu_key_click_trigger()
	if gui.clear() ~= 1 then
		CAPI.save_mouse_pos() -- Useful for New Light GUI and so forth.
		gui.show("main")
	end
]])

-- Main menu - has two forms, for logging into the master, or for entering an instance

function setup_main_menu()
	if EV.logged_into_master == 0 then
		gui.new("main", [[
			gui.button("log in...", [=[ show_login() ]=], "menu")
			gui.bar()
			gui.button("plugins...", [=[ gui.show("plugins") ]=])
			gui.button("options...", [=[ gui.show("options") ]=])
			gui.button("help...", [=[ gui.show("help") ]=])
			gui.button("quit", [=[ engine.quit() ]=], "exit")
		]])
	end
	if EV.logged_into_master == 1 then
		gui.new("main", [[
			if EV.have_master ~= 0 then
				gui.button("^f2connect to lobby...^f~", "CV:run('connect_to_lobby')")
				gui.bar()
				gui.button("connect to selected...", "CV:run('connect_to_selected_instance')")
			end
			gui.button("local connection...", "CV:run('connect 127.0.0.1 28787')")
			gui.button("manual connection...", "gui.show('manual_connect')")
			gui.bar()
			gui.button("plugins...", [=[ gui.show("plugins") ]=])
			gui.button("options...", [=[ gui.show("options") ]=])
			gui.button("special...", [=[ gui.show("special") ]=])
			gui.button("help...", [=[ gui.show("help") ]=])
			gui.button("quit", [=[ engine.quit() ]=], "exit")
		]])
	end
end

function show_login()
	if EV.hashed_password ~= "" then
		EV.entered_password = '--------' -- 8 '-'s: means "use existing hashed password"
											  -- which we need if there was a password entered before
	end
	gui.show("login")
end

gui.new("login", [[
	gui.text(string.format("master server: ^f2%s")) -- (get_config "Network" "master_server") TODO
	gui.bar()
	gui.list([=[
	]=])
]])
--[[
newgui login [
    guitext (format "master server: ^f2%1" (get_config "Network" "master_server"))

    guibar

    guilist [
        newusername = (strreplace $entered_username "-" "@") // Need to swap @ with something else, or sauer will 'act' on it on load
        true_username $newusername // Can be sent to the server: contains the "@"
        guitext "username: "
        guifield newusername 30 [
            true_username $newusername // Can be sent to the server: contains the "@"
            entered_username (strreplace $newusername "@" "-")
        ]
    ]

    guilist [
        guitext "password: "
        newpassword = $entered_password
        guifield newpassword 24 [entered_password $newpassword] 1
    ]

    guibar

    guibutton "log in" [
        newpassword = "" // FIXME: do this elsewhere as well
        "do_login" $true_username $entered_password
    ]

    if ( (| (strcmp $entered_password "") (strcmp $entered_username "") ) ) [
        guibar
        guitext "^f2(you can create a free account at www.syntensity.com)"
    ]
]
]]

-- Special
gui.new("special", [[
	if EV.last_uploaded_map_asset ~= "" then
		gui.button("repeat last map upload...", "CV:run('repeat_upload')")
	end
]])

-- Help
gui.new("help", [[
	gui.text("press Escape to exit a menu / go back")
	gui.bar()
	gui.text("some useful commands:")
	gui.text("   M - toggle mouselook mode")
	gui.text("   9 - toggle thirdperson mode")
	gui.text("   mouse wheel - zoom in/out")
	gui.bar()
	gui.text("camera control vars:")
	gui.text("   cameraheight, smoothcamera, cameraavoid")

	gui.tab("about")
	gui.text("CubeCreate - developer build")
	gui.text("http://cubecreate.com")
	gui.bar()
	gui.text("Licensed under MIT/X11")
	gui.text("(see README.txt and COPYING.txt)")
	gui.bar()
	gui.text("Thanks to Cube 2, Syntensity, Lua, SDL,")
	gui.text("   Python, love2d, zlib")
]])

--[[// Login error

error_message ""

newgui error [
    guitext ( format "An error occurred: %1" $error_message )
] ]]

-- Options - split up into submenus for speed

function resbutton(w, h)
	gui.button(
		string.format("%sx%s", w, h),
		string.format("CV:run('screenres %s %s')", w, h),
		(EV.scr_w == w and EV.scr_h == h) and "radio_on" or "radio_off"
	)
end

gui.new("options", [[
	gui.button("general", "gui.show('general')")
	gui.button("video",   "gui.show('video')")
	gui.button("audio",   "gui.show('audio')")
	gui.button("input",   "gui.show('input')")
]])


gui.new("plugins", [[
	CAPI.show_plugins()
]])

setup_main_menu()
--[[
setup_main_menu = [
			guibutton "manual connection..." "showgui manual_connect"
			guibar
			if ( (& (= $can_edit 1) (isconnected)) ) [
				if (= (private_edit_mode) 0) [
					guibutton "request private edit mode..." "request_private_edit_mode"
				] [
					guitext "(in private edit mode)"
				]
				guibutton "restart map..." "showgui restart_map"
				guibutton "upload map..." "showgui upload"
				guibutton "editing commands..." "showgui editing"
				guibutton "export entities..." "showgui exportentities"
				guibar
			]
			guibutton "plugins..."		"showgui plugins"
]

setup_main_menu
]]
