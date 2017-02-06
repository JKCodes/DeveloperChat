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

@end

#endif /* Header_h */
