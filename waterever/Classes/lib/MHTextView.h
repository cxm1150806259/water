//
//  MHTextVIew.h
//  waterever
//
//  Created by qyyue on 2017/9/28.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHTextView : UITextView
@property(nonatomic,strong)NSString *placeholder;
@property(nonatomic,strong)UIColor *placeholderColor;

-(void)addObserver;
@end
