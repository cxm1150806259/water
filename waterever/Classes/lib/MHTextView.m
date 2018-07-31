//
//  MHTextVIew.m
//  waterever
//
//  Created by qyyue on 2017/9/28.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHTextView.h"

@implementation MHTextView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChanged) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

-(void)addObserver{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChanged) name:UITextViewTextDidChangeNotification object:self];
}

-(instancetype)init{
    if(self=[super init]){
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChanged) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder=placeholder;
    [self setNeedsDisplay];
}

-(void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor=placeholderColor;
    [self setNeedsDisplay];
}

-(void)setFont:(UIFont *)font{
    [super setFont:font];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if(!self.hasText){
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        
        [attributes setObject:self.placeholderColor==nil?[UIColor grayColor]:self.placeholderColor forKey:NSForegroundColorAttributeName];
        
        if(self.font) [attributes setObject:self.font forKey:NSFontAttributeName];
        
        [self.placeholder drawAtPoint:CGPointMake(5, 8) withAttributes:attributes];
    }
}

-(void)textDidChanged{
    [self setNeedsDisplay];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
