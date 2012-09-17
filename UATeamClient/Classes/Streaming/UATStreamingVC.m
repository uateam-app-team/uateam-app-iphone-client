//
//  UATStreamingVC.m
//  UATeamClient
//
//  Created by Andrii Titov on 8/12/12.
//  Copyright (c) 2012 uateam-app. All rights reserved.
//

#import "UATStreamingVC.h"

@interface UATStreamingVC ()

@end

@implementation UATStreamingVC

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieLoadStateDidChange:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    MPMoviePlayerController *player = self.moviePlayer;
    [player setMovieSourceType:MPMovieSourceTypeUnknown];
    player.controlStyle = MPMovieControlStyleEmbedded;
    [player.view setFrame: self.view.bounds];  // player's frame must match parent's
    [player prepareToPlay];
    
    // ...
    //[player play];
     
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload   
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)dealloc {
    //[self.moviePlayer stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - notifications from player

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    NSError *error = [[notification userInfo] objectForKey:@"error"];
    NSLog(@"%@",error);
    if (error) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Could not load video because of %@\nWould you like to try other app?",[error localizedDescription]] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Open", nil] show];
    }
}

//MPMoviePlayerLoadStateDidChangeNotification
- (void) movieLoadStateDidChange:(NSNotification*)notification {
    NSLog(@"%d",self.moviePlayer.loadState);
}

#pragma mark - alert delegate

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [[UIApplication sharedApplication] openURL:self.moviePlayer.contentURL];
    }
    [self.navigationController popViewControllerAnimated:(buttonIndex == alertView.cancelButtonIndex)];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
