//
//  comicModel.m
//  MyComics
//
//  Created by Michael Thomas on 8/1/14.
//
//

#import "comicModel.h"
#import "comicInfo.h"

@interface comicModel()
{
    NSMutableData *retrievedData;
}

@end

@implementation comicModel

- (void)getItems:(NSString *)searchQuery
{
    NSString *url = [NSString stringWithFormat:@"http://www.comicvine.com/api/search/?api_key=83e9c317513c910e43056bd5c694a7b91619388e&format=JSON&query=%@&resources=volume&resource_type=volume", searchQuery];
    
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
    
    // Create a new team object and set its props to JsonElement properties
    for (int i = 0; i < _objects.count; i++)
    {
        comicInfo *info = [[comicInfo alloc]init];
        
        //NSLog(@"%@",[[_objects valueForKey:@"count_of_issues"]objectAtIndex:i]);
        NSDictionary *publisher =[_objects valueForKey:@"publisher"];
        
        info.issueCount =[[_objects valueForKey:@"count_of_issues"]objectAtIndex:i];
        info.volumeName =[[_objects valueForKey:@"name"]objectAtIndex:i];
        info.volumeID = [[_objects valueForKey:@"id"]objectAtIndex:i];
        info.publisherName = [[publisher valueForKey:@"name"]objectAtIndex:i];
        
        //NSLog(@"%@", info.publisherName);
        
        [_comics addObject:info];
    }
    
    
    // Ready to notify delegate that data is ready and pass back items
    if (self.delegate)
    {
        [self.delegate itemsRetrieved:_comics];
    }
}


@end
