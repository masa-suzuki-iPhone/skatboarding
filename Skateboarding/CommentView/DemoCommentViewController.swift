//
//  DemoCommentViewController.swift
//  Skateboarding
//
//  Created by 鈴木正義 on 2021/01/29.
//  Copyright © 2021 masayoshi.suzuki. All rights reserved.
//

import UIKit
import FirebaseUI


class DemoCommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var detailTableView: UITableView!
    
    //前画面からデータを受け取るための変数
    var postDataReceived: PostData!
    func setPostData(_ postData: PostData) {
        postDataReceived = postData
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        detailTableView.delegate = self
        detailTableView.dataSource = self
        
        //         カスタムセルを登録する
        let nib = UINib(nibName: "imageTableViewCell", bundle: nil)
        detailTableView.register(nib, forCellReuseIdentifier: "cell1")
        
        detailTableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
//        if let cell = cell as? imageTableViewCell {
//            cell.setPostData(postDataReceived)
//            return cell
//        }
        
        return cell
    }
    
    
    
}

