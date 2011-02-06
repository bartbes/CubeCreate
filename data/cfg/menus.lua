-- Standard menu definitions
-- do not modify

-- Cubescript ugliness to replace
cc.console.binds.add("ESCAPE", [[
	cc.gui.menu_key_click_trigger()
	if cc.gui.clear() ~= 1 then
		CAPI.save_mouse_pos() -- Useful for New Light GUI and so forth.
		cc.gui.show("main")
	end
]])

-- Main menu - has two forms, for logging into the master, or for entering an instance

function setup_main_menu()
	if logged_into_master == 0 then
		cc.gui.new("main", [[
			cc.gui.button("log in...", [=[ show_login() ]=], "menu")
			cc.gui.bar()
			cc.gui.button("plugins...", [=[ cc.gui.show("plugins") ]=])
			cc.gui.button("options...", [=[ cc.gui.show("options") ]=])
			cc.gui.button("help...", [=[ cc.gui.show("help") ]=])
			cc.gui.button("quit", [=[ engine.quit() ]=], "exit")
		]])
	end
	if logged_into_master == 1 then
		cc.gui.new("main", [[
			if have_master ~= 0 then
				cc.gui.button("^f2connect to lobby...^f~", "CV:run('connect_to_lobby')")
				cc.gui.bar()
				cc.gui.button("connect to selected...", "CV:run('connect_to_selected_instance')")
			end
			cc.gui.button("local connection...", "CV:run('connect 127.0.0.1 28787')")
			cc.gui.button("manual connection...", "cc.gui.show('manual_connect')")
			cc.gui.bar()
			cc.gui.button("plugins...", [=[ cc.gui.show("plugins") ]=])
			cc.gui.button("options...", [=[ cc.gui.show("options") ]=])
			cc.gui.button("special...", [=[ cc.gui.show("special") ]=])
			cc.gui.button("help...", [=[ cc.gui.show("help") ]=])
			cc.gui.button("quit", [=[ engine.quit() ]=], "exit")
		]])
	end
end

function show_login()
	if hashed_password ~= "" then
		entered_password = '--------' -- 8 '-'s: means "use existing hashed password"
											  -- which we need if there was a password entered before
	end
	cc.gui.show("login")
end

cc.gui.new("login", [[
	cc.gui.text(string.format("master server: ^f2%s")) -- (get_config "Network" "master_server") TODO
	cc.gui.bar()
	cc.gui.list([=[
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
cc.gui.new("special", [[
	if last_uploaded_map_asset ~= "" then
		cc.gui.button("repeat last map upload...", "CV:run('repeat_upload')")
	end
]])

-- Help
cc.gui.new("help", [[
	cc.gui.text("press Escape to exit a menu / go back")
	cc.gui.bar()
	cc.gui.text("some useful commands:")
	cc.gui.text("   M - toggle mouselook mode")
	cc.gui.text("   9 - toggle thirdperson mode")
	cc.gui.text("   mouse wheel - zoom in/out")
	cc.gui.bar()
	cc.gui.text("camera control vars:")
	cc.gui.text("   cameraheight, smoothcamera, cameraavoid")

	cc.gui.tab("about")
	cc.gui.text("CubeCreate - developer build")
	cc.gui.text("http://cubecreate.com")
	cc.gui.bar()
	cc.gui.text("Licensed under MIT/X11")
	cc.gui.text("(see README.txt and COPYING.txt)")
	cc.gui.bar()
	cc.gui.text("Thanks to Cube 2, Syntensity, Lua, SDL,")
	cc.gui.text("   Python, love2d, zlib")
]])

--[[// Login error

error_message ""

newgui error [
    guitext ( format "An error occurred: %1" $error_message )
] ]]

-- Options - split up into submenus for speed

function resbutton(w, h)
	cc.gui.button(
		string.format("%sx%s", w, h),
		string.format("CV:run('screenres %s %s')", w, h),
		(scr_w == w and scr_h == h) and "radio_on" or "radio_off"
	)
end

cc.gui.new("options", [[
	cc.gui.button("general", "cc.gui.show('general')")
	cc.gui.button("video",   "cc.gui.show('video')")
	cc.gui.button("audio",   "cc.gui.show('audio')")
	cc.gui.button("input",   "cc.gui.show('input')")
]])


cc.gui.new("plugins", [[
	cc.gui.show_plugins()
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
