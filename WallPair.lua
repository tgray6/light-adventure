--[[
	Wall Pairs Class
]]--


WallPair = Class{}


--Size of the gap between the walls, as in top and bottom, the gap between the 2 pair
GAP_HEIGHT  = 90;





function WallPair:init(y)
	--Initializes the walls x position past the right of the screen, so +32 pixels off the right side
	self.x = VIRTUAL_WIDTH + 20;


	--Set the y value to the topmost wall. The gap is a vertical shift of the second wall
	self.y = y;

	--Create the two walls that belong to this pair. Our logic for the upper Y is set in Wall.lua, which is also set to set Y to whatever self.y is HERE. So our BOTTOM just needs to be set to the WALL_HEIGHT + 90(GAP_HEIGHT) so it is placed 90 pixels below the very bottom left corner of the top wall. Right now I have initial Y set to -200, so for the bottom, -200 + 288 + 90 is where the top left corner of our Bottom wall will be, which is just 90 pixels below the upper wall.
	self.walls = {
		['upper'] = Wall('top', self.y),
		['lower'] = Wall('bottom', self.y + WALL_HEIGHT + GAP_HEIGHT)
	};


	--Whether this wall pair is ready to be removed from the scene.
	self.remove = false;
end;





function WallPair:update(dt)
	--Remove the wall from the scene if it is beyond the left edge of the screen, else move it from right to left
	if self.x + WALL_WIDTH > 0 then
		self.x = self.x - WALL_SCROLL * dt;
		self.walls['lower'].x = self.x;
		self.walls['upper'].x = self.x;
	else
		self.remove = true;
	end;

end;





function WallPair:render()
	--looping and rendering our wall pairs. logic for the Y on upper was set in Wall.lua, and we ended up just setting our lower logic in the init above, based on whatever the initial Y argument we pass in main.lua, which I have set to -200 right now.
	for i, wall in pairs(self.walls) do
		wall:render();
	end;
end;