//
//  WACityCell.m
//  Weather
//
//  Created by Siyana Slavova on 9/5/13.
//  Copyright (c) 2013 Siyana Slavova. All rights reserved.
//

#import "WACityCell.h"

@implementation WACityCell

-(void)setIsInEditMode:(BOOL)isInEditMode
{
    [self willChangeValueForKey:@"isInEditMode"];
    _isInEditMode = isInEditMode;
    [self didChangeValueForKey:@"isInEditMode"];
    [self setNeedsLayout];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
   
    if([self isInEditMode]){
        self.deleteButton.hidden = NO;
    }else{
        self.deleteButton.hidden = YES;
    }
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    UIView *result = [super hitTest:point withEvent:event];
//    
//    if (!result) {
//        for (UIView *subview in self.subviews) {
//            if (CGRectContainsPoint(subview.frame, point)) {
//                if ([subview isKindOfClass:[UIImageView class]]) {
//                    return subview;
//                }
//            }
//        }
//    }
//    
//    return result;
//}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(deleteButtonTappedForCell:)]) {
        [self.delegate deleteButtonTappedForCell:self];
    }
}

@end
