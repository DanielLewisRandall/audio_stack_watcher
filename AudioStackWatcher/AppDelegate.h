/*
CoreAudio Monitor - A tool for monitoring the CoreAudio stack
Copyright (C) 2012  Daniel Randall

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#import <Cocoa/Cocoa.h>
#include "AudioDeviceItem.h"
#include "AudioDeviceItems.h"

@interface 
	AppDelegate 
		: NSObject 
			<NSApplicationDelegate,
			NSTableViewDelegate,
			NSTableViewDataSource>
{
	NSPointerArray* aDevices;
	NSImage* InputImage;
	NSImage* DefInputImage;
	NSImage* OutputImage;
	NSImage* DefOutputImage;
	NSImage* SpeakersImage;
	NSImage* HeadphonesImage;
	NSImage* InternalMicImage;
	AudioDeviceItem* DefInputDevice;
	AudioDeviceItem* DefOutputDevice;
	NSTimer* ResampleTimer;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTableView *DevicesTableView;
@property (assign) IBOutlet NSTableColumn *InputColumn;
@property (assign) IBOutlet NSTableColumn *OutputColumn;
@property (assign) IBOutlet NSTableColumn *InJackColumn;
@property (assign) IBOutlet NSTableColumn *OutJackColumn;
@property (assign) IBOutlet NSTableColumn *NameColumn;
@property (assign) IBOutlet NSTableColumn *IdColumn;
@property (assign) IBOutlet NSTableColumn *UidColumn;


- (void)
		resample
			:(NSTimer*)theTimer;


@end
