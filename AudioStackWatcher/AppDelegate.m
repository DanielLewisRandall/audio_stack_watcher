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

#import "AppDelegate.h"
#import <CoreAudioKit/CoreAudioKit.h>

#import "AudioDeviceItem.h"
#import "AudioDeviceItems.h"

#include "Macros.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize DevicesTableView;
@synthesize InputColumn;
@synthesize OutputColumn;
@synthesize InJackColumn;
@synthesize OutJackColumn;
@synthesize NameColumn;
@synthesize IdColumn;
@synthesize UidColumn;

- (void)dealloc
{
    if (InputImage)
			[InputImage release];
		
    if (DefInputImage)
			[DefInputImage release];
		
    if (OutputImage)
			[OutputImage release];
		
    if (DefOutputImage)
			[DefOutputImage release];

    if (SpeakersImage)
			[SpeakersImage release];

    if (HeadphonesImage)
			[HeadphonesImage release];

    if (InternalMicImage)
			[InternalMicImage release];

		[self cleanup];
		
		[super dealloc];
}

- (id)init
{
	InputImage = 
		[[NSImage alloc] 
			initWithContentsOfFile:
				[[NSBundle mainBundle] 
					pathForResource:@"Input" 
					ofType:@"png"]];

	DefInputImage = 
		[[NSImage alloc] 
			initWithContentsOfFile:
				[[NSBundle mainBundle] 
					pathForResource:@"DefInput" 
					ofType:@"png"]];

	OutputImage = 
		[[NSImage alloc] 
			initWithContentsOfFile:
				[[NSBundle mainBundle] 
					pathForResource:@"Output" 
					ofType:@"png"]];

	DefOutputImage = 
		[[NSImage alloc] 
			initWithContentsOfFile:
				[[NSBundle mainBundle] 
					pathForResource:@"DefOutput" 
					ofType:@"png"]];
	
	SpeakersImage = 
		[[NSImage alloc] 
			initWithContentsOfFile:
				[[NSBundle mainBundle] 
					pathForResource:@"Speakers" 
					ofType:@"png"]];
	
	HeadphonesImage = 
		[[NSImage alloc] 
			initWithContentsOfFile:
				[[NSBundle mainBundle] 
					pathForResource:@"Headphones" 
					ofType:@"png"]];
	
	InternalMicImage = 
		[[NSImage alloc] 
			initWithContentsOfFile:
				[[NSBundle mainBundle] 
					pathForResource:@"InternalMic" 
					ofType:@"png"]];
	
	return [super init];
}


- (void)cleanup
{
	if (DefInputDevice)
		[DefInputDevice release];

	if (DefOutputDevice)
		[DefOutputDevice release];

	if (aDevices)
		[aDevices release];
		
	DefInputDevice = nil;
	DefOutputDevice = nil;	
	aDevices = nil;
}

- (void)sampleAudioStack
{
	[AudioDeviceItem 
		getDefault
			:true 
			:&DefInputDevice];
	
	[AudioDeviceItem 
		getDefault
			:false 
			:&DefOutputDevice];

	[AudioDeviceItems getList:&aDevices];

	[[self DevicesTableView] setDataSource:self];
	
	[[self DevicesTableView] reloadData];
}

- (void)resampleAudioStack:(NSTimer*)theTimer
{
	[self cleanup];
	
	[self sampleAudioStack];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[self cleanup];
	
	[self sampleAudioStack];
	
	ResampleTimer = 
		[NSTimer 
			scheduledTimerWithTimeInterval:0.1 
			target: self 
			selector: @selector(resampleAudioStack:) 
			userInfo: nil 
			repeats: true];
}

-(BOOL)
	applicationShouldTerminateAfterLastWindowClosed
		:(NSApplication*) sender
{
    return YES;
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	return [aDevices count];
}

-(id)
	tableView
		:(NSTableView *)tableView 
		objectValueForTableColumn:(NSTableColumn *)tableColumn 
		row:(NSInteger)row
{
	AudioDeviceItem* item = [aDevices pointerAtIndex:row];

	if (tableColumn == InputColumn)
	{
		if ([item IsInput])
		{
			return 
				([DefInputDevice DeviceID] == [item DeviceID]) ? 
					DefInputImage : 
					InputImage;
		}
		else 
		{
			return nil;
		}
	}  
	else if (tableColumn == OutputColumn)
	{
		if ([item IsOutput])
		{
			return 
				([DefOutputDevice DeviceID] == [item DeviceID]) ? 
					DefOutputImage : 
					OutputImage;
		}
		else 
		{
			return nil;
		}
	}  
	else if (tableColumn == InJackColumn)
	{
		switch ([item InJackState])
		{
			case JackStatePluggedIn:
			{
				return InputImage;
			}
			case JackStateUnplugged:
			{
				return InternalMicImage;
			}
			default:
			{
				return nil;
			}
		}
	}  
	else if (tableColumn == OutJackColumn)
	{
		switch ([item OutJackState])
		{
			case JackStatePluggedIn:
			{
				return HeadphonesImage;
			}
			case JackStateUnplugged:
			{
				return SpeakersImage;
			}
			default:
			{
				return nil;
			}
		}
	}  
	else if (tableColumn == NameColumn)
	{
		return [item Name];
	}  
	else if (tableColumn == IdColumn)
	{
		return [NSString stringWithFormat:@"%.08lX", [item DeviceID]];
	}  
	else if (tableColumn == UidColumn)
	{
		return [item UID];
	}
	else 
	{
		return nil;
	}  
}		

@end
