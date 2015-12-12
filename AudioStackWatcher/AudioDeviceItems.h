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

#import <Foundation/Foundation.h>

// for initializing property sizes:
#define INIT_SIZE(_n, _i) \
	UInt32 _n = sizeof(_i)

// for initializing property addresses:
#define INIT_PROP_ADDR(_n, _s, _c, _e) \
		AudioObjectPropertyAddress _n;     \
		_n.mSelector = _s;                 \
		_n.mScope = _c;                    \
		_n.mElement = _e

// for initializing global property addresses:
#define INIT_ADDR(_n, _s)              \
		INIT_PROP_ADDR(                    \
		_n,                                \
		_s,                                \
		kAudioObjectPropertyScopeGlobal,   \
		kAudioObjectPropertyElementMaster)

// shorthand wrapper for AudioObjectGetPropertyData:
#define GET_ITEM_DATA(_i, _a, _s, _p)  \
	AudioObjectGetPropertyData(          \
		_i,                                \
		&_a,                               \
		0,                                 \
		NULL,                              \
		&_s,                               \
		_p)

// shorthand wrapper for AudioObjectGetPropertyData for system objects:
#define GET_DATA(_a, _s, _p)  \
	GET_ITEM_DATA(kAudioObjectSystemObject, _a, _s, _p)

// shorthand wrapper for AudioObjectSetPropertyData:
#define SET_ITEM_DATA(_i, _a, _s, _p)  \
	AudioObjectSetPropertyData(          \
		_i,                                \
		&_a,                               \
		0,                                 \
		NULL,                              \
		_s,                                \
		_p)

// shorthand wrapper for AudioObjectSetPropertyData for system objects:
#define SET_DATA(_a, _s, _p)  \
	SET_ITEM_DATA(              \
		kAudioObjectSystemObject, \
		_a,                       \
		_s,                       \
		_p)

// shorthand wrapper for AudioObjectGetPropertyDataSize:
#define GET_ITEM_SIZE(_i, _a, _s)   \
		AudioObjectGetPropertyDataSize( \
			_i,                           \
			&_a,                          \
			0,                            \
			NULL,                         \
			&_s);
		
// shorthand wrapper for AudioObjectGetPropertyDataSize for system objects:
#define GET_SIZE(_a, _s)      \
	GET_ITEM_SIZE(              \
		kAudioObjectSystemObject, \
		_a,                       \
		_s)
		
// forward declarations:
@class AudioDeviceItem;

@interface AudioDeviceItems : NSObject
{ 
	@protected NSPointerArray* DeviceArray;
}

@property (assign) NSPointerArray* DeviceArray;

+(OSStatus) 
	getDefault
		:(bool) isInput
		:(AudioObjectID*) pDevice;

+(OSStatus) 
	setDefault
		:(bool) isInput
		:(AudioObjectID*) pDevice;

+(OSStatus) 
	getStereoChannels
		:(AudioObjectID*) pDevice
		:(bool) isInput
		:(UInt32*) pChannel0
		:(UInt32*) pChannel1;

+(bool) 
	hasChannels
		:(AudioObjectID*) pDevice
		:(bool) isInput;

+(bool) 
	isInput
		:(AudioObjectID*) pDevice;

+(bool) 
	isOutput
		:(AudioObjectID*) pDevice;

+(OSStatus) 
	getProperty
		:(AudioObjectID*) pDevice
		:(AudioObjectPropertySelector) selector
		:(AudioObjectPropertyScope) scope
		:(AudioObjectPropertyElement) element
		:(UInt32) size
		:(void*) pValue;

+(OSStatus) 
	getMasterProperty
		:(AudioObjectID*) pDevice
		:(AudioObjectPropertySelector) selector
		:(AudioObjectPropertyScope) scope
		:(UInt32) size
		:(void*) pValue;

+(OSStatus) 
	getGlobalProperty
		:(AudioObjectID*) pDevice
		:(AudioObjectPropertySelector) selector
		:(UInt32) size
		:(void*) pValue;

+(OSStatus) 
	getScopedProperty
		:(AudioObjectID*) pDevice
		:(AudioObjectPropertySelector) selector
		:(bool) isInput
		:(AudioObjectPropertyElement) element
		:(UInt32) size
		:(void*) pValue;

+(OSStatus) 
	getScopedMasterProperty
		:(AudioObjectID*) pDevice
		:(AudioObjectPropertySelector) selector
		:(bool) isInput
		:(UInt32) size
		:(void*) pValue;

+(OSStatus) 
	getStringProperty
		:(AudioObjectID*) pDevice
		:(AudioObjectPropertySelector) selector
		:(NSString**) ppValue;

+(OSStatus) 
	setProperty
		:(AudioObjectID*) pDevice
		:(AudioObjectPropertySelector) selector
		:(AudioObjectPropertyScope) scope
		:(AudioObjectPropertyElement) element
		:(UInt32) size
		:(void*) pValue;

+(OSStatus) 
	setMasterProperty
		:(AudioObjectID*) pDevice
		:(AudioObjectPropertySelector) selector
		:(AudioObjectPropertyScope) scope
		:(UInt32) size
		:(void*) pValue;

+(OSStatus) 
	setGlobalProperty
		:(AudioObjectID*) pDevice
		:(AudioObjectPropertySelector) selector
		:(UInt32) size
		:(void*) pValue;

+(OSStatus) 
	setScopedProperty
		:(AudioObjectID*) pDevice
		:(AudioObjectPropertySelector) selector
		:(bool) isInput
		:(AudioObjectPropertyElement) element
		:(UInt32) size
		:(void*) pValue;

+(OSStatus) 
	setScopedMasterProperty
		:(AudioObjectID*) pDevice
		:(AudioObjectPropertySelector) selector
		:(bool) isInput
		:(UInt32) size
		:(void*) pValue;

+(OSStatus) 
	getVolume
		:(AudioObjectID*) pDevice
		:(bool) isInput
		:(int) channel
		:(Float32*) pValue;

+(OSStatus) 
	setVolume
		:(AudioObjectID*) pDevice
		:(bool) isInput
		:(int) channel
		:(Float32) value;

+(OSStatus) 
	getStereoVolume
		:(AudioObjectID*) pDevice
		:(bool) isInput
		:(Float32*) pValue0
		:(Float32*) pValue1;
		
+(OSStatus) 
	setStereoVolume
		:(AudioObjectID*) pDevice
		:(bool) isInput
		:(Float32) value0
		:(Float32) value1;

+(OSStatus) 
	getUID
		:(AudioObjectID*) pDevice
		:(NSString**) ppUID;

+(OSStatus) 
	getName
		:(AudioObjectID*) pDevice
		:(NSString**) ppName;

+(bool) 
	hasUID
		:(AudioObjectID*) pDevice
		:(NSString*) pUID;

-(OSStatus) 
	setDefaultByUID
		:(bool) isInput
		:(NSString*) pstrUID;

-(OSStatus) 
	getByUID
		:(NSString*) pstrUID
		:(AudioObjectID*) pDevice;

-(OSStatus) 
	getAllByDirection
		:(bool) isInput
		:(bool) isOutput
		:(NSPointerArray**) ppDevices;

-(OSStatus) 
	getAllInputs
		:(NSPointerArray**) ppDevices;

-(OSStatus) 
	getAllOutputs
		:(NSPointerArray**) ppDevices;

-(OSStatus) 
	getAll
		:(NSPointerArray**) ppDevices;

-(void)release;

-(id)init;

-(void)
	resetList;

-(OSStatus) 
	buildList; 

// simply returns all audio devices as an NSPointerArray of AudioDeviceItem:
+(OSStatus) 
	getList
		:(NSPointerArray**) ppDevices;	 

@end
