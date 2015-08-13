//
//  GestureAdditions.h
//  Crave
//
//  Created by Sony Theakanath on 6/28/15.
//  Copyright (c) 2015 Kuriakose Sony Theakanath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "objc/runtime.h"

@interface UITapGestureRecognizer (SpecPrivate)

@property (strong, nonatomic, readwrite) UIView *mockTappedView_;
@property (assign, nonatomic, readwrite) CGPoint mockTappedPoint_;
@property (strong, nonatomic, readwrite) id mockTarget_;
@property (assign, nonatomic, readwrite) SEL mockAction_;

@end
