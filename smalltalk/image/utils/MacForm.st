'From Smalltalk-80, Version 2.2 of July 4, 1987 on 12 January 1988 at 11:03:38 am'!



!Form methodsFor: 'fileIn/Out'!

writeMacPaint: fileName
	"Saves the receiver on the file fileName in MacPaint format."
	"Form fromUser writeMacPaint: 'form.paint'"

	"The first 512 bytes of the file are the header. The first four bytes
	comprise the version number, followed by 38*8 = 304 bytes of       
	patterns.  The remaining 204 bytes of the header are reserved for
	future expansion. If the version number is zero, the patterns are     
	ignored. Hence, programs that wish to create files to be read into
	MACpaint can just write out 512 bytes of zero as the header.       
	        
	Following the header are 720 compressed scanlines of data which
	form the 576 wide by 720 tall bitmap. The bitmap is compressed as 
	follows:      
		Any run of three or more equal bytes is compressed into a count       
		byte and a single data byte. Runs of unequal bytes are passed
		on literally, preceded also by a count byte, i.e.:      
	        
		<count byte> <data byte>     	count = -1..-127 --> replicate byte 2..128 times       
		<count byte> <n data bytes> 	count =  0.. 127 --> copy 1..128 bytes  
	     uncompressed                    	count = -128 ignored for backward compatibility."



	| file loopIndex rasterNum wordWidth maxHeight formIndex maxFormWordWidth myBits |
	file _ fileName asFilename writeStream.
	file binary.
	myBits _ self bits.
	wordWidth _ width +15 // 16.
	width	< 576 ifTrue: [maxFormWordWidth _ width +15 // 16]	ifFalse: [maxFormWordWidth _ 36].
	height	< 720 ifTrue: [maxHeight _ height]						ifFalse: [maxHeight _ 720].
	loopIndex _ 1.
	[loopIndex <= 512] whileTrue: [file nextPut: 0. loopIndex _ loopIndex + 1].
	rasterNum _ 1.
	formIndex _ 1.
	[rasterNum <= maxHeight] whileTrue: 
		[file nextPut: 71. 
		loopIndex _ 1.
		formIndex _ ((rasterNum - 1) * wordWidth) + 1.
		[loopIndex <= maxFormWordWidth] whileTrue: 
			[file nextWordPut: (myBits at: formIndex). 
			formIndex	_ formIndex	+ 1.
			loopIndex	_ loopIndex	+ 1].
		"loopIndex <= 35 ifTrue: [file nextPut: (255 - 72 - (loopIndex * 2)) asInteger. file nextPut: 0.]."
		[loopIndex <= 36] whileTrue: [file nextWordPut: 0. loopIndex _ loopIndex + 1].
		rasterNum _ rasterNum + 1].

	"If the MacPaint file needs to be padded with blank rasters at the bottom of the picture,
	then pad it with compressed blank rasters..."
	[rasterNum <= 720] whileTrue: 
		[file nextPut: 185.
		file nextPut: 0.	
		rasterNum _ rasterNum + 1].

	file close.! !


!Form class methodsFor: 'instance creation'!

readFormFileFromMacPaint: fileName 
	"Answer an instance of me with bitmap initialized from a MacPaint     
	   file..."
	"(Form readFormFileFromMacPaint: 'form.paint') edit"

	"The first 512 bytes of the file are the header. The first four bytes
	comprise the version number, followed by 38*8 = 304 bytes of       
	patterns.  The remaining 204 bytes of the header are reserved for
	future expansion. If the version number is zero, the patterns are     
	ignored. Hence, programs that wish to create files to be read into
	MACpaint can just write out 512 bytes of zero as the header.       
	        
	Following the header are 720 compressed scanlines of data which
	form the 576 wide by 720 tall bitmap. The bitmap is compressed as 
	follows:      
		Any run of three or more equal bytes is compressed into a count       
		byte and a single data byte. Runs of unequal bytes are passed
		on literally, preceded also by a count byte, i.e.:      
	        
		<count byte> <data byte>     	count = -1..-127 --> replicate byte 2..128 times       
		<count byte> <n data bytes> 	count =  0.. 127 --> copy 1..128 bytes  
	     uncompressed                    	count = -128 ignored for backward compatibility."

	| file form formBits countByte dataByte byteIndex wordIndex loopIndex |
	file _ fileName asFilename readStream.
	file binary.
	form _ self new.
	"Throw away the MacPaint header..."
	loopIndex _ 1.
	[loopIndex <= 512]
		whileTrue: 
			[dataByte _ file next.
			loopIndex _ loopIndex + 1].
	"MacPaint images, by definition, are always  4608 pixels (576 bytes) 
	wide and 720 rasters tall... so the form will have a word array  
	that is of size 576 * 720 / 16."
	form extent: 576 @ 720.
	formBits _ WordArray new: 25920.
	wordIndex _ 1.
	byteIndex _ 1.
	"And now unpack the file..."
	[wordIndex < formBits size]
		whileTrue: 
			[countByte _ file next.
			"Compare against 128, because the data as read in is unsigned..."
			countByte < 128
				ifTrue: 
					"Uncompressed run..."
					[countByte _ countByte + 1.
					loopIndex _ 1.
					[loopIndex <= countByte]
						whileTrue: 
							[loopIndex _ loopIndex + 1.
							dataByte _ file next.
							(byteIndex bitAnd: 1)
								= 1
								ifTrue: [formBits at: wordIndex put: (dataByte bitShift: 8)]
								ifFalse: 
									[formBits at: wordIndex put: (formBits at: wordIndex)
											+ dataByte.
									wordIndex _ wordIndex + 1].
							byteIndex _ byteIndex + 1]]
				ifFalse: 
					"Compressed run..."
					[dataByte _ file next.
					countByte _ 257 - countByte.
					loopIndex _ 1.
					[loopIndex <= countByte]
						whileTrue: 
							[loopIndex _ loopIndex + 1.
							(byteIndex bitAnd: 1)
								= 1
								ifTrue: [formBits at: wordIndex put: (dataByte bitShift: 8)]
								ifFalse: 
									[formBits at: wordIndex put: (formBits at: wordIndex)
											+ dataByte.
									wordIndex _ wordIndex + 1].
							byteIndex _ byteIndex + 1]]].
	form bits: formBits.
	file close.
	^form! !
