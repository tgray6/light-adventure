--
-- StateMachine - a state machine
--
-- Usage:
--
-- -- States are only created as need, to save memory, reduce clean-up bugs and increase speed due to garbage collection taking longer with more data in memory.
-- --
-- -- States are added with a string identifier and an intialization function.The init function, when called, will return a table with Render, Update, Enter and Exit methods.
--
-- gStateMachine = StateMachine {
-- 		['MainMenu'] = function()
-- 			return MainMenu()
-- 		end,
-- 		['InnerGame'] = function()
-- 			return InnerGame()
-- 		end,
-- 		['GameOver'] = function()
-- 			return GameOver()
-- 		end,
-- }
-- gStateMachine:change("MainGame")
--
-- Arguments passed into the Change function after the state name
-- will be forwarded to the Enter function of the state being changed to.
--
-- State identifiers should have the same name as the state table, unless there's a good
-- reason not to. i.e. MainMenu creates a state using the MainMenu table. This keeps things straight forward.
--
-- =Doing Transitions=

StateMachine = Class{};




--Takes an init and a series of states that we define each behavior in the functions and that compiles our state, more or less.
function StateMachine:init(states)
	--Empty table, all are empty functions
	self.empty = {
		render = function() end,
		update = function() end,
		enter = function() end,
		exit = function() end
	};

	--This is something you can do in lua, allowing us to initialize a variable if it is not given a value in our function. As in, it gets what we passed in as states OR, if states is nothing, a falsey value, just set it to an empty table. Just shorthand for saying like: **if states == nil then self.states = {};**
	self.states = states or {};

	--Setting selt.current to be equal to whatever self.empty is
	self.current = self.empty;
end;





--Function to change states. Takes in a name and optional parameters that we can use to enter that state. When we change the state, call the exit function of whatever state we are in, set the current to whatever argument we passed in for stateName, and with enter, we enter that state machine with whatever enterParams we passed in, which is optional.
function StateMachine:change(stateName, enterParams)
	assert(self.states[stateName]); --A state MUST exist
	self.current:exit();
	self.current = self.states[stateName]();
	self.current:enter(enterParams);
end;





--Updates whatever the current, self.current state is
function StateMachine:update(dt)
	self.current:update(dt);
end;





--Renders whatever state self.current is set to
function StateMachine:render()
	self.current:render();
end;