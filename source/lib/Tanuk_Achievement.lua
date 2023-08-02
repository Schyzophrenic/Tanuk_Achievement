class("Tanuk_Achievement").extends()

--- Achievement object
-- @param name
-- @param description
-- @param fnTest will return a boolean indicating if the achievement is unlocked. 
-- The achievement only works when fnTest references global variables
function Tanuk_Achievement:init(name, description, fnTest)
    Tanuk_Achievement.super.init(self)

    assert(name, "Name is missing")
    assert(fnTest, "No test provided for the achievement")
    self.name = name
    self.description = description
    self.fnTest = fnTest
    self.isCompleted = false
end