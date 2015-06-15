//
//  AppDelegate.m
//  CopyBundleToDocs
//
//  Created by shailesh on 10/06/15.
//  Copyright (c) 2015 shailesh. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (NSString*) getPathForDirectory:(int)directory {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES);
  return [paths objectAtIndex:0];
}

- (void)copyFromBundleToDocuments:(BOOL)overWrite {
  NSString *appBundleDirectory = [[NSBundle mainBundle] resourcePath];
  NSString* documentsDirectory = [self getPathForDirectory:NSDocumentDirectory];
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSError *error =  nil;
  NSArray* itemsToCopy = [fileManager contentsOfDirectoryAtPath:appBundleDirectory error:&error];
  if(error){
    NSLog(@"Failed to get contents of App Bundle");
    return;
  }
  for (NSString* item in itemsToCopy) {
    NSString *sourceDir = [appBundleDirectory stringByAppendingFormat:@"/%@",item];
    NSString *destDir = [documentsDirectory stringByAppendingFormat:@"/%@",item];
    BOOL isDirectory;
    BOOL fileExists = [fileManager fileExistsAtPath:destDir isDirectory:&isDirectory];
    if (fileExists && overWrite) {
        [fileManager removeItemAtPath:destDir error:&error];
        if(error && error.code != NSFileNoSuchFileError && error.code != NSFileWriteFileExistsError){
          NSDictionary *userInfo = [error userInfo];
          NSString *errorString = [[userInfo objectForKey:NSUnderlyingErrorKey] localizedDescription];
          NSLog(@"Delete File Failed: %@. %s, %i", errorString, __PRETTY_FUNCTION__, __LINE__);
        }
    }
    //copyItemAtPath doesnt succeed if file already exists
    BOOL copySuccess =  [fileManager copyItemAtPath:sourceDir toPath:destDir error:&error];
    if (copySuccess) {
      NSString* theFileName = [[destDir lastPathComponent] stringByDeletingPathExtension];
        NSLog(@"Successfully copied: %@", theFileName);
    }
  }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.
  [self copyFromBundleToDocuments:YES];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
