--[[Main Program- LUA LOVE2D Dr Light Adventure]]

--Class library allows us to use classes
Class = require 'class';


--Push is a library that will allow us to draw our game at a virtual resolution, instead of however large our window is; used to provide a more retro aesthetic
push = require 'push';


require 'Drlight';
require 'Wall';
require 'WallPair';


WINDOW_WIDTH = 1280;
WINDOW_HEIGHT = 720;

VIRTUAL_WIDTH = 512;
VIRTUAL_HEIGHT = 288;


local background = love.graphics.newImage("images/background.png");
local ground = love.graphics.newImage("images/floor.png");


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


--Wrapped around update function-turn true and stops all update code if collision detected
local gameover = false;


--Love2d method that allows window resizing
function love.resize(w, h)
    push:resize(w, h);
end;





--[[
    Runs when the game first starts up, only once; used to initialize the game
]]
function love.load()
    math.randomseed(os.time());


	love.graphics.setDefaultFilter('nearest', 'nearest');


	love.window.setTitle('Dr. Light Adventure');


    --Initiailize our window the the virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    });


    --Setting up our own global empty table(keysPressed) in the love.keyboard object to keep track of keys pressed
    love.keyboard.keysPressed = {};
end;





--[[
    Runs every frame, with "dt" passed in, our delta in seconds since the last frame, which LÖVE2D supplies us
]]
function love.update(dt)
  if gameover == false then


    --Scrolling our background and ground using %, which also resets to 0 at end of looping point. 
    backgroundScroll = (backgroundScroll + (BACKGROUND_SCROLL_SPEED * dt)) % BACKGROUND_LOOPING_POINT;
    groundScroll = (groundScroll + (GROUND_SCROLL_SPEED * dt)) % GROUND_LOOPING_POINT; 


    -- Set our spawnTimer to be equal to itself + dt so it essentially just counts
    spawnTimer = spawnTimer + dt;


    --Check if spawnTimer is greater than 2(2 seconds). If so, spawn a random height wall
    if spawnTimer > 2 then

        --Our initial Y is based off of our top FLIPPED wall location. remember our bottom wall is drawn based off of this, but just with a + GAP_WIDTH distance apart on the y axis, as in WALL_HEIGHT + GAP_HEIGHT. SO, remember the drawing, the initial flip, our Y data point is STILL on the top left of the image, it doesn't matter if it is upside down. So at -288 the BOTTOM of our image is at the 0 point on the Y axis(the top of the screen) and when we set it to -200 like below, we are moving the image lower and lower, same for the opposite, a smaller negative number moves the image farther above off screen. -200 seemed about a decent starting point as I was shooting for roughly mid screen with the 90 pixel gap
        initialAndLastY = -200;


        --Modify the initialAndLastY coordinate placed above
        --we do not want a y position to go any higher than 25 pixels below the top edge of the screen(25 is aproximately the pixel height of the top(aka the bottom since it was flipped) of my wall + the blades so I can still see both without them getting cut off)
        --and no lower than approximately my spikes + my wall and blades(120 pixels) from the bottom
        local y = math.max(-WALL_HEIGHT + 25, math.min(initialAndLastY + math.random(-75, 75), -120));

        --Uncomment the below to enable a smoother contour and easier playing experience. By setting initialAndLastY to be y, our next y position will be within a closer threshold of the previous y position, since the previous y would be based off this position.

        -- initialAndLastY = y;


        --Inserts walls, aka 'WallPair' into our wallPairs table. WallPair takes a (y) that will be where the start of the gap is between the top and bottom walls
        table.insert(wallPairs, WallPair(y));


        --Reset ospawnTimer to 0 so that spawnTimer > 2 will be false again
        spawnTimer = 0;
    end;


    --To iterate over our wallsTable, lua gives you a function called 'pairs', that gives you all the key/value pairs of a table that you can then use while your iterating over it. Doing this will actually give you the keys of each pair. NOTE: i is the key and wall will be the value
    for i, wall in pairs(wallPairs) do 

        --Update each wall, top and bottom by dt
        wall:update(dt);


        --Check lights collision with walls and set gameover to true if he does
        if drlight:collides(wall.walls.upper) == true or drlight:collides(wall.walls.lower) == true then
            gameover = true;
        end;
    end;


    --Removes each wall pair at i position, which will be the 1 position in our object each time since we constantly remove the one on the left of the screen.
    for i, wall in pairs(wallPairs) do
        if wall.remove == true then
            table.remove(wallPairs, i);
        end;
    end;


    --Update light and blade animation on the wall. WallPair.lua updates the actual walls
    drlight:update(dt);
    Wall:update(dt);


  --End of our gameover if statement encapsulating all the code above.
  end;


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


    --Drawing each of our walls, stored in wallPairs
    for i, walls in pairs(wallPairs) do
        walls:render();
    end;


    --Drawing the ground spikes at -x value so it scrolls left
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 15);


    --Render dr light
    drlight:render();


	--Drawing random stats, fps, etc
   	displayFPS();


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





--[[
    Renders the current FPS and other stuff.
]]
function displayFPS()
    -- simple FPS display across all states
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 0, 0);
    -- love.graphics.print('Background: ' .. tostring(background:getWidth()), 0, 10);
    -- love.graphics.print('Ground: ' .. tostring(ground:getWidth()), 0, 20);
    -- love.graphics.print('Spawn Timer: ' .. tostring(spawnTimer), 0, 30);
end;