//
//  ViewController.m
//  AdstirNativeAdSample
//
//  Copyright (c) 2014年 UNITED. All rights reserved.
//

#import "ViewController.h"
#import "AdstirNativeAd.h"

@interface ViewController () <AdstirNativeAdDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *descView;
@property (strong, nonatomic) AdstirNativeAd* nativead;
@property (strong, nonatomic) AdstirNativeAdResponse* nativeadResponse;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.nativead = [[AdstirNativeAd alloc]init];
	self.nativead.media = @"MEDIA-ID";
	self.nativead.spot = 1;
	// ガイドラインで規定されているスポンサー表記を実装した通りに設定してください。
	self.nativead.sponsoredText = @"AD";
	// 広告に必要な要素を要求するパラメーターを設定します
	self.nativead.titleLength = 25;
	self.nativead.descriptionLength = 100;
	self.nativead.image = YES;
	// 広告レスポンスを受け取るDelegateを設定します
	self.nativead.delegate = self;
	[self.nativead getAd];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)adstirNativeAdDidReceiveAd:(AdstirNativeAd*)nativeAd response:(AdstirNativeAdResponse*)response{
	NSLog(@"adstirNativeAdDidReceived");
	// 広告レスポンスが正常に取得できた時に行う処理を実装します
	// AdstirNativeAdDelegateのメソッドはすべてバックグラウンドスレッドで動作します
	self.nativeadResponse = response;
	dispatch_sync(dispatch_get_main_queue(), ^(void){
		self.titleView.text = response.title;
		self.descView.text = response.description;
		[response bindImageToImageView:self.imgView];
	});
	[response impression];
	// 広告を表示するときにimpressionを呼び出します
}

- (void)adstirNativeAdDidFailToReceiveAd:(AdstirNativeAd*)nativeAd{
	NSLog(@"adstirNativeAdDidFailToReceiveAd");
}

- (IBAction)nativeadClick:(id)sender{
	NSLog(@"nativeadClick %p",self.nativeadResponse);
	[self.nativeadResponse click];
}

- (void)dealloc {
    // デリゲートを解放します。
    self.nativead.delegate = nil;
    self.nativead = nil;
    self.nativeadResponse = nil;
}
@end
