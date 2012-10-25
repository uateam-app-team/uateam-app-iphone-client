//
//  UATStreamingVC.m
//  UATeamClient
//
//    This file is part of UATeamClient.
//    UATeamClient is designed to give fast access to freshest releases on
//    <http://uateam.ua>.
//    Copyright (c) 2012 Andrii Titov. All rights reserved.
//
//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.
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
