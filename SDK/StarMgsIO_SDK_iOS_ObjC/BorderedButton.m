//
//  BorderedButton.m
//  StarMgsIO_SDK_iOS_ObjC
//

#import "BorderedButton.h"

@implementation BorderedButton

- (void)drawRect:(CGRect)rect
{
    self.layer.cornerRadius = _cornerRadius;
    self.layer.borderWidth = _borderWidth;
    self.layer.borderColor = _borderColor.CGColor;

    [super drawRect:rect];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.layer.borderColor = UIColor.clearColor.CGColor;
    } else {
        self.layer.borderColor = self.titleLabel.textColor.CGColor;
    }
}
@end
