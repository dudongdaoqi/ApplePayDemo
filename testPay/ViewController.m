//
//  ViewController.m
//  testPay
//
//  Created by lc on 16/2/24.
//  Copyright © 2016年 xulicheng. All rights reserved.
//

#import "ViewController.h"
#import "PassKit/PassKit.h"

@interface ViewController ()<PKPaymentAuthorizationViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(60, 100, 200, 50);
//    btn.center = self.view.center;
//    [btn setBackgroundImage:[UIImage imageNamed:@"ApplePayBTN_64pt__whiteLine_textLogo_"] forState:UIControlStateNormal];
    [btn setTitle:@"pay" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(ApplePay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark ----支付状态

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion
{
    NSLog(@"Payment was authorized: %@", payment);
    /*
     有网状态时，返回信息
     Payment was authorized: <PKPayment: 0x127e520e0; token: <PKPaymentToken: 0x127e3c0d0; transactionIdentifier: C1E0851756B00424C4A9C3DB74D57CE8962300A571BE30A073C89922A0AEC505; paymentData: 4714 bytes>>
     无网状态时，此代理不回调
     */
    BOOL asyncSuccessful = FALSE;
    if(asyncSuccessful) {
        completion(PKPaymentAuthorizationStatusSuccess);
        
        // do something to let the user know the status
        
        NSLog(@"支付成功");
        
    } else {
        completion(PKPaymentAuthorizationStatusFailure);
        
        // do something to let the user know the status
        NSLog(@"支付失败");
        
    }
    
}


#pragma mark ----开始支付
- (void)ApplePay{
    if([PKPaymentAuthorizationViewController canMakePayments]) {
        
        NSLog(@"支持支付");
        
        if ([PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:@[PKPaymentNetworkChinaUnionPay, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa]]) {
            NSLog(@"设备支持苹果支付，已帮卡");
        }else{
            NSLog(@"设备支持苹果支付，但用户未添加任何所要求的银行卡。");
        }
        PKPaymentRequest *request = [[PKPaymentRequest alloc] init];

        PKPaymentSummaryItem *widget1 = [PKPaymentSummaryItem summaryItemWithLabel:@"鸡蛋"
                                                                            amount:[NSDecimalNumber decimalNumberWithString:@"0.01"]];
        
        PKPaymentSummaryItem *widget2 = [PKPaymentSummaryItem summaryItemWithLabel:@"苹果"
                                                                            amount:[NSDecimalNumber decimalNumberWithString:@"0.00"]];
        
        PKPaymentSummaryItem *widget3 = [PKPaymentSummaryItem summaryItemWithLabel:@"2个苹果"
                                                                            amount:[NSDecimalNumber decimalNumberWithString:@"0.00"]];
        
        PKPaymentSummaryItem *widget4 = [PKPaymentSummaryItem summaryItemWithLabel:@"总金额" amount:[NSDecimalNumber decimalNumberWithString:@"0.01"] type:PKPaymentSummaryItemTypeFinal];
        
        request.paymentSummaryItems = @[widget1, widget2, widget3, widget4];
        
        request.countryCode = @"CN";
        request.currencyCode = @"CNY";
        //此属性限制支付卡，可以支付。PKPaymentNetworkChinaUnionPay支持中国的卡 9.2增加的
        request.supportedNetworks = @[PKPaymentNetworkChinaUnionPay, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
        request.merchantIdentifier = @"merchant.com.xulicheng.merchantname";
        /*
         PKMerchantCapabilityCredit NS_ENUM_AVAILABLE_IOS(9_0)   = 1UL << 2,   // 支持信用卡
         PKMerchantCapabilityDebit  NS_ENUM_AVAILABLE_IOS(9_0)   = 1UL << 3    // 支持借记卡
         */
        request.merchantCapabilities = PKMerchantCapabilityCredit;
        request.merchantCapabilities = PKMerchantCapabilityEMV;

        //增加邮箱及地址信息
        request.requiredBillingAddressFields = PKAddressFieldEmail | PKAddressFieldPostalAddress;
        
        PKPaymentAuthorizationViewController *paymentPane = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
        paymentPane.delegate = self;
        
       
        
        if (!paymentPane) {
            
            
            
            NSLog(@"出问题了");
            
        }else{
            [self presentViewController:paymentPane animated:YES completion:nil];

        }
        
        
        
//        
//        PKPaymentSummaryItem *good1 = [PKPaymentSummaryItem summaryItemWithLabel:@"HHKB professional 2" amount:[NSDecimalNumber decimalNumberWithString:@"0.01"]]; PKPaymentSummaryItem *good2 = [PKPaymentSummaryItem summaryItemWithLabel:@"营养快线" amount:[NSDecimalNumber decimalNumberWithString:@"0"]]; PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:@"德玛西亚" amount:[NSDecimalNumber decimalNumberWithString:@"0.1"]]; request.paymentSummaryItems = @[ good1, good2, total ];
//        request.countryCode = @"CN";
//        request.currencyCode = @"CNY";
//        request.merchantIdentifier = @"merchant.com.xulicheng.merchantname";
//        request.supportedNetworks = @[ PKPaymentNetworkMasterCard, PKPaymentNetworkVisa, PKPaymentNetworkChinaUnionPay ];
//        request.merchantCapabilities = PKMerchantCapabilityEMV;
//        request.requiredShippingAddressFields = PKAddressFieldPostalAddress | PKAddressFieldPhone | PKAddressFieldEmail | PKAddressFieldName;
//        PKPaymentAuthorizationViewController *paymentPane = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
//        paymentPane.delegate = self;
//        [self presentViewController:paymentPane animated:YES completion:nil];

    } else {
        NSLog(@"该设备不支持支付");
    }
    
}

#pragma mark ----支付完成
- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    
    [controller dismissViewControllerAnimated:TRUE completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
