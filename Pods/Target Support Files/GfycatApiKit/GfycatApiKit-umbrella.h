#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "GfycatApi.h"
#import "GfycatEventTracker.h"
#import "GfycatApiConstants.h"
#import "GfycatApiKit.h"
#import "GfycatCategory.h"
#import "GfycatConfigurationObject.h"
#import "GfycatExtendedMedia.h"
#import "GfycatMedia.h"
#import "GfycatModel.h"
#import "GfycatModelConstants.h"
#import "GfycatPaginationInfo.h"
#import "GfycatReferencedMedia.h"
#import "GfycatUploadKey.h"
#import "NSDictionary+GfycatApiKit.h"

FOUNDATION_EXPORT double GfycatApiKitVersionNumber;
FOUNDATION_EXPORT const unsigned char GfycatApiKitVersionString[];

