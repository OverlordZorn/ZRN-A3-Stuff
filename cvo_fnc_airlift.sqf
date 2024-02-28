cvo_fnc_airlift = {

    /*
    * Author: Zorn
    * Creates Waypoints to Slingload slingloadable cargo to an destination and then returns to a waiting point.
    *
    * Arguments:
    * 0: _heliCrew     <Group>             - Group of Heli Crew
    * 1: _cargoObj     <Object>            - Object to be slung - needs to be slingloadable!
    * 2: _dropOffPos   <Object or Pos>     - Destination of the Cargo Object. Ether Pos or Object, like empty Helipad.
    * 3: _returnPos    <Object or Pos>     - Point of return for the helicopter once the cargo has been delivered. Ether Pos or Object, like empty Helipad.
    *
    * Return Value:
    * none
    *
    * Example:
    * [airlift_heli_1_grp,airlift_cargo_1, [1000,1000,0]] call cvo_fnc_airlift;
    *
    * Public: [Yes/No]
    */



    params [
        [ "_heliCrew",	   grpNull,		   [grpNull]		       ],
        [ "_cargoObj",	   objNull,		   [objNull]		       ],
        [ "_dropOffPos","UNDEFINED",	   [objNull,[]],	  [2,3]],
        [ "_returnPos",	"UNDEFINED",	   [objNull,[]],	  [2,3]],
        [ "_protected",       true,       [false]                 ]
    ];

    if (_heliCrew isEqualTo grpNull) exitWith {};
    if (_cargoObj isEqualTo objNull) exitWith {};

    if (_dropOffPos isEqualTo "UNDEFINED") exitWith {};

    if (_protected) then {
        { _x allowDamage false; } forEach units _heliCrew + [vehicle leader _heliCrew];
    };


	private ["_dropOffPosObj", "_returnPosObj"];

    If (_dropOffPos isEqualType []) then {
        _dropOffPosObj = createVehicle ["Land_HelipadEmpty_F", _dropOffPos];
    } else {    _dropOffPosObj = _dropOffPos; _dropOffPos = getPos _dropOffPosObj;  };


    if (_returnPos isEqualTo "UNDEFINED") then {
        _returnPos = getPos leader _heliCrew;
    };

    If (_returnPos isEqualType []) then {
        _returnPosObj = createVehicle ["Land_HelipadEmpty_F", _returnPos];
    } else {    _returnPosObj = _returnPos; _returnPos = getPos _returnPosObj;  };



    private _heliObj = vehicle leader _heliCrew;
    private _heliPos = getPos leader _heliCrew;
    private _cargoPos = getPos _cargoObj;

    private _dirCargoToHeli = _cargoObj getDir _heliObj;

    _heliObj setFuel 1;



private _code = {
    {	moveOut _x;	} foreach crew _this select 1;
    _this select 1 lockCargo true;
    _this select 1 lockDriver true;
    { _this select 1 lockTurret [_x, true]; } foreach allTurrets [_this select 1, true];
    _this select 1 setMass 1000;
};

[ { _this select 0 distance _this select 1 < 100 }, _code, [_heliObj, _cargoObj], 600, _code ] call CBA_fnc_waitUntilAndExecute;






    _heliObj limitSpeed 200;

    private _wpPos1 = _cargoPos getPos [750, _dirCargoToHeli];
    private _wpPos2 = _cargoPos getPos [200, _dirCargoToHeli];
    private _wpPos3 = _cargoPos getPos [50, _dirCargoToHeli];
    private _wpPos4 = + _cargoPos;
    private _wpPos5 = + _cargoPos; // _cargoPos getPos [150, _dirCargoToHeli + 180];

    private _wp1 = _heliCrew addWaypoint [_wpPos1, -1];
    _wp1 setWaypointBehaviour "CARELESS";
    _wp1 setWaypointStatements ["true", "vehicle this flyInHeight [50, true]; vehicle this limitSpeed 100;"];
    _wp1 setWaypointSpeed "FULL";


    private _wp2 = _heliCrew addWaypoint [_wpPos2, -1];
    _wp2 setWaypointStatements ["true", "vehicle this flyInHeight [30, true]; vehicle this limitSpeed 50;"];
    _wp2 setWaypointSpeed "LIMITED";

    private _wp3 = _heliCrew addWaypoint [_wpPos3, -1];
    _wp3 setWaypointStatements ["true", " vehicle this flyInHeight [30, false]; vehicle this limitSpeed 25; " ];

    // Empty the cargo vehicle and locks it + setMass for Airlift


    {	moveOut _x;	} foreach crew _cargoObj;
    _cargoObj lockCargo true;
    _cargoObj lockDriver true;
    { _cargoObj lockTurret [_x, true]; } foreach allTurrets [_cargoObj, true];
    _cargoObj setMass 1000;"


    private _wp4 = _heliCrew addWaypoint [_cargoObj, -1];
    _wp4 waypointAttachVehicle _cargoObj;
    _wp4 setWaypointType "HOOK";
    _wp4 setWaypointStatements ["true", "vehicle this flyInHeight [15, false]; vehicle this limitSpeed 25;"];


    private _wp5 = _heliCrew addWaypoint [_wpPos5, -1];
    _wp5 setWaypointStatements ["true", "vehicle this flyInHeight [75, true]; vehicle this limitSpeed 200;"];



    private _wp6 = _heliCrew addWaypoint [_dropOffPos, -1];
    private _wp7 = _heliCrew addWaypoint [_dropOffPos, -1];
    _wp7 waypointAttachVehicle _dropOffPosObj;
    _wp7 setWaypointType "UNHOOK";
    _wp7 setWaypointStatements ["true", "vehicle this flyInHeight [50, false]; vehicle this limitSpeed 200;"];


    private _wp8 = _heliCrew addWaypoint [_returnPos, -1];
    _wp8 setWaypointSpeed "FULL";
    _wp8 setWaypointStatements ["true", "vehicle this land 'LAND'"];
    _wp8 waypointAttachVehicle _returnPosObj;

};


/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
// adds the action to every client and JIP, but also adds it when it was already removed. E.g., Laptop has already been hacked by a player

{
    [
    	_x,														// Object the action is attached to
    	'<t color="#690000" size="2.0">Request Airlift for this Vehicle</t>',													// Title of the action
    	"\a3\ui_f\data\igui\cfg\simpleTasks\types\container_ca.paa",	        // Idle icon shown on screen
    	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	        // Progress icon shown on screen
    	"_this distance _target < 3",									        // Condition for the action to be shown
    	"_caller distance _target < 3",									// Condition for the action to progress
    	{},																// Code executed when action starts
    	{},																// Code executed on every progress tick
    	{ [airlift_heli_1_grp, _this select 0, DZ_1, LZ, true] call cvo_fnc_airlift; },							// Code executed on completion
    	{},																// Code executed on interrupted
    	[],																// Arguments passed to the scripts as _this select 3
    	15,																// Action duration in seconds
    	0,																// Priority
    	true,															// Remove on completion
    	false															// Show in unconscious state
    ] remoteExec ["BIS_fnc_holdActionAdd", 0, _x];				        // MP-compatible implementation
   
} forEach [_vehicleToBeAirLifted1];







/*
Potential additions:
- check via configFile >> "CfgVehicles" >> "I_MBT_03_cannon_F" >> "slingLoadCargoMemoryPoints"
if vehicle is sling loadable, if not, then create helper object that gets slung loaded

- Adjustable Ingress/Egress Direction

- Use Linear Conversion for first WP instead of hard coded distance values.

known Issues:
- If Dropzone is close to Landing Zone & DropZone Obj is invisible Helipad, heli will try to land on DZ (on top of the slung obj)

*/



