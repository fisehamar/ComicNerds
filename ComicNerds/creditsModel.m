//
//  creditsModel.m
//  MyComics
//
//  Created by Michael Thomas on 8/7/14.
//
//

#import "creditsModel.h"
#import "creditsInfo.h"

@implementation creditsModel
{
    NSMutableData *retrievedData;
}

- (void)getItems:(NSString *)apiURL
{
    NSString *url = [NSString stringWithFormat:@"%@", apiURL];
    
    NSLog(@"URL %@",url);
    // Download the json file
    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    
    // Create the request
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    // Create the NSURLConnection
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

#pragma mark NSURLConnectionDataProtocol Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // Initialize the data object
    retrievedData = [[NSMutableData alloc] init];
    NSLog(@"retrieved Data %@", retrievedData);
    NSLog(@"URL Respons %@",response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the newly downloaded data
    [retrievedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Create an array to store the locations
    NSMutableDictionary *_objects = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *_comics = [[NSMutableArray alloc]init];
    
    //NSLog(@"did recieve data%@", retrievedData);
    
    // Parse the JSON that came in
    NSError *error;
    
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:retrievedData  options:NSJSONReadingMutableLeaves error:&error];
    
    _objects = [jsonArray objectForKey:@"results"];
    
    creditsInfo *info = [[creditsInfo alloc]init];
    
    //NSLog(@"Credits %@", [_objects valueForKey:@"person_credits"]);
    if ([_objects valueForKey:@"person_credits"])
    {
        for(NSDictionary *person in [_objects valueForKey:@"person_credits"])
        {
            if ([person[@"role"]isEqualToString:@"writer"])
            {
                //NSLog(@"%@", person[@"name"]);
                info.author = person[@"name"];
                [_comics addObject:info];
            }
            else if([person[@"role"]isEqualToString:@"artist"])
            {
                //NSLog(@"%@", person[@"name"]);
                info.artist = person[@"name"];
                [_comics addObject:info];
            }
        }
    }
    
    //NSLog(@"count from the model %lu",(unsigned long)_comics.count);
    
    // Ready to notify delegate that data is ready and pass back items
    if (self.delegate)
    {
        [self.delegate itemsRetrieved:_comics];
    }
}


@end
