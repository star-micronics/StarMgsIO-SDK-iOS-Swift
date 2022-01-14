//
//  STARScale.h
//  StarMgsIO
//

#import <Foundation/Foundation.h>

#import "STARScaleDelegate.h"

@import CoreBluetooth;

typedef NS_ENUM(NSUInteger, STARScaleSetting) {
    STARScaleSettingZeroPointAdjustment
};


@interface STARScale : NSObject<CBPeripheralDelegate>

@property(nonatomic, readonly) NSString * _Nullable name;

@property(nonatomic, readonly) NSString * _Nullable identifier;

@property(nonatomic, readonly) CBPeripheral * _Nullable peripheral;  //private

@property(nonatomic, weak) id<STARScaleDelegate> _Nullable delegate;

- (void)updateSetting:(STARScaleSetting)setting;

@end
