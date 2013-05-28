//
//  LevelViewController.m
//  Robolution
//
//  Created by Praktikant on 23.05.13.
//  Copyright (c) 2013 baniaf. All rights reserved.
//

#import "LevelSelectViewController.h"
#import "ViewController.h"




//extern int externlevel;
//NSInteger   *externLevel;

 @interface LevelSelectViewController ()

@end

@implementation LevelSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Segue: %@",segue.identifier);
    ViewController *gameController = segue.destinationViewController;

    NSString *levelIdentifier = segue.identifier;
    if ([levelIdentifier isEqualToString:@"level1_segue"]) {
        [gameController jumpToLevel:0];
    }
     else if ([levelIdentifier isEqualToString:@"level2_segue"]){
         [gameController jumpToLevel:1];

     
     }
     else if ([levelIdentifier isEqualToString:@"level3_segue"]){
         [gameController jumpToLevel:2];
         
         
     }
     else if ([levelIdentifier isEqualToString:@"level4_segue"]){
         [gameController jumpToLevel:3];
         
         
     }
     else if ([levelIdentifier isEqualToString:@"level5_segue"]){
         [gameController jumpToLevel:4];
         
         
     }
     else if ([levelIdentifier isEqualToString:@"level6_segue"]){
         [gameController jumpToLevel:5];
         
         
     }     else if ([levelIdentifier isEqualToString:@"level7_segue"]){
         [gameController jumpToLevel:6];
         
         
     }     else if ([levelIdentifier isEqualToString:@"level8_segue"]){
         [gameController jumpToLevel:7];
         
         
     }     else if ([levelIdentifier isEqualToString:@"level9_segue"]){
         [gameController jumpToLevel:8];
         
         
     }     
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
