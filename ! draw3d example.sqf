
if !(hasInterface) exitwith {};
if (side group player == sideLogic) exitWith {};

private _eh_objects = addMissionEventHandler ["Draw3D",
    {

        private _list = missionNamespace getVariable ["RF_3DHints", []];


        if (count _list > 0) then
        {
            if (count (lxRF_FOBs select {_x distance player < 300}) == 0) exitwith {};
            if (isRemoteControlling player)  exitwith {};


            {
                _x params [
                    ["_object", objNull, [objNull]],
                    ["_distance", 3.0, [0.0]],
                    ["_height",0.0,[0.0]],
                    ["_text1", "", [""]],
                    ["_text2", "", [""]]
                ];

                if (  !isNull _object && alive _object && focusOn distance _object < _distance && vehicle focusOn == focusOn ) then {
                    _addpos = 0;
                    if ((getposatl player)#2 > 100) then {_addpos =  ((getposasl player) select 2);};
                    drawIcon3D [
                        "\a3\UI_f\data\IGUI\Cfg\Actions\arrow_down_gs.paa",
                        [1,1,1,1],
                        [(position _object select 0),(position _object select 1), ( position   _object select 2) + _height + _addpos],
                        0.5,
                        0.5,
                        0,
                        "",
                        0,
                        0.05,
                        "PuristaMedium",
                        "CENTER"
                    ];

                    drawIcon3D [
                        "\lxRF\data_rf\img\3dActions\bck_cross.PAA",
                        [1,1,1,0.6],
                        [(position _object select 0),(position _object select 1), ( position   _object select 2) + _height + _addpos],
                        15,
                        1.5,
                        0,
                        "",
                        0,
                        0.05,
                        "PuristaMedium",
                        "CENTER"
                    ];

                    drawIcon3D [
                        "",
                        [1,1,1,1],
                        [(position _object select 0),(position _object select 1), ( position  _object select 2) + _height + _addpos],
                        2,
                        -1.40,
                        0,
                        _text1,
                        0.3,
                        0.04,
                        "PuristaMedium",
                        "right"
                    ];

                    drawIcon3D [
                        "",
                        [189/255,183/255,108/255,1],
                        [(position _object select 0),(position _object select 1), ( position  _object select 2) + _height + _addpos],
                        2,
                        0.20,
                        0,
                        _object getvariable ["text2",""],
                        0.3,
                        0.03,
                        "PuristaMedium",
                        "RIGHT"
                    ];
                };
            }
            forEach _list;
        };
    }
];
