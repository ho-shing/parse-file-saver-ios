//
//  ViewController.m
//  ParseFileSaver
//
//  Created by Wilson Tang on 25/9/14.
//  Copyright (c) 2014 Test Limited. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>

@interface ViewController ()

@property (strong, nonatomic) PFFile *videoFileToSend;
@property (nonatomic, assign) UIBackgroundTaskIdentifier sendMessageBackgroundTaskId;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButtonTapped:(id)sender {
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"sample_iTunes" ofType:@"mov"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    self.videoFileToSend = [PFFile fileWithName:@"Video.mp4" data:data];
    
    self.sendMessageBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.sendMessageBackgroundTaskId];
    }];
    
    [self.videoFileToSend saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error)
        {
            NSLog(@"Error in sending video file: %@", error);
            [[UIApplication sharedApplication] endBackgroundTask:self.sendMessageBackgroundTaskId];
            UIAlertView *alart = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send message" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alart show];
            [[UIApplication sharedApplication] endBackgroundTask:self.sendMessageBackgroundTaskId];
            return;
        }
        else
        {
            NSLog(@"Send video file successfully");
        }
    }];
}
@end
