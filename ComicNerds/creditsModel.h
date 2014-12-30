//
//  creditsModel.h
//  MyComics
//
//  Created by Michael Thomas on 8/7/14.
//
//

#import <Foundation/Foundation.h>

@protocol creditsModelDelegate <NSObject>

- (void)itemsRetrieved:(NSArray *)items;

@end

@interface creditsModel : NSObject<NSURLConnectionDataDelegate>

@property (nonatomic, weak) id<creditsModelDelegate> delegate;

- (void)getItems:(NSString *)apiURL;

@end
