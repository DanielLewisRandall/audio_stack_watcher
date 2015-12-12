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
#import <CoreAudioKit/CoreAudioKit.h>
#import <CoreAudio/CoreAudio.h>

enum JackState
{
	JackStateUndefined,
	JackStateUnplugged,
	JackStatePluggedIn
};

@interface AudioDeviceItem : NSObject
{
	@public AudioObjectID DeviceID;
	@public bool IsInput;
	@public bool IsOutput;
	@public enum JackState OutJackState;
	@public enum JackState InJackState;
	@public NSString* Name;
	@public NSString* UID;
}

@property (assign) AudioObjectID DeviceID;
@property (assign) bool IsInput;
@property (assign) bool IsOutput;
@property (assign) enum JackState OutJackState;
@property (assign) enum JackState InJackState;
@property (assign) NSString* Name;
@property (assign) NSString* UID;

+(OSStatus) 
	getDefault
		:(bool) isInput
		:(AudioDeviceItem**) ppDevice;

-(OSStatus) 
	setDefault
		:(bool) isInput;

-(bool)
	hasSameID
		:(AudioDeviceItem*) pDevice;

-(OSStatus) 
	getSafetyOffset
		:(bool) isInput
		:(UInt32*) pValue;

-(OSStatus) 
	getBufferSizeFrames
		:(bool) isInput
		:(UInt32*) pValue;

-(OSStatus) 
	getNominalSampleRate
		:(bool) isInput
		:(Float64*) pValue;

-(OSStatus) 
	getProperty
		:(AudioObjectPropertySelector) selector
		:(AudioObjectPropertyScope) scope
		:(AudioObjectPropertyElement) element
		:(UInt32) size
		:(void*) pValue;

-(OSStatus) 
	getMasterProperty
		:(AudioObjectPropertySelector) selector
		:(AudioObjectPropertyScope) scope
		:(UInt32) size
		:(void*) pValue;

-(OSStatus) 
	getGlobalProperty
		:(AudioObjectPropertySelector) selector
		:(UInt32) size
		:(void*) pValue;

-(OSStatus) 
	getScopedProperty
		:(AudioObjectPropertySelector) selector
		:(bool) isInput
		:(AudioObjectPropertyElement) element
		:(UInt32) size
		:(void*) pValue;

-(OSStatus) 
	getScopedMasterProperty
		:(AudioObjectPropertySelector) selector
		:(bool) isInput
		:(UInt32) size
		:(void*) pValue;

-(OSStatus) 
	setProperty
		:(AudioObjectPropertySelector) selector
		:(AudioObjectPropertyScope) scope
		:(AudioObjectPropertyElement) element
		:(UInt32) size
		:(void*) pValue;

-(OSStatus) 
	setMasterProperty
		:(AudioObjectPropertySelector) selector
		:(AudioObjectPropertyScope) scope
		:(UInt32) size
		:(void*) pValue;

-(OSStatus) 
	setGlobalProperty
		:(AudioObjectPropertySelector) selector
		:(UInt32) size
		:(void*) pValue;

-(OSStatus) 
	setScopedProperty
		:(AudioObjectPropertySelector) selector
		:(bool) isInput
		:(AudioObjectPropertyElement) element
		:(UInt32) size
		:(void*) pValue;

-(OSStatus) 
	setScopedMasterProperty
		:(AudioObjectPropertySelector) selector
		:(bool) isInput
		:(UInt32) size
		:(void*) pValue;

-(OSStatus) 
	getVolume
		:(bool) isInput
		:(int) channel
		:(Float32*) pValue;

-(OSStatus) 
	setVolume
		:(bool) isInput
		:(int) channel
		:(Float32) value;

-(OSStatus) 
	getStereoVolume
		:(bool) isInput
		:(Float32*) pValue0
		:(Float32*) pValue1;
		
-(OSStatus) 
	setStereoVolume
		:(bool) isInput
		:(Float32) value0
		:(Float32) value1;

-(void)release;

-(id)init;

-(OSStatus)
	setProperties
		:(AudioObjectID*) pID;

-(bool) 
	hasUID
		:(NSString*) pUID;

@end
