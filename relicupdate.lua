--old update logic, being moved from main.lua into our gStateMachine:update(dt) 

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