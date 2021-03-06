//
//  DeviceInformationViewController.m
//  sebot
//
//  Created by yulei on 16/6/16.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "DeviceInformationViewController.h"
#import "FamilyTeamViewController.h"
#import "InCallViewController.h"
#import "CheckDeviceModel.h"


@interface DeviceInformationViewController ()
{
    
     UIImageView * _heandBtn;
     CheckDeviceModel * checkmodel;
     NSString * strDid;
     NSString * strName;
     dispatch_source_t timer3;
    
}

@end

@implementation DeviceInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // sip登陆。
    
    [SephoneManager addProxyConfig:[AccountManager sharedAccountManager].loginModel.sipno password:[AccountManager sharedAccountManager].loginModel.sippw domain:@"www.segosip001.cn"];
    

    [self setNavTitle: NSLocalizedString(@"tabDevice", nil)];
    self.view.backgroundColor = LIGHT_GRAY_COLOR;
    self.dataSource =[NSMutableArray array];
    self.dicSource =[NSMutableArray array];
    
   
    NSArray * arrName =@[NSLocalizedString(@"deviceNumber", nil),NSLocalizedString(@"repairName", nil),NSLocalizedString(@"familyTeam", nil)];
    [self.dicSource addObjectsFromArray:arrName];

    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            // 许可对话没有出现，发起授权许可
            
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                
                if (granted) {
                    //第一次用户接受
                }else{
                    //用户拒绝
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            // 已经开启授权，可继续
            
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            // 用户明确地拒绝授权，或者相机设备无法访问
            
            break;
        default:
            break;
    }
    
    

    //麦克风
    
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        
        if (granted) {
            
            // 用户同意获取麦克风
             NSLog(@"用户同意获取麦克风");
            
        } else {
            
            // 用户不同意获取麦克风
            NSLog(@"用户不同意");
            
        }
        
    }];
    

    
}

/**
 *  通知  内存 处理
 *
 *  @param animated diss
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super  viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callUpdate:) name:kSephoneCallUpdate object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registrationUpdate:) name:kSephoneRegistrationUpdate object:nil];
    

}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSephoneCallUpdate object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kSephoneRegistrationUpdate object:nil];
     dispatch_source_cancel(timer3);
    
    
}

// 注册消息处理
- (void)registrationUpdate:(NSNotification *)notif {
    SephoneRegistrationState state = [[notif.userInfo objectForKey:@"state"] intValue];
    // SephoneProxyConfig *cfg = [[notif.userInfo objectForKey:@"cfg"] pointerValue];
    // Only report bad credential issue
    switch (state) {
            
        case SephoneRegistrationNone:
            
            NSLog(@"======开始");
            break;
        case SephoneRegistrationProgress:
            NSLog(@"=====注册进行");
            break;
        case SephoneRegistrationOk:
            
            NSLog(@"=======成功");
            break;
        case SephoneRegistrationCleared:
            NSLog(@"======注销成功");
            break;
        case SephoneRegistrationFailed:
            NSLog(@"========OK 以外都是失败");
            break;
            
        default:
            break;
    }
    
}


// 通话状态处理
- (void)callUpdate:(NSNotification *)notif {
    SephoneCall *call = [[notif.userInfo objectForKey:@"call"] pointerValue];
    SephoneCallState state = [[notif.userInfo objectForKey:@"state"] intValue];
    
    switch (state) {
        case SephoneCallOutgoingInit:{
            // 成功
         InCallViewController *   _incallVC =[[InCallViewController alloc]initWithNibName:@"InCallViewController" bundle:nil];
            _incallVC.titileStr = strName;
            [_incallVC setCall:call];
            [self presentViewController:_incallVC animated:YES completion:nil];
            break;
        }
            
        case SephoneCallStreamsRunning: {
            break;
        }
        case SephoneCallUpdatedByRemote: {
            break;
        }
            
        default:
            break;
    }
}



- (void)setupView
{
    
    [super setupView];
    [self request];
    
    
}



- (void)request
{
    NSTimeInterval period = 10.0; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    timer3 = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer3, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(timer3, ^{
        
        [self requestMain];
        NSLog(@"sure");
    });
    dispatch_source_set_cancel_handler(timer3, ^{
        NSLog(@"cancel");
        
    });
    
    dispatch_resume(timer3);
    
    
  
    
    
    
}



- (void)requestMain
{
    
    NSString * str1 =[AccountManager sharedAccountManager].loginModel.userid;
    [[AFHttpClient sharedAFHttpClient]deciveInforamtion:str1 token:str1 did:self.didNumber complete:^(ResponseModel * model) {
        
        [self.dataSource removeAllObjects];
        checkmodel =[[CheckDeviceModel alloc]initWithDictionary:model.retVal error:nil];
        
        NSString * str = model.retVal[@"status"];
        
        // 设备状态 UIbutton
        if ([str isEqualToString:@"ds001"]) {
            
            _heandBtn.image =[UIImage imageNamed:@"on_line"];
            _startBtn.selected = YES;
            _startBtn.backgroundColor =RED_COLOR;
            
        }else if ([str isEqualToString:@"ds002"])
            
        {
            _heandBtn.image =[UIImage imageNamed:@"off_line"];
            _startBtn.selected = NO;
        }else
        {
            _heandBtn.image =[UIImage imageNamed:@"on_connection"];
            _startBtn.selected = NO;
            
        }
        
        
        //        if (page == START_PAGE_INDEX) {
        [self.dataSource removeAllObjects];
        checkmodel =[[CheckDeviceModel alloc]initWithDictionary:model.retVal error:nil];
        //        } else {
        //            checkmodel =[[CheckDeviceModel alloc]initWithDictionary:model.retVal error:nil];
        //        }
        
        //        if (model.list.count < REQUEST_PAGE_SIZE){
        //            self.tableView.mj_footer.hidden = YES;
        //        }else{
        //            self.tableView.mj_footer.hidden = NO;
        //        }
        
        [self.tableView reloadData];
        [self handleEndRefresh];
        
        
    }];
    
    
}



-(void)loadDataSourceWithPage:(int)page{
    NSString * str1 =[AccountManager sharedAccountManager].loginModel.userid;
    [[AFHttpClient sharedAFHttpClient]deciveInforamtion:str1 token:str1 did:self.didNumber complete:^(ResponseModel * model) {
        NSString * str = model.retVal[@"status"];
        // 设备状态 UIbutton
        if ([str isEqualToString:@"ds001"]) {
            _heandBtn.image =[UIImage imageNamed:@"on_line"];
            _startBtn.selected = YES;
            _startBtn.backgroundColor =RED_COLOR;
            
        }else if ([str isEqualToString:@"ds002"])
        {
            _heandBtn.image =[UIImage imageNamed:@"off_line"];
            _startBtn.selected = NO;
        }else
        {
            _heandBtn.image =[UIImage imageNamed:@"on_connection"];
            _startBtn.selected = NO;
        }

        if (page == START_PAGE_INDEX) {
            [self.dataSource removeAllObjects];
             checkmodel =[[CheckDeviceModel alloc]initWithDictionary:model.retVal error:nil];
        } else {
            checkmodel =[[CheckDeviceModel alloc]initWithDictionary:model.retVal error:nil];
        }
        
        if (model.list.count < REQUEST_PAGE_SIZE){
            self.tableView.mj_footer.hidden = YES;
        }else{
            self.tableView.mj_footer.hidden = NO;
        }
        
        [self.tableView reloadData];
        [self handleEndRefresh];
        
    }];
    
}



- (void)setupData
{
    
    [super setupData];
    UIView  * _headView = [[UIView alloc]initWithFrame:CGRectMake(0* W_Wide_Zoom, 0 * W_Hight_Zoom, 375 * W_Wide_Zoom, 260 * W_Hight_Zoom)];
    _headView.backgroundColor =GRAY_COLOR;
    [self.view addSubview:_headView];
    _heandBtn =[[UIImageView alloc]initWithFrame:CGRectMake(0, 80*W_Wide_Zoom, 375*W_Hight_Zoom, 150*W_Hight_Zoom)];
    [_headView addSubview:_heandBtn];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 425*W_Hight_Zoom);
    self.tableView.scrollEnabled = NO;
    
    self.tableView.tableHeaderView =_headView;
    self.tableView.showsVerticalScrollIndicator   = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    

}

/**
 *  查询设备状态
 */

- (void)checkDeviceState
{
    
    
    
}

/**
 *  开始视频
 */

- (IBAction)startVideoBtn:(UIButton *)sender {

    if (sender.selected) {
        
         [self sipCall:checkmodel.deviceno sipName:nil];
         [self addDeviceUseMember];
    }else
    {
        
        [self showSuccessHudWithHint:@"设备暂不能开启"];
    }
   
}


/**
 * 添加设备使用记录
 */

- (void)addDeviceUseMember

{
    
   // "object": "主叫对象(mobile 移动客户端/device 设备端)"
    NSString  * str = [AccountManager sharedAccountManager].loginModel.userid;
    [[AFHttpClient sharedAFHttpClient]solvDevice:str token:str call:str called:checkmodel.did object:@"mobile" complete:^(ResponseModel *model) {
        NSUserDefaults * user =[NSUserDefaults standardUserDefaults];
        [user setObject:model.content forKey:@"contentID"];
        [user synchronize];
    }];
}

/**
 *  解绑
 */

- (IBAction)cancelDeviceBtn:(UIButton *)sender {
    
    UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:nil message:@"你确定解除绑定吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;{
    
    if (buttonIndex == 0) {
        
        NSString * str = [AccountManager sharedAccountManager].loginModel.userid;
        [[AFHttpClient sharedAFHttpClient]solvDevice:str token:str did:checkmodel.did complete:^(ResponseModel * model) {
            [[AppUtil appTopViewController] showHint:model.retDesc];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"bangdingshuaxin" object:nil];

        }];
        [self.navigationController popViewControllerAnimated:YES];
    }
        
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma Marr ------ UITableViewDelegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count+3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55*W_Hight_Zoom;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * showUserInfoCellIdentifier = @"PerInformation";
    PerInformationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:showUserInfoCellIdentifier];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PerInformationTableViewCell" owner:self options:nil]lastObject];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.introduceLable.text = self.dicSource[indexPath.row];
    
    if (indexPath.row ==1 || indexPath.row ==2) {
        //显示箭头
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    if (indexPath.row  ==0) {
        cell.inforLable.text =checkmodel.deviceno;
        
    }else if (indexPath.row ==1)
    {
        
        cell.inforLable.text = checkmodel.deviceremark;
        strName =checkmodel.deviceremark;
    }
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    if (indexPath.row ==1) {
        // 修改备注
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"repairName", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Sure", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //获取第1个输入框；
            UITextField *userNameTextField = alertController.textFields.firstObject;
            
            if (userNameTextField.text.length > 10) {
                userNameTextField.text = [userNameTextField.text substringToIndex:10];
                
            }else if ([AppUtil isBlankString:userNameTextField.text])
            {
                
                [self showSuccessHudWithHint:@"不能为空"];
                return ;
            }
            NSString * str= [AccountManager sharedAccountManager].loginModel.userid;
            [[AFHttpClient sharedAFHttpClient]repairName:str token:str did:checkmodel.did remark:userNameTextField.text complete:^(ResponseModel * model) {
                
                 // NSLog(@"======%@",model);
                
                [self initRefreshView];
            }];
            

            
            
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleDefault handler:nil]];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = NSLocalizedString(@"tabDevice", nil);
           // textField.borderStyle =UITextBorderStyleBezel;
            
        }];
       
        
        [self presentViewController:alertController animated:true completion:nil];
    }
     else if (indexPath.row == 2)
     {
         FamilyTeamViewController * famVC =[[FamilyTeamViewController alloc]initWithNibName:@"FamilyTeamViewController" bundle:nil];
         famVC.deviceNum = checkmodel.deviceno;
         famVC.did = checkmodel.did;
         [self.navigationController pushViewController:famVC animated:YES];
         
         
         
     }
    
    
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

#pragma mark - Event Functions

//  call
//
/*
 @dialerNumber 别人的账号
 @sipName 自己的账号
 @ 视频通话
 */
- (void)sipCall:(NSString*)dialerNumber sipName:(NSString *)sipName
{
    
    NSString *  displayName  =nil;
    [[SephoneManager instance]call:dialerNumber displayName:displayName transfer:FALSE highDefinition:FALSE];
    
    
}

@end
