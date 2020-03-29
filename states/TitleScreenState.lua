--[[
    TitleScreenState Class

    The TitleScreenState is the starting screen of the game, shown on startup. It should
    display "Press Enter" and also our highest score.
]]


--'_includes' come from our Class library we are using. _includes allows us to use all the methods from our BaseState, aka inheritance of the BaseState class. In other words, it takes an object, copies everything from that object, put it into THIS one, and we add more stuff to it.

TitleScreenState = Class{__includes = BaseState};





--If we press enter, we call our change method to change the state to play, otherwise it just sits at the title screen waiting for enter to be pressed.
function TitleScreenState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown');
    end
end




--Straightforward...just changing fonts and printing text to screen
function TitleScreenState:render()
	love.graphics.setFont(largeFont);
	love.graphics.printf('Light Flight', 0, 64, VIRTUAL_WIDTH, 'center');

	love.graphics.setFont(mediumFont);
	love.graphics.printf('Press Enter', 0, 100, VIRTUAL_WIDTH, 'center');

	love.graphics.setFont(smallFont);
	love.graphics.printf('Escape to Quit', 0, 164, VIRTUAL_WIDTH, 'center');
end;