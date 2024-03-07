yolo = false;
sleep 1;
yolo = true;
private _obj = cursorObject;


private _current = 0;
private _r = 1;
private _g = 0;
private _b = 0;

while {yolo} do {

	for "_i" from 0 to 90 do {
	
		switch _current do 
		{
			case 0: {_r = (round (100 * cos _i))*0.01 ; _g = (round (100 * sin _i))*0.01 ;};
			case 1: {_g = (round (100 * cos _i))*0.01 ; _b = (round (100 * sin _i))*0.01 ;};
			case 2: {_b = (round (100 * cos _i))*0.01 ; _r = (round (100 * sin _i))*0.01 ;};
		};
		uiSleep 0.001; // waits at least 1 frame
    	_textureStr = format ["#(rgb,8,8,3)color(%1,%2,%3,1)",_r, _g, _b];
	    {_obj setObjectTextureGlobal [_x,_textureStr];} forEach [0,1,2,3];
	};	
	_current = switch _current do 
	{
		case 0: {1};
		case 1: {2};
		case 2: {0};
	};
};


// https://streamable.com/py9lcn