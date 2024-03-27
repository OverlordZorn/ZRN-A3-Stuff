if (getPlayerUID player == "_SP_PLAYER_") then {
	CKN_DEBUG = true;
} else {
	CKN_DEBUG = false;
};

///////////////////////////////////////////////////



if (CKN_DEBUG) then {

	addMusicEventHandler ["MusicStop", {
			params ["_musicClassname", "_ehId"];
			systemChat "[CVO][Music] Stop";
		}
	];
	addMusicEventHandler ["MusicStart", { 
			params ["_musicClassname", "_ehId"];
			systemChat format ["[CVO][Music] Now Playing: %1", _musicClassname];
			if (getAudioOptionVolumes#1 < 0.05) then {
				systemChat format ["[CVO][Music] Your Music Volume is low at %1%2", (getAudioOptionVolumes#1 * 100),"%"];
			}; 
		};
	];

};

///////////////////////////////////////////////////

