//
//  STARDeviceManager.h
//  StarMgsIO
//

#import <Foundation/Foundation.h>

#import "STARDeviceManagerDelegate.h"

@import CoreBluetooth;

@interface STARDeviceManager : NSObject<CBCentralManagerDelegate>

@property(nonatomic, weak) id<STARDeviceManagerDelegate> _Nullable delegate;

@property(nonatomic, readonly) NSString * _Nonnull versionString;

+ (nonnull instancetype)sharedManager;

+ (nullable instancetype)alloc __attribute__((unavailable));
- (nullable instancetype)init __attribute__((unavailable));
+ (nullable instancetype)new __attribute__((unavailable));

- (void)scanForScales;

- (void)stopScan;

- (void)connectScale:(nonnull STARScale *)scale;

- (void)connectScaleWithIdentifier:(nonnull NSString *)identifier;

- (void)disconnectScale:(nonnull STARScale *)scale;

@end
