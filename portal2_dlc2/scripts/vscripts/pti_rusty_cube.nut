///model changer script for PTI. Allows models to be changed by an external script to provide checks to ensure the models and script are packed properly. If script is not present, calls will fail and the entity will keep its current Valve model. If the script is available, it will switch to that model. 

function rusty_cube() // Rusty cube like normal one, but using clean skin slots instead to allow showing gels.
{
self.SetModel("models/props_ingame/metal_box_rusty.mdl");
}

function rusty_choose() // switches this branch to true immediately, used to choose which spawner to kill
{
	EntFireByHandle(self, "SetValue", "1", 0, null, null);
}

function rusty_killme() // Used to kill the normal spawner to choose for dropperless cubes.
{
	EntFireByHandle(self, "Kill", "", 0, null, null);
}