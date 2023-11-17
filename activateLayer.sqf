{
	_x enableSimulationGlobal true;
	_x hideObjectGlobal false;
	
} forEach (getMissionLayerEntities "OPFOR_AMBUSH");


// ###############


systemChat format ["Trigger:- %1 - activated", str thisTrigger];

if (getPlayerUID player == "_SP_PLAYER_") then {
	CKN_DEBUG = true;
} else {
	CKN_DEBUG = false;
};


// ################# add waypoint by trigger





[] spawn {

	heli1 setFuel 1;
	heli1 setDamage 0;

	_wp1 = attackchoppergroup addWaypoint [(getpos king), 10, index, name];
	_wp1 setWaypointType "LOITER";
	_wp1 setWaypointLoiterRadius 200;
	_wp1 setWaypointLoiterType selectRandom ["CIRCLE", "CIRCLE_L"];

	while {sleep 10; true} do {
	waitUntil {sleep 10; (vehicle king != king)};

	_wp1 waypointAttachVehicle vehicle king;
	_wp1 setWaypointType "LOITER";
	_wp1 setWaypointLoiterRadius 100;
	_wp1 setWaypointLoiterType selectRandom ["CIRCLE", "CIRCLE_L"];

	waitUntil {sleep 10; (vehicle king == king)};
	};
};




// #############

{
	[
		{_x setDamage 1;},
		[],
		(15 + floor random 300)
	] call CBA_fnc_waitAndExecute;
} forEach [IED_2,IED_3,IED_4,IED_5];


// ##########

CKN_Toggle_Lamp_1 = false;
this addAction ["Toggle the Jump Light",{
	if (CKN_Toggle_Lamp_1) then {
	CKN_Toggle_Lamp_1 = false;
	publicVariable "CKN_Toggle_Lamp_1";
	/*Insert Code to switch thing to Red*/
	RED3 	hideObjectGlobal false;
	GREEN3 	hideObjectGlobal true;
} else {
	CKN_Toggle_Lamp_1 = true;
	publicVariable "CKN_Toggle_Lamp_1";
	/*Insert Code to switch thing to Green*/
	RED3 	hideObjectGlobal true;
	GREEN3 	hideObjectGlobal false;
};
}];


/////

if (CKN_DEBUG) then {

	addMusicEventHandler ["MusicStop", {
			params ["_musicClassname", "_ehId"];
			systemChat "[CVO][Music] Stop";
		}
	];
	addMusicEventHandler ["MusicStart", { 
			params ["_musicClassname", "_ehId"];
			systemChat format ["[CVO][Music] Now Playing: %1", _musicClassname];
			if (getAudioOptionVolumes#1 < 0.05) then {
				systemChat format ["[CVO][Music] Your Music Volume is low at %1%2", (getAudioOptionVolumes#1 * 100),"%"];
			}; 
		};
	];

};