//
//  MHSectionHeaderView.h
//  waterever
//
//  Created by qyyue on 2017/10/9.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHGuidanceGroupModel.h"

typedef enum {
    btnClose,
    btnOpen,
}btnStatus;

@class MHSectionHeaderView;

@protocol MHSectionHeaderViewDelegate <NSObject>

-(void)sectionBtnClicked:(MHSectionHeaderView *)secitonHeaderView;

@end

@interface MHSectionHeaderView : UITableViewHeaderFooterView

@property(nonatomic,strong)MHGuidanceGroupModel *groupModel;

@property(nonatomic,strong)id<MHSectionHeaderViewDelegate>delegate;

@property(nonatomic,assign) btnStatus btnStatus;
@end
