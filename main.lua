--[[Main Program- LUA LOVE2D Dr Light Adventure]]

--Class library allows us to use classes
Class = require 'class';


--Push is a library that will allow us to draw our game at a virtual resolution, instead of however large our window is; used to provide a more retro aesthetic
push = require 'push';


require 'Drlight';
require 'Wall';
require 'WallPair';

--Code relating to game state and state machines
require 'StateMachine';
require 'states/BaseState';
require 'states/PlayState';
require 'states/TitleScreenState';
require 'states/ScoreState';
require 'states/CountdownState';


WINDOW_WIDTH = 1280;
WINDOW_HEIGHT = 720;

VIRTUAL_WIDTH = 512;
VIRTUAL_HEIGHT = 288;


local background = love.graphics.newImage('images/background.png');
local ground = love.graphics.newImage('images/floor.png');


--Scroll variables to scroll the image left on x axis
local backgroundScroll = 0;
local groundScroll = 0;


--Speed variables for our background and ground scroll
local BACKGROUND_SCROLL_SPEED = 30;
local GROUND_SCROLL_SPEED = 60;


--Looping point of our background and ground
local BACKGROUND_LOOPING_POINT = 2048;
local GROUND_LOOPING_POINT = 1078;


--Variable creating dr light from Drlight.lua
local drlight = Drlight();


--Creationg wall pairs for upper and lower and storing them in our table
local wallPairs = {};


--Timer to determine when another wall spawn
local spawnTimer = 0;


--Love2d method that allows window resizing
function love.resize(w, h)
    push:resize(w, h);
end;





--[[
    Runs when the game first starts up, only once; used to initialize the game
]]
function love.load()
    math.randomseed(os.time());

    love.mouse.setVisible(false);

	love.graphics.setDefaultFilter('nearest', 'nearest');


	love.window.setTitle('Light Flight');


    --megaman ttf font I downloaded. setting different sizes here
    smallFont = love.graphics.newFont('images/megaman.ttf', 8);
    mediumFont = love.graphics.newFont('images/megaman.ttf', 14);
    largeFont = love.graphics.newFont('images/megaman.ttf', 22);
    hugeFont = love.graphics.newFont('images/megaman.ttf', 40)
    love.graphics.setFont(smallFont);



    --initialize table of sounds
    sounds = {
        ['rocket'] = love.audio.newSource('sounds/rocket.wav', 'static'),
        ['rocket2'] = love.audio.newSource('sounds/rocket2.wav', 'static'),
        ['death'] = love.audio.newSource('sounds/death.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['theme'] = love.audio.newSource('sounds/theme.mp3', 'static'),
    };



    --kick off music at the start
    sounds['theme']:setLooping(true);
    sounds['theme']:play();


    --Initiailize our window the the virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    });


    --Initialize state machine with all state-returning functions and set it initially to title state. These keys map to functions that will return our states.
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end,
        ['countdown'] = function() return CountdownState() end,
    };
    gStateMachine:change('title');


    --Setting up our own global empty table(keysPressed) in the love.keyboard object to keep track of keys pressed
    love.keyboard.keysPressed = {};
end;





--[[
    Runs every frame, with "dt" passed in, our delta in seconds since the last frame, which LÖVE2D supplies us
]]
function love.update(dt)
    --Scrolling our background and ground using %, which also resets to 0 at end of looping point. 
    backgroundScroll = (backgroundScroll + (BACKGROUND_SCROLL_SPEED * dt)) % BACKGROUND_LOOPING_POINT;
    groundScroll = (groundScroll + (GROUND_SCROLL_SPEED * dt)) % GROUND_LOOPING_POINT; 


    --we not just update the state machine, instead of all our update logic we had before, which I have stored in relicupdate.lua for reference. When we call the below, it is going to look, see what our current state is, and perform the update logic for that state.
    gStateMachine:update(dt);


    --Setting our table back to empty because we just want to check this table frame by frame. If we did not, every key would we pressed would always be set to true, so there would be no way of telling what the last key pressed was.
    love.keyboard.keysPressed = {};
end;





--[[
    Called after update by LÖVE2D, used to draw anything to the screen, updated or otherwise. !!love.draw draws in layers based on the order they are in the code
]]
function love.draw()
	--Begin rendering at virtual resolution
    push:start();


    --Pretty blue sky
    love.graphics.clear(128/255, 128/255, 255);


    --Drawing the background at -x value so it scrolls left
    love.graphics.draw(background, -backgroundScroll, 0);


    --Draw the state machine between the background and ground and defer render logic to the currently active state. Old draw logic is stored in relicdraw.lua for reference
    gStateMachine:render();


    --Drawing the ground spikes at -x value so it scrolls left
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 15);


    --End rendering at virtual resolution
    push:finish();
end;





--[[
    keypressed is a Callback function that love2d gives us that allows us to add the key to our table to check each frame whether a certain key has been pressed. We add that key to the table and set it to true.
]]
function love.keypressed(key)
    --since love.keypressed is given to us by lua, we can use the below. Now, anytime a key is pressed we will push it to our keysPressed {}.
    love.keyboard.keysPressed[key] = true;

	if key == 'escape' then
		love.event.quit();
	end;
end;





--[[
    We can use the below to query our table anytime we want to, which means, on that last frame, say, .0015 seconds in delta time, was that key pressed?...and if so return to true so we can tell if it was pressed or not in our table. The key then gets immediately flushed from the table so it is NO LONGER TRUE, and ready for another input
]]
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] == true then
        return true;
    else
        return false;
    end;
end;



