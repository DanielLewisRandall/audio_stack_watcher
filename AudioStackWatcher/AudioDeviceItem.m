/*
AudioStackWatcher - A tool for monitoring the CoreAudio stack
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

#import <CoreAudio/CoreAudio.h>

#import "AudioDeviceItem.h"

#import "AudioDeviceItems.h"

#include "Macros.h"

@implementation AudioDeviceItem

@synthesize DeviceID;
@synthesize IsInput;
@synthesize IsOutput;
@synthesize OutJackState;
@synthesize InJackState;
@synthesize Name;
@synthesize UID;

+(OSStatus) 
	getDefault
		:(bool) isInput
		:(AudioDeviceItem**) ppDevice
{
	OSStatus status = noErr;
	
	AudioObjectID deviceID;
	
	if (!ppDevice)
	{
		return EINVAL;
	}
	
	status = 
		[AudioDeviceItems
			getDefault
				:isInput 
				:&deviceID];

	if (status == noErr)
	{
		*ppDevice = [AudioDeviceItem new];

		if (*ppDevice)
		{
			status =
				[*ppDevice 
					setProperties
						:&deviceID];
		}
		else
		{
			status = ENOMEM;
		}
	}

	return status;
}

-(OSStatus) 
	setDefault
		:(bool) isInput
{
	return
		[AudioDeviceItems
			setDefault
				:isInput 
				:&DeviceID];
}		

-(bool)
	hasSameID
		:(AudioDeviceItem*) pDevice 
{
	return (DeviceID == [pDevice DeviceID]);
}

-(OSStatus) 
	getSafetyOffset
		:(bool) isInput
		:(UInt32*) pValue
{
	return
		[self
			getScopedMasterProperty
				:kAudioDevicePropertySafetyOffset 
				:isInput 
				:sizeof(UInt32) 
				:pValue];
}

-(OSStatus) 
	getBufferSizeFrames
		:(bool) isInput
		:(UInt32*) pValue
{
	return
		[self
			getScopedMasterProperty
				:kAudioDevicePropertyBufferFrameSize 
				:isInput 
				:sizeof(UInt32) 
				:pValue];
}

-(OSStatus) 
	getNominalSampleRate
		:(bool) isInput
		:(Float64*) pValue
{
	return
		[self
			getScopedMasterProperty
				:kAudioDevicePropertyNominalSampleRate 
				:isInput 
				:sizeof(Float64) 
				:pValue];
}

-(OSStatus) 
	getProperty
		:(AudioObjectPropertySelector) selector
		:(AudioObjectPropertyScope) scope
		:(AudioObjectPropertyElement) element
		:(UInt32) size
		:(void*) pValue
{
	return
		[AudioDeviceItems
			getProperty
				:&DeviceID 
				:selector 
				:scope 
				:element 
				:size 
				:pValue];
}

-(OSStatus) 
	getMasterProperty
		:(AudioObjectPropertySelector) selector
		:(AudioObjectPropertyScope) scope
		:(UInt32) size
		:(void*) pValue
{
	return
		[AudioDeviceItems
			getMasterProperty
				:&DeviceID  
				:selector 
				:scope 
				:size 
				:pValue];
}

-(OSStatus) 
	getGlobalProperty
		:(AudioObjectPropertySelector) selector
		:(UInt32) size
		:(void*) pValue
{
	return
		[AudioDeviceItems
			getGlobalProperty
				:&DeviceID  
				:selector 
				:size 
				:pValue];
}

-(OSStatus) 
	getScopedProperty
		:(AudioObjectPropertySelector) selector
		:(bool) isInput
		:(AudioObjectPropertyElement) element
		:(UInt32) size
		:(void*) pValue
{
	return
		[AudioDeviceItems
			getScopedProperty
				:&DeviceID  
				:selector 
				:isInput 
				:element 
				:size 
				:pValue];
}

-(OSStatus) 
	getScopedMasterProperty
		:(AudioObjectPropertySelector) selector
		:(bool) isInput
		:(UInt32) size
		:(void*) pValue
{
	return
		[AudioDeviceItems
			getScopedMasterProperty
				:&DeviceID  
				:selector 
				:isInput 
				:size 
				:pValue];
}

-(OSStatus) 
	setProperty
		:(AudioObjectPropertySelector) selector
		:(AudioObjectPropertyScope) scope
		:(AudioObjectPropertyElement) element
		:(UInt32) size
		:(void*) pValue
{
	return
		[AudioDeviceItems
			setProperty
				:&DeviceID  
				:selector 
				:scope 
				:element 
				:size 
				:pValue];
}

-(OSStatus) 
	setMasterProperty
		:(AudioObjectPropertySelector) selector
		:(AudioObjectPropertyScope) scope
		:(UInt32) size
		:(void*) pValue
{
	return
		[AudioDeviceItems
			setMasterProperty
				:&DeviceID  
				:selector 
				:scope 
				:size 
				:pValue];
}

-(OSStatus) 
	setGlobalProperty
		:(AudioObjectPropertySelector) selector
		:(UInt32) size
		:(void*) pValue
{
	return
		[AudioDeviceItems
			setGlobalProperty
				:&DeviceID  
				:selector 
				:size 
				:pValue];
}

-(OSStatus) 
	setScopedProperty
		:(AudioObjectPropertySelector) selector
		:(bool) isInput
		:(AudioObjectPropertyElement) element
		:(UInt32) size
		:(void*) pValue
{
	return
		[AudioDeviceItems
			setScopedProperty
				:&DeviceID  
				:selector 
				:isInput 
				:element 
				:size 
				:pValue];
}

-(OSStatus) 
	setScopedMasterProperty
		:(AudioObjectPropertySelector) selector
		:(bool) isInput
		:(UInt32) size
		:(void*) pValue
{
	return
		[AudioDeviceItems
			setScopedMasterProperty
				:&DeviceID  
				:selector 
				:isInput 
				:size 
				:pValue];
}

-(OSStatus) 
	getVolume
		:(bool) isInput
		:(int) channel
		:(Float32*) pValue
{
	return
		[AudioDeviceItems
			getVolume
				:&DeviceID  
				:isInput 
				:channel 
				:pValue];
}

-(OSStatus) 
	setVolume
		:(bool) isInput
		:(int) channel
		:(Float32) value
{
	return
		[AudioDeviceItems
			setVolume
				:&DeviceID  
				:isInput 
				:channel 
				:value];
}

-(OSStatus) 
	getStereoVolume
		:(bool) isInput
		:(Float32*) pValue0
		:(Float32*) pValue1
{
	return
		[AudioDeviceItems
			getStereoVolume
				:&DeviceID  
				:isInput 
				:pValue0 
				:pValue1];
}

-(OSStatus) 
	setStereoVolume
		:(bool) isInput
		:(Float32) value0
		:(Float32) value1
{
	return
		[AudioDeviceItems
			setStereoVolume
				:&DeviceID  
				:isInput 
				:value0 
				:value1];
}

-(void)release
{
	if ([self Name])
	{
		[[self Name] release];
	}
	
	if ([self UID])
	{
		[[self UID] release];
	}
	
	[self setName:nil];
	[self setUID:nil];
}

-(id)init
{
	[self setDeviceID:0];
	[self setIsInput:false];
	[self setIsOutput:false];
	[self setName:nil];
	[self setUID:nil];

	return self;
}

-(OSStatus)
	setProperties
		:(AudioObjectID*) pID
{
	OSStatus status = noErr;

	[self setDeviceID:*pID];
	
	NSString* pString = nil;
	
	status = 
		[AudioDeviceItems
			getName
				:pID
				:&pString];		

	[self setName:pString];

	if (status != noErr) 
	{
		return status;
	}
	
	status = 
		[AudioDeviceItems
			getUID
				:pID
				:&pString];		

	[self setUID:pString];

	if (status != noErr) 
	{
		return status;
	}
	
	[self
		setIsInput
			:[AudioDeviceItems 
				isInput
					:pID]];
	
	[self
		setIsOutput
			:[AudioDeviceItems 
				isOutput
					:pID]];
					
	///
	
	enum JackState jackState = JackStateUndefined;
	
	UInt32 stateCode = 0;
		
	[AudioDeviceItems 
		getScopedMasterProperty
			:pID
			:kAudioDevicePropertyDataSource 
			:false 
			:sizeof(UInt32) 
			:&stateCode];

	switch (stateCode)
	{
		case BYTES_TO_DWORD('i', 's', 'p', 'k'):
		{
			jackState = JackStateUnplugged;

			break;
		}
		case BYTES_TO_DWORD('h', 'd', 'p', 'n'):
		{
			jackState = JackStatePluggedIn;

			break;
		}
		default:
		{
			jackState = JackStateUndefined;
		}
	}

	[self
		setOutJackState
			:jackState];

	//
	
	jackState = JackStateUndefined;
	
	stateCode = 0;
		
	[AudioDeviceItems 
		getScopedMasterProperty
			:pID
			:kAudioDevicePropertyDataSource 
			:true 
			:sizeof(UInt32) 
			:&stateCode];

	switch (stateCode)
	{
		case BYTES_TO_DWORD('i', 'm', 'i', 'c'):
		{
			jackState = JackStateUnplugged;

			break;
		}
		case BYTES_TO_DWORD('l', 'i', 'n', 'e'):
		{
			jackState = JackStatePluggedIn;

			break;
		}
		default:
		{
			jackState = JackStateUndefined;
		}
	}

	[self
		setInJackState
			:jackState];

	///
	
	LOGD(
		@"Device[%.08lX] %c.%c \"%@\"", 
		(UInt32)*pID, 
		[self IsInput] ? 'I' : '_',
		[self IsOutput] ? 'O' : '_',
		[self Name]);
/*
	#ifdef _DEBUG
	Float32 left = 0;
	Float32 right = 0;
	[self getStereoVolume:false :&left :&right];
	LOGD(
		@"volume: [%f] [%f]", 
		left,
		right);
	#endif
*/	
	return status;
}


-(bool) 
	hasUID
		:(NSString*) pUID
{
	NSComparisonResult result = 
		[pUID compare:[self UID]];

	return (result == NSOrderedSame); 
}

@end