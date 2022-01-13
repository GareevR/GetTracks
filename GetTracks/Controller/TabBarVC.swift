//
//  TabBarVC.swift
//  GetTracks
//
//  Created by Ринат Гареев on 11.01.2022.
//

import UIKit

class TabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
     
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.minimumLineSpacing = CGFloat(30)
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 30, right: 5)
        
        let searchNC = UINavigationController(rootViewController: SearchVC(collectionViewLayout: collectionViewFlowLayout))
        searchNC.navigationBar.isTranslucent = false
//        searchNC.navigationBar.prefersLargeTitles = true
        searchNC.tabBarItem.title = "Search"
        searchNC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        let historyNC = UINavigationController(rootViewController: HistoryVC())
        historyNC.navigationBar.isTranslucent = false
        historyNC.tabBarItem.title = "History"
        historyNC.navigationBar.prefersLargeTitles = true
        historyNC.tabBarItem.image = UIImage(systemName: "book")
        
        self.viewControllers = [searchNC, historyNC]
        self.tabBar.isTranslucent = false
        view.backgroundColor = .white
    }
}


