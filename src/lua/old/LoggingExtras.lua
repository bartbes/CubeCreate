-------------------------------------------------------------------------------
-- Logging extras for CubeCreate.
-- Globalizes log function and its levels.
-- Licensed under MIT/X11 (see the COPYING.txt).
--
-- @author q66 (quaker66@gmail.com)
--
-- @copyright 2010 CubeCreate project
-------------------------------------------------------------------------------

--- Logs a message into C++ logging system.<br/>
-- There are several logging levels:<br/><br/>
-- <strong>ERROR</strong> - Logs message as error, prints into console.<br/>
-- <strong>WARNING</strong> - Logs message as warning, prints into terminal.<br/>
-- <strong>DEBUG</strong> - Logs message as debug, doesn't print into terminal unless you've got your loglevel set to DEBUG.<br/>
-- <strong>INFO</strong> - Use this when you want to log a message repeating i.e. every frame.<br/>
-- @param level The logging level to use for the message
-- @param message The message itself. Use string.format if you want to format it.
-- @class function
-- @name log
log = Logging.log

INFO = Logging.INFO
DEBUG = Logging.DEBUG
WARNING = Logging.WARNING
ERROR = Logging.ERROR

--- Prints something into console.<br/>
-- Useful for printing various console messages, like reports: Unlike logging, this has no level.<br/><br/>
-- @param message The message. Use string.format if you want to format it.
-- @class function
-- @name echo
echo = Logging.echo

echo("Test message")
