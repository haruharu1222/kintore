//
//  graphViewController.swift
//  fat
//
//  Created by 山口遥陽 on 2020/08/26.
//  Copyright © 2020 山口遥陽. All rights reserved.
//

import UIKit

class graphViewController: UIViewController {
    
    
    @IBOutlet weak var ratio_taiju: UILabel!
    @IBOutlet weak var ratio_sibo: UILabel!
    @IBOutlet weak var scview: UIScrollView!
    //storyboardでスクロールビューを配置しているので接続
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //*******グラフ描写********
        let graphview = Graph() //グラフを表示するクラス
        scview.addSubview(graphview) //グラフをスクロールビューに配置
        graphview.drawLineGraph() //グラフ描画開始

        scview.contentSize = CGSize(width:graphview.checkWidth()+20, height:graphview.checkHeight()) //スクロールビュー内のコンテンツサイズ設定
        //scview.contentSize = scview.visibleSize
        //scview.contentSize = CGSize(width:graphview.checkWidth()+20, height:scview.visibleSize.height)
        
        
        
        
        //*******前回との差　ラベル********
        let dt = Date()
        let dateFormatter = DateFormatter()
        let ud = UserDefaults.standard
        //入力がない
        let notin:Int = 1000
        //今日の日付取得
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMMd", options: 0, locale: Locale(identifier: "ja_JP"))
        
        let new_key = ud.integer(forKey: "length")
        let pre_key = new_key - 1
        
        if pre_key < 0{
            ratio_taiju.text = "-"
            ratio_sibo.text = "-"
        }else{
            let new_data_hairetu = ud.array(forKey: "\(new_key)") as! [String]
            let pre_data_hairetu = ud.array(forKey: "\(pre_key)") as! [String]
            
            if new_data_hairetu[0] == dateFormatter.string(from: dt){
                let r_taiju:Int = Int(atof(new_data_hairetu[1])) - Int(atof(pre_data_hairetu[1]))
                let r_sibo:Int = Int(atof(new_data_hairetu[2])) - Int(atof(pre_data_hairetu[2]))
                
                if new_data_hairetu[1] == "\(notin)" || pre_data_hairetu[1] == "\(notin)" || new_data_hairetu[1] == "" || pre_data_hairetu[1] == ""{
                    ratio_taiju.text = "-"
                }else{
                    if r_taiju > 0{
                        ratio_taiju.text = "+\(r_taiju)"
                    }else{
                        ratio_taiju.text = "\(r_taiju)"
                    }
                }
                
                if new_data_hairetu[2] == "\(notin)" || pre_data_hairetu[2] == "\(notin)" || new_data_hairetu[2] == "" || pre_data_hairetu[2] == ""{
                    ratio_sibo.text="-"
                }else{
                    if r_sibo > 0{
                        ratio_sibo.text = "+\(r_sibo)"
                    }else{
                        ratio_sibo.text = "\(r_sibo)"
                    }
                }
            }else{
                ratio_taiju.text = "-"
                ratio_sibo.text = "-"
            }
        }
        
    }
}
