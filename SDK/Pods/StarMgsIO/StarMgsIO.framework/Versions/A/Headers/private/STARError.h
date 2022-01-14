//
//  STARError.h
//  StarMgsIO
//

#pragma once

static const NSErrorDomain STARErrorDomain = @"jp.star-m.starmgsio";

typedef NS_ENUM(NSInteger, STARErrorCode) {
    STARNotAvailableError = 100,
    STARAlreadyConnectedError = 101,
    STARNotConnectedError = 102,
    STARRequestRejectedError = 103,
    STARUnexpectedDisconnectionError = 104,
    STARTimeoutError = 105,
    STARNotSupportedError = 106,
    STARUnexpectedError = 200
};
