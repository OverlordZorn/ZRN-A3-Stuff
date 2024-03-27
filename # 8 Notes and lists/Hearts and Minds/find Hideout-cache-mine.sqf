////////////////////////////////////////////////////////////////////////////
///// Hideout //////


private _Array = [];

// Creates Marker for Hideout

{ 
    _markerName = ("hideout_" + str _forEachIndex);
    _markerPos = getPos _x;
    _marker = createMarkerLocal [_markerName, getPos _x, 0 ];
    _marker setMarkerShapeLocal "ICON";
    _marker setMarkerSizeLocal [1,1];
    _marker setMarkerTextLocal _markerName;
    _marker setMarkerColorLocal "ColorCIV";
    _marker setMarkerTypeLocal "Minefield";

    _Array pushBack _marker;


} forEach ((allMissionObjects "all") select {"Flag_Red_F" == typeOf _x});


////////////////////////////////////////////////////////////////////////////
///// Weapons Cache //////
// Creates Marker for Cache
 
["btc_cache_obj"] remoteExec ["publicVariable", 2];

private _isCBRN = false;

if ( count ((getPos btc_cache_obj) nearObjects 10 select {"CBRN" in (typeOf _x)}) > 0 ) then 
    {    _isCBRN = true;   };

   
_markerName = ("Weapon Cache");  
_markerPos = getPos btc_cache_obj;  
_markerCache = createMarkerLocal [_markerName, _markerPos, 0 ];  
_markerCache setMarkerShapeLocal "ICON";  
_markerCache setMarkerSizeLocal [1,1];
if (_isCBRN) then {
    _markerCache setMarkerTextLocal (_markerName + " !CBRN!") ;  
    _markerCache setMarkerColorLocal "ColorRED";  
    _markerCache setMarkerTypeLocal "MinefieldAP"; 
} else {
    _markerCache setMarkerTextLocal _markerName;  
    _markerCache setMarkerColorLocal "ColorOrange";  
    _markerCache setMarkerTypeLocal "Minefield"; 
};

_Array pushBack _markerCache;


_code = {
    {    deleteMarkerLocal _x;      } forEach (_this#0);
};
[_code, [_Array], 10] call CBA_fnc_waitAndExecute;




////////////////////////////////////////////////////////////////////////////
///// Creates a marker for each MINE //////
 
{  
  _markerName = ("ied_" + str _forEachIndex + " - " + str (typeOf _x)); 
  _markerPos = getPos _x; 
  _marker = createMarkerLocal [_markerName, getPos _x, 0 ]; 
  _marker setMarkerShapeLocal "ICON"; 
  _marker setMarkerSizeLocal [1,1]; 
  _marker setMarkerTextLocal _markerName; 
  _marker setMarkerColorLocal "ColorCIV"; 
  _marker setMarkerTypeLocal "Minefield"; 


 _code = {
    params ["_marker"];
    deleteMarker _marker;
 };
 
 [_code, [_marker], 120] call CBA_fnc_waitAndExecute;
 
} forEach allMines;



 /// TP player to all mines one after another


[] spawn {
    systemChat str (count allMines) + " Mines detected";
    {
        systemChat str _forEachIndex + " / " + str allMines;
        systemChat typeOf _x;
        _minePos = getPos _x;
        player setPos _minePos;

        sleep 5;
    } forEach allMines;
  
};


///////////////////////////
/// deletes all map markers

{    deleteMarker _x;   } forEach allMapMarkers;
