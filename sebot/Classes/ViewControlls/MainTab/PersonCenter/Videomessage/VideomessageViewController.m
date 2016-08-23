//
//  VideomessageViewController.m
//  sebot
//
//  Created by czx on 16/8/18.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "VideomessageViewController.h"
#import "VideoMessageTableViewCell.h"
#import "AFHttpClient+Videomessage.h"
#import "VideoMessageModel.h"
#import "UIImage-Extensions.h"
#import <MediaPlayer/MediaPlayer.h>
static NSString * cellId = @"videomessagetableviewcellid";
@interface VideomessageViewController ()

@end

@implementation VideomessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"视频留言"];
}

-(void)setupView{
    [super setupView];
    self .tableView.frame =  CGRectMake(0, 0, self.view.width, 715 * W_Hight_Zoom);
    [self.tableView registerClass:[VideoMessageTableViewCell class] forCellReuseIdentifier:cellId];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self initRefreshView];


}

-(void)setupData{
    [super setupData];

}

-(void)loadDataSourceWithPage:(int)page{
    [[AFHttpClient sharedAFHttpClient]getVideomessageWithUserid:@"UI1608000016944" token:@"UI1608000016944" page:[NSString stringWithFormat:@"%d",page]complete:^(ResponseModel *model) {
        
        if (page == START_PAGE_INDEX) {
//            if (model.list.count == 0) {
//                [self noShuju];
//            }
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

#pragma mark - TableView的代理函数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
    //return 5;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200*W_Hight_Zoom;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoMessageModel * model = self.dataSource[indexPath.row];
    VideoMessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.nameLabel.text = model.deviceremark;
    cell.timeLabel.text = model.opttime;
    
    if (model.cutImage) {
        cell.centerImage.image = model.cutImage;
    }else{
        [cell.centerImage sd_setImageWithURL:[NSURL URLWithString:model.thumbnails] placeholderImage:[UIImage imageNamed:@"默认图片.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                cell.centerImage.image = [image imageByScalingProportionallyToSize:CGSizeMake(self.tableView.width, CGFLOAT_MAX)];
                model.cutImage = cell.centerImage.image;
            }
            
        }];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoMessageModel * model = self.dataSource[indexPath.row];
    
    MPMoviePlayerViewController * vc = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:model.networkaddress]];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryPlayback error:&err];
    [self presentMoviePlayerViewControllerAnimated:vc];




}







@end
