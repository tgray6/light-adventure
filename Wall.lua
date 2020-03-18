--[[Walls
    The Wall class represents the walls that randomly spawn in our game, which act as our primary obstacles.The walls can stick out a random distance from the top or bottom of the screen. When the player collides with one of them, it's game over. Rather than our Dr Light actually moving through the screen horizontally, the walls themselves scroll through the game to give the illusion of player movement.
]]--


Wall = Class{};


--Using all 3 images to simulate blade animation
WALL_IMAGE0 = love.graphics.newImage('images/wall.png');
WALL_IMAGE1 = love.graphics.newImage('images/wall.png');
WALL_IMAGE2 = love.graphics.newImage('images/wall2.png');


WALL_SCROLL = 60;


--Height of the wall image, globally accessible
WALL_HEIGHT = 288;
WALL_WIDTH = 70;


--A counter to change between wall images to simulate blade animation in Wall:update
bladeAnimation = 0;





--Before, our init took no parameters, now it takes an orientation and a y value. The orientation allows us to ask if it is a top wall or a bottom wall, if it is top, we need to flip it, draw it, and shift it due to the gap. If it is a bottom wall, we will just draw it as normal.
function Wall:init(orientation, y)
	self.x = VIRTUAL_WIDTH;

	self.y = y;

	self.width = WALL_IMAGE1:getWidth();
	self.height = WALL_HEIGHT;

	self.orientation = orientation;
end;





-- The actual walls are updating now in WallPair, this is just for blade animation.
function Wall:update(dt)
	bladeAnimation = bladeAnimation + dt;

	if bladeAnimation < 0.01 then
		WALL_IMAGE0 = WALL_IMAGE1;
	else 
		WALL_IMAGE0 = WALL_IMAGE2;
		bladeAnimation = 0;
	end;
end;





function Wall:render()
    love.graphics.draw(WALL_IMAGE0, 
    	self.x, --X position
        (self.orientation == 'top' and self.y + WALL_HEIGHT or self.y), --Y position, this is saying IF the orientation is a 'top' then set the y to itself PLUS WALL_HEIGHT, because when we flip it, it also flips the Y way above, by an entire WALL_LENGTH, remember the drawing where it flips and the Y is way off the top of the screen, so we have to set Y to be at the bottom of the Wall, not the top. ELSE just set it to self.y(which is for our bottom wall)
        0, --rotation
        1, --X scale, 1 mean no scaling
        self.orientation == 'top' and -1 or 1) --Y scale, so IF the walls orientation is a 'top' we set the scale to -1, which flips it along the axis, aka mirroring it
end;