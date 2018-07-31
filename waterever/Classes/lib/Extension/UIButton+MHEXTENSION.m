//
//  UIButton+MHEXTENSION.m
//  waterever
//
//  Created by qyyue on 2017/9/8.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "UIButton+MHEXTENSION.h"
#import <objc/runtime.h>

#define MHUIColorFromHex(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s & 0xFF00) >> 8))/255.0 blue:((s & 0xFF))/255.0  alpha:1.0]

@interface UIButton ()

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) NSString *titleString;

@property (nonatomic, assign) NSTimeInterval leaveTime;
@end

@implementation UIButton (MHEXTENSION)
static NSString *displayLinkKey;
static NSString *leaveTimeKey;
static NSString *titleStringKey;

-(void)setDisplayLink:(CADisplayLink *)displayLink{
    
    objc_setAssociatedObject(self, &displayLinkKey, displayLink, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CADisplayLink *)displayLink{
    return  objc_getAssociatedObject(self, &displayLinkKey);
}


-(void)setLeaveTime:(NSTimeInterval)leaveTime{
    objc_setAssociatedObject(self, &leaveTimeKey, @(leaveTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSTimeInterval)leaveTime{
    return  [objc_getAssociatedObject(self, &leaveTimeKey) doubleValue];
}


-(void)setTitleString:(NSString *)titleString{
    objc_setAssociatedObject(self, &titleStringKey, titleString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)titleString{
    
    return objc_getAssociatedObject(self, &titleStringKey);
    
}

-(void)countDownWithTimeInterval:(NSTimeInterval) duration{
    self.titleString=self.currentTitle;
    self.leaveTime = duration;
    self.enabled=NO;
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(countDown)];
    self.displayLink.frameInterval=60;
    [self.displayLink  addToRunLoop: [NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

-(void)countDown{
    self.leaveTime--;
    [self setTitle:[NSString stringWithFormat:@"剩余%d秒",(int)self.leaveTime] forState:UIControlStateDisabled];
    if (self.leaveTime == 0) {
        [self.displayLink invalidate];
        self.displayLink=nil;
        self.enabled=YES;
        [self setTitle:@"重新发送" forState:UIControlStateNormal];
    }    
}

//设置图片和文字的位置
- (void)setbuttonType:(MHCategoryType)type {
    
    [self layoutIfNeeded];
    
    CGRect titleFrame = self.titleLabel.frame;
    CGRect imageFrame = self.imageView.frame;
    
    CGFloat space = titleFrame.origin.x - imageFrame.origin.x - imageFrame.size.width + 5;
    
    if (type == MHCategoryTypeLeft) {
        
        [self setImageEdgeInsets:UIEdgeInsetsMake(0,titleFrame.size.width + space, 0, -(titleFrame.size.width + space))];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -(titleFrame.origin.x - imageFrame.origin.x), 0, titleFrame.origin.x - imageFrame.origin.x)];
        
    } else if(type == MHCategoryTypeBottom) {
        
        [self setImageEdgeInsets:UIEdgeInsetsMake(0,0, titleFrame.size.height + space, -(titleFrame.size.width))];
        
        [self setTitleEdgeInsets:UIEdgeInsetsMake(imageFrame.size.height + space, -(imageFrame.size.width), 0, 0)];
    }
}

@end
