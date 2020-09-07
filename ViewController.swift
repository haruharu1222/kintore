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
//let ud = UserDefaults(suiteName: "A")!
let ud = UserDefaults.standard



//ユーザーデフォルトにデータを保存
///ID：日付，体重，体脂肪






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
        //outputText.text = textField.text
        return true
    }
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        //let ud = UserDefaults.standard
       
        hideKeyboardWhenTappedAround()
        taiju_text.delegate = self
        sibo_text.delegate = self
        
        
        
        
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMMd", options: 0, locale: Locale(identifier: "ja_JP"))
        today.text = dateFormatter.string(from: dt)
        

        let graphPoints = ["2000/2/3", "2000/3/3", "2000/4/3", "2000/5/3", "2000/6/3", "2000/7/3", "2000/8/3"]
        let graphDatas = ["100", "30", "10", "-50", "90", "12", "40"]
        var date_length:Int = 0
 
        
        for i in 0 ... 6{
            ud.set([graphPoints[i],graphDatas[i],graphDatas[i]], forKey: "\(i)")
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
        if input_text != nil{
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
        //let ud = UserDefaults.standard
        //var tkiroku = kiroku[dateFormatter.string(from: dt)]
        var data_length = ud.integer(forKey: "length")

      
        
        
        //ユーザーデフォルトにセット
        var new_data_hairetu:[String] = []
        var old_data_hairetu:[String] = []
        
        
        //体脂肪入力されてるか？
        if input_text != nil{
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
    
