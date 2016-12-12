
Global tileSize = 30
Global maxSize = 5
Global minSize = 3
Global maxArea = 100
Global minArea = 100
Global areaBounds
Global areaCount
Global dim areas[] as area
Global shiftOrigin as shift

Type tile
	
	img as integer
	spr as integer
	posX as integer
	posY as integer
	
endType

Type area
	
	sizeX as integer
	sizeY as integer
	tiles as tile[]
	pos as shift
	sizeXP as integer
	sizeYP as integer
	sizeXPDiff as integer
	sizeYPDiff as integer
	
EndType

Type shift
	
	x as integer
	y as integer
	pX as integer
	pY as integer
	
EndType

Function makeMap()
	
	areaCount = Random( minArea, maxArea )
	// subtract one to account for 0 indexing (assigning integer 0 to .length still means there is an element at the 0 index)
	areas.length = areaCount - 1
	
	for i = 0 to areas.length
		
		// init areas
		areas[i].sizeX = Random( minSize, maxSize )
		areas[i].sizeY = areas[i].sizeX
		
		areaBounds = maxSize * tileSize
		
		if( i = 0 )
		
			ca = Random( 100, 180 )
			cb = Random( 150, 200 )
			cc = Random( 100, 180 )
			
		elseif( Random ( 0, 1 ) = 0 )
			
			ca = ca + Random( 0, 10 )
			if( ca > 180 ) then ca = 180
			cb = cb + Random( 0, 10 )
			if( cb > 200 ) then cb = 200
			cc = cc + Random( 0, 10 )
			if( cc > 180 ) then cc = 180
			
		else
			
			ca = ca - Random( 0, 10 )
			if( ca < 100 ) then ca = 100
			cb = cb - Random( 0, 10 )
			if( cb < 150 ) then cb = 150
			cc = cc - Random( 0, 10 )
			if( cc < 100 ) then cc = 100
			
		endif
		
		// init tiles of area (account for 0 index)
		areas[i].tiles.length = ( areas[i].sizeX * areas[i].sizeY ) - 1
		// tmp vars track placement of tiles X and Y planes wise
		iX = 0
		iY = 0
		for i2 = 0 to areas[i].tiles.length
			
			// init spr
			areas[i].tiles[i2].img = LoadImage("gfx/floor.png")
			areas[i].tiles[i2].spr = CreateSprite(areas[i].tiles[i2].img)
			SetSpriteDepth(areas[i].tiles[i2].spr, 0)
			SetSpriteColor(areas[i].tiles[i2].spr, Random( ( ca - 50 ), ca ), Random( ( cb - 50 ), cb ), Random( ( cc - 50 ), cc ), 255)
			
			// check x plane for bounds, if so, iterate to new plane on y
			if( iX = ( areas[i].sizeX ) )
				iX = 0
				iY = iY + 1
			endif
			
			// set position multiplied by pixel size of sprites (30x30)
			areas[i].tiles[i2].posX = iX * tileSize
			areas[i].tiles[i2].posY = iY * tileSize
			SetSpritePosition( areas[i].tiles[i2].spr, areas[i].tiles[i2].posX, areas[i].tiles[i2].posY )
			
			// iterate on x plane
			iX = iX + 1
			
		next i2
		
	next i
	
	// set shifts (positioning of whole areas in relevance to eachother)
	areas[0].pos.x = 0
	areas[0].pos.y = 0
	areas[0].pos.pX = 0
	areas[0].pos.pY = 0
	areas[0].sizeXP = areas[0].sizeX * tileSize
	areas[0].sizeYP = areas[0].sizeY * tileSize
	areas[0].sizeXPDiff = areaBounds - areas[0].sizeXP
	areas[0].sizeYPDiff = areaBounds - areas[0].sizeYP
	// center view on original area TMP
	SetViewOffset( -widthHalf + ( areas[0].sizeXP / 2 ), -heightHalf + ( areas[0].sizeYP / 2 ) )
	// init shiftOrigin to original area
	shiftOrigin.x = 0
	shiftOrigin.y = 0
	// init other areas' shifts and size*P ( size in x or y pixels )
	for i = 1 to areas.length
		
		// set pos
		shifter()
		areas[i].pos.x = shiftOrigin.x
		areas[i].pos.y = shiftOrigin.y
		areas[i].sizeXP = areas[i].sizeX * tileSize
		areas[i].sizeYP = areas[i].sizeY * tileSize
		areas[i].sizeXPDiff = areaBounds - areas[i].sizeXP
		areas[i].sizeYPDiff = areaBounds - areas[i].sizeYP
		
	next i
	
	// place areas
	for i = 1 to areas.length
		
		tmpX = 0
		tmpY = 0
		
		if( areas[i].pos.x > 0 )
			
			// find position pixels if area is right
			tmpX = areaBounds - areas[0].sizeXPDiff
			for i2 = areas.length to 1 step -1
				
				if( areas[i].pos.x > areas[i2].pos.x and areas[i2].pos.x > 0 and areas[i].pos.y = areas[i2].pos.y )
					
					tmpX = ( tmpX + areaBounds ) - ( areas[i].sizeXPDiff + areas[i2].sizeXPDiff )
					
				endif
				
			next i2
			
		elseif( areas[i].pos.x < 0 )
				
			// find position pixels if area is left
			tmpX = -areaBounds + areas[i].sizeXPDiff
			for i2 = areas.length to 1 step -1
				
				if( areas[i].pos.x < areas[i2].pos.x and areas[i2].pos.x < 0 and areas[i].pos.y = areas[i2].pos.y )
					
					tmpX = ( tmpX - areaBounds ) + ( areas[i].sizeXPDiff + areas[i2].sizeXPDiff )
					
				endif
				
			next i2
			
		endif
		
		if( areas[i].pos.y < 0)
			
			// find position pixels if area is down
			tmpY = areaBounds - areas[0].sizeYPDiff
			for i2 = areas.length to 1 step -1
				
				if( areas[i].pos.y < areas[i2].pos.y and areas[i2].pos.y < 0 and areas[i].pos.x = areas[i2].pos.x )
					
					tmpY = ( tmpY + areaBounds ) - ( areas[i].sizeYPDiff + areas[i2].sizeYPDiff )
					
				endif
				
			next i2
			
		elseif( areas[i].pos.y > 0 )
			
			// find position pixels if areas is up
			tmpY = -areaBounds + areas[i].sizeYPDiff
			for i2 = areas.length to 1 step -1
				
				if( areas[i].pos.y > areas[i2].pos.y and areas[i2].pos.y > 0 and areas[i].pos.x = areas[i2].pos.x )
					
					tmpY = ( tmpY - areaBounds ) + ( areas[i].sizeYPDiff + areas[i2].sizeYPDiff )
					
				endif
				
			next i2
			
		endif
		
		areas[i].pos.pX = tmpX
		areas[i].pos.pY = tmpY
		
	next i
	
	// update new area sprite positions
	for i = 0 to areas.length
		
		for i2 = 0 to areas[i].tiles.length
			
			areas[i].tiles[i2].posX = areas[i].tiles[i2].posX + areas[i].pos.pX
			areas[i].tiles[i2].posY = areas[i].tiles[i2].posY + areas[i].pos.pY
			SetSpritePosition( areas[i].tiles[i2].spr, areas[i].tiles[i2].posX , areas[i].tiles[i2].posY )
			
		next i2
		
	next i
	
EndFunction

Function shifter()
	
	shiftOrigin.x = 0
	shiftOrigin.y = 0
	
	for i = 0 to areas.length
		
		if( areas[i].pos.x = shiftOrigin.x and areas[i].pos.y = shiftOrigin.y )
			
			i = 0
			gosub shiftMake
		
		endif
		
	next i
	
EndFunction

ShiftMake:
// find target shift
	if( Random( 0, 1 ) = 0 )
		
		// shiftX
		if( Random( 0, 1 ) = 0 )
			
			// shiftPos
			shiftOrigin.x = shiftOrigin.x + 1
			
		else
			
			//shiftNeg
			shiftOrigin.x = shiftOrigin.x - 1
			
		endif
		
	else
		
		// shiftY
		if( Random( 0, 1 ) = 0 )
			
			// shiftPos
			shiftOrigin.y = shiftOrigin.y + 1
			
		else
			
			// shiftNeg
			shiftOrigin.y = shiftOrigin.y - 1
			
		endif
		
	endif
return
