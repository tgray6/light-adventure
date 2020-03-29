--[[
	Drlight main player sprite class
]]--


Drlight = Class{};


--Change between these 2 sprites based on dy variable, going up or down for fun animation
local light1 = love.graphics.newImage('images/light1.png');
local light2 = love.graphics.newImage('images/light2.png');


--Set a gravity constant, this will be used to move our Y axis on dr light to 10 pixels per frame, in a positive value, therefore going towards the bottom of the screen.
local GRAVITY = 10;


--Setting this variable to go in the opposite direction on the y-axis, aka a negative value to top. We use this in keypressed to make dr light go up.
local ANTI_GRAVITY = -1.5;





function Drlight:init()
	--Load dr light image and assign its width and height
	self.image = light1;
	self.width = self.image:getWidth();
	self.height = self.image:getHeight();

	--Position drlight in the middle of the screen
	self.x = VIRTUAL_WIDTH / 2 - self.width;
	self.y = VIRTUAL_HEIGHT / 2 - self.height;

	--Set a variable for our delta y. this value will be added to our GRAVITY * dt and then dr lights y value will be set to this value, so he will constantly fall downwards with increased velocity since this delta y is increasing as well as our y, so the velocity keeps going up.
	self.dy = 0;
end;





--Creating our collides function to determine if drlight sprite hits a wall
function Drlight:collides(wall)
	--Offsets are used to shrink the hit box of drlight so we dont just immediately die pixel perfect when a collision happens
	--Return true if there was a collision, otherwise always return false

	--AABB Collision Detection. Just remember it is a bit confusing since our top wall is flipped, so visually, top is bottom, bottom is top for the top wall.
	
	--Lights face vs front of walls -AND- Back of lights head vs right side of walls
	if self.x + (self.width - 4) >= wall.x and (self.x + 17) <= (wall.x + wall.width) and
	--Bottom of light vs top of walls    -And-     Top of lights head vs bottom of wall
		self.y + (self.height - 4) >= wall.y and (self.y + 3) <= (wall.y + wall.height)then
		return true;
	end;
	return false;
end;





function Drlight:update(dt)
	--Apply gravity value to our dy so dr light goes +y, to bottom of screen
	self.dy = self.dy + GRAVITY * dt;


	--Apply current dy velocity value to Y position
	self.y = self.y + self.dy;


	--Setting our dy to -5 so it goes the negative value, towards top of screen. Remember wasPressed is our table we created and if the key 'f' was pressed, it was inserted into the table with a value of true.
	if love.keyboard.wasPressed('f') == true then
		self.dy = ANTI_GRAVITY;
		sounds['rocket']:play();
		sounds['rocket2']:play();
	end;

	--Dr light animation basedd on dy value, which is only < 0 when going up
	if self.dy > 0 then
	 	self.image = light1;
	 else
	 	self.image = light2;
	end;
end;





function Drlight:render()
	love.graphics.draw(self.image, self.x, self.y, self.rotation);
end;