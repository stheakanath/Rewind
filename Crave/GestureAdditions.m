//
//  GestureAdditions.m
//  Crave
//
//  Created by Sony Theakanath on 6/28/15.
//  Copyright (c) 2015 Kuriakose Sony Theakanath. All rights reserved.
//

#import "GestureAdditions.h"
#import "objc/runtime.h"

NSString const *MockTappedViewKey = @"MockTappedViewKey";
NSString const *MockTappedPointKey = @"MockTappedPointKey";
NSString const *MockTargetKey = @"MockTargetKey";
NSString const *MockActionKey = @"MockActionKey";

@implementation UITapGestureRecognizer (Spec)

// It is necessary to call the original init method; super does not set appropriate variables.
// (eg, number of taps, number of touches, gods know what else)
// Swizzle our own method into its place. Note that Apple misspells 'swizzle' as 'exchangeImplementation'.
+(void)load {
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(initWithTarget:action:)),
                                   class_getInstanceMethod(self, @selector(initWithMockTarget:mockAction:)));
}

-(id)initWithMockTarget:(id)target mockAction:(SEL)action {
    self = [self initWithMockTarget:target mockAction:action];
    self.mockTarget_ = target;
    self.mockAction_ = action;
    self.mockTappedView_ = nil;
    return self;
}

-(UIView *)view {
    return self.mockTappedView_;
}

-(CGPoint)locationInView:(UIView *)view {
    return [view convertPoint:self.mockTappedPoint_ fromView:self.mockTappedView_];
}

//-(UIGestureRecognizerState)state {
//    return UIGestureRecognizerStateEnded;
//}

-(void)performTapWithView:(UIView *)view andPoint:(CGPoint)point {
    self.mockTappedView_ = view;
    self.mockTappedPoint_ = point;
    
    // warning because a leak is possible because the compiler can't tell whether this method
    // adheres to standard naming conventions and make the right behavioral decision. Suppress it.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.mockTarget_ performSelector:self.mockAction_];
#pragma clang diagnostic pop
    
}

# pragma mark - Who says we can't add members in a category?

- (void)setMockTappedView_:(UIView *)mockTappedView {
    objc_setAssociatedObject(self, &MockTappedViewKey, mockTappedView, OBJC_ASSOCIATION_ASSIGN);
}

-(UIView *)mockTappedView_ {
    return objc_getAssociatedObject(self, &MockTappedViewKey);
}

- (void)setMockTappedPoint_:(CGPoint)mockTappedPoint {
    objc_setAssociatedObject(self, &MockTappedPointKey, [NSValue value:&mockTappedPoint withObjCType:@encode(CGPoint)], OBJC_ASSOCIATION_COPY);
}

- (CGPoint)mockTappedPoint_ {
    NSValue *value = objc_getAssociatedObject(self, &MockTappedPointKey);
    CGPoint aPoint;
    [value getValue:&aPoint];
    return aPoint;
}

- (void)setMockTarget_:(id)mockTarget {
    objc_setAssociatedObject(self, &MockTargetKey, mockTarget, OBJC_ASSOCIATION_ASSIGN);
}

- (id)mockTarget_ {
    return objc_getAssociatedObject(self, &MockTargetKey);
}

- (void)setMockAction_:(SEL)mockAction {
    objc_setAssociatedObject(self, &MockActionKey, NSStringFromSelector(mockAction), OBJC_ASSOCIATION_COPY);
}

- (SEL)mockAction_ {
    NSString *selectorString = objc_getAssociatedObject(self, &MockActionKey);
    return NSSelectorFromString(selectorString);
}

@end
