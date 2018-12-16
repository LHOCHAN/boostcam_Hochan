//
//  Alert.swift
//  boostcamp_3_iOS
//
//  Created by 이호찬 on 16/12/2018.
//  Copyright © 2018 leehochan. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func networkErrorAlert(completion: @escaping ((UIAlertAction) -> Void) = {_ in}) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "네트워크 오류", message: "데이터를 받는데 실패하였습니다.", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "확인", style: .default, handler: completion)
            alertController.addAction(okayAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func sortActionSheet(completion: @escaping ((String) -> Void) = {_ in}) {
        let actionSheet = UIAlertController(title: "정렬방식 선택", message: "영화를 어떤 순서로 정렬할까요?", preferredStyle: .actionSheet)
        
        let reservationRate = UIAlertAction(title: "예매율", style: .default) { _ in
            MovieListData.shared.sortRule = MovieListData.orderType.reservationRate
            completion(MovieListData.shared.sortRule.name())
        }
        
        let userRating = UIAlertAction(title: "큐레이션", style: .default) { _ in
            MovieListData.shared.sortRule = MovieListData.orderType.curation
            completion(MovieListData.shared.sortRule.name())
        }
        
        let data = UIAlertAction(title: "개봉일", style: .default) { _ in
            MovieListData.shared.sortRule = MovieListData.orderType.openingDate
            completion(MovieListData.shared.sortRule.name())        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        actionSheet.addAction(reservationRate)
        actionSheet.addAction(userRating)
        actionSheet.addAction(data)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
}
