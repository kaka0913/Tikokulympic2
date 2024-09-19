//
//  TikokuRankingViewModel.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/20.
//

import UIKit
import CoreLocation

class TikokuRankingViewModel {
    var currentLocation: CLLocationCoordinate2D?

    init() {
        // AppDelegateから位置情報を取得
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
           let location = appDelegate.currentLocation {
            self.currentLocation = location
            print("取得した位置: 緯度 \(location.latitude), 経度 \(location.longitude)")
        } else {
            print("位置情報がまだ取得されていません")
        }

        // 位置情報の更新を監視
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(locationDidUpdate(notification:)),
            name: Notification.Name("LocationDidUpdate"),
            object: nil
        )
    }

    @objc private func locationDidUpdate(notification: Notification) {
        if let userInfo = notification.userInfo,
           let location = userInfo["location"] as? CLLocationCoordinate2D {
            self.currentLocation = location
            print("更新された位置: 緯度 \(location.latitude), 経度 \(location.longitude)")
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("LocationDidUpdate"), object: nil)
    }
}
