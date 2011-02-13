-- Standard menu definitions

cc.console.binds.add("ESCAPE", [[
    cc.gui.menu_key_click_trigger()
    if cc.gui.clear() ~= 1 then
        cc.console.save_mouse_pos() -- Useful for New Light GUI and so forth.
        cc.gui.show("main")
    end
]])

-- Main menu

function setup_main_menu()
    cc.gui.new("main", [[
        cc.gui.text("Welcome to CubeCreate development release. (1)")
        cc.gui.bar()
        cc.gui.show_plugins()
        cc.gui.text("Credits: Cube 2, Syntensity, Love, Lua, SDL, Python, zlib.")
        cc.gui.text("Licensed under MIT/X11.")
        cc.gui.bar()
        cc.gui.list([=[
            cc.gui.text("mini-console: ")
            cc.gui.field("minicon_entry", 36)
            cc.gui.bar()
            cc.gui.button("exec", [==[if minicon_entry then loadstring(minicon_entry)() end]==])
        ]=])
        cc.gui.bar()
        cc.gui.button("quit", [=[ engine.quit() ]=], "exit")
    ]])
end

setup_main_menu()
