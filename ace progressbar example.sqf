/* * Finish/Failure/Conditional are all passed [_args, _elapsedTime, _totalTime, _errorCode]
 *
 * Arguments:
 * 0: Total Time (in game "time" seconds) <NUMBER>
 * 1: Arguments, passed to condition, fail and finish <ARRAY>
 * 2: On Finish: Code called or STRING raised as event. <CODE, STRING>
 * 3: On Failure: Code called or STRING raised as event. <CODE, STRING>
 * 4: (Optional) Localized Title <STRING>
 * 5: Code to check each frame (Optional) <CODE>
 * 6: Exceptions for checking EFUNC(common,canInteractWith) (Optional)<ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [5, [], {Hint "Finished!"}, {hint "Failure!"}, "My Title"] call ace_common_fnc_progressBar
*/




[
    5,                                      // Total Time (in game "time" seconds) <NUMBER>
    [],                                     // Arguments, passed to condition, fail and finish <ARRAY>
    {Hint "Finished!"},                     // On Finish: Code called or STRING raised as event. <CODE, STRING>
    {hint "Failure!"},                      // On Failure: Code called or STRING raised as event. <CODE, STRING>
    "My Title",                             // (Optional) Localized Title <STRING>
    {},                                     // Code to check each frame (Optional) <CODE>
    []                                      // Exceptions for checking EFUNC(common,canInteractWith) (Optional)<ARRAY>

] call ace_common_fnc_progressBar;


[
    _duration,                              // Total Time (in game "time" seconds) <NUMBER>
    [],                                     // Arguments, passed to condition, fail and finish <ARRAY>
    {
        [player] call ace_medical_treatment_fnc_fullHealLocal;
        Hint "You ahve been treated!";
    },                                      // On Finish:  Code called or STRING raised as event. <CODE, STRING>
    {hint "You have been interrupted!"},    // On Failure: Code called or STRING raised as event. <CODE, STRING>
    "Get Treated...",                             // (Optional) Localized Title <STRING>
    {},                                     // Code to check each frame (Optional) <CODE>
    []                                      // Exceptions for checking EFUNC(common,canInteractWith) (Optional)<ARRAY>
] call ace_common_fnc_progressBar;



