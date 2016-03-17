//
//  UIView+Extension.m
//  Travelling
//
//  Created by Scott_Mr on 15/11/23.
//  Copyright © 2015年 Troll. All rights reserved.
//

#import "UIView+Extension.h"
#import <objc/runtime.h>

static const void *JTLoadingKey = &JTLoadingKey;

@interface UIView ()

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL selector;

@property (nonatomic, assign) id targetLongPress;
@property (nonatomic, assign) SEL selectorLongPress;

@end

@implementation UIView (Extension)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}


- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (UIImage *)convertViewToImage {
   
    UIGraphicsBeginImageContext(self.bounds.size);
    
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}


#pragma mark - 点击事件
- (void)setTarget:(id)target{
    objc_setAssociatedObject(self, "ViewClickOnTarget", target, OBJC_ASSOCIATION_ASSIGN);
}

- (id)target{
    return objc_getAssociatedObject(self, "ViewClickOnTarget");
}

- (void)setSelector:(SEL)selector{
    objc_setAssociatedObject(self, "ViewClickOnSelector", NSStringFromSelector(selector), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SEL)selector{
    return NSSelectorFromString(objc_getAssociatedObject(self, "ViewClickOnSelector"));
}

- (void)addTarget:(id)target action:(SEL)selector{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnEvent:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
    self.userInteractionEnabled = YES;
    self.target = target;
    self.selector = selector;
}

- (void)clickOnEvent:(UITapGestureRecognizer *)tao{
    
    if(self.target && self.selector){
        
        if([self.target respondsToSelector:self.selector]){
            
            // 屏蔽performSelector-leak警告
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.target performSelector:self.selector withObject:self];
        }
    }
}

#pragma mark - 长按手势
- (void)setTargetLongPress:(id)targetLongPress {
    objc_setAssociatedObject(self, @"longPressTarget", targetLongPress, OBJC_ASSOCIATION_ASSIGN);
}

- (id)targetLongPress {
    return objc_getAssociatedObject(self, @"longPressTarget");
}

- (void)setSelectorLongPress:(SEL)selectorLongPress {
    objc_setAssociatedObject(self, @"selectorLongPress", NSStringFromSelector(selectorLongPress), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SEL)selectorLongPress {
    return NSSelectorFromString(objc_getAssociatedObject(self, @"selectorLongPress"));
}

- (void)addLongPressTarget:(id)target withAction:(SEL)selector {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressEvent:)];
    longPress.minimumPressDuration = 1;
    [self addGestureRecognizer:longPress];
    self.userInteractionEnabled = YES;
    self.targetLongPress = target;
    self.selectorLongPress = selector;
}

- (void)longPressEvent:(UILongPressGestureRecognizer *)longPress {
    if(longPress.state == UIGestureRecognizerStateBegan){
        if (self.targetLongPress && self.selectorLongPress) {
            [self.targetLongPress performSelector:self.selectorLongPress withObject:self];
        }
    }
}

@end
