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



//ユーザーデフォルトにデータを保存
///日付：体重，体脂肪






class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var today: UILabel!
    @IBOutlet weak var taiju_text: UITextField!
    @IBOutlet weak var sibo_text: UITextField!
    

    let dt = Date()
    let dateFormatter = DateFormatter()
    
    // UseDefaultsのインスタンスを生成
    let userDefaults = UserDefaults.standard
    
    

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
        let ud = UserDefaults.standard
       
        hideKeyboardWhenTappedAround()
        taiju_text.delegate = self
        sibo_text.delegate = self
        
        
        
        
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMd", options: 0, locale: Locale(identifier: "ja_JP"))
        today.text = dateFormatter.string(from: dt)
        
        
        let graphPoints = ["2000/2/3", "2000/3/3", "2000/4/3", "2000/5/3", "2000/6/3", "2000/7/3", "2000/8/3"]
        let graphDatas = [100, 30, 10, -50, 90, 12, 40]
 
        ud.set([100],forKey:"2000/2/3")
        
        for i in 0 ... 6{
            ud.set([graphDatas[i]],forKey: graphPoints[i])
        }
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    
    
    
    
    
    
    //体重入力
    @IBAction func taiju_in(_ sender: Any) {
        let input_text = taiju_text.text
        let ud = UserDefaults.standard
        //var tkiroku = kiroku[dateFormatter.string(from: dt)]

        
        //今日のデータは入力済みで，更新したいのか？そうでないなら，今日用の新たなキーを作成
        if ud.array(forKey: dateFormatter.string(from: dt)) != nil {
            var kiroku = ud.array(forKey: dateFormatter.string(from: dt)) as! [Int]
            
            //体重入力されてるか？
            if input_text != nil{
                //体重も体脂肪も入力済みのとき
                if kiroku.count == 2{
                    kiroku[0] = Int(input_text!)!
                }else{
                    let tmp = kiroku[0]
                    kiroku[0] = Int(input_text!)!
                    kiroku += [tmp]
                }
            }
            ud.set(kiroku,forKey: dateFormatter.string(from: dt))
        }else{
            var new_kiroku :[Int] = []
            //nilを強制アンラップはエラーが出るから
            if input_text != nil{
                //inputtextはoptional型だから強制アンラップ
                new_kiroku += [Int(input_text!)!]
                ud.set(new_kiroku, forKey: dateFormatter.string(from: dt))
            }
        }
        
      let a = ud.array(forKey: "2000/4/3") as! [Int]
      today.text = "\(a[0])"
           
           
    }
    
    
    
    
    

    //体脂肪
    @IBAction func sibo_in(_ sender: Any) {
       let input_text = sibo_text.text
       let ud = UserDefaults.standard
       //var tkiroku = kiroku[dateFormatter.string(from: dt)]

      
       //今日のデータは入力済みで，更新したいのか？そうでないなら，今日用の新たなキーを作成
       if ud.array(forKey: dateFormatter.string(from: dt)) != nil {
           var kiroku = ud.array(forKey: dateFormatter.string(from: dt)) as! [Int]
          
           //体脂肪入力されてるか？
           if input_text != nil{
               kiroku += [Int(input_text!)!]
           }
           ud.set(kiroku,forKey: dateFormatter.string(from: dt))
       }else{
           var new_kiroku :[Int] = []
           //nilを強制アンラップはエラーが出るから
           if input_text != nil{
               //inputtextはoptional型だから強制アンラップ
               new_kiroku += [Int(input_text!)!]
               ud.set(new_kiroku, forKey: dateFormatter.string(from: dt))
           }
       }
    }
}
/*
       if ud.kirokus(forKey: dateFormatter.string(from: dt)) != nil{
           tkiroku = [taiju_text.text!]
       }

       today.text = tkiroku![0]
       
       
       if kiroku! == []{
            UserDefaults.standard.kirokus = [dateFormatter.string(from: dt): [taiju_text.text!]]
       }else{
           if kiroku!.count == 2{
               kiroku![0] = taiju_text.text!
           }else{
               let tmp:String = kiroku![0]
               kiroku![0] = taiju_text.text!
               kiroku! += [tmp]
           }
       }
       
       UserDefaults.standard.kirokus[dateFormatter.string(from: dt)] = kiroku

   }
 */
