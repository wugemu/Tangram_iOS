//
//  ViewController.m
//  TangramDemo_lang
//
//  Created by jessie on 2017/12/27.
//  Copyright © 2017年 langzu. All rights reserved.
//

#import "ViewController.h"
#import "MJDIYHeader.h"
#import <UIKit/UIKit.h>
#import "TangramView.h"
#import "TangramDefaultDataSourceHelper.h"
#import "TangramDefaultItemModelFactory.h"
#import "TangramContext.h"
#import "TangramEvent.h"
#import "TMUtils.h"
#import "AFNetworking.h"
#import "NSDictionary+RequestEncoding.h"

@interface ViewController ()<TangramViewDatasource>
@property (nonatomic, strong) NSMutableArray *layoutModelArray;//json 转换后数据源

@property (nonatomic, strong) TangramView    *tangramView;

@property (nonatomic, strong) NSArray *layoutArray;//布局列表

@property  (nonatomic, strong) TangramBus *tangramBus;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self registEvent];
    [self getLayoutData];
//    [self loadMockContent];
}

- (TangramBus *)tangramBus
{
    if (nil == _tangramBus) {
        _tangramBus = [[TangramBus alloc]init];
    }
    return _tangramBus;
}
-(NSMutableArray *)layoutModelArray
{
    if (nil == _layoutModelArray) {
        _layoutModelArray = [[NSMutableArray alloc]init];
    }
    return _layoutModelArray;
}

-(TangramView *)tangramView
{
    if (nil == _tangramView) {
        _tangramView = [[TangramView alloc]init];
        _tangramView.frame = self.view.bounds;
        [_tangramView setLoadNumber:2];
        [_tangramView setEnableAutoLoadMore:YES];
        _tangramView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(getLayoutData)];
        [_tangramView setDataSource:self];
        _tangramView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_tangramView];
    }
    return _tangramView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//加载本地json
-(void)loadMockContent
{
    NSString *mockDataString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TangramMock" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [mockDataString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
    self.layoutModelArray = [[dict objectForKey:@"data"] objectForKey:@"cards"];
    self.layoutArray = [TangramDefaultDataSourceHelper layoutsWithArray:self.layoutModelArray tangramBus:self.tangramBus];
    [self.tangramView reloadData];
}

- (void)registEvent
{
    [TangramDefaultItemModelFactory registElementType:@"1" className:@"TangramSingleImageElement"];
    [TangramDefaultItemModelFactory registElementType:@"2" className:@"TangramSimpleTextElement"];
    [TangramDefaultItemModelFactory registElementType:@"3" className:@"TangramSimpleFixElement"];
    [TangramDefaultItemModelFactory registElementType:@"4" className:@"TangramImageTextElement"];
    [self.tangramBus registerAction:@"responseToClickEvent:" ofExecuter:self onEventTopic:@"jumpAction"];
    [self.tangramBus registerAction:@"getMoreData:" ofExecuter:self onEventTopic:@"requestItems"];
}

- (void)responseToClickEvent:(TangramContext *)context
{
    //点击事件
    NSString *action = [context.event.params tm_stringForKey:@"action"];
    [AppTools showToastUseMBHub:self.view showText:action];
    if([action isEqualToString:@"刷新"]){
        [_tangramView.mj_header beginRefreshing];
    }
}

- (void)getMoreData:(TangramContext *)context
{
    //加载更多事件
    NSString *action = [context.event.params tm_stringForKey:@"loadAPI"];
//    NSString *page=[context.event.params tm_stringForKey:@"page"];
//    NSString *loadType = [context.event.params tm_stringForKey:@"loadType"];
//    NSDictionary *loadParams = [context.event.params tm_stringForKey:@"loadParams"];
//    if([page intValue]>5){
//        [self.tangramView setEnableAutoLoadMore:NO];//控制是否加载更多
//        return;
//    }
    UIView<TangramLayoutProtocol> *layout=(UIView<TangramLayoutProtocol> *)[context.event.params tm_safeValueForKey:@"Card"];
    NSLog(@"%@",action);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager sharedClient];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];//设置相应内容类型
    manager.requestSerializer.timeoutInterval = 10.f;//设置超时时长
    manager.requestSerializer.HTTPShouldHandleCookies = YES;
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary * mutPara = [[NSMutableDictionary alloc] init];
    [manager POST:@"http://10.42.0.1:8080/scb/doTest/loadMoreTangram.do" parameters:mutPara success:^(NSURLSessionDataTask *task, id responseObject) {
        [_tangramView.mj_header endRefreshing];
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"请求返回数据===%@",responseStr);
        id json = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        id dict = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        if([dict isKindOfClass:[NSArray class]]){
            NSMutableArray *modelArray = [[NSMutableArray alloc] init];
            [modelArray addObjectsFromArray:layout.itemModels];
            [modelArray addObjectsFromArray:[TangramDefaultDataSourceHelper modelsWithDictArray:dict]];
            [layout setItemModels:[NSArray arrayWithArray:modelArray]];
            self.tangramView.isLoadMore=YES;
            [self.tangramView reloadLayout:layout];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_tangramView.mj_header endRefreshing];
        NSLog(@"请求失败的原因%@",error);
    }];
}

//布局个数
- (NSUInteger)numberOfLayoutsInTangramView:(TangramView *)view
{
    return self.layoutModelArray.count;
}

//设置每个位置 布局
- (UIView<TangramLayoutProtocol> *)layoutInTangramView:(TangramView *)view atIndex:(NSUInteger)index
{
    return [self.layoutArray objectAtIndex:index];
}

//每个布局中组件的个数
- (NSUInteger)numberOfItemsInTangramView:(TangramView *)view forLayout:(UIView<TangramLayoutProtocol> *)layout
{
    return layout.itemModels.count;
}

//设置组件model
- (NSObject<TangramItemModelProtocol> *)itemModelInTangramView:(TangramView *)view forLayout:(UIView<TangramLayoutProtocol> *)layout atIndex:(NSUInteger)index
{
    return [layout.itemModels objectAtIndex:index];;
}

//设置组件 及 组件中控件绑定数据
- (UIView *)itemInTangramView:(TangramView *)view withModel:(NSObject<TangramItemModelProtocol> *)model forLayout:(UIView<TangramLayoutProtocol> *)layout atIndex:(NSUInteger)index
{
    //首先查找是否有可以复用的组件,是否可以复用是根据它的reuseIdentifier决定的
    //布局不复用，复用的是组件
    UIView *reuseableView = [view dequeueReusableItemWithIdentifier:model.reuseIdentifier ];
    //判断组件是否存在
    if (reuseableView) {
        reuseableView =  [TangramDefaultDataSourceHelper refreshElement:reuseableView byModel:model layout:layout tangramBus:self.tangramBus];
    }
    else
    {
        reuseableView =  [TangramDefaultDataSourceHelper elementByModel:model layout:layout tangramBus:self.tangramBus];
    }
    return reuseableView;
}

-(void)getLayoutData
{
    [_tangramView setEnableAutoLoadMore:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager sharedClient];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];//设置相应内容类型
    manager.requestSerializer.timeoutInterval = 10.f;//设置超时时长
    manager.requestSerializer.HTTPShouldHandleCookies = YES;
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary * mutPara = [[NSMutableDictionary alloc] init];
    [manager POST:@"http://10.42.0.1:8080/scb/doTest/main.do" parameters:mutPara success:^(NSURLSessionDataTask *task, id responseObject) {
        [_tangramView.mj_header endRefreshing];
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"请求返回数据===%@",responseStr);
        id json = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        id dict = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        if([dict isKindOfClass:[NSDictionary class]]){
            [self.layoutModelArray removeAllObjects];
            [self.layoutModelArray addObjectsFromArray:[[dict objectForKey:@"data"] objectForKey:@"cards"]];
            self.layoutArray = [TangramDefaultDataSourceHelper layoutsWithArray:self.layoutModelArray tangramBus:self.tangramBus];
            [self.tangramView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_tangramView.mj_header endRefreshing];
        NSLog(@"请求失败的原因%@",error);
    }];
}

@end
