//EntityGroup[0] = the prop_portal
//EntityGroup[1] = the info_target reference
canOpen <- false;  // Portal only opens after player enters the level

function open_portal() {
	if (canOpen) {
	local origin = EntityGroup[1].GetOrigin(); // the info_target is in the exact position we need
	local angles = EntityGroup[1].GetAngles();
	EntFireByHandle(EntityGroup[0],"SetActivatedState","1",0,null,null);
	EntFireByHandle(EntityGroup[0],"NewLocation",origin.x+" "+origin.y+" "+origin.z+" "+angles.x+" "+angles.y+" "+angles.z,0.01,null,null); // We need to move the portal to the end of the piston
	}
}

function close_portal() {
	EntFireByHandle(EntityGroup[0],"SetActivatedState","0",0,null,null);
}

function enter_map() {
	canOpen = true;
}