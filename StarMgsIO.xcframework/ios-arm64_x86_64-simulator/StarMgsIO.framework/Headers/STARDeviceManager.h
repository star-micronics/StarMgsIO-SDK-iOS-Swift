//
//  STARDeviceManager.h
//  StarMgsIO
//

#import <Foundation/Foundation.h>

#import <StarMgsIO/STARDeviceManagerDelegate.h>

#import <CoreBluetooth/CoreBluetooth.h>

@interface STARDeviceManager : NSObject<CBCentralManagerDelegate>

@property(nonatomic, weak) id<STARDeviceManagerDelegate> _Nullable delegate;

@property(nonatomic, readonly) NSString * _Nonnull versionString;

+ (nonnull instancetype)sharedManager;


+ (nonnull instancetype)alloc __attribute__((unavailable));
- (nonnull instancetype)init __attribute__((unavailable));
+ (nonnull instancetype)new __attribute__((unavailable));


- (void)scanForScales;

- (void)stopScan;

- (void)connectScale:(nonnull STARScale *)scale;

- (void)connectScaleWithIdentifier:(nonnull NSString *)identifier;

- (void)disconnectScale:(nonnull STARScale *)scale;

@end
