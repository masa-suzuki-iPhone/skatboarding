//
//  CommentViewController.swift
//  Skateboarding
//
//  Created by 鈴木正義 on 2021/01/28.
//  Copyright © 2021 masayoshi.suzuki. All rights reserved.
//

import UIKit
import FirebaseUI
import SVProgressHUD

class CommentViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var roadSurfaceLabel: UILabel!
    @IBOutlet weak var kickoutLabel: UILabel!
    @IBOutlet weak var rainyLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    //前画面からデータを受け取るための変数
    var postDataReceived: PostData?
    
    func setPostData(_ postData: PostData) {
           postDataReceived = postData
        
       }
    
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
        
        guard let postData = postDataReceived else {
            return
        }
        
       imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
       let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
       imageView.sd_setImage(with: imageRef)
        
                // キャプションと詳細と説明の表示
        self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"
        self.roadSurfaceLabel.text = "\(postData.roadsurface!)"
        self.kickoutLabel.text = "\(postData.kickout!)"
        self.rainyLabel.text = "\(postData.rainy!)"
        self.categoryLabel.text = "\(postData.category!)"
        self.detailLabel.text = "\(postData.detail!)"

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
