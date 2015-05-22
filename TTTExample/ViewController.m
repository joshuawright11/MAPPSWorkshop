//
//  ViewController.m
//  TTTExample
//
//  Created by Josh Wright on 5/22/15.
//  Copyright (c) 2015 Josh Wright. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

// List of image views that are behind the buttons
@property (weak, nonatomic) IBOutlet UIImageView *iv1;
@property (weak, nonatomic) IBOutlet UIImageView *iv2;
@property (weak, nonatomic) IBOutlet UIImageView *iv3;
@property (weak, nonatomic) IBOutlet UIImageView *iv4;
@property (weak, nonatomic) IBOutlet UIImageView *iv5;
@property (weak, nonatomic) IBOutlet UIImageView *iv6;
@property (weak, nonatomic) IBOutlet UIImageView *iv7;
@property (weak, nonatomic) IBOutlet UIImageView *iv8;
@property (weak, nonatomic) IBOutlet UIImageView *iv9;

// List of buttons
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *b1;
@property (weak, nonatomic) IBOutlet UIButton *b2;
@property (weak, nonatomic) IBOutlet UIButton *b3;
@property (weak, nonatomic) IBOutlet UIButton *b4;
@property (weak, nonatomic) IBOutlet UIButton *b5;
@property (weak, nonatomic) IBOutlet UIButton *b6;
@property (weak, nonatomic) IBOutlet UIButton *b7;
@property (weak, nonatomic) IBOutlet UIButton *b8;
@property (weak, nonatomic) IBOutlet UIButton *b9;


@end

@implementation ViewController
{
    NSMutableArray *boardButtons;
    NSMutableArray *imageViews;

    NSMutableArray *state;
    
    BOOL xturn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    boardButtons = [NSMutableArray arrayWithArray:
                    @[self.b1, self.b2, self.b3, self.b4,
                      self.b5, self.b6, self.b7, self.b8, self.b9]];
    
    imageViews = [NSMutableArray arrayWithArray:
                  @[self.iv1, self.iv2, self.iv3, self.iv4,
                    self.iv5, self.iv6, self.iv7, self.iv8, self.iv9]];
    
    [self setup];
}

- (void)setup {

    state = [NSMutableArray arrayWithArray:@[@"e", @"e", @"e", @"e",
                                             @"e", @"e", @"e", @"e", @"e"]];

    for(UIImageView *iv in imageViews){
        iv.image = nil;
    }
    
    xturn = YES;
    self.statusLabel.text = @"It's X's turn!";
}

- (IBAction)boardPressed:(UIButton *)sender {
    
    NSInteger index = [boardButtons indexOfObject:sender];

    UIImageView *iv = imageViews[index];
    NSString *spot = state[index];
    
    if(![spot isEqualToString:@"e"]){
        return;
    }else if(xturn){
        UIImage *image = [UIImage imageNamed: @"x"];
        [iv setImage: image];
        state[index] = @"X";
    }else{
        UIImage *image = [UIImage imageNamed: @"o"];
        [iv setImage: image];
        state[index] = @"O";
    }
    
    if(![self testWinner]){
        xturn = !xturn;
        
        NSString *player = xturn ? @"X" : @"O";
        NSString *statusString = [NSString stringWithFormat:@"It's %@'s turn!", player];
        
        self.statusLabel.text = statusString;
    }
}

/**
 * 3 Cases: Vertical, Horizontal, Diagonal
 */
- (BOOL)testWinner {
    
    NSArray *winningCombinations =
      @[
        @[@0,@1,@2],@[@3,@4,@5],@[@6,@7,@8], // Vertical
        @[@0,@3,@6],@[@1,@4,@7],@[@2,@5,@8], // Horizontal
        @[@0,@4,@8],@[@6,@4,@2]              // Diagonal
      ];
    
    BOOL isWinner = [self testWinningCombinations:winningCombinations];
    
    if(!isWinner && ![state containsObject:@"e"]){
        self.statusLabel.text = @"Cat's game. :'(";
        return YES;
    }
    return isWinner;
}

// Checks every combination passed to see if all letters in that combination are the same (and either X or O)
- (BOOL)testWinningCombinations:(NSArray *)combos {
    
    for(NSArray *indices in combos){
        
        BOOL flag = YES;
        for(NSNumber *index in indices){
            
            if(![state[[indices[0] intValue]] isEqualToString:state[[index intValue]]]
               || ![@[@"X",@"O"] containsObject:state[[index intValue]]]){
                flag = NO;
            }
        }
        
        if(flag){
            self.statusLabel.text = [NSString stringWithFormat: @"%@ wins!!", state[[indices[0] intValue]]];
            return YES;
        }
    }
    
    return NO;
}

- (IBAction)resetPressed:(UIButton *)sender {
    [self setup];
}

@end
