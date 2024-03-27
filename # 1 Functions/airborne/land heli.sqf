params [
    ["_lz",             objNull,                            [objNull]   ],
    ["_heliClass",      "I_Heli_light_03_unarmed_F",        [""]        ],
    ["_side",           "DEFAULT",                          ["", west]  ],
    ["_distance",       5000,                               [0]         ],
    ["_azimuth",        "RAND",                             ["", 0]     ],
    ["_protected",      true,                               [true]      ]
];


private _asl = getposASL _lz select 0;

if (_azimuth isEqualTo "RAND") then {
    _azimuth = 10 * ceil random 36;
};

private _spawnPos = _lz getPosASL [_distance, _azimuth];

private _heli = createVehicle [_heliClass, _spawnPos, [], 0, "FLY"];

if (_side isEqualTo "DEFAULT") then {  createVehicleCrew _heli; } else {    _side createVehicleCrew _heli;  };

private _crew = group driver _heli;

_wp = _crew addWaypoint [_lz, -1];
_wp setWaypointType "MOVE";

_asl = _asl;
_heli flyInHeightASL [_asl,_asl,_asl];


if _protected then { {  _x allowDamage false; } forEach [_heli] + crew _heli ; };

{
    _x params ["_distance", "_speed", "_alt"];

    _condition = { _this#0 distance2D _this#1 < _distance};                // condition - Needs to return bool
    _statement = { 
        _this#0 limitSpeed _speed;
        _this#0 flyInHeight _alt; 
        };                                    // Code to be executed once condition true
    _parameter = [_heli, _lz];                // arguments to be passed on -> _this
    [_condition, _statement, _parameter, 600,_statement] call CBA_fnc_waitUntilAndExecute;

} foreach [
    // distance, speed, alt
    [1500, 200, 50],
    [1200, 180, 50],
    [1000, 160, 50],
    [ 800, 140, 50],
    [ 600, 120, 50],
    [ 400, 100, 50],
    [ 400, 100, 30],
    [ 300,  80, 30],
    [ 200,  70, 20],
    [ 100,  50, 10]
];

_condition = { _this#0 distance2D _this#1 < 10};                // condition - Needs to return bool
_statement = { 
    _this#0 land "GET IN";
    };
_parameter = [_heli, _lz, _spawnPos];                // arguments to be passed on -> _this
[_condition, _statement, _parameter, 600,_statement] call CBA_fnc_waitUntilAndExecute;

/*
_parameter = _this;                                             // arguments to be passed on -> _this
_condition = { _this#0 distance2D _this#1 < 50};                // condition - Needs to return bool
_statement = { 
    _this#0 land "NONE";
    _wp = group driver _this#0 addWaypoint [_spawnPos, 100];
    _wp setWaypointType "MOVE";
    _this#0 limitSpeed 999;
    _this#0 flyinHeight 30;
    };
[_condition, _statement, _parameter, 600,_statement] call CBA_fnc_waitUntilAndExecute;

*/