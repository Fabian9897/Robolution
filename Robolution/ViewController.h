//
//  ViewController.h
//  Robolution
//
//  Created by Fabian Töpfer on 10.05.13.
//  Copyright (c) 2013 baniaf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>

#import "Sprite.h"




@interface ViewController : UIViewController {
     UIImageView *canvas;
    Sprite *player;
    int zaehler;
    bool normalAction;
    int level;
    double screenWidth;
    double screenHeight;
    
    // Steuerung
    UIImageView *rechtsButton;
    UIImageView *linksButton;
    UIImageView *powerAnzeige;

    UIImageView *jumpButton;
    double playerSpeedX;
    double playerSpeedY;
    bool playerHasContactToFloor; // Bodenkontakt fuer Spruenge
    bool playerAddJumpEnergy;  
    int playerLooksLike; // fuer Animation
   
    //SCHRITTE
    int maxSteps;
    int currentSteps;
    int  steps ;
    
    
    // Plattformen
    NSMutableArray *levelSource;
    NSMutableArray *platforms;
    int maxPlatformWidth;
    
    // Preloader  
    NSMutableArray *imageSource;
    NSMutableArray *platformGraphicSource;
    NSMutableArray *animationSource;
    
    // Parallax 
    Sprite *layer0;
    Sprite *layer1;
    Sprite *fogLayer;
    double fogMove;
    
    
    UITextField *Level;
    
  //  bool bewegung;
     
}


@property (nonatomic,strong) UIImageView *canvas;
@property (nonatomic,strong) UIImageView *rechtsButton;
@property (nonatomic,strong) UIImageView *linksButton;
@property (nonatomic,strong) UIImageView *powerAnzeige;
@property (nonatomic,strong) UIImageView *cloud;

@property (nonatomic,strong) UIImageView *jumpButton;
@property (nonatomic,strong) Sprite *player;
@property (nonatomic, strong) NSMutableArray *imageSource;
@property (nonatomic, strong) NSMutableArray *animationSource;

@property (nonatomic, strong) NSMutableArray *platformGraphicSource;
@property (nonatomic, strong) NSMutableArray *levelSource;
@property (nonatomic, strong) NSMutableArray *platforms;
@property (nonatomic,strong) Sprite *layer0;
@property (nonatomic,strong) Sprite *layer1;
@property (nonatomic,strong) Sprite *fogLayer;

//@property  int level;



//DEBUG
 @property (nonatomic,strong) UITextField *Level;

@end

