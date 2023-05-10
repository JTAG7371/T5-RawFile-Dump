
// background overlay
itemDef
{
	style			WINDOW_STYLE_FILLED
	rect			0 0 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
	backcolor		0 0 0 0.5 
	visible			1
	decoration
}

// gradient_top
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			0 0 854 75 HORIZONTAL_ALIGN_FULLSCREEN 0
	background		"gradient_top"
	visible			1
	decoration
}

// gradient_bottom
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			0 405 854 75 HORIZONTAL_ALIGN_FULLSCREEN 0
	background		"gradient_bottom"
	visible			1
	decoration
}

#ifndef SINGLE_PLAYER
// lower corner glows
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			0 0 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN;
	background		"menu_mp_background_glow"
	forecolor		0.205 0.165 0.055 0
	exp forecolor	a ( ((sin(milliseconds()/1500) + 1) * 0.25) + 0.25 )
	visible			1
	decoration
}

itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			0 0 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN;
	background		"menu_mp_background_glow"
	forecolor		0.205 0.165 0.055 0
	exp forecolor	a ( ((sin(milliseconds()/480) + 1) * 0.25) + 0.25 )
	visible			1
	decoration
}
#endif //#ifndef SINGLE_PLAYER