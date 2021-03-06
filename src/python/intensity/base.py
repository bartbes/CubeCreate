
# Copyright 2010 Alon Zakai ('kripken'). All rights reserved.
# This file is part of Syntensity/the Intensity Engine, an open source project. See COPYING.txt for licensing.

"""
Some extremely basic things for our system. Among the first modules loaded, useful in
loading the others in fact.
"""

import os, sys, __main__, json, shutil


## Base module - foundational stuff

WINDOWS = sys.platform.find("win32") != -1 or sys.platform.find("win64") != -1 # ??? FIXME

LINUX = sys.platform.find("linux") != -1
OSX = sys.platform.find("darwin") != -1
BSD = sys.platform.find("bsd") != -1

UNIX = LINUX or OSX or BSD

assert(WINDOWS or UNIX)

#
# Version
#

INTENSITY_VERSION_STRING = '0.0.5'

def comparable_version(version_string):
    return tuple(map(int, version_string.split('.')))
INTENSITY_VERSION = comparable_version(INTENSITY_VERSION_STRING)

print "Intensity Engine version:", INTENSITY_VERSION_STRING

#def check_version(version_string, strict=True):
#    version = comparable_version(version_string)
#    if version == INTENSITY_VERSION: return True
#    return (not strict) and version > INTENSITY_VERSION


## Global constants
class Global:
    ## Read this to know if the current script is running on the client. Always the opposite of SERVER.
    CLIENT = None

    ## Read this to know if the current script is running on the server. Always the opposite of CLIENT.
    SERVER = None

    ## Called once on initialization, to mark the running instance as a client. Sets SERVER, CLIENT.
    @staticmethod
    def init_as_client():
        Global.CLIENT = True
        Global.SERVER = False

    ## Called once on initialization, to mark the running instance as a server. Sets SERVER, CLIENT.
    @staticmethod
    def init_as_server():
        Global.SERVER = True
        Global.CLIENT = False

#
# Directory stuff
#

## Directory where our python scripts and modules reside
PYTHON_SCRIPT_DIR = os.path.join("src", "python", "intensity")


HOME_SUBDIR = None

def set_home_dir(home_dir):
    print "Set home dir:", home_dir
    global HOME_SUBDIR
    HOME_SUBDIR = home_dir

## The subdirectory under the user's home directory which we use.
def get_home_subdir():
    global HOME_SUBDIR

    if Global.CLIENT:
        suffix = "client"
    else:
        # If no home dir is given, the default for the server is to share it with the client
        suffix = "server" if HOME_SUBDIR is not None else 'client'

    # Use default value if none given to us
    if HOME_SUBDIR is None:
        if UNIX:
            HOME_SUBDIR = os.path.join( os.path.expanduser('~'), '.cubecreate_'+suffix )
        elif WINDOWS:
            HOME_SUBDIR = os.path.join( os.path.expanduser('~'), 'cubecreate_'+suffix )
        else:
            print "Error: Not sure where to set the home directory for this platform,", sys.platform
            raise Exception
        print 'Home dir:', HOME_SUBDIR

    # Ensure it exists.
    if not os.path.exists(HOME_SUBDIR):
        os.makedirs(HOME_SUBDIR)

    return HOME_SUBDIR


## The subdirectory name (single name) under home
def get_asset_subdir():
    return 'data'

## The directory to which the client saves assets
def get_asset_dir():
    ASSET_DIR = os.path.join( get_home_subdir(), get_asset_subdir() )

    # Ensure it exists.
    if not os.path.exists(ASSET_DIR):
        # Populate with initial content. This moves some archive assets into the right place, so
        # that they can then be unzipped as necessary
        initial_packages = os.path.join('data', 'initial_packages')
        if os.path.exists(initial_packages):
            print 'Populating with initial packages'
            shutil.copytree(initial_packages, ASSET_DIR)
        else:
            # No initial data, so just make the directory
            os.makedirs(ASSET_DIR)

    return ASSET_DIR

## The directory to which the client saves assets
def get_map_dir():
    MAP_DIR = os.path.join( get_asset_dir(), 'base' )

    # Ensure it exists. Done only if we are called (the server doesn't call us)
    if not os.path.exists(MAP_DIR):
        os.makedirs(MAP_DIR)

    return MAP_DIR


## Returns the short path to an asset. If we get e.g. /home/X/intensityengine/data/base/somemap.ogz,
## then we return base/somemap.ogz, i.e., the path under /data. This short path can then be used
## to know where to play an asset on the client, under the client's home subdir.
## A shortpath does not include '/data'. Thus, you can concatenate a shortpath to the asset_dir
## returned in get_asset_dir to get a real path.
def get_asset_shortpath(path):
    ret = []
    elements = path.split(os.path.sep)
    while elements[-1] != 'data':
        ret = [elements[-1]] + ret
        elements = elements[:-1]
    return os.path.join(ret)


## Where user scripts (not part of the core engine) reside
PYTHON_USER_SCRIPT_DIR = os.path.join("src", "python", "user")


## Run a user script, in the directory PYTHON_USER_SCRIPT_DIR
def run_user_script(name):
    execfile( os.path.join(PYTHON_USER_SCRIPT_DIR, name), __main__.__dict__, __main__.__dict__ )


#
# Config file stuff
#

## Start using a persistent config file. The server and client use different ones (although, for now,
## they use the same template). Config files have the common form of "[Section] option = value", see
## the actual files for more.
## @param path The path to the config file to use
## @param template A file with default parameters, to be used if there isn't yet a config file at
## the location specified by 'path'. This occurs the first time we run.
def init_config(path, template):
    global CONFIG_FILE
    CONFIG_FILE = path

    if not os.path.exists(os.path.dirname(CONFIG_FILE)): # Create settings file's directory, if needed
        os.mkdir(os.path.dirname(CONFIG_FILE))

    if not os.path.exists(CONFIG_FILE): # Create settings file, if none exists yet
        shutil.copyfile( template, CONFIG_FILE )
        print "CONFIG FILE: created a new from template"

    config_file = open(CONFIG_FILE);
    global configFile
    configFile = json.loads(config_file.read())
    config_file.close();

    # Apply changes based on commandline options
    MARKER = '-config:'
    for arg in sys.argv:
        if arg[:len(MARKER)] == MARKER:
            arg = arg[len(MARKER):]
            section, option, value = arg.split(':')
            set_config(section, option, value)

## Write out config options - safely
def save_config():
    global CONFIG_FILE
    config_file = open(CONFIG_FILE, 'w')
    config_file.write(json.dumps(configFile, sort_keys=True, indent=4))
    config_file.flush()
    os.fsync(config_file.fileno())
    config_file.close()

## Get a value from our persistent config file.
## @param section The section (in form [Section] in the file) where to look.
## @param option The particular option, or key, whose value we want to look up.
## @param default The default value to return if there is no value for that section/option combination.
def get_config(section, option, default):
    try:
        return configFile[section][option]
    except:
        return default

## Set a value in our persistent config file.
## @param section The section (in form [Section] in the file) where to work. The section is created if it doesn't exist.
## @param option The particular option, or key, whose value we want to set. The option is replaced if existent, or otherwise it is
## created.
## @param value The value to set for that section/option combination.
def set_config(section, option, value):
    if not section in configFile:
        configFile[section] = {}
    try:
        configFile[section][option].append(value)
    except:
        configFile[section][option] = value
    # TODO: Save the config file at this point?
    return configFile[section][option]


### Components

## Loads the components in [Components]list. They should be normal python
## import paths, e.g., list=intensity.components.example_component,some.other.component
def load_components():
    components = get_config('Components', 'list', '')

    # Load additional commandline-specific components
    MARKER = '-component:'
    for arg in sys.argv:
        if arg[:len(MARKER)] == MARKER:
            component = arg[len(MARKER):]
            if component not in components:
                components.append(component)

    print "Loading components...", components
    for component in components:
        if component == '': continue
        print "Loading component '%s'..." % component
        __import__(component, level=1)


### Action queues

from intensity.safe_actionqueue import *

## Action queue for stuff to be done in the main thread
main_actionqueue = SafeActionQueue()

## Action queue for stuff to be done in a parallel thread
side_actionqueue = SafeActionQueue()
side_actionqueue.main_loop()


#
# Quitting system
#

_should_quit = False

## Notifies us to quit. Sauer checks should_quit, and quits if set to true
def quit():
    global _should_quit
    _should_quit = True

## @return Whether quitting has been called, and we should shut down.
def should_quit():
    global _should_quit
    return _should_quit


