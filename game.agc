
#include "map.agc"

Function makeGame()
	
	/** init game conditions **/
	gameVictory# = 0
	gameDefeat# = 0
	
	/** init game components **/
	makeMap()
	
EndFunction

Global gameVictory#
Global gameDefeat#
