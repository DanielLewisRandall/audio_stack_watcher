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

#import <CoreAudio/CoreAudio.h>

#import "AudioDeviceItem.h"

#import "AudioDeviceItems.h"

#include "Macros.h"

@implementation AudioDeviceItems

@synthesize DeviceArray;

+(OSStatus) 
	getDefault
		:(bool) isInput
		:(AudioObjectID*) pDevice
{
	OSStatus status = noErr;
	
	INIT_SIZE(size, AudioDeviceID);
	INIT_ADDR(
		address, 
		isInput ? 
			kAudioHardwarePropertyDefaultInputDevice :
			kAudioHardwarePropertyDefaultOutputDevice);

	status =
		GET_DATA(
			address, 
			size, 
			pDevice);
	
	return status;
}

+(OSStatus) 
	setDefault
		:(bool) isInput
		:(AudioObjectID*) pDevice
{
	OSStatus status = noErr;
	
	INIT_SIZE(size, AudioDeviceID);
	INIT_ADDR(
		address, 
		isInput ? 
			kAudioHardwarePropertyDefaultInputDevice :
			kAudioHardwarePropertyDefaultOutputDevice);

	status =
		SET_DATA(
			address, 
			size, 
			pDevice);
	
	return status;
}

+(OSStatus) 
	getStereoChannels
		:(AudioObjectID*) pDevice
		:(bool) isInput
		:(UInt32*) pChannel0
		:(UInt32*) pChannel1
{
	OSStatus status = noErr;
	
	UInt32 channels[2];

	INIT_SIZE(size, channels);
	
	status = 
		[AudioDeviceItems
			getScopedMasterProperty
				:pDevice 
				:kAudioDevicePropertyPreferredChannelsForStereo 
				:isInput 
				:size 
				:&channels];
	
	if (status == noErr)
	{
		*pChannel0 = channels[0];
		*pChannel1 = channels[1];
	}
	
	return status;
}

// tests for presence of input/output channels.
// BUGBUG: may fail with monophonic devices 
+(bool) 
	hasChannels
		:(AudioObjectID*) pDevice
		:(bool) isInput
{
	OSStatus status = noErr;
	
	UInt32 channels[2];

	INIT_SIZE(size, channels);
	
	status = 
		[AudioDeviceItems
			getScopedMasterProperty
				:pDevice 
				:kAudioDevicePropertyPreferredChannelsForStereo 
				:isInput 
				:size 
				:&channels];
	
	return (status == noErr);
}

+(bool) 
	isInput
		:(AudioObjectID*) pDevice
{
	return 
		[AudioDeviceItems
			hasChannels
			:pDevice 
			:true];
}

+(bool) 
	isOutput
		:(AudioObjectID*) pDevice
{
	return 
		[AudioDeviceItems
			hasChannels
			:pDevice 
			:false];
}

+(OSStatus) 
	getProperty
		:(AudioObjectID*) pDevice
		:(AudioObjectPropertySelector) selector
		:(AudioObjectPropertyScope) scope
		:(AudioObjectPropertyElement) element
		:(UInt32) size
		:(void*) pValue
{
	OSStatus status = noErr;

	INIT_PROP_ADDR(address, selector, scope, element);

	Boolean hasProperty =
		AudioObjectHasProperty(
			*pDevice,
			&address);
	
	if (!hasProperty)
	{
		status = ENOTSUP;
	}
	else
	{
		status = 
			GET_ITEM_DATA(
				*pDevice, 
				address, 
				size, 
				pValue);
	}
	
	return status;
}

+(OSStatus) 
	getMasterProperty
		:(AudioObjectID*) pDevice
		:(AudioObjectPropertySelector) selector
		:(AudioObjectPropertyScope) scope
		:(UInt32) size
		:(void*) pValue
{
	return
		[AudioDeviceItems 
			getProperty
				:pDevice 
				:selector 
				:scope
				:kAudioObjectPropertyElementMaster
				:size				
				:pValue];
}

+(OSStatus) 
	getGlobalProperty
		:(AudioObjectID*) pDevice
		:(AudioObjectPropertySelector) selector
		:(UInt32) size
		:(void*) pValue
{
	return
		[AudioDeviceItems 
			getMasterProperty
				:pDevice 
				:selector 
				:kAudioObjectPropertyScopeGlobal
				:size				
				:pValue];
}

+(OSStatus) 
	getScopedProperty
		:(AudioObjectID*) pDevice
		:(AudioObjectPropertySelector) selector
		:(bool) isInput
		:(AudioObjectPropertyElement) element
		:(UInt32) size
		:(void*) pValue
{
	return
		[AudioDeviceItems 
			getProperty
				:pDevice 
				:selector 
				:(isInput ? 
					kAudioDevicePropertyScopeInput :
					kAudioDevicePropertyScopeOutput)
				:element
				:size				
				:pValue];
}

+(OSStatus) 
	getScopedMasterProperty
		:(AudioObjectID*) pDevice
		:(AudioObjectPropertySelector) selector
		:(bool) isInput
		:(UInt32) size
		:(void*) pValue
{
	return
		[AudioDeviceItems 
			getScopedProperty
				:pDevice 
				:selector 
				:isInput
				:kAudioObjectPropertyElementMaster
				:size				
				:pValue];
}

+(OSStatus) 
	getStringProperty
		:(AudioObjectID*) pDevice
		:(AudioObjectPropertySelector) selector
		:(NSString**) ppValue
{
	OSStatus status = noErr;

	CFStringRef refValue;

	INIT_SIZE(size, refValue);
	
	status = 
		[AudioDeviceItems 
			getGlobalProperty
				:pDevice 
				:selector 
				:size
				:&refValue];
		
	if (status == noErr)
	{
			*ppValue = 
				[[NSString alloc] 
					initWithFormat
						:@"%@",	refValue];			

			CFRelease(refValue);
	}	
	
	return status;
}

+(OSStatus) 
	setProperty
		:(AudioObjectID*) pDevice
		:(AudioObjectPropertySelector) selector
		:(AudioObjectPropertyScope) scope
		:(AudioObjectPropertyElement) element
		:(UInt32) size
		:(void*) pValue
{
	OSStatus status = noErr;
	
	INIT_PROP_ADDR(address, selector, scope, element);

	Boolean hasProperty =
		AudioObjectHasProperty(
			*pDevice,
			&address);
	
	if (!hasProperty)
	{
		status = ENOTSUP;
	}
	else
	{
		status = 
			SET_ITEM_DATA(
				*pDevice, 
				address, 
				size, 
				pValue);
	}
	
	return status;
}

+(OSStatus) 
	setMasterProperty
		:(AudioObjectID*) pDevice
		:(AudioObjectPropertySelector) selector
		:(AudioObjectPropertyScope) scope
		:(UInt32) size
		:(void*) pValue
{
	return
		[AudioDeviceItems 
			setProperty
				:pDevice 
				:selector 
				:scope
				:kAudioObjectPropertyElementMaster
				:size				
				:pValue];
}

+(OSStatus) 
	setGlobalProperty
		:(AudioObjectID*) pDevice
		:(AudioObjectPropertySelector) selector
		:(UInt32) size
		:(void*) pValue
{
	return
		[AudioDeviceItems 
			setMasterProperty
				:pDevice 
				:selector 
				:kAudioObjectPropertyScopeGlobal
				:size				
				:pValue];
}

+(OSStatus) 
	setScopedProperty
		:(AudioObjectID*) pDevice
		:(AudioObjectPropertySelector) selector
		:(bool) isInput
		:(AudioObjectPropertyElement) element
		:(UInt32) size
		:(void*) pValue
{
	return
		[AudioDeviceItems 
			setProperty
				:pDevice 
				:selector 
				:(isInput ? 
					kAudioDevicePropertyScopeInput :
					kAudioDevicePropertyScopeOutput)
				:element
				:size				
				:pValue];
}

+(OSStatus) 
	setScopedMasterProperty
		:(AudioObjectID*) pDevice
		:(AudioObjectPropertySelector) selector
		:(bool) isInput
		:(UInt32) size
		:(void*) pValue
{
	return
		[AudioDeviceItems 
			setScopedProperty
				:pDevice 
				:selector 
				:isInput
				:kAudioObjectPropertyElementMaster
				:size				
				:pValue];
}

+(OSStatus) 
	getVolume
		:(AudioObjectID*) pDevice
		:(bool) isInput
		:(int) channel
		:(Float32*) pValue
{
	return
		[AudioDeviceItems 
			getScopedProperty
				:pDevice 
				:kAudioDevicePropertyVolumeScalar 
				:isInput
				:channel
				:sizeof(Float32)
				:pValue];
}

+(OSStatus) 
	setVolume
		:(AudioObjectID*) pDevice
		:(bool) isInput
		:(int) channel
		:(Float32) value
{
	return
		[AudioDeviceItems 
			setScopedProperty
				:pDevice 
				:kAudioDevicePropertyVolumeScalar 
				:isInput
				:channel
				:sizeof(Float32)
				:&value];
}

+(OSStatus) 
	getStereoVolume
		:(AudioObjectID*) pDevice
		:(bool) isInput
		:(Float32*) pValue0
		:(Float32*) pValue1
{
	OSStatus status = noErr;
	
	UInt32 channel0;
	UInt32 channel1;

	status = 
		[AudioDeviceItems 
			getStereoChannels
				:pDevice 
				:isInput 
				:&channel0 
				:&channel1];

	if (status == noErr)
	{
		// set both channels to the volume value:
		status = 
			[AudioDeviceItems 
				getVolume
					:pDevice 
					:isInput
					:channel0
					:pValue0];
		
		if (status == noErr)
		{
			status = 
				[AudioDeviceItems 
					getVolume
						:pDevice 
						:isInput
						:channel1
						:pValue1];
		}
	}
	
	return status;
}

+(OSStatus) 
	setStereoVolume
		:(AudioObjectID*) pDevice
		:(bool) isInput
		:(Float32) value0
		:(Float32) value1
{
	OSStatus status = noErr;
	
	UInt32 channel0;
	UInt32 channel1;

	status = 
		[AudioDeviceItems 
			getStereoChannels
				:pDevice 
				:isInput 
				:&channel0 
				:&channel1];

	if (status == noErr)
	{
		// set both channels to the volume value:
		status = 
			[AudioDeviceItems 
				setVolume
					:pDevice 
					:isInput
					:channel0
					:value0];
		
		if (status == noErr)
		{
			status = 
				[AudioDeviceItems 
					setVolume
						:pDevice 
						:isInput
						:channel1
						:value1];
		}
	}
	
	return status;
}

+(OSStatus) 
	getUID
		:(AudioObjectID*) pDevice
		:(NSString**) ppUID
{
	return 
		[AudioDeviceItems
			getStringProperty
				:pDevice 
				:kAudioDevicePropertyDeviceUID 
				:ppUID];
}

+(OSStatus) 
	getName
		:(AudioObjectID*) pDevice
		:(NSString**) ppName
{
	return 
		[AudioDeviceItems
			getStringProperty
				:pDevice 
				:kAudioDevicePropertyDeviceNameCFString 
				:ppName];
}

+(bool) 
	hasUID
		:(AudioObjectID*) pDevice
		:(NSString*) pUID
{
	OSStatus status = noErr;
	bool hasUID = false;

	NSString* pDeviceUID = nil;

	status = 
		[AudioDeviceItems 
			getUID
				:pDevice
				:&pDeviceUID];		
	
	if (status == noErr)
	{
		NSComparisonResult result = 
				[pDeviceUID compare:pUID];

		[pDeviceUID release];
		
		hasUID = (result == NSOrderedSame); 
	}
	
	return hasUID;
}

-(OSStatus) 
	setDefaultByUID
		:(bool) isInput
		:(NSString*) pstrUID
{
	OSStatus status = noErr;
	
	AudioObjectID* pDevice = NULL;

	status = 
		[self 
			getByUID
				:pstrUID
				:pDevice];

	if (status == noErr)
	{
		status =
			[AudioDeviceItems 
				setDefault
					:isInput
					:pDevice];
	}	
	
	return status;
}

-(OSStatus) 
	getByUID
		:(NSString*) pUID
		:(AudioObjectID*) pDevice
{
	OSStatus status = ENOTCONN;
	bool bFoundDevice = false;
	
	if (![self DeviceArray])
	{
		return ENOTSUP;
	}

	UInt32 nDevices = 
		[[self DeviceArray] count];
		
	for (UInt32 nDeviceIndex = 0; nDeviceIndex < nDevices; nDeviceIndex++)
	{
		AudioDeviceItem* pItem =
			[[self 
				DeviceArray] 
					pointerAtIndex
						:nDeviceIndex];
		
		bFoundDevice = 
			[pItem 
				hasUID
					:pUID];
					
		if (bFoundDevice)
		{
			*pDevice = [pItem DeviceID];
			
			status = noErr;
			
			break;
		}
	}
	
	#ifdef _DEBUG
	if (!bFoundDevice)
	{
		LOGD(@"ERROR: Device with UID \"%@\" not found.", pUID);
	}
	#endif

	return status;
}

-(OSStatus) 
	getAllByDirection
		:(bool) isInput
		:(bool) isOutput
		:(NSPointerArray**) ppDevices
{
	OSStatus status = noErr;
	
	if (![self DeviceArray])
	{
		return ENOTSUP;
	}

	if (!ppDevices)
	{
		return EINVAL;
	}

	*ppDevices = [NSPointerArray new];
	
	if (!*ppDevices)
	{
		return ENOMEM;
	}
	
	UInt32 nDevices = 
		[[self DeviceArray] count];
		
	for (UInt32 nDeviceIndex = 0; nDeviceIndex < nDevices; nDeviceIndex++)
	{
		bool addDevice = false;

		AudioDeviceItem* pItem =
			[[self 
				DeviceArray] 
					pointerAtIndex
						:nDeviceIndex];
		
		if (isInput)
		{
			addDevice = 
				[pItem 
					IsInput];
		}
		
		if (isOutput)
		{
			addDevice = 
				[pItem 
					IsOutput];
		}					
	
		if (addDevice)
		{
			[*ppDevices addPointer:pItem];
		}
	}
	
	return status;
}

-(OSStatus) 
	getAllInputs
		:(NSPointerArray**) ppDevices
{
	return
		[self 
			getAllByDirection
				:true 
				:false 
				:ppDevices];
}

-(OSStatus) 
	getAllOutputs
		:(NSPointerArray**) ppDevices
{
	return
		[self 
			getAllByDirection
				:false 
				:true 
				:ppDevices];
}

-(OSStatus) 
	getAll
		:(NSPointerArray**) ppDevices
{
	return
		[self 
			getAllByDirection
				:true 
				:true 
				:ppDevices];
}

-(void)release
{
	[self resetList];
}

-(id)init
{
	[self setDeviceArray:nil];
	
	return self;
}

-(void)
	resetList
{
	if ([self DeviceArray])
	{
		UInt32 devices = [[self DeviceArray] count];
		
		for (UInt32 device = 0; device < devices; device++)
		{
			AudioDeviceItem* pItem =
				[[self DeviceArray] pointerAtIndex:device];
				
			if (pItem)
			{			
				[pItem release];	  
			}
		}

		[[self DeviceArray] release];
	}

	[self setDeviceArray:nil];
}

-(OSStatus) 
	buildList 
{		 
	OSStatus status = noErr;
	
	// allow object re-use:
	[self resetList];
	
	UInt32 cbData = 0;
	INIT_ADDR(address, kAudioHardwarePropertyDevices);

	status = 
		GET_SIZE(
			address, 
			cbData); 
	
	if (status == noErr) 
	{
		NSInteger nDevices = 
			(cbData / sizeof(AudioDeviceID));
		
		AudioObjectID* pDevices = 
			(AudioDeviceID*)
				calloc(
					nDevices, 
						sizeof(AudioDeviceID));

		if (!pDevices)
		{
			status = ENOMEM;
		}
		else
		{
			status = 
				GET_DATA(
					address, 
					cbData, 
					pDevices);
					
			if (status == noErr) 
			{
				// init the device array:
				[self setDeviceArray:[NSPointerArray new]];
				
				// populate device array:
				for (UInt32 nDeviceIndex = 0; nDeviceIndex < nDevices; nDeviceIndex++)
				{
					AudioDeviceItem* pDevice = [AudioDeviceItem new];
					
					if (!pDevice)
					{
						status = ENOMEM;
						
						break;
					}
					
					status =
						[pDevice 
							setProperties
								:&pDevices[nDeviceIndex]];

						[[self DeviceArray] addPointer:pDevice];

					if (status != noErr) 
					{
						break;
					}					
				}
			}
			else
			{
				[self resetList];
			}
		
			// free the returned list of IDs:
			free(pDevices);
		}
	}

	return status;
}

// simply returns all audio devices as an NSPointerArray of AudioDeviceItem:
+(OSStatus) 
	getList
		:(NSPointerArray**) ppDevices	 
{		 
	OSStatus status = noErr;
	
	UInt32 cbData = 0;
	INIT_ADDR(address, kAudioHardwarePropertyDevices);

	status = 
		GET_SIZE(
			address, 
			cbData); 
	
	if (status == noErr) 
	{
		NSInteger nDevices = 
			(cbData / sizeof(AudioDeviceID));
		
		AudioObjectID* pDevices = 
			(AudioDeviceID*)
				calloc(
					nDevices, 
						sizeof(AudioDeviceID));

		if (!pDevices)
		{
			status = ENOMEM;
		}
		else
		{
			status = 
				GET_DATA(
					address, 
					cbData, 
					pDevices);
					
			if (status == noErr) 
			{
				// init the device array:
				*ppDevices = [NSPointerArray new];
				
				if (!*ppDevices)
				{
					return ENOMEM;
				}

				// populate device array:
				for (UInt32 nDeviceIndex = 0; nDeviceIndex < nDevices; nDeviceIndex++)
				{
					AudioDeviceItem* pDevice = [AudioDeviceItem new];
					
					if (!pDevice)
					{
						status = ENOMEM;
						
						break;
					}
					
					status =
						[pDevice 
							setProperties
								:&pDevices[nDeviceIndex]];

						[(*ppDevices) addPointer:pDevice];

					if (status != noErr) 
					{
						break;
					}					
				}
			}

			// free the returned list of IDs:
			free(pDevices);
		}
	}

	return status;
}

@end
