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
#import "Sprite.h"

@interface ViewController : UIViewController {
    // Das duerfte bekannt sein:
    UIImageView *canvas;
    Sprite *player;
    int zaehler;
    bool normalAction;
    int level;
    double screenWidth;
    double screenHeight;
    
    // Steuerung
    UIImageView *joypad;
    UIImageView *jumpButton;
    double playerSpeedX;
    double playerSpeedY;
    bool playerHasContactToFloor; // Bodenkontakt fuer Spruenge
    bool playerAddJumpEnergy; // Sprungkraft
    int playerLooksLike; // fuer Animation
    
    // Plattformen
    NSMutableArray *levelSource;
    NSMutableArray *platforms;
    int maxPlatformWidth;
    
    // Preloader fuer die Grafiken
    NSMutableArray *imageSource;
    NSMutableArray *platformGraphicSource;
    NSMutableArray *animationSource;
    
    // Parallax-Scrolling
    Sprite *layer0;
    Sprite *layer1;
    Sprite *fogLayer;
    double fogMove;
    
}


@property (nonatomic,strong) UIImageView *canvas;
@property (nonatomic,strong) UIImageView *joypad;
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

@end

