//
//  VoicePlayTool.swift
//  VoiceMemo
//
//  Created by Ru on 16/11/16.
//  Copyright © 2016年 Ru. All rights reserved.
//


import UIKit
import AVFoundation


class VoicePlayTool: NSObject , AVAudioPlayerDelegate{

    
    static let shareInstance = VoicePlayTool()
    
    
    var player: AVAudioPlayer?
    var currentModel: VoiceRecordModel!
    
    
    
    func playVoice(model: VoiceRecordModel) -> () {
            //改变上一个model的状态
            if currentModel != nil  {
                currentModel.isPlaying = false
            }
            
            //改变model状态
            model.isPlaying = true
            
            let ducumentPath = NSHomeDirectory() + "/Documents/" + model.name! + ".caf"
            let url = URL(fileURLWithPath: ducumentPath)
            
            
            
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.prepareToPlay()
                player?.play()
                player?.delegate = self
                
                currentModel = model
            }catch {
                print(error)
                return
            }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "playStateDidChange"), object: nil)
        
        
        
        
        
       
        
    }
    
    func pauseVoice() -> () {
        player?.pause()
        currentModel.isPlaying = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "playStateDidChange"), object: nil)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        currentModel.isPlaying = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "playStateDidChange"), object: nil)
    }
    
}
