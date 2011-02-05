-- Provides Global table, setting if we're client, server or whatever, also provides defaultValue.

Global = {
    -- Read this to know if the current script is running on the client. Always the opposite of SERVER.
    CLIENT = false,
    -- Read this to know if the current script is running on the server. Always the opposite of CLIENT.
    SERVER = false,
    -- Called once on initialization, to mark the running instance as a client. Sets SERVER, CLIENT.
    initAsClient = function(self)
        self.CLIENT = true;
        self.SERVER = false;
    end,
    -- Called once on initialization, to mark the running instance as a server. Sets SERVER, CLIENT.
    initAsServer = function(self)
        self.SERVER = true;
        self.CLIENT = false;
    end
}

-- Small convenience function, useful for default values for functions
function defaultValue(value, def)
    if value == nil then
        return def
    else
        return value
    end
end
