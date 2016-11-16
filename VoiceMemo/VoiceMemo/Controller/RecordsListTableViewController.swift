//
//  RecordsListTableViewController.swift
//  VoiceMemo
//
//  Created by Ru on 16/11/16.
//  Copyright © 2016年 Ru. All rights reserved.
//

import UIKit

class RecordsListTableViewController: UITableViewController {
    var dataList = [VoiceRecordModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playStateDidChange), name: NSNotification.Name(rawValue: "playStateDidChange"), object: nil)
        
        if let dataList = CoreDataManager.shareInstance.getRecords(){
            self.dataList = dataList
        }else{
            print("cannot fetch data")
        }
    }

    
    
    
    func playStateDidChange() {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return dataList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VoiceCell", for: indexPath) as! VoiceCell
        let model = dataList[indexPath.row]
        cell.model = model
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    
    
    
    deinit {
        
        VoicePlayTool.shareInstance.pauseVoice()
        
        NotificationCenter.default.removeObserver(self)
        
    }


}
