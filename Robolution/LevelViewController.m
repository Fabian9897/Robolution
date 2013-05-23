//
//  LevelViewController.m
//  Robolution
//
//  Created by Praktikant on 23.05.13.
//  Copyright (c) 2013 baniaf. All rights reserved.
//

#import "LevelViewController.h"
#import "ViewController.h"




//extern int externlevel;

 @interface LevelViewController ()

@end

@implementation LevelViewController



-(IBAction)level1:(id)sender
{
    ViewController *viewController = [[ViewController alloc] init];
    [self presentViewController:viewController animated:YES completion:nil];
    viewController = [self.storyboard instantiateInitialViewController];
    

}

-(IBAction)level2:(id)sender
{
    ViewController *viewController = [[ViewController alloc] init];
    [self presentViewController:viewController animated:YES completion:nil];
    
    
    
}

-(IBAction)level3:(id)sender
{
    ViewController *viewController = [[ViewController alloc] init];
    [self presentViewController:viewController animated:YES completion:nil];
    
    
    
}

-(IBAction)level4:(id)sender
{
    ViewController *viewController = [[ViewController alloc] init];
    [self presentViewController:viewController animated:YES completion:nil];
    
    
    
}

-(IBAction)level5:(id)sender
{
    ViewController *viewController = [[ViewController alloc] init];
    [self presentViewController:viewController animated:YES completion:nil];
    
    
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
