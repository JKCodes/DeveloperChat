//
//  Header.h
//  DeveloperChat
//
//  Created by Joseph Kim on 2/5/17.
//  Copyright © 2017 Joseph Kim. All rights reserved.
//

#ifndef Header_h
#define Header_h


@protocol AAPLCameraVCDelegate <NSObject>

-(void)shouldEnableRecordUI:(BOOL)enable;
-(void)shouldEnableCameraUI:(BOOL)enable;
-(void)recordingHasStarted;
-(void)canStartRecording;
-(void)videoRecordingFailed;
-(void)snapshotFailed;
-(void)snapshotTaken:(NSData*)imageData;
-(void)videoRecordingComplete:(NSURL *)outputFileURL;

@end

#endif /* Header_h */
