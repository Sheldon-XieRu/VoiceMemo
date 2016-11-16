//
//  VoiceCell.swift
//  VoiceMemo
//
//  Created by Ru on 16/11/16.
//  Copyright © 2016年 Ru. All rights reserved.
//

import UIKit

class VoiceCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    }
    
    
    var model: VoiceRecordModel! {
        didSet {
            nameLabel.text = model.name
            playButton.isSelected = model.isPlaying
        }
    }
    
    
    
    
    @IBAction func playButtonClicked(_ sender: UIButton) {
        
        if sender.isSelected == false {
            VoicePlayTool.shareInstance.playVoice(model: model)
        }else{
            
            VoicePlayTool.shareInstance.pauseVoice()
        }
        
        
        
    }
    

}
