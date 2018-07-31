//
//  MHMDTextField.m
//  waterever
//
//  Created by qyyue on 2017/9/21.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHMDTextField.h"

@implementation MHMDTextField

-(void)setMhMaxTextCount:(int)mhMaxTextCount{
    _mhMaxTextCount = mhMaxTextCount;
    [self addTarget:self action:@selector(limit:) forControlEvents:UIControlEventEditingChanged];
}

- (void)limit:(MDTextField *)textField{
    if(textField.text.length > _mhMaxTextCount){
        textField.text = [textField.text substringToIndex:_mhMaxTextCount];
    }
}

@end
