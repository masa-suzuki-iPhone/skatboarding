//
//  MapViewController.swift
//  Skateboarding
//
//  Created by 鈴木正義 on 2021/02/08.
//  Copyright © 2021 masayoshi.suzuki. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var mapManager: CLLocationManager = CLLocationManager()
    var latitude: CLLocationDegrees! = CLLocationDegrees()
    var longitude: CLLocationDegrees! = CLLocationDegrees()
    var gmaps: GMSMapView!
    var markers: [GMSMarker] = []
    
    // 投稿データを格納する配列
    var postArray: [PostData] = []
    // Firestoreのリスナー
    var listener: ListenerRegistration!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "マップ"
        self.navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 0, green: 0.4745, blue: 0.6784, alpha: 1)
        
        mapManager.delegate = self
        mapManager.requestWhenInUseAuthorization()
        mapManager.requestAlwaysAuthorization()
        mapManager.desiredAccuracy = kCLLocationAccuracyBest
        mapManager.distanceFilter = 1000
        mapManager.startUpdatingLocation()
        
        gmaps = GMSMapView(frame: CGRect(x:0, y:0, width:self.view.bounds.width, height:self.view.bounds.width))
        self.view.addSubview(gmaps)
        gmaps.isMyLocationEnabled = true
        gmaps.settings.compassButton = true
        
        self.view = gmaps
        gmaps.delegate = self
        
        if Auth.auth().currentUser != nil {
            // ログイン済み
            if listener == nil {
                // listener未登録なら、登録してスナップショットを受信する
                let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
                listener = postsRef.addSnapshotListener() { (querySnapshot, error) in
                    if let error = error {
                        print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                        return
                    }
                    // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                    self.postArray = querySnapshot!.documents.map { document in
                        print("DEBUG_PRINT: document取得 \(document.documentID)")
                        let postData = PostData(document: document)
                        self.postArray.insert(postData, at: 0)
                        self.makeMarker(postData: postData)
                        return postData
                    }
                   
                }
            }
        } else {
            // ログイン未(またはログアウト済み)
            if listener != nil {
                // listener登録済みなら削除してpostArrayをクリアする
                listener.remove()
                listener = nil
                postArray = []
            }
        }
        
    }
    
    func makeMarker(postData: PostData) -> [GMSMarker] {
        
        let marker = GMSMarker()
        let latitude = Double(postData.latitude!)
        let longitude = Double(postData.longitude!)
        
        marker.position = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        
        marker.title = "\(postData.caption!)"
        marker.tracksInfoWindowChanges = true //情報ウィンドウを自動的に更新するように設定する
        marker.appearAnimation = GMSMarkerAnimation.pop //マーカーの表示にアニメーションをつける
        gmaps.selectedMarker = marker //デフォルトで情報ウィンドウを表示
        marker.map = self.gmaps
        
        markers = [marker]
        
        return markers
    }
    
    //現在地の読み込み完了時に呼ばれるメソッド
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        latitude = userLocation.coordinate.latitude
        longitude = userLocation.coordinate.longitude
        let now :GMSCameraPosition = GMSCameraPosition.camera(withLatitude: latitude,longitude:longitude,zoom:14)
        gmaps.camera = now
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
