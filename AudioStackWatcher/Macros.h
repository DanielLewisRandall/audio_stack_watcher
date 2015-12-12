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

#ifndef AudioStackWatcher_Macros_h
	
	#define AudioStackWatcher_Macros_h

	// debug-only logging:
	#ifdef _DEBUG
		#define LOGD(args...) NSLog(args)
	#else
		#define LOGD(args...)
	#endif 

	// no operation (for placing breakpoints in empty space):
	#ifdef _DEBUG
		#define NO_OP asm("NOP");
	#else
		#define NO_OP 
	#endif
	
	// converts 4 characters into a four-char-code:
	#define BYTES_TO_DWORD(_a, _b, _c, _d) \
			( (_d << 0x00) | \
				(_c << 0x08) | \
				(_b << 0x10) | \
				(_a << 0x18) )

#endif
