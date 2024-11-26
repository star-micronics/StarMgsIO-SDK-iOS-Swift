//
//  STARScale.h
//  StarMgsIO
//

#import <Foundation/Foundation.h>

#import <StarMgsIO/STARScaleDelegate.h>
#import <StarMgsIO/STARScaleType.h>

#import <CoreBluetooth/CoreBluetooth.h>

typedef NS_ENUM(NSUInteger, STARScaleSetting) {
    STARScaleSettingZeroPointAdjustment
};


@interface STARScale : NSObject<CBPeripheralDelegate>

@property(nonatomic, readonly) NSString * _Nullable name;

@property(nonatomic, readonly) NSString * _Nullable identifier;

@property(nonatomic, readonly) CBPeripheral * _Nullable peripheral;  //private

@property(nonatomic, weak) id<STARScaleDelegate> _Nullable delegate;

@property(nonatomic, readonly) STARScaleType_ENUM scaleType;

- (void)updateSetting:(STARScaleSetting)setting;

@end
