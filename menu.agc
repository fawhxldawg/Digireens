
Global t0
Global t1
Global t2

Function makeMenu()
	
	/** text **/
	t0 = CreateText("Digireens")
	t1 = CreateText("Play")
	t2 = CreateText("End")
	SetTextSize(t0, 88)
	SetTextSize(t1, 22)
	SetTextSize(t2, 22)
	SetTextColor(t0, 0, 0, 0, 255)
	SetTextColor( t1, 0, 0, 0, 255 )
	SetTextColor( t2, 0, 0, 0, 255 )
	SetTextPosition(t0, ( widthHalf - ( GetTextTotalWidth(t0) / 2 )), ( heightHalf - ( GetTextTotalHeight(t0) * 2.5 )))
	SetTextPosition(t1, ( widthHalf - ( GetTextTotalWidth(t1) / 2 )), ( heightHalf - ( GetTextTotalHeight(t1) / 2 )))
	SetTextPosition(t2, ( widthHalf - ( GetTextTotalWidth(t2) / 2 )), (( heightHalf + 145 ) - ( GetTextTotalHeight(t2) / 2 )))
	
	/** button **/
	AddVirtualButton(1, widthHalf, ( heightHalf ), 100)
	AddVirtualButton(2, widthHalf, ( heightHalf + 145 ), 100)
	
	/** activate **/
	setMenuActive(1)
	
EndFunction

Function setMenuActive(param as integer)
	
	/** screen **/
	if ( param = 1 )
		SetClearColor(255, 255, 255)
		SetBorderColor(0, 0, 0)
		inMenu# = 1
		inGame# = 0
	else
		SetClearColor(0, 0, 0)
		SetBorderColor(0, 0, 0)
		inMenu# = 0
		inGame# = 1
	endif
	ClearScreen()
	
	/** menu **/
	SetTextVisible(t0, param)
	SetTextVisible(t1, param)
	SetTextVisible(t2, param)
	SetVirtualButtonActive(1, param)
	SetVirtualButtonVisible(1, param)
	SetVirtualButtonActive(2, param)
	SetVirtualButtonVisible(2, param)
	
EndFunction
