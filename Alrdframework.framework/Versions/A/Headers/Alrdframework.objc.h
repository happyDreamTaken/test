// Objective-C API for talking to alrd/alrdframework Go package.
//   gobind -lang=objc alrd/alrdframework
//
// File is generated by gobind. Do not edit.

#ifndef __Alrdframework_H__
#define __Alrdframework_H__

@import Foundation;
#include "ref.h"
#include "Universe.objc.h"


/**
 * export Test
 */
FOUNDATION_EXPORT void AlrdframeworkTest(void);

/**
 * export VpnRemoteWith
 */
FOUNDATION_EXPORT void AlrdframeworkVpnRemoteWith(NSData* _Nullable whitenames, NSString* _Nullable proxyurl, NSString* _Nullable updns, NSString* _Nullable listenurl);

#endif
