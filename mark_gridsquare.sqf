/*
* Author: xyz
* Marks grid squares with enemies in them every x seconds, enemy and time defined in script
* todo
* - add duplicate marker filter
* - majority group member pos instead of leader pos
*
* Arguments:
*
* Return Value:
* None
*
* Example:
* ['something', player] call cvo_fnc_sth
*
* Public: Yes
*/
```sqf
AI_PRESENCE_SQF = [] spawn {

_EnemySide = independent; //set enemy side.
_TimerValue = 30; //set grid update timer.

   while {count units _EnemySide > 0} do {

        _EnemyGroups = groups _EnemySide;

        {

        _LeaderUnit = leader _x;

        _LeaderGrid = mapGridPosition _LeaderUnit;

        _GridXstr = _LeaderGrid select [0, 3];
        _GridYstr = _LeaderGrid select [3, 3];

        _GridXnum = parseNumber _GridXstr;
        _GridYnum = parseNumber _GridYstr;

        systemchat str [_GridXstr, _GridYstr];

        _GridCenterPos = [100 * _GridXnum + 50, 100 * _GridYnum + 50];

        _GroupName = str group _LeaderUnit + "_Marker";


            _GroupName = str _x;
            
            _GroupMarker = createMarkerLocal [_GroupName, _GridCenterPos];
            _GroupName setMarkerShapeLocal "RECTANGLE";
            _GroupName setMarkerColorLocal "ColorRed";
            _GroupName setMarkerBrushLocal "DiagGrid";
            _GroupName setMarkerSizeLocal [50, 50];
            _GroupName setMarkerAlphaLocal 0.50;
            _GroupName setMarkerPos _GridCenterPos;
            if (_GridXstr == "") then {deleteMarker _GroupName};

        } forEach _EnemyGroups;
        sleep _TimerValue;


        

   };

    if (count units _EnemySide == 0) exitWith {systemchat "no enemies left"};

};
```