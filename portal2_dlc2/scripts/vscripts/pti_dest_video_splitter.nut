// --------------------------------------------------------
// TeamSpen210: modified version of video_splitter to work with overgrown maps and fit Cave's PTI dialogue
// See _comments version for all the comments, the normal one has been shrunk to have a smaller filesize.
// --------------------------------------------------------
RandomVideos <- // Original set of videos
[
	"laser_danger_vert",
	"fizzler",
	"laser_portal",
	"turret_colours_type",
	"bluescreen",
	"community_bg1",
	"plc_blue_horiz",
	"exercises_vert",
	"plc_blue_vert",
	"faithplate",
	"aperture_logo",
	"aperture_appear_vert",
	"coop_orangebot_load",
	"turret_exploded_grey",
	"exercises_horiz",
	"laser_danger_horiz",
	"animalking",
	"turret_dropin",
	"coop_bots_load",
	"coop_bots_load_wave",
	"coop_bluebot_load",
	"hard_light",
	"aperture_appear_horiz",
]
CaveVideos <-  // Matches Cave's lines
[ // nums index into above array
5, 7, 6, 16, 22, 6, 22, 14, 10, 22, 19, 17, 3, 21, 3, 9, 1, 10, 
"sp_a5_credits", 
"sp_a5_credits", 
"sp_a5_credits", 
10, 15, 16, 3, 14, 6, 16, 9, 9, 18, 13, 5, 
"sp_credits_bg", 
13, 
"sp_credits_bg",
2, 17, 19, 10, 11, 21, 12, 14, 18, 16, 16, 10, 21, 6, 5, 5, 16, 20, 17, 9, 22, 7, 17, 20, 2, 1, 2, 5, 16, 9, 3, 21, 
"sp_credits_bg", 
"sp_credits_bg", 
10, 0, 12, 9, 
"sp_a5_credits", 
"coop_bts_radar_1" // +7 more, let them be random
]

ARRIVAL_VIDEO <- 0
DEPARTURE_VIDEO <- 1
ARRIVAL_DESTRUCTED_VIDEO <- 2
DEPARTURE_DESTRUCTED_VIDEO <- 3

chosenVideo <- ""

EntFire("@elev_arrival_script","Kill","",0); // Remove the original scripts, allowing them to be used instead if this script isn't packed.
EntFire("@elev_departure_script","Kill","",0);

function Precache()
{
	if( "PrecachedVideos" in this )
	{
		// don't do anything
	}
	else
	{
		// If we're in a community map, pick a random one
		local communityMapIndex = GetMapIndexInPlayOrder();
		if ( true || communityMapIndex != -2 )
		{
			if ( communityMapIndex == -1 )
			{
				communityMapIndex = GetNumMapsPlayed(); 
			}
			// the map index is actually the same as the dialogue that's chosen, so match vids to Cave if possible.
			printl("Map = " + communityMapIndex);
			if(communityMapIndex < 76)
				{
				local vid = CaveVideos[communityMapIndex];
				if (typeof vid=="integer") // to decrease size, just store the index
					{
					chosenVideo = "media\\" + RandomVideos[vid] + ".bik"
					}
				else // Some vids only play with Cave dialogue, choose them if needed
					{
					chosenVideo = "media\\" + vid + ".bik"
					}
				}
			else // otherwise choose randomly
				{
				chosenVideo = "media\\" + RandomVideos[communityMapIndex % RandomVideos.len()] + ".bik";
				}
		}
		else
		{
		chosenVideo = "media\\" + RandomVideos[RandomInt(0,RandomVideos.len())] + ".bik"; // For playtesting
		}
		
		printl( "Preching movie: " + chosenVideo )
		PrecacheMovie( chosenVideo )
	}
}

function StopArrivalVideo(width,height)
{
	EntFire("@arrival_video_master", "Disable", "", 0)
	EntFire("@arrival_video_master", "killhierarchy", "", 1.0)
	StopVideo(ARRIVAL_VIDEO,width,height)
}

function StopDepartureVideo(width,height)
{
	EntFire("@departure_video_master", "Disable", "", 0)
	EntFire("@departure_video_master", "killhierarchy", "", 1.0)
	StopVideo(DEPARTURE_VIDEO,width,height)
}

function StopVideo(videoType,width,height)
{
	for(local i=0;i<width;i+=1)
	{
		for(local j=0;j<height;j+=1)
		{
			local panelNum = 1 + width*j + i;
			local signName
			
			if (videoType == DEPARTURE_VIDEO || videoType == DEPARTURE_DESTRUCTED_VIDEO )
			{
				signName = "@departure_sign_" + panelNum;
			}
			else
			{
				signName = "@arrival_sign_" + panelNum;
			}
			
			EntFire(signName, "Disable", "", 0)
			EntFire(signName, "killhierarchy", "", 1.0)
		}
	}
}

function StartDestructedArrivalVideo(width,height)
{
		printl("Setting arrival movie to " + chosenVideo )
		EntFire("@arrival_video_master", "SetMovie", chosenVideo, 0)
	
		EntFire("@arrival_video_master", "Enable", "", 0.1)
		StartVideo(ARRIVAL_DESTRUCTED_VIDEO, width, height)
}

function StartDestructedDepartureVideo(width,height)
{
		printl("Setting departure movie to " + chosenVideo )
		EntFire("@departure_video_master", "SetMovie", chosenVideo, 0)
		
		EntFire("@departure_video_master", "Enable", "", 0.1)
		StartVideo(DEPARTURE_DESTRUCTED_VIDEO, width, height)
}

function StartVideo(videoType,width,height)
{
	local videoScaleType = RandomInt(1,13) // since the map's destroyed, choose a random scaling type.
	local randomDestructChance = RandomInt(30,80)
	if(chosenVideo == "media\\bluescreen.bik")
	{
		videoScaleType=14 // make this appear correctly
	}
	for(local i=0;i<width;i+=1)
	{
		for(local j=0;j<height;j+=1)
		{
			local panelNum = 1 + width*j + i
			local signName
			
			if (videoType == DEPARTURE_VIDEO || videoType == DEPARTURE_DESTRUCTED_VIDEO )
			{
				signName = "@departure_sign_" + panelNum
			}
			else
			{
				signName = "@arrival_sign_" + panelNum
			}		
					
			{
				if( randomDestructChance > RandomInt(0,100) )
				{
					EntFire(signName, "Kill", "", 0)
					continue
				}
				
				EntFire(signName, "SetUseCustomUVs", 1, 0)
				
				local uMin = (i+0.0001)/(width)
				local uMax = (i+1.0001)/(width)
				local vMin = (j+0.0001)/(height)
				local vMax = (j+1.0001)/(height)
				
				if( videoScaleType == 0 /*full elevator*/ ) 				
				{
				
				}				
				else if( videoScaleType == 1 /*stretch*/ ) 
				{
					uMin = 1.0 - (1.0-uMin)*(1.0-uMin)*(1.0-uMin)
					uMax = 1.0 - (1.0-uMax)*(1.0-uMax)*(1.0-uMax)
				}				

				else if( videoScaleType == 2 /*Mirror*/ ) 
				{					
					uMin = 4*(1.0-uMin)*uMin
					uMax = 4*(1.0-uMax)*uMax					
				}				
				
				else if( videoScaleType == 3 /*Ouroboros*/ )
				{
					uMin = ((i%12)+0.0001)/12
					uMax = ((i%12)+1.0001)/12

					if( ((i)%2) == 1 )
					{
						local temp = uMin
						uMin = uMax
						uMax = temp
					}
				}
				
				else if( videoScaleType == 4 /*Upside down*/ )
				{
					vMin = 0.99999
					vMax = 0.00001
					
					uMin = ((i%3)+0.0001)/3
					uMax = ((i%3)+1.0001)/3					
				}
				
				else if( videoScaleType == 5 /*Tiled*/ )
				{
					vMin = 0.00001
					vMax = 0.99999
					
					uMin = ((i%3)+0.0001)/3
					uMax = ((i%3)+1.0001)/3
				}

				else if( videoScaleType == 6 /*Tiled Really Big*/ )
				{
					uMin = ((i%8)+0.0001)/8
					uMax = ((i%8)+1.0001)/8
				}

				else if( videoScaleType == 7 /*Tiled Big*/ )
				{
					uMin = ((i%12)+0.0001)/12
					uMax = ((i%12)+1.0001)/12
				}

				else if( videoScaleType == 8 /*Tiled Single*/ )
				{
					uMin = 0.0001
					uMax = 0.9999
					vMin = 0.0001
					vMax = 0.9999
				}

				else if( videoScaleType == 9 /*Tiled Double*/ )
				{
					uMin = ((i%2)+0.0001)/2
					uMax = ((i%2)+1.0001)/2
				}

				else if( videoScaleType == 10 /*Two by two*/ )
				{
					vMin = 0.00001
					vMax = 0.99999
					
					uMin = ((i%2)+0.0001)/2
					uMax = ((i%2)+1.0001)/2
				}

				else if( videoScaleType == 11 /*Tiled off 1*/ )
				{
					vMin = 0.00001
					vMax = 0.99999
					
					uMin = (((i+1)%3)+0.0001)/3
					uMax = (((i+1)%3)+1.0001)/3
				}

				else if( videoScaleType == 12 /*Tiled 2x4*/ )
				{
					uMin = ((i%6)+0.0001)/6
					uMax = ((i%6)+1.0001)/6
				}

				else if( videoScaleType == 13 /*Tiled Double - with two blank*/ )
				{
					if( ((i)%4) < 2 )
					{
						uMin = ((i%2)+0.0001)/2
						uMax = ((i%2)+1.0001)/2
					}
					else
					{
						uMin = 0.97
						uMax = 0.97
					}
				}

				else if( videoScaleType == 14 /*bluescreen*/ )
				{
					if( (i%8) >= 1 &&  
						(i%8) < 7 )
					{
						uMin = (((i-1)%8)+0.0001)/6
						uMax = (((i-1)%8)+1.0001)/6
					}
					else
					{
						uMin = 0.97
						uMax = 0.97
					}
				}
								 
				EntFire(signName, "SetUMin", uMin, 0)
				EntFire(signName, "SetUMax", uMax, 0)
				EntFire(signName, "SetVMin", vMin, 0)
				EntFire(signName, "SetVMax", vMax, 0)

				EntFire(signName, "Enable", "", 0.1)
			}
		}
	}
}
