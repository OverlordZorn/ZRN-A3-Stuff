/////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////  That's stuff to be run on client init  ////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////



DFUNC(toggleZeusFPS) = compileFinal {
    if (isNil QGVAR(pfhID)) then {
        // Subscribe to the FPS monitoring
        [QGVAR(addFrameStatusObserver), clientOwner] call CBA_fnc_serverEvent;

        disableSerialization;

        // Control creation - inspired from ace_common_fnc_displayTextStructured
        private _ctrlHint = (findDisplay 312) ctrlCreate ["RscStructuredText", -1];
        _ctrlHint ctrlSetBackgroundColor (missionNamespace getVariable ["ace_common_displayTextColor", [0, 0, 0, 0.5]]);
        _ctrlHint ctrlSetTextColor (missionNamespace getVariable ["ace_common_displayTextFontColor", [1, 1, 1, 1]]);
        _ctrlHint ctrlEnable false;
        _ctrlHint ctrlCommit 0;

        private _calc = ((safezoneW / safezoneH) min 1.2) / 40;

        _ctrlHint ctrlSetPosition [
            (profilenamespace getVariable ["IGUI_GRID_ACE_displayText_X", (safezoneX + safezoneW) - 12.9 * _calc]) min (safezoneX + safezoneW - 22.5 * _calc),
            profilenamespace getVariable ["IGUI_GRID_ACE_displayText_Y", safeZoneY + 0.175 * safezoneH],
            10 * _calc,
            4 * _calc
        ];
        _ctrlHint ctrlCommit 0;

        uiNamespace setVariable [QGVAR(displayFPS), _ctrlHint];

        GVAR(monitorTime) = time;

        // Display server and clients' FPS
        GVAR(pfhID) = [FUNC(draw3D), _ctrlHint, 0] call CBA_fnc_addPerFrameHandler;
    } else {
        // Stop displaying server and clients' FPS
        ctrlDelete (uiNamespace getVariable [QGVAR(displayFPS), controlNull]);

        // Unsubscribe from the FPS monitoring
        [QGVAR(removeFrameStatusObserver), clientOwner] call CBA_fnc_serverEvent;
    };
};

///////////////////////////////////////////////////////////////////////////////////////////////////////
// For FPS monitoring
["Framework", "Toggle_ZeusFPS", "Toggle Zeus FPS", {
    if (!isNull curatorCamera) then {
        call FUNC(toggleZeusFPS);
        playSound "ClickSoft";
    };
}, "", [DIK_F2, [false, false, false]]] call CBA_fnc_addKeybind;

ACE_player setVariable [QGVAR(runningVersion), productVersion select 7, true];
ACE_player setVariable [QGVAR(currentFPS), diag_fps, true];

[{
    if (GVAR(frameStatusIsRunning)) then {
        ACE_player setVariable [QGVAR(currentFPS), diag_fps, true];
    };
}, [], 1] call CBA_fnc_addPerFrameHandler;

///////////////////////////////////////////////////////////////////////////////////////////////////////
// Display the server FPS in pause menu in the bottom right corner
addUserActionEventHandler ["ingamePause", "Activate", {
    // Only show for admins and host
    if !(isServer || IS_ADMIN || (getPlayerUID player) in EGVAR(Common,allAdmins)) exitWith {};

    [
        {
            !isNull findDisplay 49
        }, {
        // Subscribe to the FPS monitoring
        [QGVAR(addFrameStatusObserver), clientOwner] call CBA_fnc_serverEvent;

        disableSerialization;

        private _pauseMenuDisplay = findDisplay 49;
        private _ctrl = _pauseMenuDisplay ctrlCreate ["RscStructuredText", -1];

        _ctrl ctrlSetPosition [safeZoneX + safeZoneW - PX(20), safeZoneY + safeZoneH - PY(15), PX(30), PY(11)];
        _ctrl ctrlSetFade 0;

        private _fnc_updateFPS = {
            disableSerialization;

            params ["_ctrl"];

            // Remove PFH when the display has been closed
            if (isNull _ctrl) exitWith {
                (_this select 1) call CBA_fnc_removePerFrameHandler;

                // Unsubscribe from the FPS monitoring
                [QGVAR(removeFrameStatusObserver), clientOwner] call CBA_fnc_serverEvent;
            };

            // Get server FPS and display it
            _ctrl ctrlSetStructuredText parseText format ["Server: %1 FPS", (missionNamespace getVariable [QGVAR(serverFPS), -999]) toFixed 2];
        };

        // Run the first time manually
        _ctrl call _fnc_updateFPS;
        _ctrl ctrlCommit 0;

        // Automatically update FPS counter
        [_fnc_updateFPS, _ctrl, 0.5] call CBA_fnc_addPerFrameHandler;
    }] call CBA_fnc_waitUntilAndExecute;
}];


/////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////  That's stuff to be run on client init  ////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////

// Frame rate monitoring
GVAR(frameStatusObservers) = [];

GVAR(frameStatusIsRunning) = false;
publicVariable QGVAR(frameStatusIsRunning);

[QGVAR(addFrameStatusObserver), {
    params ["_owner"];

    GVAR(frameStatusObservers) pushBackUnique _owner;

    // Turn on frame monitoring
    if (!GVAR(frameStatusIsRunning)) then {
        GVAR(frameStatusIsRunning) = true;
        publicVariable QGVAR(frameStatusIsRunning);
    };
}] call CBA_fnc_addEventhandler;

[QGVAR(removeFrameStatusObserver), {
    params ["_owner"];

    GVAR(frameStatusObservers) deleteAt (GVAR(frameStatusObservers) find _owner);

    // Turn off frame monitoring if there are no clients monitoring frames
    if (GVAR(frameStatusIsRunning) && GVAR(frameStatusObservers) isEqualTo []) then {
        GVAR(frameStatusIsRunning) = false;
        publicVariable QGVAR(frameStatusIsRunning);
    };
}] call CBA_fnc_addEventhandler;

// When disconnecting, remove client from observers
addMissionEventHandler ["PlayerDisconnected", {
    [QGVAR(removeFrameStatusObserver), _this select 4] call CBA_fnc_localEvent;
}];

[{
    GVAR(serverFPS) = diag_fps;

    // If someone is monitoring, broadcast FPS values to those observing
    if (GVAR(frameStatusIsRunning)) then {
        GVAR(serverMinFPS) = diag_fpsMin;

        {
            _x publicVariableClient QGVAR(serverMinFPS);
            _x publicVariableClient QGVAR(serverFPS);
        } forEach GVAR(frameStatusObservers);
    };

    // Notify everyone of low frames
    if (GVAR(serverFPS) < 20) then {
        [QGVAR(lowFPSWarning), GVAR(serverFPS)] call CBA_fnc_globalEvent;
    };
}, [], 1] call CBA_fnc_addPerFrameHandler;