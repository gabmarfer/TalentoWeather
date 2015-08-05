//
//  TMWHelpers.m
//  TalentoWeather
//
//  Created by gabmarfer on 05/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

#import "TMWHelpers.h"

NSString *pathInDocumentDirectory(NSString *fileName)
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = documentDirectories[0];
    return [documentDirectory stringByAppendingPathComponent:fileName];
}

NSString *pathInLibraryCacheDirectory(NSString *fileName)
{
    NSArray *cacheDirectories = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = cacheDirectories[0];
    return [cacheDirectory stringByAppendingPathComponent:fileName];
}

NSString *pathInTmpDirectory(NSString *fileName)
{
    NSString *resultPath;
    NSString *tmpDirectory = NSTemporaryDirectory();
    if (tmpDirectory)
        resultPath = [tmpDirectory stringByAppendingPathComponent:fileName];
    else
        resultPath = pathInLibraryCacheDirectory(fileName);
    return resultPath;
}
