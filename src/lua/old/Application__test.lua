log(DEBUG, "---- APPLICATION TEST BEGIN ----")

local save = ApplicationManager.instance

local ApplicationTest = class(Application)
ApplicationManager.setApplicationClass(ApplicationTest)
assert(is_a(ApplicationManager.instance, ApplicationTest))

ApplicationManager.instance = save

assert(type(ApplicationManager.instance.performClick) == "function")
assert(ApplicationManager.instance:getPcClass() == "Player")

-- TODO: more tests on Application

log(DEBUG, "---- APPLICATION TEST END ----")
