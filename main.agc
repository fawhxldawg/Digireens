
// Project: Digireens 
// Created: 2016-11-12

// show all errors
SetErrorMode(2)

// set window properties
SetWindowTitle( "Digireens" )
SetWindowSize( 980, 640, 0 )

// set display properties
SetVirtualResolution( 980, 640 )
SetOrientationAllowed( 0, 0, 1, 1 )
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery

Global widthHalf
Global heightHalf

widthHalf = GetDeviceWidth() / 2
heightHalf = GetDeviceHeight() / 2

// imports
#include "game.agc"
#include "menu.agc"

makeMenu()

Do
	
	/** controls (menu) **/
	if ( inMenu# = 1 )
		
		if ( GetVirtualButtonReleased(1) = 1 ) // play
			setMenuActive(0)
			makeGame()
		elseif ( GetVirtualButtonReleased(2) = 1 ) // end
			exit
		endif
		
	/** controls (game) :: TODO :: **/
	elseif ( inGame# = 1 )
		
		AddVirtualJoystick( 1, ( widthHalf * 1.66 ), ( heightHalf * 1.5 ), 80 )
		SetPrintSize(20)
		inGame# = 2
		
	elseif ( inGame# = 2 )
		
		SetViewOffset( GetViewOffsetX() + GetVirtualJoystickX(1) * 16, GetViewOffsetY() + GetVirtualJoystickY(1) * 16 )
		Print( "'It looks like an island...'" )
				
	endif
    
    // update screen
    Sync()
Loop

Global inMenu# = 0
Global inGame# = 0
