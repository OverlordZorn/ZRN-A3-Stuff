// if you only spawn them in via ZEUS and not via script or anything you can also add an event handler
// https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#CuratorObjectPlaced

this addEventHandler ["CuratorObjectPlaced", {
	params ["_curator", "_entity"];
    if (typeOf _entity isEqualTo "CUP_O_BTR90_RU") then {
		_entity removeMagazinesTurret ["CUP_400Rnd_30mm_AGS17_M", [0]];
	};
}];




///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////





player spawn { 
 
	private _pos = getPos _this; 
 
	playSound3D [getMissionPath "cvo\fancyIED\sound\burning_fuse_23.ogg", _nade];
	[_pos] execVM "cvo\fancyIED\failedIED_pfx.sqf";

 	"mini_Grenade" createVehicle _pos;
 	sleep 3;

	for "_i" from 1 to (20 + round random 20) do {
		systemChat str _i; 
 
  		_nade = "mini_Grenade" createVehicle _pos; 

		_velX =  selectRandom[-1,1] * (2 + random 3);
		_velY =  selectRandom[-1,1] * (2 + random 3); 
		_velZ =  (2 + random 3); 
		_nade setVelocity [_velX, _velY, _velZ]; 
		sleep ((2 + random 5)/_i); 
 	}; 
};



///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////


player spawn {  
  
 private _pos = getPos _this;  
  
  _nade = "mini_Grenade" createVehicle _pos;
  playSound3D [getMissionPath "cvo\sounds\burning_fuse_23.ogg", _nade,false,(getPos _nade),3,1.4];
  sleep 5; 
 
 for "_i" from 1 to (20 + round random 20) do { 
  systemChat str _i;  
  
    _nade = "mini_Grenade" createVehicle _pos;  
  playSound3D [getMissionPath "cvo\sounds\burning_fuse_23.ogg", _nade,false,(getPos _nade),3,1.4]; 
 
  _velX =  selectRandom[-1,1] * (2 + random 5); 
  _velY =  selectRandom[-1,1] * (2 + random 5);  
  _velZ =  (random 10);  
  _nade setVelocity [_velX, _velY, _velZ];
  _pos = getPos _nade;  
  sleep ((random 10)/_i);  
  };  
};

[] spawn {
private _pos = getPos player;
_pos set [2, _pos#2 + 1];

private _duration = 20;



};

///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////

// make list of fobs + HQ - Format ["name", object];

private _endPointArray pushBack ["HQ", btc_gear_triggerOBJect];

_fobs = count (btc_fobs select 0);

if (_fobs > 0) then {
    for "_i" from 0 to (_fobs-1) do { 
        _array = []; 
        _array pushBack (btc_fobs select 0 select _i); 
        _array pushBack (btc_fobs select 1 select _i);
        _endPointArray pushBack _array;    
    }; 
};


/*
###############################
Open/Close Gate via Trigger + Animation for Gate Guard 
###############################
*/


// on deactivation
cvo_base_gate_1 animate ["Door_1_rot", 1];


// on activation

[(selectRandom thisList), cvo_gate_guard_1, cvo_base_gate_1, [6287.46,7129.08,0.0220032] ] spawn {

params ["_triggerOBJ","_guardOBJ","_gateOBJ", "_guardPos"];

systemChat str _this;
systemChat str thisList;


private _idleArray = [
"Acts_Ambient_Rifle_Drop",
"Acts_Ambient_Stretching",
"Acts_Ambient_Shoelaces",
"Acts_Ambient_Picking_Up",
"Acts_Ambient_Relax_1",
"Acts_Ambient_Relax_2",
"Acts_Ambient_Relax_3",
"Acts_Ambient_Relax_4",
"Acts_Dance_02",
"Acts_Dance_01",
"Acts_Rifle_Operations_Checking_Chamber",
"Acts_Rifle_Operations_Barrel"
];

private _idleArraySelect = [];
_idleArraySelect pushBack selectRandom _idleArray;
_idleArraySelect pushBack selectRandom _idleArray;
_idleArraySelect pushBack selectRandom _idleArray;

_dir = _guardOBJ getDir _triggerOBJ;
_dirGate = _guardOBJ getDir _gateOBJ;

_guardOBJ setPos _guardPos;
sleep 0.1;
_guardOBJ setDir _dir;


_guardOBJ playMove "Acts_Peering_Front";
_guardOBJ playMove "Acts_Peering_Back";
_guardOBJ playMove "Acts_PercMstpSlowWrflDnon_handup2c";

sleep 15;

_guardOBJ setDir _dirGate;
sleep 1;
_guardOBJ playMove "acts_miller_knockout";
sleep 5;
_gateOBJ animate ["Door_1_rot", 0];
sleep 1;

_guardOBJ setDir _dir;
sleep 1;

_guardOBJ playMove "acts_millerChooper_in";
_guardOBJ playMove "acts_millerChopper_loop";
_guardOBJ playMove "acts_millerChopper_out";

{
  _guardOBJ playMove _x;

} forEach _idleArraySelect;
};


//

[player, cvo_gate_guard_1, cvo_base_gate_1, [6287.46,7129.08,0.0220032] ] spawn { 
 
params ["_triggerOBJ","_guardOBJ","_gateOBJ", "_guardPos"]; 
 
systemChat str _this; 
 
 
private _idleArray = [ 
"Acts_Ambient_Rifle_Drop", 
"Acts_Ambient_Stretching", 
"Acts_Ambient_Shoelaces", 
"Acts_Ambient_Picking_Up", 
"Acts_Ambient_Relax_1", 
"Acts_Ambient_Relax_2", 
"Acts_Ambient_Relax_3", 
"Acts_Ambient_Relax_4", 
"Acts_Dance_02", 
"Acts_Dance_01", 
"Acts_Rifle_Operations_Checking_Chamber", 
"Acts_Rifle_Operations_Barrel" 
]; 
 
private _idleArraySelect = []; 
_idleArraySelect pushBack selectRandom _idleArray; 
_idleArraySelect pushBack selectRandom _idleArray; 
_idleArraySelect pushBack selectRandom _idleArray; 
 
_dir = _guardOBJ getDir _triggerOBJ; 
 
 
_guardOBJ setPos _guardPos; 
sleep 0.1; 
_guardOBJ setDir _dir; 
 
 
_guardOBJ playMove "Acts_Peering_Front"; 
_guardOBJ playMove "Acts_Peering_Back"; 
_guardOBJ playMove "Acts_PercMstpSlowWrflDnon_handup2c"; 
 
sleep 15; 
 
_guardOBJ setDir (_guardOBJ getDir _gateOBJ); 
sleep 1; 
_guardOBJ playMove "acts_miller_knockout"; 
sleep 5; 
_gateOBJ animate ["Door_1_rot", 0]; 
sleep 1; 
 
_guardOBJ setDir _dir; 
sleep 1; 
 
_guardOBJ playMove "acts_millerChooper_in"; 
_guardOBJ playMove "acts_millerChopper_loop"; 
_guardOBJ playMove "acts_millerChopper_out"; 
 
{ 
  _guardOBJ playMove _x; 
 
} forEach _idleArraySelect; 
};





ied_tunnel_1_entrance

this addAction ["Exit the Tunnel", {      
  
1 cutText ["","BLACK OUT",1];  
  
sleep 2;  
  
player setPosASL (getPosASL ied_tunnel_1_entrance);   
player setDir 0;  
  
sleep 0.5;    
 
1 cutText ["","BLACK IN",1];  
  
  
}, nil, 1.5, true, true, "", "true", 5, false, "", ""]; 