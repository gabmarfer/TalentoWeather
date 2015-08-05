//
//  TMWHelpers.h
//  TalentoWeather
//
//  Created by gabmarfer on 05/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Load a path from disk
 *
 * @param filename a name of a file on disk
 * @return a path to the file
 */
NSString *pathInDocumentDirectory(NSString *fileName);

/**
 * Load a path from cache directory
 *
 * @param filename a name of a file on disk
 * @return a path to the file
 */
NSString *pathInLibraryCacheDirectory(NSString *fileName);

/**
 * Load a path from tmp directory
 *
 * @param filename a name of a file on disk
 * @return a path to the file
 */
NSString *pathInTmpDirectory(NSString *fileName);

