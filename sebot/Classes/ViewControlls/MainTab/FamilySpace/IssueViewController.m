//
//  IssueViewController.m
//  sebot
//
//  Created by czx on 16/7/6.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "IssueViewController.h"
#import "AFHttpClient+Alumb.h"

@interface IssueViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>
@property (nonatomic,strong)UITextView * topTextView;
@property (nonatomic,strong)UIView * downWithView;
@property (nonatomic,strong)UIButton * coverButton;
@property (nonatomic,strong)UIView * littleDownView;
@property (nonatomic,strong)NSMutableArray * imageArray;
@property(nonatomic,strong)UIImagePickerController * imagePicker;
@property (nonatomic,strong)UIButton * imageButtones;
@property (nonatomic,strong)UILabel * placeholderLabel;

@property(nonatomic,strong)UIView * bigView;

@property (nonatomic,strong)UIButton * leftButton;

@end

@implementation IssueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor grayColor];
    _imagePicker =[[UIImagePickerController alloc]init];
    _imagePicker.delegate= self;
    CGSize titleSize =self.navigationController.navigationBar.bounds.size;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleSize.width/2,titleSize.height)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text=@"发布";
    self.navigationItem.titleView=label;

    self.automaticallyAdjustsScrollViewInsets = NO;
    // [self showBarButton:NAV_RIGHT title:@"发布" fontColor:[UIColor whiteColor]];
    self.view.backgroundColor = LIGHT_GRAY_COLOR;

    UIButton *releaseButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    //[releaseButton setTitle:@"发布" forState:normal];
    [releaseButton setImage:[UIImage imageNamed:@"new_upload.png"] forState:UIControlStateNormal];
    [releaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [releaseButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, -6, -20)];
    releaseButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [releaseButton addTarget:self action:@selector(releaseInfo:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
    
    
    _leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [_leftButton setImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(doLeftButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:_leftButton];
    [_leftButton setTitleEdgeInsets:UIEdgeInsetsMake(-1, -25, 0, 0)];
    [_leftButton setImageEdgeInsets:UIEdgeInsetsMake(-1, -25, 0, 0)];
    
    self.navigationItem.leftBarButtonItem = releaseButtonItem2;
    
    

    _topTextView = [[UITextView alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 60 * W_Hight_Zoom, 375 * W_Wide_Zoom, 150 * W_Hight_Zoom)];
    _topTextView.textAlignment = NSTextAlignmentLeft;
    _topTextView.backgroundColor = [UIColor whiteColor];
    _topTextView.delegate = self;
    _topTextView.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_topTextView];
    
    _placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 60 * W_Hight_Zoom, 100 * W_Wide_Zoom, 35 * W_Hight_Zoom)];
    _placeholderLabel.textColor = [UIColor grayColor];
    _placeholderLabel.backgroundColor = [UIColor clearColor];
    _placeholderLabel.text = @"  请输入内容";
    _placeholderLabel.font = _topTextView.font;
    _placeholderLabel.layer.cornerRadius = 5;
    [self.view addSubview:_placeholderLabel];
    
    
    
    _imageArray = [[NSMutableArray alloc]init];
    [_imageArray addObjectsFromArray:_choseeImage];
    
    [self addImageS];
    
    UIView * centerView = [[UIView alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 222 * W_Hight_Zoom, 375 * W_Wide_Zoom, 50 * W_Hight_Zoom)];
    centerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:centerView];
    NSUserDefaults * userdefaults = [NSUserDefaults standardUserDefaults];
    NSString * strrr = [userdefaults objectForKey:@"albuumname"];
    
    
    UILabel * shancghuandao = [[UILabel alloc]initWithFrame:CGRectMake(10 * W_Wide_Zoom, 10 * W_Hight_Zoom, 100 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
    shancghuandao.text = @"上传到:";
    shancghuandao.textColor = [UIColor blackColor];
    shancghuandao.font = [UIFont systemFontOfSize:15];
    [centerView addSubview:shancghuandao];
    
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(200 * W_Wide_Zoom, 10 * W_Hight_Zoom, 163 * W_Wide_Zoom, 30 * W_Hight_Zoom)];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.textAlignment = NSTextAlignmentRight;
    nameLabel.text = strrr;
    nameLabel.font = [UIFont systemFontOfSize:15];
    [centerView addSubview:nameLabel];
    
    
    
    
}


-(void)releaseInfo:(UIButton *)sender{
 
    [_imageArray removeLastObject];
    if (_imageArray.count < 1) {
         [[AppUtil appTopViewController] showHint:@"请至少选择一张图片"];
        return;
    }
    
    NSMutableString * stingArr =[[NSMutableString alloc]init];
    NSDateFormatter * formater =[[NSDateFormatter alloc]init];
    NSMutableArray * dataBaseArr =[[NSMutableArray alloc]init];
    for (int i = 0 ; i < _imageArray.count; i ++) {
        NSData * dataImage = UIImageJPEGRepresentation(_imageArray[i], 0.5);
        NSString * dateBase64 =[dataImage base64EncodedStringWithOptions:0];
        [dataBaseArr addObject:dateBase64];
    }
    [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    [formater stringFromDate:[NSDate date]];
    
    NSString *picname1 = [NSString stringWithFormat:@"%@.jpg",[formater stringFromDate:[NSDate date]]];
    [stingArr appendString:@"["];
    for (int i = 0; i < _imageArray.count; i++) {
        NSString * picstr =[NSString stringWithFormat:@"{\"%@\":\"%@\",\"%@\":\"%@\"}",@"name",picname1,@"pic",dataBaseArr[i]];
        [stingArr appendString:picstr];
        
        if (i != _imageArray.count-1) {
            [stingArr appendString:@","];
        }
    }
    [stingArr appendString:@"]"];
    
    sender.userInteractionEnabled = NO;
    _leftButton.userInteractionEnabled = NO;
    [self showHudInView:self.view hint:@"正在发布..."];

    [[AFHttpClient sharedAFHttpClient]issueWithuserid:[AccountManager sharedAccountManager].loginModel.userid token:[AccountManager sharedAccountManager].loginModel.userid aid:_aidstr coneten:_topTextView.text  photos:stingArr userides:[AccountManager sharedAccountManager].loginModel.userid complete:^(ResponseModel *model) {
 
        if (model) {
           // [self dismissViewControllerAnimated:YES completion:nil];
            [self.navigationController popToRootViewControllerAnimated:NO];

            [[NSNotificationCenter defaultCenter]postNotificationName:@"shuaxinn" object:nil];
         
        }
         sender.userInteractionEnabled = YES;
        _leftButton.userInteractionEnabled = YES;
    }];

}


-(void)doLeftButtonTouch{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有发布内容，是否要退出？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        // 点击按钮后的方法直接在这里面写
       // [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
        NSLog(@"取消");
    }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


-(void)addImageS{
    _bigView = [[UIView alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 285 * W_Hight_Zoom, 375 * W_Wide_Zoom, 200 * W_Hight_Zoom)];
    _bigView.backgroundColor = LIGHT_GRAY_COLOR;
    [self.view addSubview:_bigView];
    [_imageArray addObject:[UIImage imageNamed:@"addImage11.png"]];
    for (int i = 0 ; i < _imageArray.count; i++) {
        _imageButtones = [[UIButton alloc]initWithFrame:CGRectMake(12.5 * W_Wide_Zoom + i * 90 * W_Wide_Zoom, 0 * W_Hight_Zoom, 80 * W_Wide_Zoom, 80 * W_Hight_Zoom)];
        [_imageButtones setImage:_imageArray[i] forState:UIControlStateNormal];
        [_bigView addSubview:_imageButtones];
        _imageButtones.tag = i;
        [_imageButtones addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)buttonTouch:(UIButton *)sender{
    
    NSInteger i = _imageArray.count;
    if (i <= 1) {
        NSLog(@"如果删除完了，弹出来的是可以选择视频的界面");
        //  [self openDownBigView];
        [self openDownImageView];
    }else{
        if (sender.tag == i - 1 ) {
            if (_imageArray.count > 4) {
                NSLog(@"不能大于4张");
                return;
            }
            [self openDownImageView];
        }else{
            UIAlertController *  alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            //          [alert addAction:[UIAlertAction actionWithTitle:@"预览" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //
            //              NSLog(@"预览");
            //
            //
            //          }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [sender removeFromSuperview];
                [_imageArray removeObjectAtIndex:sender.tag];
                [_bigView removeFromSuperview];
                [self paixuImageButton];
                
            }]];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}
//删除照片后重新排序
-(void)paixuImageButton{
    
    _bigView = [[UIView alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 285 * W_Hight_Zoom, 375 * W_Wide_Zoom, 200 * W_Hight_Zoom)];
    _bigView.backgroundColor = LIGHT_GRAY_COLOR;
    [self.view addSubview:_bigView];
    for (int i = 0 ; i < _imageArray.count; i++) {
        _imageButtones = [[UIButton alloc]initWithFrame:CGRectMake(12.5 * W_Wide_Zoom + i * 90 * W_Wide_Zoom, 285 * W_Hight_Zoom, 80 * W_Wide_Zoom, 80 * W_Hight_Zoom)];
        [_imageButtones setImage:_imageArray[i] forState:UIControlStateNormal];
        [self.view addSubview:_imageButtones];
        _imageButtones.tag = i;
        [_imageButtones addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

-(void)openDownBigView{
    _downWithView = [[UIView alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 667 * W_Hight_Zoom, 375 * W_Wide_Zoom, 160 * W_Hight_Zoom)];
}



-(void)openDownImageView{
    _downWithView = [[UIView alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 667 * W_Hight_Zoom, 375 * W_Wide_Zoom, 80 * W_Hight_Zoom)];
    _littleDownView = [[UIView alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 667 * W_Hight_Zoom, 375 * W_Wide_Zoom, 40 * W_Hight_Zoom)];
    _coverButton = [[UIButton alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 0 * W_Hight_Zoom, 375 * W_Wide_Zoom, 667 * W_Hight_Zoom)];
    _coverButton.backgroundColor = [UIColor blackColor];
    _coverButton.alpha = 0.4;
    [[UIApplication sharedApplication].keyWindow addSubview:_coverButton];
    [_coverButton addTarget:self action:@selector(hideButton:) forControlEvents:UIControlEventTouchUpInside];
    [UIView animateWithDuration:0.3 animations:^{
        _downWithView.frame = CGRectMake(0 * W_Wide_Zoom, 540 * W_Hight_Zoom, 375 * W_Wide_Zoom, 80 * W_Hight_Zoom);
        _littleDownView.frame = CGRectMake(0 * W_Wide_Zoom, 627 * W_Hight_Zoom, 375 * W_Wide_Zoom, 40 * W_Hight_Zoom);
        _littleDownView.backgroundColor = [UIColor whiteColor];
        _downWithView.backgroundColor = [UIColor whiteColor];
        [[UIApplication sharedApplication].keyWindow addSubview:_littleDownView];
        [[UIApplication sharedApplication].keyWindow addSubview:_downWithView];
    }];
    NSArray * nameArray = @[NSLocalizedString(@"photograph", nil),NSLocalizedString(@"photoalbum", nil)];
    for (int i = 0; i < 2; i++) {
        UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 0 * W_Hight_Zoom + i * 40 * W_Hight_Zoom, 375 * W_Wide_Zoom, 1 * W_Hight_Zoom)];
        lineLabel.backgroundColor = GRAY_COLOR;
        [_downWithView addSubview:lineLabel];
        
        UIButton * downButtones = [[UIButton alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 0 * W_Hight_Zoom + i * 40 * W_Hight_Zoom, 375 * W_Wide_Zoom, 40 * W_Hight_Zoom)];
        [downButtones setTitle:nameArray[i] forState:UIControlStateNormal];
        [downButtones setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        downButtones.titleLabel.font = [UIFont systemFontOfSize:14];
        [_downWithView addSubview:downButtones];
        downButtones.tag = i;
        [downButtones addTarget:self action:@selector(imageButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    UIButton * quxiaoButton = [[UIButton alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 0 * W_Hight_Zoom, 375 * W_Wide_Zoom, 40 * W_Hight_Zoom)];
    [quxiaoButton setTitle:@"取消" forState:UIControlStateNormal];
    [quxiaoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    quxiaoButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_littleDownView addSubview:quxiaoButton];
    [quxiaoButton addTarget:self action:@selector(hideButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}
-(void)hideButton:(UIButton *)sender{
    _coverButton.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        _downWithView.frame = CGRectMake(0 * W_Wide_Zoom, 667 * W_Hight_Zoom, 375 * W_Wide_Zoom, 80 * W_Hight_Zoom);
        _littleDownView.frame = CGRectMake(0 * W_Wide_Zoom, 667 * W_Hight_Zoom, 375 * W_Wide_Zoom, 40 * W_Hight_Zoom);
    }];
}

-(void)imageButtonTouch:(UIButton *)sender{
    if (sender.tag == 0) {
        [self takePhoto];
    }else{
        [self loacalPhoto];
    }
    
}


#pragma mark - Uiimagepicker

// 拍照
- (void)takePhoto
{
    [self hideButton:nil];
    NSArray * mediaty = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePicker.mediaTypes = @[mediaty[0]];
        //设置相机模式：1摄像2录像
        _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        //使用前置还是后置摄像头
        _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        //闪光模式
        _imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        _imagePicker.allowsEditing = YES;
    }else
    {
        NSLog(@"打开摄像头失败");
    }
    [self presentViewController:_imagePicker animated:YES completion:nil];
    //[self.navigationCo                                                                                                                                                                                                                                                                                                                                                                                                             ntroller pushViewController:_imagePicker animated:YES];
    
}
//相册选取
- (void)loacalPhoto
{
    [self hideButton:nil];
    NSArray * mediaTypers = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePicker.mediaTypes = @[mediaTypers[0],mediaTypers[1]];
        _imagePicker.allowsEditing = YES;
    }
    [self presentViewController:_imagePicker animated:NO completion:nil];
    
}

//得到图片之后的处理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [_imageArray removeLastObject];
    UIImage * getImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [_imageArray addObject:getImage];
    [self dismissViewControllerAnimated:NO completion:nil];
    [self addImageS];
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    _placeholderLabel.text = @"";
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (_topTextView.text.length == 0) {
        _placeholderLabel.text = @"  请输入内容";
    }else{
        _placeholderLabel.text = @"";
    }
}
- (void)textViewDidChange:(UITextView *)textView {
     NSInteger number = [textView.text length];
    if (number > 30) {
          textView.text = [textView.text substringToIndex:30];
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"字符个数不能大于30" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];

    }



}


@end
