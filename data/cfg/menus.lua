-- Standard menu definitions
-- do not modify

-- Cubescript ugliness to replace
Console.binds.add("ESCAPE", [[
	CV:run("menu_key_click_trigger")
	if GUI.clear() ~= 1 then
		CV:run("save_mouse_pos") -- Useful for New Light GUI and so forth.
		GUI.show("main")
	end
]])

-- Main menu - has two forms, for logging into the master, or for entering an instance

function setup_main_menu()
	if EV.logged_into_master == 0 then
		GUI.new("main", [[
			GUI.button("log in...", [=[ show_login() ]=], "menu")
			GUI.bar()
			GUI.button("plugins...", [=[ GUI.show("plugins") ]=])
			GUI.button("options...", [=[ GUI.show("options") ]=])
			GUI.button("help...", [=[ GUI.show("help") ]=])
			GUI.button("quit", [=[ Engine.quit() ]=], "exit")
		]])
	end
	if EV.logged_into_master == 1 then
		GUI.new("main", [[
			if EV.have_master ~= 0 then
				GUI.button("^f2connect to lobby...^f~", "CV:run('connect_to_lobby')")
				GUI.bar()
				GUI.button("connect to selected...", "CV:run('connect_to_selected_instance')")
			end
			GUI.button("local connection...", "CV:run('connect 127.0.0.1 28787')")
			GUI.button("manual connection...", "GUI.show('manual_connect')")
			GUI.bar()
			GUI.button("plugins...", [=[ GUI.show("plugins") ]=])
			GUI.button("options...", [=[ GUI.show("options") ]=])
			GUI.button("special...", [=[ GUI.show("special") ]=])
			GUI.button("help...", [=[ GUI.show("help") ]=])
			GUI.button("quit", [=[ Engine.quit() ]=], "exit")
		]])
	end
end

function show_login()
	if EV.hashed_password ~= "" then
		EV.entered_password = '--------' -- 8 '-'s: means "use existing hashed password"
											  -- which we need if there was a password entered before
	end
	GUI.show("login")
end

GUI.new("login", [[
	GUI.text(string.format("master server: ^f2%s")) -- (get_config "Network" "master_server") TODO
	GUI.bar()
	GUI.list([=[
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
GUI.new("special", [[
	if EV.last_uploaded_map_asset ~= "" then
		GUI.button("repeat last map upload...", "CV:run('repeat_upload')")
	end
]])

-- Help
GUI.new("help", [[
	GUI.text("press Escape to exit a menu / go back")
	GUI.bar()
	GUI.text("some useful commands:")
	GUI.text("   M - toggle mouselook mode")
	GUI.text("   9 - toggle thirdperson mode")
	GUI.text("   mouse wheel - zoom in/out")
	GUI.bar()
	GUI.text("camera control vars:")
	GUI.text("   cameraheight, smoothcamera, cameraavoid")

	GUI.tab("about")
	GUI.text("CubeCreate - developer build")
	GUI.text("http://cubecreate.com")
	GUI.bar()
	GUI.text("Licensed under MIT/X11")
	GUI.text("(see README.txt and COPYING.txt)")
	GUI.bar()
	GUI.text("Thanks to Cube 2, Syntensity, Lua, SDL,")
	GUI.text("   Python, love2d, zlib")
]])

--[[// Login error

error_message ""

newgui error [
    guitext ( format "An error occurred: %1" $error_message )
] ]]

-- Options - split up into submenus for speed

function resbutton(w, h)
	GUI.button(
		string.format("%sx%s", w, h),
		string.format("CV:run('screenres %s %s')", w, h),
		(EV.scr_w == w and EV.scr_h == h) and "radio_on" or "radio_off"
	)
end

GUI.new("options", [[
	GUI.button("general", "GUI.show('general')")
	GUI.button("video",   "GUI.show('video')")
	GUI.button("audio",   "GUI.show('audio')")
	GUI.button("input",   "GUI.show('input')")
]])


GUI.new("plugins", [[
	CV:run("show_plugins")
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
