//
//  STARDeviceManagerDelegate.h
//  StarMgsIO
//

#pragma once

@class STARScale, STARDeviceManager;

@protocol STARDeviceManagerDelegate

- (void)manager:(nonnull STARDeviceManager *)manager didDiscoverScale:(nullable STARScale *)scale error:(nullable NSError *)error;

- (void)manager:(nonnull STARDeviceManager *)manager didConnectScale:(nullable STARScale *)scale error:(nullable NSError *)error;

- (void)manager:(nonnull STARDeviceManager *)manager didDisconnectScale:(nullable STARScale *)scale error:(nullable NSError *)error;

@end
