--old draw logic, being moved from main.lua into our gStateMachine:render() 



--Drawing each of our walls, stored in wallPairs

for i, walls in pairs(wallPairs) do
    walls:render();
end;


 --Render dr light
 drlight:render();