--[[
    -- BaseState Class --
    Used as the base class for all of our states, so we don't have to
    define empty methods in each of them. StateMachine requires each
    State have a set of four "interface" methods that it can reliably call,
    so by inheriting from this base state, our State classes will all have
    at least empty versions of these methods even if we don't define them
    ourselves in the actual classes.
]]

--Implements empty methods so we can just inherit this state and choose which methods we want to define without throwing errors because it will blindly call all these functions, not checking to see if they are actually implemented. THis is essentially a way to avoid a lot of boilerplate code.

BaseState = Class{};

function BaseState:init() end;
function BaseState:enter() end;
function BaseState:exit() end;
function BaseState:update(dt) end;
function BaseState:render() end;