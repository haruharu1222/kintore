//
//  ViewController.swift
//  fat
//
//  Created by 山口遥陽 on 2020/08/26.
//  Copyright © 2020 山口遥陽. All rights reserved.
//

import UIKit


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}


//ユーザーデフォルト
let ud = UserDefaults.standard
//ユーザーデフォルトにデータを保存
///データの長さ
///辞書型[key : 何番目のデータか　：　value : 配列[日付，体重，体脂肪]]





class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var today: UILabel!
    @IBOutlet weak var taiju_text: UITextField!
    @IBOutlet weak var sibo_text: UITextField!
    

    let dt = Date()
    let dateFormatter = DateFormatter()
    
    // UseDefaultsのインスタンスを生成
    let userDefaults = UserDefaults.standard
    
    //入力がない
    let notin:Int = 1000
    
    

    @IBAction func unwindToTop(segue: UIStoryboardSegue) {
    }


    //数字のみを受け付ける
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
          let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
          let compSepByCharInSet = string.components(separatedBy: aSet)
          let numberFiltered = compSepByCharInSet.joined(separator: "")
          return string == numberFiltered
    }
    
    //returnキーでキーボード閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    

    
/*
     ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    ここから，画面の動き
     ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 */
    override func viewDidLoad() {
        //let ud = UserDefaults.standard
       
        hideKeyboardWhenTappedAround()
        taiju_text.delegate = self
        sibo_text.delegate = self
        
        
        
        
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMMd", options: 0, locale: Locale(identifier: "ja_JP"))
        today.text = dateFormatter.string(from: dt)
        

        let graphPoints = ["2月3日", "3月3日", "4月3日", "5月3日", "6月3日", "7月3日", "8月3日"]
        let graphTaijuDatas = ["100", "94", "1000", "89", "1000", "1000", "80"]
        //let graphTaijuDatas = ["100", "94", "90", "89", "80", "87", "81"]
        let graphSiboDatas = ["40", "32", "30", "23", "34", "29", "40"]
        var date_length:Int = 0
 
        
        for i in 0 ... graphPoints.count-1{
            ud.set([graphPoints[i],graphTaijuDatas[i],graphSiboDatas[i]], forKey: "\(i)")
            if i == 0{
                date_length = 0
            }else{
                date_length += 1
            }
        }
        

        if ud.object(forKey: "length") == nil {
            ud.set(date_length,forKey: "length")
        }
        

        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    

    
    //体重入力
    @IBAction func taiju_in(_ sender: Any) {
        let input_text = taiju_text.text
        
        var data_length = ud.integer(forKey: "length")

        //ユーザーデフォルトにセット
        var new_data_hairetu:[String] = []
        var old_data_hairetu:[String] = []
        
        
        //体重入力されてるか？
        if input_text != ""{
            if data_length >= 0{
                old_data_hairetu = ud.array(forKey: "\(data_length)") as! [String]
                //今日のデータは入力済みで，更新したいのか？そうでないなら，今日用の新たなキーを作成
                if old_data_hairetu[0] == dateFormatter.string(from: dt){
                    old_data_hairetu[1] = input_text!
                    ud.set(old_data_hairetu, forKey: "\(data_length)")
                }else{
                    new_data_hairetu += [dateFormatter.string(from: dt)]
                    new_data_hairetu += [input_text!]
                    new_data_hairetu += ["\(notin)"]
                    ud.set(new_data_hairetu, forKey: "\(data_length + 1)")
                    data_length += 1
                    ud.set(data_length,forKey: "length")
                }
            }else{
                old_data_hairetu += [dateFormatter.string(from: dt)]
                old_data_hairetu += [input_text!]
                old_data_hairetu += ["\(notin)"]
                ud.set(old_data_hairetu, forKey: "0")
                data_length = 0
                ud.set(data_length,forKey: "length")
            }
        }
        //plistファイルへの出力と同期する。
        userDefaults.synchronize()
    }
    
    
    
    

    //体脂肪
    @IBAction func sibo_in(_ sender: Any) {
        let input_text = sibo_text.text
        var data_length = ud.integer(forKey: "length")

        
        //ユーザーデフォルトにセット
        var new_data_hairetu:[String] = []
        var old_data_hairetu:[String] = []
        
        //体脂肪入力されてるか？
        if input_text != ""{
            if data_length > 0{
                old_data_hairetu = ud.array(forKey: "\(data_length)") as! [String]
                //今日のデータは入力済みで，更新したいのか？そうでないなら，今日用の新たなキーを作成
                if old_data_hairetu[0] == dateFormatter.string(from: dt){
                    old_data_hairetu[2] = input_text!
                    ud.set(old_data_hairetu, forKey: "\(data_length)")
                }else{
                    new_data_hairetu += [dateFormatter.string(from: dt)]
                    new_data_hairetu += ["\(notin)"]
                    new_data_hairetu += [input_text!]
                    ud.set(new_data_hairetu, forKey: "\(data_length + 1)")
                    data_length += 1
                    ud.set(data_length,forKey: "length")
                }
            }else{
                old_data_hairetu += [dateFormatter.string(from: dt)]
                old_data_hairetu += ["\(notin)"]
                old_data_hairetu += [input_text!]
                ud.set(old_data_hairetu, forKey: "0")
                data_length = 0
                ud.set(data_length,forKey: "length")
            }
        }
        //plistファイルへの出力と同期する。
        userDefaults.synchronize()
   }
}
    
