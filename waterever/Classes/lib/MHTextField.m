//
//  MHTextField.m
//  waterever
//
//  Created by qyyue on 2017/11/6.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHTextField.h"

@implementation MHTextField

-(void)setMhMaxTextCount:(int)mhMaxTextCount{
    _mhMaxTextCount = mhMaxTextCount;
    [self addTarget:self action:@selector(limit:) forControlEvents:UIControlEventEditingChanged];
}

- (void)limit:(UITextField *)textField{
    if(textField.text.length > _mhMaxTextCount){
        textField.text = [textField.text substringToIndex:_mhMaxTextCount];
    }
}

@end
