//
//  AFHttpClient+MyDevice.m
//  sebot
//
//  Created by czx on 16/7/5.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "AFHttpClient+MyDevice.h"

@implementation AFHttpClient (MyDevice)
-(void)checkmoel:(NSString *)userid token:(NSString *)token complete:(void (^)(ResponseModel *))completeBlock{
    
    NSMutableDictionary * parms = [[NSMutableDictionary alloc]init];
    parms[@"userid"] = userid;
    parms[@"token"] = token;
    parms[@"objective"] = @"device";
    parms[@"action"] = @"queryUserDeviceInfo";
    NSMutableDictionary * dataparms = [[NSMutableDictionary alloc]init];
    dataparms[@"userid"] = userid;
    parms[@"data"] =dataparms;
    
    [self POST:@"sebot/moblie/forward" parameters:parms result:^(ResponseModel * model) {
        
        model.list = [CheckDeviceModel arrayOfModelsFromDictionaries:model.list];
        
        if (model) {
            completeBlock(model);
        }
        
    }];
    
}

@end