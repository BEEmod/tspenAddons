///model changer script for PTI. Allows models to be changed by an external script to provide checks to ensure the models and script are packed properly. If script is not present, calls will fail and the entity will keep its current Valve model. If the script is available, it will switch to that model. 

//To use, just set the entity script for a prop to this (set its model to the valve equivalent if it exists) then runScriptCode one of the functions here. Pack the script and the model in.

function off_4panel() // PTI angled panel arm with no lights
{
self.SetModel("models/props_ingame/arm_4panel_off.mdl");
}

function rusty_4panel() // PTI angled panel arm - rusty
{
self.SetModel("models/props_ingame/arm_4panel_rusty.mdl");
}

function rusty_4panel_norail() // PTI angled panel arm - rusty + nodrawed rail
{
self.SetModel("models/props_ingame/arm_4panel_rusty_norail.mdl");
}

function off_4panel_glass() // PTI angled panel arm with no lights and glass
{
self.SetModel("models/props_ingame/arm_4panel_glass_off.mdl");
}

function off_8panel() // PTI stair panel arm with no lights
{
self.SetModel("models/props_ingame/arm_8panel_off.mdl");
}

function rusty_8panel() // PTI stair panel arm - rusty
{
self.SetModel("models/props_ingame/arm_8panel_rusty.mdl");
}

function rusty_8panel_norail() // PTI stair panel arm - rusty + nodrawed rail
{
self.SetModel("models/props_ingame/arm_8panel_rusty_norail.mdl");
}

function rusty_reflect() // Reflection cube with dirty gel skins
{
self.SetModel("models/props_ingame/reflection_cube_rusty.mdl");
}

function p1_button() // Portal 1 style button
{
self.SetModel("models/props_ingame/p1_switch.mdl");
}

function p1_cube() // Portal 1 style companion/standard cube
{
self.SetModel("models/props_ingame/p1_metal_box.mdl");
EntFireByHandle(self, "Color", "255 255 255", 0.00, null, null); // Clear the rendercolor
}

function p1_ball() // Portal 1 style sphere
{
self.SetModel("models/props_ingame/p1_ball.mdl");
EntFireByHandle(self, "Color", "255 255 255", 0.00, null, null); // Clear the rendercolor
}

function p1_portal_frame()
{
self.SetModel("models/props/autoportal_frame/autoportal_frame.mdl");
EntFireByHandle(self, "Enable", "", 0.00, null, null);
EntFire(self.GetName()+"_fallback", "Kill", "", 0, null); // Kill the fallback version (two fizzler models)
}

function p1_lfield()
{
self.SetModel("models/props_ingame/p1_lfield.mdl");
EntFireByHandle(self, "Color", "255 255 255", 0.00, null, null); // Clear the rendercolor
EntFire(self.GetName()+"_haz", "Kill", "", 0, null); // Kill the fallback version (brush on top of model)
}