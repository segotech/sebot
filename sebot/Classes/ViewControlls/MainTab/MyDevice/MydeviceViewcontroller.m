//
//  MydeviceViewcontroller.m
//  sebot
//
//  Created by yulei on 16/6/15.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "MydeviceViewcontroller.h"
#import "PopView.h"
#import "MyDeviceTableViewCell.h"
#import "DeviceInformationViewController.h"
#import "SaomaoViewController.h"
#import "CheckDeviceModel.h"



@interface MydeviceViewcontroller()<PopDelegate>
{
    
    
    PopView * _popView;
    AppDelegate *app;
    //CheckDeviceModel * checkModel;
    

}


@end



@implementation MydeviceViewcontroller




- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 接收下级界面传回来的值
    
    NSUserDefaults * defults =[NSUserDefaults standardUserDefaults];
    NSString * str =[defults objectForKey:@"s_m_text"];
    
    
    
    
    
}


- (void)viewDidLoad{
    [super viewDidLoad];
    [self setNavTitle: NSLocalizedString(@"tabDevice", nil)];
    self.view.backgroundColor = LIGHT_GRAY_COLOR;
    [self showBarButton:NAV_RIGHT imageName:@"tab_square_press"];
    
     app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _popView = [[PopView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH ,SCREEN_HEIGHT)];
    _popView.center = self.view.center;
    
    _popView.ParentView = app.window;
    _popView.delegate = self;
   
    
    self.dataSource =[NSMutableArray array];
    //[AccountManager sharedAccountManager].loginModel.userid
    
    [[AFHttpClient sharedAFHttpClient] POST:@"sebot/moblie/forward" parameters:@{@"userid" : @"1" , @"objective":@"device", @"token" : @"1" , @"action" : @"queryUserDeviceInfo", @"data" : @{@"userid" : @"1"}} result:^(id model) {
        
        [self.dataSource addObjectsFromArray:model[@"list"]];
        
        //  测试
        /*
        for (CheckDeviceModel * checkModel in  self.dataSource) {
            NSLog(@"===%@",checkModel);
            
        }
         */
        
        
        [self.tableView reloadData];
    }];
    


}

/**
 *  继承
 */
- (void)setupView
{
    
    [super setupView];
    
}

- (void)setupData

{
    
    [super setupData];
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
   // self.tableView.scrollEnabled = NO;
    
    
    self.tableView.showsVerticalScrollIndicator   = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.tableView.tableHeaderView =[[UIView alloc]initWithFrame:CGRectZero];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }

    
    
}

- (void)doRightButtonTouch
{
    
    [self.view addSubview:_popView];

}




/**
 *  pop 代理
 */

- (void)saomaMehod
{
    
    NSLog(@"11");
    SaomaoViewController * saomoVC =[[SaomaoViewController alloc]initWithNibName:@"SaomaoViewController" bundle:nil];
    [self.navigationController pushViewController:saomoVC animated:YES];
    
    
}
- (void)cancelMehod
{
    
    NSLog(@"22");
    [_popView removeFromSuperview];
}
/**
 *  绑定
 */
- (void)sureMehod
{

    [[AFHttpClient sharedAFHttpClient]POST:@"sebot/moblie/forward" parameters:@{@"userid" : @"1" , @"objective":@"device", @"token" : @"1",@"action":@"requestBinding",@"data":@{@"userid":@"1",@"deviceno":@"9000000006"}} result:^(id model) {
        
        NSLog(@"%@",model[@"retDesc"]);
        [_popView removeFromSuperview];
        [self showSuccessHudWithHint:model[@"retDesc"]];
        
        
    }];
    
    
    
    
}


#pragma Marr ------ UITableViewDelegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55*W_Hight_Zoom;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    CheckDeviceModel *checkModel = [CheckDeviceModel modelWithDictionary:(NSDictionary *)self.dataSource[indexPath.row]];
        static NSString * showUserInfoCellIdentifier = @"MydeviceList";
    MyDeviceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:showUserInfoCellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyDeviceTableViewCell" owner:self options:nil]lastObject];
    }
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     cell.numberLable.text =checkModel.deviceno;
    // ds001 红色
    if ([checkModel.status  isEqualToString:@"ds0001"]) {
        // 可以去开启视频
        
        [cell.VideoStateBtn setImage:[UIImage imageNamed:@"launguide.jpg"] forState:UIControlStateNormal];
        
    }else
    {
        // 灰色  不能开启
        
       // [cell.VideoStateBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
    }
    
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CheckDeviceModel *checkModel = [CheckDeviceModel modelWithDictionary:(NSDictionary *)self.dataSource[indexPath.row]];
    DeviceInformationViewController * inforationVC =[[DeviceInformationViewController alloc]initWithNibName:@"DeviceInformationViewController" bundle:nil];
    inforationVC.didNumber = checkModel.did;
    [self.navigationController pushViewController:inforationVC animated:YES];
    
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}




@end
