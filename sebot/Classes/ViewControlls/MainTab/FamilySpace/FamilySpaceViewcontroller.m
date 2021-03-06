//
//  FamilySpaceViewcontroller.m
//  sebot
//
//  Created by yulei on 16/6/15.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "FamilySpaceViewcontroller.h"
#import "NewPhotoalbumViewController.h"
#import "FamilyTableViewCell.h"
#import "AFHttpClient+Alumb.h"
#import "FamilyquanModel.h"
#import "UIImage-Extensions.h"
#import "LargeViewController.h"
#import "PopView.h"
#import "CommentViewController.h"
#import "SaomaoViewController.h"
#import "AFHttpClient+MyDevice.h"

#import "DetailViewController.h"


static NSString * cellId = @"FamilyCellides";
@interface FamilySpaceViewcontroller ()<PopDelegate>
{
    PopView * _popView;
    AppDelegate *app;
    NSMutableArray * _listArray;
    UIImageView * _image;
    UIImageView * _noShujuImage;
}
@end


@implementation FamilySpaceViewcontroller

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dada) name:@"shuaxinn" object:nil];
    //shuaxinn12
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dada1) name:@"shuaxinn12" object:nil];
        //bangdingshuaxin
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dada3) name:@"bangdingshuaxin" object:nil];
    
        _listArray = [NSMutableArray array];
        [[AFHttpClient sharedAFHttpClient]querMydeviceWithUserid:[AccountManager sharedAccountManager].loginModel.userid token:[AccountManager sharedAccountManager].loginModel.userid complete:^(ResponseModel *model) {
    
            [_listArray addObjectsFromArray:model.list];
        
        }];
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSUserDefaults * defults =[NSUserDefaults standardUserDefaults];
    NSString * str =[defults objectForKey:@"s_m_text"];
    _popView.numberTextfied.text= str;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pass) name:@"haha" object:nil];

}
- (void)pass

{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}



-(void)dada{
    [self initRefreshView];
}
-(void)dada1{

    [self loadDataSourceWithPage:1];

}

-(void)dada3{
  
   // [self isbangding];
 
}



- (void)viewDidLoad{
    [super viewDidLoad];
    [self setNavTitle: NSLocalizedString(@"tabFamily", nil)];
     self.view.backgroundColor = [UIColor whiteColor];
    
    [self showBarButton:NAV_RIGHT imageName:@"相机.png"];
    
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _popView = [[PopView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH ,SCREEN_HEIGHT)];
    _popView.center = self.view.center;
    _popView.ParentView = app.window;
    _popView.delegate = self;
    
    
   // [self isbangding];
}

-(void)setupView{
    [super setupView];
   // self.tableView.hidden = NO;
    self .tableView.frame =  CGRectMake(0, 0, self.view.width, self.view.height);
    [self.tableView registerClass:[FamilyTableViewCell class] forCellReuseIdentifier:cellId];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self initRefreshView];


}
-(void)doRightButtonTouch{
//    _listArray = [NSMutableArray array];
//    [[AFHttpClient sharedAFHttpClient]querMydeviceWithUserid:[AccountManager sharedAccountManager].loginModel.userid token:[AccountManager sharedAccountManager].loginModel.userid complete:^(ResponseModel *model) {
//        
//        [_listArray addObjectsFromArray:model.list];
        if (_listArray.count > 0 ) {
            NewPhotoalbumViewController * newVc = [[NewPhotoalbumViewController alloc]init];
            [self.navigationController pushViewController:newVc animated:NO];

        }else {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有绑定设备，是否立即绑定？" preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self.view addSubview:_popView];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            
    
        }
//    }];
//
    
    
    
}
-(void)setupData{
    [super setupData];

}
-(void)loadDataSourceWithPage:(int)page{
    [_noShujuImage removeFromSuperview];
    _noShujuImage.hidden = YES;
    [[AFHttpClient sharedAFHttpClient]familyArticlesWithUserid:[AccountManager sharedAccountManager].loginModel.userid token:[AccountManager sharedAccountManager].loginModel.userid page:[NSString stringWithFormat:@"%d",page] complete:^(ResponseModel *model) {
    
        if (page == START_PAGE_INDEX) {
            if (model.list.count == 0) {
                [self noShuju];
            }
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:model.list];
        } else {
            [self.dataSource addObjectsFromArray:model.list];
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

-(void)noShuju{

    NSLog(@"heheh");
    _noShujuImage = [[UIImageView alloc]initWithFrame:CGRectMake(60 * W_Wide_Zoom, 136 * W_Hight_Zoom, 250 * W_Wide_Zoom, 250 * W_Hight_Zoom)];
    _noShujuImage.image = [UIImage imageNamed:@"无图时.png"];
    [self.tableView addSubview:_noShujuImage];
    
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有绑定设备，是否立即绑定？" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.view addSubview:_popView];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
    
}


#pragma mark - TableView的代理函数
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
    return 400*W_Hight_Zoom;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FamilyquanModel * model = self.dataSource[indexPath.row];
    FamilyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.namelabel.text = model.nickname;
    cell.content.text = model.content;

    
//   cell.content.frame = CGRectMake(CGRectGetMinX(cell.timeLabel.frame), CGRectGetMaxY(cell.bigImage.frame), 360 * W_Wide_Zoom, 30 * W_Hight_Zoom);
//    cell.content.text = model.content;
//    NSString * str111 = model.content;
//    CGSize labelSize111 = {0,0};
//    labelSize111 = [str111 sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200.0, 5000) lineBreakMode:NSLineBreakByWordWrapping];;
//    cell.content.numberOfLines = 0;
//    cell.content.lineBreakMode = UILineBreakModeCharacterWrap;
//    cell.content.frame = CGRectMake(cell.content.frame.origin.x,  CGRectGetMaxY(cell.bigImage.frame), cell.content.frame.size.width, labelSize111.height);
//    
//
//    cell.lineLabel.frame = CGRectMake(0 * W_Wide_Zoom, CGRectGetMaxY(cell.content.frame)+5, 375 * W_Wide_Zoom, 1 * W_Hight_Zoom);
//
//  
    
    [cell.headImage.layer setMasksToBounds:YES];
    NSString * headStr = model.headportrait;
    NSURL * headUrl = [NSURL URLWithString:headStr];
    [cell.headImage sd_setImageWithURL:headUrl placeholderImage:[UIImage imageNamed:@"默认头像.png"]];
    //这里不仅要这样写，cell里面要把这个图片的 contentMode = UIViewContentModeCenter，layer.masksToBounds = YES;
    if (model.cutImage) {
        cell.bigImage.image = model.cutImage;
    }else{
        [cell.bigImage sd_setImageWithURL:[NSURL URLWithString:model.thumbnails] placeholderImage:[UIImage imageNamed:@"默认图片.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                cell.bigImage.image = [image imageByScalingProportionallyToSize:CGSizeMake(self.tableView.width, CGFLOAT_MAX)];
                model.cutImage = cell.bigImage.image;
            }

        }];
    }
    
    UIButton * bigBtn = [[UIButton alloc]initWithFrame:cell.bigImage.frame];
    bigBtn.backgroundColor = [UIColor clearColor];
    [cell addSubview:bigBtn];
    bigBtn.tag = indexPath.row + 21;
    [bigBtn addTarget:self action:@selector(lookPictureButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    
    cell.timeLabel.text = model.publishtime;
    if ([model.praised isEqualToString:@"0"]) {
//        [cell.aixin setImage:[UIImage imageNamed:@"dianzanzan.png"] forState:UIControlStateNormal];
        cell.aixin.selected = NO;
        //cell.aixin.selected = NO;
    }else{
      //  [cell.aixin setImage:[UIImage imageNamed:@"dianzanhou.png"] forState:UIControlStateNormal];
         cell.aixin.selected = YES;
    }
    cell.aixin.tag = indexPath.row + 22;
    cell.aixin.userInteractionEnabled = YES;
    [cell.aixin addTarget:self action:@selector(dianzanbttuntouch:) forControlEvents:UIControlEventTouchUpInside];
    cell.aixinLabel.text = model.praises;
    cell.pinglunlabel.text = model.comments;

    cell.pinglunBtn.tag = indexPath.row + 23;
    [cell.pinglunBtn addTarget:self action:@selector(pinglunbuttonTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    //tabview隐藏点击效果和分割线
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
//评论
-(void)pinglunbuttonTouch:(UIButton *)sender{
    NSInteger i = sender.tag - 23;
    NSLog(@"%ld",i);
     FamilyquanModel * model = self.dataSource[i];
//    CommentViewController * commVc = [[CommentViewController alloc]init];
//    commVc.wid = model.aid;
//    [self.navigationController pushViewController:commVc animated:NO];
    DetailViewController * Vcc = [[DetailViewController alloc]init];
    Vcc.wid = model.aid;
    Vcc.indexnumber = i;
    [self.navigationController pushViewController:Vcc animated:NO];
    
}

//点赞
-(void)dianzanbttuntouch:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    NSInteger i = sender.tag - 22;
    FamilyquanModel * model1 = self.dataSource[i];
    if (sender.selected == YES) {
         sender.userInteractionEnabled = YES;
        [[AppUtil appTopViewController] showHint:@"您已经点过赞了，不能重复点赞哦!"];
    }else{
    [[AFHttpClient sharedAFHttpClient]dianzanWithUserid:[AccountManager sharedAccountManager].loginModel.userid token:[AccountManager sharedAccountManager].loginModel.userid objid:model1.aid objtype:@"a" complete:^(ResponseModel *model) {
        if (model) {
            [[AppUtil appTopViewController] showHint:model.retDesc];
            //给model重新赋值再刷新tabview
            model1.praised = @"1";
            NSInteger k = [model1.praises integerValue];
            NSInteger kk = k + 1;
            model1.praises = [NSString stringWithFormat:@"%ld",kk];
            [self.tableView reloadData];
        }
        
    }];
        
    }
    
}

//点击查看大图
-(void)lookPictureButtonTouch:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    NSInteger i = sender.tag - 21;
    NSLog(@"%ld",i);
    FamilyquanModel * model = self.dataSource[i];
    [[AFHttpClient sharedAFHttpClient]lookpictureWithUserid:[AccountManager sharedAccountManager].loginModel.userid token:[AccountManager sharedAccountManager].loginModel.userid aid:model.aid complete:^(ResponseModel *model) {
        if (model) {
             NSArray * array = model.list;
            
            if (array.count == 0 ) {
                [[AppUtil appTopViewController]showHint:@"照片已删除"];
            }else{
             LargeViewController * largeVC =[[LargeViewController alloc]initWithNibName:@"LargeViewController" bundle:nil];
            largeVC.dataArray = array;
            [self.navigationController pushViewController:largeVC animated:NO];
                sender.userInteractionEnabled = YES;
            }
        }
    }];
}



/**
 * pop 代理
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
    
    
    NSString * str = [AccountManager sharedAccountManager].loginModel.userid;
    
    if ([AppUtil isBlankString:_popView.numberTextfied.text]) {
        [self showSuccessHudWithHint:@"请输入设备号"];
        return;
    }
    //[self showHudInView:self.view hint:@"正在绑定中..."];
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;//枚举类型不同的效果
    hud.labelText=@"加载中.......";
    [_popView removeFromSuperview];
    
    [[AFHttpClient sharedAFHttpClient]addDevide:str token:str deviceno:_popView.numberTextfied.text complete:^(ResponseModel * model) {
        [_popView removeFromSuperview];
        [[AppUtil appTopViewController] showHint:model.retDesc];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
   
    
}



@end
