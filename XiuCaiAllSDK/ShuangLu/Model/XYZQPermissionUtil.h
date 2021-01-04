//
//  PermissionUtil.h
//  Open2.0
//
//  Created by mac on 2016/11/25.
//  Copyright © 2016年 Young. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYZQPermissionUtil : NSObject

- (BOOL)PermissionPhoto:(BOOL)tip;
- (BOOL)PermissionCamera:(BOOL)tip;
- (BOOL)PermissionMicrophone:(BOOL)tip;
- (BOOL)PermissionLocation:(BOOL)tip;
- (BOOL)PermissionCellularNetwork:(BOOL)tip;

@end
