//
//  graphViewController.swift
//  fat
//
//  Created by 山口遥陽 on 2020/08/26.
//  Copyright © 2020 山口遥陽. All rights reserved.
//

import UIKit

class graphViewController: UIViewController {
    
    @IBOutlet weak var scview: UIScrollView!
    //storyboardでスクロールビューを配置しているので接続

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let graphview = Graph() //グラフを表示するクラス
        scview.addSubview(graphview) //グラフをスクロールビューに配置
        graphview.drawLineGraph() //グラフ描画開始

        scview.contentSize = CGSize(width:graphview.checkWidth()+20, height:graphview.checkHeight()) //スクロールビュー内のコンテンツサイズ設定
    }
}
