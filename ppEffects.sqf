// Nomas' Crimson Red Selected

PP_colorC = ppEffectCreate ["ColorCorrections",1500];
PP_colorC ppEffectEnable true;
PP_colorC ppEffectAdjust [1,1,0,[0.2,-0.2,0.1,0.2],[1.3,-0.5,-1.3,0.5],[0.33,0.33,0.33,0],[0,0,0,0,0,0,4]];
PP_colorC ppEffectCommit 10;
PP_film = ppEffectCreate ["FilmGrain",2000];
PP_film ppEffectEnable true;
PP_film ppEffectAdjust [0.14,1.04,1.77,0.59,0.58,true];
PP_film ppEffectCommit 10;
// Date YYYY-MM-DD-HH-MM: [2035,6,24,8,0]. Overcast: 0.577761. Fog: 0.494346. Fog params: [0.494346,0.013,0] 
// GF PostProcess Editor parameters: Copy the following line to clipboard and click Import in the editor.
//[[false,100,[0.01,0.01,0.34,0.38]],[false,200,[0.01,0.01,false]],[false,300,[0.2,0.2,0.2,1,1,1,1,0.05,0.01,0.05,0.01,0.1,0.1,0.2,0.2]],[true,1500,[1,1,0,[0.2,-0.2,0.1,0.2],[1.3,-0.5,-1.3,0.5],[0.33,0.33,0.33,0],[0,0,0,0,0,0,4]]],[false,500,[0.25]],[true,2000,[0.14,1.04,1.77,0.59,0.58,true]],[false,2500,[1,1,1]]]