//
//  AgoraManager.swift
//  Agora Demo
//
//  Created by iOS Team on 16/07/25.
//

import Foundation
import AgoraRtcKit
import UIKit
import AVFoundation

class AgoraManager: NSObject {
    static let shared = AgoraManager()

    var agoraKit: AgoraRtcEngineKit!
    let appID = "ba67a60a8b3d4ab8b226d58433f14887"
    let token: String = "007eJxTYHi3NYQzc9e+xK/P+E7P8yy0jk8z19WKyvmoeeTuaqkH7BYKDEmJZuaJZgaJFknGKSaJSRZJRkZmKaYWJsbGaYYmFhbmazd2ZjQEMjJ4RRuzMDJAIIjPxZCRWFScEe+SmpvPwAAA/uEg6g=="
    var channelName: String = "harsh_Demo"
    var closureRemoteView: ((UInt) -> ()) = {_ in}
    var closureAudioCallJoined: ((UInt) -> ()) = {_ in}
    var closureRemoteViewOnOff: ((Bool) -> ()) = {_ in}
    var closureCallLeft: (() -> ())?
    var isSpeakerOn: Bool = true
    
    override init() {
        super.init()
        initializeAgora()
    }

    func initializeAgora() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: appID, delegate: self)
    }
    
    func joinChannel(channelName: String) {
        agoraKit.setAudioSessionOperationRestriction(.all)
        agoraKit.enableAudio()
        //for video call only
        //agoraKit.enableVideo()
        //agoraKit.muteLocalVideoStream(false)
        //agoraKit.muteAllRemoteVideoStreams(false)
        agoraKit.muteLocalAudioStream(false)
        agoraKit.muteAllRemoteAudioStreams(false)
        agoraKit.setChannelProfile(.communication)
        agoraKit.setDefaultAudioRouteToSpeakerphone(true)
        agoraKit.joinChannel(byToken: token, channelId: channelName, info: nil, uid: 0) { [weak self] _, _, _ in
            guard let self = self else{ return }
            //presentVideoCallScreen()
            presentAudioCallScreen()
        }
    }
    
    func presentAudioCallScreen() {
        guard let rootVC = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            print("❌ Couldn't get root view controller")
            return
        }
        if rootVC.presentedViewController is AudioCall {
            print("ℹ️ AudioCall is already presented")
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let audioCallVC = storyboard.instantiateViewController(withIdentifier: "AudioCall") as? AudioCall {
            audioCallVC.modalPresentationStyle = .fullScreen
            audioCallVC.modalTransitionStyle = .crossDissolve
            rootVC.present(audioCallVC, animated: true, completion: nil)
        }
    }
    
    func presentVideoCallScreen() {
        guard let rootVC = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            print("❌ Couldn't get root view controller")
            return
        }
        if rootVC.presentedViewController is VideoCallVC {
            print("ℹ️ VideoCallVC is already presented")
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let videoCallVC = storyboard.instantiateViewController(withIdentifier: "VideoCallVC") as? VideoCallVC {
            videoCallVC.modalPresentationStyle = .fullScreen
            videoCallVC.modalTransitionStyle = .crossDissolve
            rootVC.present(videoCallVC, animated: true, completion: nil)
        }
    }
    
    func leaveChannel() {
        agoraKit.leaveChannel(nil)
        agoraKit.stopPreview()
        print("✅ Left channel")
    }
    
    func switchCamera(){
        agoraKit.switchCamera()
    }
    
    func muteCall(isMute: Bool){
        agoraKit.muteLocalAudioStream(isMute)
    }
    
    func muteLocalVideoStream(isCameraOff: Bool){
        agoraKit.muteLocalVideoStream(isCameraOff)
    }
    
    func setEnableSpeakerphone(){
        isSpeakerOn.toggle()
        agoraKit.setEnableSpeakerphone(isSpeakerOn)
        toggleAudioRoute()
    }
    
    func toggleAudioRoute(){
        let session = AVAudioSession.sharedInstance()
        do{
            if isSpeakerOn{ 
                try session.overrideOutputAudioPort(.speaker)
            }else{
                try session.overrideOutputAudioPort(.none)
            }
        }catch{
            print("Audio route toggle failed: \(error.localizedDescription)")
        }
    }
}

extension AgoraManager: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        print("Successfully joined channel: \(channel) with UID: \(uid)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        print("👤 Remote user joined with uid: \(uid)")
        //closureRemoteView(uid)
        closureAudioCallJoined(uid)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        print("❌ Remote user left")
        self.closureCallLeft?()
        leaveChannel()
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoMuted muted: Bool, byUid uid: UInt) {
        print("🎥 Remote video \(muted ? "stopped" : "resumed") by uid: \(uid)")
        self.closureRemoteViewOnOff(muted)
    }
}
