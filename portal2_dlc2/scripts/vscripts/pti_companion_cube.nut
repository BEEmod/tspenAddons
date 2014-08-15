///model changer script for PTI. Allows models to be changed by an external script to provide checks to ensure the models and script are packed properly. If script is not present, calls will fail and the entity will keep its current Valve model. If the script is available, it will switch to that model. 

thinkRun <- true;

function under_ccube() // underground old aperture cube with hearts. Applied to old cube.
{
self.SetModel("models/props_underground/underground_cmpanion_cube.mdl");
}

function cmp_choose() // switches this branch to true immediately, used to choose which spawner to kill
{
	if (thinkRun)
	{
		thinkRun = false;
		EntFireByHandle(self, "SetValue","1",0, null, null);
	}
}