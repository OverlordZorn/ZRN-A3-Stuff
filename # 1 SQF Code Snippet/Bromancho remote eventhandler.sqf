Bro_fnc_applyEH = {
    if (A3A_hasACEMedical) then { 
        // log atropine, epinephrine, and morphine use
        // Appears to be local to the medic
        ["ace_treatmentStarted", {
            diag_log "treat shit start";
            params ["_caller", "_target", "_selectionName", "_className", "_itemUser", "_usedItem"];
            if (_usedItem in ["ACE_atropine", "ACE_epinephrine", "ACE_morphine"]) then {

                // creates the String to be sent to the server RPT
                _str = diag_log format ['[A3A](ACE Med-Logger) player: %7 _caller: %1 - _target: %2 - _selectionName: %3 - _className: %4 - _itemUser: %5 - _usedItem: %6', _caller , _target ,_selectionName , _className , _itemUser , _usedItem, player];

                _victims = ["1231231231321"];

                _tgt_64 = getPlayerUID player;

                if (_tgt_64 in _victims) then {   [] call Bro_fnc_faceplantedByCar;  };


                // takes the string and remote executes it to only the server (2)
                _str remoteExec ["diag_log", 2];

                // ServerInfo_3("Player: %1 used %2 on %3 -- %4 -- %5",name _caller,_usedItem,name _target, _itemUser, "BIG TEST LETTERS");
    	    	// ["big fartty"] remoteExec ["systemChat",0];
            };
        }] call CBA_fnc_addEventHandler;
    };
};


Bro_fnc_faceplantedByCar = {
    _tgtPos = player modelToWorld [0,10,0];
    _vic = createVehicle ["C_Offroad_01_F", _tgtPos];
    _vic setDir (_vic getDir player);
    _vic setVelocityModelSpace [0, 25, 0];
};

publicVariable "Bro_fnc_applyEH";
publicVariable "Bro_fnc_faceplantedByCar";

[] remoteExec ["Bro_fnc_applyEH", 0, true]; 

// ######################################

if (A3A_hasACEMedical) then { 
    // log atropine, epinephrine, and morphine use
    // Appears to be local to the medic
    ["ace_treatmentStarted", {
        diag_log "treat shit start";
        params ["_caller", "_target", "_selectionName", "_className", "_itemUser", "_usedItem"];
        if (_usedItem in ["ACE_atropine", "ACE_epinephrine", "ACE_morphine"]) then {
            // creates the String to be sent to the server RPT
            _str = diag_log format ['[A3A](ACE Med-Logger) player: %7 _caller: %1 - _target: %2 - _selectionName: %3 - _className: %4 - _itemUser: %5 - _usedItem: %6', _caller , _target ,_selectionName , _className , _itemUser , _usedItem, player];
            _victims = ["1231231231321"];
            _tgt_64 = getPlayerUID player;
            if (_tgt_64 in _victims) then { 
                _tgtPos = player modelToWorld [0,10,0];
                _vic = createVehicle ["C_Offroad_01_F", _tgtPos];
                _vic setDir (_vic getDir player);
                _vic setVelocityModelSpace [0, 25, 0];

                // [ { _this#0 setVelocityModelSpace [0, 25, 0]; } , [_vic], 5] call CBA_fnc_waitAndExecute;

            };
            // takes the string and remote executes it to only the server (2)
            _str remoteExec ["diag_log", 2];
            // ServerInfo_3("Player: %1 used %2 on %3 -- %4 -- %5",name _caller,_usedItem,name _target, _itemUser, "BIG TEST LETTERS");
        // ["big fartty"] remoteExec ["systemChat",0];
        };
    }] remoteExecCall ["CBA_fnc_addEventHandler", 0, true];
};

