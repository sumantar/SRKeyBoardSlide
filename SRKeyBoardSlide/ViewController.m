//
//  ViewController.m
//  SRKeyBoardSlide
//
//  Created by sumantar on 14/03/13.
//  Copyright (c) 2013 sumantar. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    CGFloat animationDuration;
    CGRect  keyboardFrame;
    float   viewOffset;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)notification{
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardFrame1 = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"keyboardFrame1: %@", NSStringFromCGRect(keyboardFrame1));
    
}
- (void)keyboardWillShow:(NSNotification*)notification{
    NSDictionary *userInfo = [notification userInfo];
    keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //Convert screen coordinate to view coordinate
    keyboardFrame = [self.view convertRect:keyboardFrame fromView:nil];
    
    NSLog(@"keyboardFrame: %@", NSStringFromCGRect(keyboardFrame));
    animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [self moveViewUp:_activeField];
}
- (void)keyboardWillBeHidden:(NSNotification*)notification{
    [self moveViewDown];
}

-(void)moveViewUp:(UITextField *)textField{
    // Scroll the hidden textField
    CGRect rect = self.view.frame;
    
    //Get visible rectangle after removing keyboard
    rect.size.height -= keyboardFrame.size.height;
    
    //Get TextField left buttom edge point
    CGPoint activeFieldPoint =textField.frame.origin;
    activeFieldPoint.y += textField.frame.size.height;
    
    //initialize offset
    viewOffset = 0.0;
    
    //Check if TextField left buttom edge point is visible
    if (!CGRectContainsPoint(rect, activeFieldPoint) ) {
        //viewOffset = [self isLandScape] ? _activeField.frame.origin.y-keyboardFrame.size.width: _activeField.frame.origin.y-keyboardFrame.size.height;
        viewOffset = _activeField.frame.origin.y-keyboardFrame.size.height;
        
        CGRect viewFrame = self.view.frame;
        
        viewFrame.origin.y -= viewOffset;
        [UIView animateWithDuration:animationDuration animations:^{
            [self.view setFrame:viewFrame];
        }];
    }
}

-(void)moveViewDown{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += viewOffset;
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view setFrame:viewFrame];
    }];
}

- (BOOL)isLandScape{
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    
    return (!(orientation == UIInterfaceOrientationPortrait ||
              orientation == UIInterfaceOrientationPortraitUpsideDown));
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _activeField = nil;
}
@end
