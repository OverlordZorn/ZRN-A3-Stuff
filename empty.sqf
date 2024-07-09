


This version uses getRelPos to focus placement on or next to the road so that wrecks inside buildings are less likely, and a 25% chance of placing a wreck so its less cluttered. can be changedto a higher chance
```sqf

[   // Input
    [0,0],    // Position Array [0,0] or [0,0,0]
    500,        // Radius in meters
    25          // chance in % 0..100 - affects "density" - higher, more wrecks.
] call {
    
    private _layerID = -1 add3DENLayer "Wrecks";

    params [
        ["_pos",    [0,0,0],    [[]], [2,3] ],
        ["_radius", 500,        [0]         ],
        ["_chance",  25,        [0]         ]
    ];

    private _vicClassArray = [
        "Land_Wreck_Skodovka_F", 
        "UK3CB_Lada_Wreck", 
        "Land_Wreck_UAZ_F",
        "Land_Wreck_Offroad_F",
        "Land_Wreck_Car3_F",   
        "datsun02Wreck", 
        "datsun01Wreck", 
        "hiluxWreck",
        "Land_Wreck_Offroad2_F",
        "Land_Wreck_Car2_F",
        "Land_Wreck_Truck_dropside_F",
        "Land_Wreck_Van_F"
    ];

    {
        if (random 100 <= _chance) then {
            _obj = create3DENEntity [
                "Object", 
                selectRandom _vicClass,
                [  _x getRelPos [[0,5,10], 1]   ]  call BIS_fnc_randomPos
            ];
            _obj set3DENLayer _layerID;
        };

    } forEach nearestTerrainObjects [_pos ,["road"], _radius];
};
```


