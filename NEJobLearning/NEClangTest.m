//
//  NEClangTest.m
//  NEJobLearning
//
//  Created by neareast on 2017/8/12.
//  Copyright © 2017年 neareast. All rights reserved.
//

//在clang编译器的帮助下改写并窥探oc代码的一些秘密
//xcrun -sdk iphonesimulator10.1  clang -rewrite-objc -F /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS10.1.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks -fobjc-runtime=ios-8.0.0 -fobjc-arc -fblocks NEClangTest.m
//代码注释中有改写后的关键信息，完整信息请自行运行上述命令
#import "NEClangTest.h"

@implementation NEClangTest

- (void)blockVarTest {
//    __attribute__((__blocks__(byref))) __Block_byref_iToModify_0 iToModify = {(void*)0,(__Block_byref_iToModify_0 *)&iToModify, 0, sizeof(__Block_byref_iToModify_0), 0};
    __block int iToModify = 0;
    
//    int iNormal = 1;
    int iNormal = 1;
    
//    __NEClangTest__blockVarTest_block_func_0
    ^{
//        int iNormal = __cself->iNormal; // bound by copy
        
//        __Block_byref_iToModify_0 *iToModify = __cself->iToModify; // bound by ref
//        (iToModify->__forwarding->iToModify) = 100;
        iToModify = 100;
        
//        NSLog((NSString *)&__NSConstantStringImpl__var_folders_fd__xzybhgj6c52bwj_2tt8h9fw0000gn_T_NEClangTest_e1f197_mi_0, iNormal, (iToModify->__forwarding->iToModify));
        NSLog(@"use block var iNormal %zd and modified iToModify %zd", iNormal, iToModify);
    }();
}

@end
