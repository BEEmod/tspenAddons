// Script for my worldportal doors which lives in a logic_script named @worlportal_door, with wportal_think() as the think function. WorldPortal entry doors trigger the entry function passing the portal name along (using worlporal_door_entry.nut). This puts them in a queue which the think function runs through. For each door, it triggers the output relay for the door. This causes the other door to run the worldportal_door_exit.nut script, which passes the portal name to the exit() function. This now has the names of both portals, and is able to then SetPartner both of the doors and set some branches to allow the logic to open the doors. All the entities that are to be triggered are named with the prefix of the worldportal name, so I can just append the rest of the name to the worldportal name without needing to deal with much string manipulation.

doorQueue <- [];
isWaiting <- false;
currentDoor <- -1;
function entry(door)
{
printl("Adding entry door \"" + door + "\"");
doorQueue.append(door);
}

function wportal_think()
{
if (isWaiting || currentDoor + 1 == doorQueue.len())
	return; // We are waiting for a door to reply or we have finished the queue.
else
	{
	currentDoor += 1;
	isWaiting = true;
	printl("Triggering Exit door");
	EntFire(doorQueue[currentDoor] + "_partner_rl", "Trigger", "",0.0); // trigger exit door
	}
}

function exit(door)
{
printl("Reply recieved from \"" + door + "\"");
printl("Exchanging names with \"" + doorQueue[currentDoor] + "\"");
EntFire(door, "SetPartner", doorQueue[currentDoor], 0.0 );
EntFire(doorQueue[currentDoor], "SetPartner", door, 0.0 );
EntFire(door + "_active", "SetValue", 1, 0.0 );
EntFire(doorQueue[currentDoor] + "_active", "SetValue",    1, 0.0 ); // earlier version of unlock logic, kept to ensure it doesn't fail
EntFire(door + "_man", "SetStateATrue", "", 0.0 ); // unlock manager to allow door to open
EntFire(doorQueue[currentDoor] + "_man", "SetStateBTrue", "", 0.0 ); // unlock manager to allow door to open
isWaiting = false;
}