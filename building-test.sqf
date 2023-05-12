nearBuildings = player nearObjects ["House", 50];
{ 


} forEach _nearBuildings;



[
	187d0188b80# 53823: mil_guardhouse_ep1.p3d,
	187d0188100# 53825: fort_watchtower_ep1.p3d,
	185f9027580# 53482: чл*з.
	p3d,186039c0100# 53449: wall_l_2m5_gate_ep1.p3d
]


BIS_fnc_destroyCity
https://community.bistudio.com/wiki/BIS_fnc_destroyCity





Civilians

/*
 * Author: Glowbal
 * Sets a unit in the unconscious state.
 *
 * Arguments:
 * 0: The unit that will be put in an unconscious state <OBJECT>
 * 1: Set unconsciouns <BOOL> (default: true)
 * 2: Minimum unconscious time (set to 0 to ignore) <NUMBER><OPTIONAL> (default: 0)
 * 3: Force wakeup at given time if vitals are stable <BOOL><OPTIONAL> (default: false)
 *
 * Return Value:
 * Success? <BOOLEAN>
 *
 * Example:
 * [bob, true] call ace_medical_fnc_setUnconscious;
 * [player, true, 5, true] call ace_medical_fnc_setUnconscious;
 *
 * Public: Yes
 */



 /*
 * Author: PabstMirror
 * Manually Apply Damage to a unit (can cause lethal damage)
 *
 * Arguments:
 * 0: The Unit <OBJECT>
 * 1: Damage to Add <NUMBER>
 * 2: Body part ("Head", "Body", "LeftArm", "RightArm", "LeftLeg", "RightLeg") <STRING>
 * 3: Projectile Type <STRING>
 * 4: Source <OBJECT>
 * 5: Unused parameter maintained for backwards compatibility <ARRAY> (default: [])
 * 6: Override Invulnerability <BOOL> (default: true)
 *
 * Return Value:
 * Successful <BOOL>
 *
 * Example:
 * [player, 0.8, "rightleg", "bullet"] call ace_medical_fnc_addDamageToUnit
 * [cursorTarget, 1, "body", "stab", player] call ace_medical_fnc_addDamageToUnit
 *
 * Public: Yes
 */

// Types Of Damage for 3 Projectile Type

selectRandom ["Head", "Body", "LeftArm", "RightArm", "LeftLeg", "RightLeg"];
selectRandom ["vehiclecrash", "collision", "falling", "punch", "unkown"];


[
	_obj,
 	random 1, 
	selectRandom ["Head", "Body", "LeftArm", "RightArm", "LeftLeg", "RightLeg"], 
	selectRandom ["vehiclecrash", "collision", "falling", "punch", "unkown"]
] call ace_medical_fnc_addDamageToUnit;

/*
Damage Value


Goals of this script:

1. Destroy A Random Array of Buildings
1.1 Predefine or Randomise?

1.2 Be able to destroy building easily as zeus

2. With each building, spawn random amounts of civilians 0-2.
2.1 Provide Damage to those Civilians
2.1.1 Define random number 1-10.
	Possible Outcomes
	A) no Damage, running away
	Limping?
	B.1)  walking

	B.2) crouching
		-> _x setDamage 0.6 => vanilla damage;
		-> _x setUnitPos "MIDDLE";

	C) Uncon + ACE Wounds
		-> Amount of wounds [2-5]
	
	D) Dead
_obj = player;
_objPos = getPos _obj;
_objPos set [2, (random 5)];
_obj setPos _objPos;
_obj setDamage 1;


Input:

0 Building to be destroyed
1 Amount of Civlians being spawned per Building
2 Types of Civilians, Array Classname
3 Amount of Wounds



/// create array of buildings

selectRandom array
*/

[
	[427.109,9267.15],
	 1000,
	 0.3,
	 3,
	 ["UK3CB_TKC_C_WORKER", "UK3CB_TKC_C_SPOT",	"UK3CB_TKC_C_PILOT", "UK3CB_TKC_C_DOC", "UK3CB_TKC_C_CIV"]
] spawn {

	
	
	params [
		["_centerPos", [0,0,0], [objNull, []], [2,3]],
		["_radius", 1000, [0]],
		["_selectionChance", 0.5, [0]],
		["_numOfCiv", 1, [1,[]], [2]],
		["_civClasses", ["C_man_1"], []]
	];

	private _nearBuildingsSelection = [];
	private _civQty = 0;

	{
		if (random 1 > _selectionChance) then {_nearBuildingsSelection pushBack _x};
	} forEach (_centerPos nearObjects ["House", _radius]);

	diag_log "####### CVO Earthquake Building Array #######";
	diag_log "_nearBuildingsSelection";
	diag_log _nearBuildingsSelection;

	[3] remoteExec ["BIS_fnc_earthquake"];
	{
		sleep random 3;

		// destroy buildling

		_x call BIS_fnc_createRuin;
		[_x, true] remoteExecCall ["hideObject", -2];

		//  spawn Civilian
		diag_log "_civQTY_1";
		diag_log _civQTY;

		if (_numOfCiv isEqualType []) then {

			_civQty =  (round random _numOfCiv#1) min _numOfCiv#0;

		diag_log "_civQTY_2";
		diag_log _civQTY;



		} else { 
			_civQty = _numOfCiv;
			diag_log "_civQTY_3";
			diag_log _civQTY;
		};



		if (_civQty isEqualTo  0) then {continue};

		for "_i" from 1 to _civQty do {

			// Random CIV CLASS
			private "_selectedCivClass";
			if (_civClasses isEqualType []) then {
				_selectedCivClass = selectRandom _civClasses;
			} else {
				_selectedCivClass = _civClasses;
			};

			// Create Group + CIV
			_grp = createGroup [civilian, true];
			_civOBJ = _grp createUnit [_selectedCivClass, _x, [], (1.5 * sizeOf typeOf _x), "NONE"];


			// Define Default behaviour: Walk away far

			_wpTGT = _civOBJ getPos [2000, round random 360];
			while {surfaceIsWater _wpTGT} do {
				_wpTGT = _civOBJ getPos [2000, round random 360];
			};

			_wp = _grp addWaypoint [_wpTGT, 250];
			_wp setWaypointStatements ["true", "{deleteVehicle _x} forEach thisList;"];



			// Define Civ Damage State
			switch (floor random 5) do
				{
					case 1: {
						// Walking Wounded
						_civOBJ setDamage 0.6;
						_civOBJ setUnitPos selectRandom ["UP", "MIDDLE"];

					};
					case 2: {
						// UNCON
						for "_i" from 0 to (5 + round random 10) do {
							[	_civOBJ,
								random 1, 
								selectRandom ["Head", "Body", "LeftArm", "RightArm", "LeftLeg", "RightLeg"], 
								selectRandom ["vehiclecrash", "collision", "falling", "punch", "unkown"]
							] call ace_medical_fnc_addDamageToUnit;
						};
						[_civOBJ,true] call ace_medical_fnc_setUnconscious; 
					};
					case 3: {
						// DEAD
						_objPos = getPos _civOBJ;
						_objPos set [2, (random 5)];
						_civOBJ setPos _objPos;
						_civOBJ setDamage 1;
					};
				};
		}; 





		
	} forEach _nearBuildingsSelection;

};


