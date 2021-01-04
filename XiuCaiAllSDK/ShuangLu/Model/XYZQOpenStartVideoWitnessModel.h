//
//  OpenStartVideoWitnessModel.h
//  OpenAccount
//
//  Created by xyzq on 17/5/16.
//  Copyright © 2017年 xyzq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYZQOpenStartVideoWitnessModel : NSObject{

}
@property(nonatomic,strong)NSString *anyChatStreamIpOut; // anychat服务器地址
@property(nonatomic,strong)NSString *anyChatStreamPort; // anychat服务器端口
@property(nonatomic,strong)NSString *userName;          // anychat服务器用户登录名
@property(nonatomic,strong)NSString *loginPwd;          // anychat服务器用户登录密码
@property(nonatomic,strong)NSString *roomId;            // anychat服务器房间号
@property(nonatomic,strong)NSString *roomPwd;           // anychat服务器房间密码
@property(nonatomic,strong)NSString *empId;           //  服务器返回的坐席ID 需要加两千万
@property(nonatomic,strong)NSString *remoteId;

@end
