//
//  RootViewController.m
//  Sample
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "RootViewController.h"
#import <IconFontsKit/IFFontAwesome.h>
#import <ESFramework/ESBadgeView.h>
#import "ApiClient.h"

#define kCellConfigKeyAction @"action"

@implementation RootViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
        self = [super initWithStyle:UITableViewStyleGrouped];
        self.showsRefreshControl = YES;
        self.configuresCellWithTableData = YES;
        return self;
}

- (void)viewDidLoad
{
        [super viewDidLoad];
        self.navigationItem.title = @"AppComponents";
        
        dispatch_block_t helloAction = ^(){
                [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
                [ESApp showCheckmarkHUDWithTitle:nil timeInterval:1 animated:YES];
        };
        
        [self.tableData addObject:
         @[@{ ACTableViewCellConfigKeyText: @"Hello",
              ACTableViewCellConfigKeyCellReuseIdentifier: @"HelloIdentifier",
              ACTableViewCellConfigKeyIconImage: [IFFontAwesome imageWithType:IFFAStar color:[UIColor es_yellowColor] fontSize:24],
              ACTableViewCellConfigKeyAccessoryType: @(UITableViewCellAccessoryDisclosureIndicator),
              ACTableViewCellConfigKeyDetailText: [[NSAttributedString alloc] initWithString:@"world" attributes:@{NSForegroundColorAttributeName: [UIColor es_oceanDarkColor]}],
              ACTableViewCellConfigKeyDetailImage: [IFFontAwesome imageWithType:IFFATwitter color:[UIColor es_twitterColor] fontSize:20],
              ACTableViewCellConfigKeyRightBadgeView: [ESBadgeView badgeViewWithText:@"New"],
              kCellConfigKeyAction:[helloAction copy] }]
         ];
        
         [self.tableData addObject:
          @[@{ ACTableViewCellConfigKeyText: @"WebViewController",
               ACTableViewCellConfigKeyAccessoryType: @(UITableViewCellAccessoryDisclosureIndicator),
               kCellConfigKeyAction: @"openWebViewController" },
            @{ ACTableViewCellConfigKeyText: @"AuthViewController",
               ACTableViewCellConfigKeyAccessoryType: @(UITableViewCellAccessoryDisclosureIndicator),
               kCellConfigKeyAction: @"openAuthViewController"}]
          ];
        
        [self.tableData addObject:
         @[@{ ACTableViewCellConfigKeyText: @"Github API Client",
              ACTableViewCellConfigKeyAccessoryType: @(UITableViewCellAccessoryDisclosureIndicator),
              ACTableViewCellConfigKeyIconImage: [IFFontAwesome imageWithType:IFFAGithub color:nil fontSize:24],
              ACTableViewCellConfigKeyRightBadgeView: [[UIImageView alloc] initWithImage:[IFFontAwesome imageWithType:IFFAGithubAlt color:nil fontSize:24]],
              kCellConfigKeyAction: @"testGithubApiClient" }
           ]
         ];
}

- (BOOL)refreshData
{
        if ([super refreshData]) {
                ESDispatchOnDefaultQueue(^{
                        [NSThread sleepForTimeInterval:2];
                        [self refreshingDataDidFinish:nil];
                });
                return YES;
        }
        return NO;
}

- (void)openWebViewController
{
        ACWebViewController *webController = [[ACWebViewController alloc] initWithURL:[NSURL URLWithString:@"https://github.com/ElfSundae/AppComponents"]];
        // webController.activityOverlayEnabeld = YES;
        webController.showsErrorViewWhenLoadingFailed = YES;
        webController.JSBridgeEnabled = YES;
        [self.navigationController pushViewController:webController animated:YES];
}

- (void)openAuthViewController
{
        ACAuthVerifyPhoneViewController *authController = [[ACAuthVerifyPhoneViewController alloc] initWithVerifyHandler:^(ACAuthVerifyPhoneViewController *controller, NSDictionary *data) {
                [ESApp showProgressHUDWithTitle:nil animated:YES];
                ESDispatchOnDefaultQueue(^{
                        // verify phone and code
                        [NSThread sleepForTimeInterval:2];
                        BOOL verifyOK = ESRandomNumber(0, 1);
                        ESDispatchOnMainThreadAsynchrony(^{
                                [ESApp hideProgressHUD:YES];
                                if (verifyOK) {
                                        [[controller class] cleanUp];
                                        [controller dismissViewControllerAnimated:YES completion:^{
                                                [UIAlertView showWithTitle:@"Welcome" message:@"Successfully login."];
                                        }];
                                } else {
                                        controller.codeTextFiled.text = nil;
                                        [controller updateUI];
                                }
                                
                        });
                });
        }];
        authController.titleForNavigationBar = @"Login";
        [authController presentAnimated:YES];
}

- (void)testGithubApiClient
{
        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
        
        [ESApp showProgressHUDWithTitle:@"Loading..." animated:YES];
        __unused NSURLSessionDataTask *dataTask = [[GithubClient client] GET:@"repos/ElfSundae/AppComponents" parameters:@{ @"sort": @"pushed"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [ESApp hideProgressHUDIfNotAutoHidden:YES];
                [[ESApp sharedApp] showImageViewControllerFromView:nil imageURL:[NSURL URLWithString:responseObject[@"owner"][@"avatar_url"]] placeholderImage:nil backgroundOptions:JTSImageViewControllerBackgroundOption_Blurred imageInfoCustomization:nil];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [ESApp hideProgressHUDIfNotAutoHidden:YES];
        }];
        // dataTask.alertFailedResponseCodeUsingTips = YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        id action = [self cellConfigDictionaryForIndexPath:indexPath][kCellConfigKeyAction];
        if ([action isKindOfClass:[NSString class]]) {
                ESInvokeSelector(self, NSSelectorFromString(action), NULL);
        } else if (action) {
                dispatch_block_t block = action;
                block();
        }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(nonnull NSIndexPath *)indexPath
{
        [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end
