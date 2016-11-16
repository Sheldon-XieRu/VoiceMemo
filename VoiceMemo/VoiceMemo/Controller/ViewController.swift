//
//  ViewController.swift
//  VoiceMemo
//
//  Created by Ru on 16/11/16.
//  Copyright © 2016年 Ru. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    
    //MARK: Property
    var currentRecorder: AVAudioRecorder?
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    
    var currentModel: VoiceRecordModel?
    
    
    
    //MARK: View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let session = AVAudioSession.sharedInstance()
        //ask grant
        switch session.recordPermission() {
        case AVAudioSessionRecordPermission.granted:
            print("Permission granted")
        case AVAudioSessionRecordPermission.denied:
            print("Pemission denied")
        case AVAudioSessionRecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                
            })
        default:
            break
        }
        
        
        //config
        
        do {
            try session.setActive(true)
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        } catch {
            fatalError("session init failed")
        }
        
        let longPressGes = UILongPressGestureRecognizer(target: self, action: #selector(recordBtnPressed))
        longPressGes.minimumPressDuration = 0.01
        recordButton.addGestureRecognizer(longPressGes)
    
        
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(playStateDidChange), name: NSNotification.Name(rawValue: "playStateDidChange"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    //MARK: Action
    
    func playStateDidChange() {
        playButton.isSelected = (currentModel?.isPlaying)!
    }
    
    
    @IBAction func play(_ sender: UIButton) {
        guard let currentModel = currentModel else {
            return
        }
        if currentModel.isPlaying == false {
            VoicePlayTool.shareInstance.playVoice(model: currentModel)
        }else{
            VoicePlayTool.shareInstance.pauseVoice()
        }
        
        
    }
    

    func recordBtnPressed(_ press: UILongPressGestureRecognizer) {
        switch press.state {
        case .began:
            recordButton.setTitle("正在录音", for: .normal)
            currentRecorder = getRecorder()
            currentRecorder?.record()
        case .ended:
            recordButton.setTitle("长按开始录音", for: .normal)
            let model = VoiceRecordModel()
            if let currentRecorder = currentRecorder{
                let nameWithSuffix = currentRecorder.url.absoluteString.components(separatedBy: "/").last
                model.name = nameWithSuffix?.components(separatedBy: ".").first
                currentModel = model
                playButton.isHidden = false
                CoreDataManager.shareInstance.insert(model: model)
            }
            
            currentRecorder?.stop()
            
        default:
            ()
        }
    }
    
    
    
    
    
    //MARK: get a new recorder
    func getRecorder() -> AVAudioRecorder? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd+HH:mm:ss"
        let recordName = formatter.string(from: Date()) + ".caf"
        
        let ducumentPath = NSHomeDirectory() + "/Documents/" + recordName
        
        let url = URL(fileURLWithPath: ducumentPath)
        print(url.absoluteString)
        
        let configDic:[String : Any] = [
            AVSampleRateKey: NSNumber(value: Float(11025.0)),
            AVFormatIDKey: NSNumber(value: Int32(kAudioFormatLinearPCM)),
            AVNumberOfChannelsKey: NSNumber(value: 2),
            AVEncoderAudioQualityKey: NSNumber(value: Int32(AVAudioQuality.medium.rawValue))
        ]
        
        do{
            let record = try AVAudioRecorder(url: url, settings: configDic)
            record.prepareToRecord()
            
            return record
            
        }catch{
            print(error)
            return nil
        }
    }



}

