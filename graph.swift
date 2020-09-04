//
//  graph.swift
//  fat
//
//  Created by 山口遥陽 on 2020/08/26.
//  Copyright © 2020 山口遥陽. All rights reserved.
//




import UIKit

class Graph: UIView {

   
    
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
    
    
    var lineWidth:CGFloat = 3.0 //グラフ線の太さ
    var lineColor_taiju:UIColor = UIColor(red:0.088,  green:0.501,  blue:0.979, alpha:1) //グラフ線の色
    var lineColor_sibo:UIColor = UIColor(red:0.088,  green:0.501,  blue:0, alpha:1) //グラフ線の色
    var circleWidth:CGFloat = 4.0 //円の半径
    var circleColor_taiju:UIColor = UIColor(red:0.088,  green:0.501,  blue:0.979, alpha:1) //円の色
    var circleColor_sibo:UIColor = UIColor(red:0.088,  green:0.501,  blue:0, alpha:1) //円の色

    var memoriMargin: CGFloat = 70 //横目盛の間隔
    var graphHeight: CGFloat = 400 //グラフの高さ
    var graphPoints: [String] = ["1","2","3","4","5","6","7","8"]
    var graphTaijuDatas: [CGFloat] = [0,0,0,0,0,0,0,0]
    var graphSiboDatas: [CGFloat] = [0,0,0,0,0,0,0,0]
    var i_graghTaijuDatas: [Int] = [0,0,0,0,0,0,0,0]
    var i_graghSiboDatas: [Int] = [0,0,0,0,0,0,0,0]
    
    /*
     データの値が１０００だった場合，入力されていないとして，その部分はグラフが空白になるようにします．
     */
    
    
    
    // UseDefaultsのインスタンスを生成
    let userDefaults = UserDefaults.standard
    
    
    
    // 保持しているDataの中で最大値と最低値の差を求める
     var yAxisMax: CGFloat {
         //return graphTaijuDatas.max()!-graphTaijuDatas.min()!
         return max(graphTaijuDatas.max()!-graphTaijuDatas.min()!,graphSiboDatas.max()!-graphSiboDatas.min()!)
     }

     //グラフ横幅を算出
     func checkWidth() -> CGFloat{
         return CGFloat(graphPoints.count-1) * memoriMargin + (circleWidth * 2)
     }

     //グラフ縦幅を算出
     func checkHeight() -> CGFloat{
         return graphHeight
     }
    
    
    func drawLineGraph()
    {
        let ud = UserDefaults.standard
        //ユーザーデフォルト
        //let ud = UserDefaults(suiteName: "A")!
        
        //graphPoints = ["2000/2/3", "2000/3/3", "2000/4/3", "2000/5/3", "2000/6/3", "2000/7/3", "2000/8/3"]
        //i_graghDatas = [100, 30, 10, -50, 90, 12, 40]
        

        
        for i in 0...ud.integer(forKey: "length")-1 {
            let data_hairetu = ud.array(forKey: "\(i)") as! [String]
            graphPoints[i] = data_hairetu[0]
            i_graghTaijuDatas[i] = Int(atof(data_hairetu[1]))
            i_graghSiboDatas[i] = Int(atof(data_hairetu[2]))
            graphTaijuDatas[i] = CGFloat(i_graghTaijuDatas[i])
            graphSiboDatas[i] = CGFloat(i_graghSiboDatas[i])
        }
    
        
        GraphFrame()
        MemoriGraphDraw()
    }

    //グラフを描画するviewの大きさ
    func GraphFrame(){
        self.backgroundColor = UIColor(red:0.972,  green:0.973,  blue:0.972, alpha:1)
        self.frame = CGRect(x:10 , y:0, width:checkWidth(), height:checkHeight())
    }

    //横目盛・グラフを描画する
    func MemoriGraphDraw() {

        var count:CGFloat = 0
        for memori in graphPoints {

            let label = UILabel()
            label.text = String(memori)
            label.font = UIFont.systemFont(ofSize: 9)

            //ラベルのサイズを取得
            let frame = CGSize(width: 250, height: CGFloat.greatestFiniteMagnitude)
            let rect = label.sizeThatFits(frame)

            //ラベルの位置
            var lebelX = (count * memoriMargin)-rect.width/2

            //最初のラベル
            if Int(count) == 0{
                lebelX = (count * memoriMargin)
            }

            //最後のラベル
            if Int(count+1) == graphPoints.count{
                lebelX = (count * memoriMargin)-rect.width
            }

            label.frame = CGRect(x: lebelX , y: graphHeight, width: rect.width, height: rect.height)
            self.addSubview(label)

            count += 1
        }
    }

    //グラフの線を描画
    override func draw(_ rect: CGRect) {

        var count_taiju:CGFloat = 0
        var count_sibo:CGFloat = 0
        let linePath_taiju = UIBezierPath()
        let linePath_sibo = UIBezierPath()
        var myCircle_taiju = UIBezierPath()
        var myCircle_sibo = UIBezierPath()

        linePath_taiju.lineWidth = lineWidth
        linePath_sibo.lineWidth = lineWidth
        

        
      
        
        lineColor_taiju.setStroke()
        //体重のグラフ描写
        for datapoint in graphTaijuDatas {
            //空白点
            if datapoint == 1000 {
                continue
            }
            
            if Int(count_taiju+1) < graphTaijuDatas.count {
                
                var nowY_taiju: CGFloat = datapoint/yAxisMax * (graphHeight - circleWidth)
                nowY_taiju = graphHeight - nowY_taiju

                if(graphTaijuDatas.min()!<0){
                    nowY_taiju = (datapoint - graphTaijuDatas.min()!)/yAxisMax * (graphHeight - circleWidth)
                    nowY_taiju = graphHeight - nowY_taiju
                }

    
                //空白点
                if graphTaijuDatas[Int(count_taiju+1)] == 1000 {
                   continue
               }
                
                
                
                //次のポイントを計算
                var nextY_taiju: CGFloat = 0
                nextY_taiju = graphTaijuDatas[Int(count_taiju+1)]/yAxisMax * (graphHeight - circleWidth)
                nextY_taiju = graphHeight - nextY_taiju

                if(graphTaijuDatas.min()!<0){
                    nextY_taiju = (graphTaijuDatas[Int(count_taiju+1)] - graphTaijuDatas.min()!)/yAxisMax * (graphHeight - circleWidth)
                    nextY_taiju = graphHeight - nextY_taiju - circleWidth
                }

                //最初の開始地点を指定
                var circlePoint:CGPoint = CGPoint()
                if Int(count_taiju) == 0 {
                    //体重の初期地点
                    linePath_taiju.move(to: CGPoint(x: count_taiju * memoriMargin + circleWidth, y: nowY_taiju))
                    circlePoint = CGPoint(x: count_taiju * memoriMargin + circleWidth, y: nowY_taiju)
                    myCircle_taiju = UIBezierPath(arcCenter: circlePoint,radius: circleWidth,startAngle: 0.0,endAngle: CGFloat(Double.pi*2),clockwise: false)
                    circleColor_taiju.setFill()
                    myCircle_taiju.fill()
                    myCircle_taiju.stroke()
                }

                //描画ポイントを指定
                linePath_taiju.addLine(to: CGPoint(x: (count_taiju+1) * memoriMargin, y: nextY_taiju))

                //体重のための円をつくる
                circlePoint = CGPoint(x: (count_taiju+1) * memoriMargin, y: nextY_taiju)
                myCircle_taiju = UIBezierPath(arcCenter: circlePoint,
                    // 半径
                    radius: circleWidth,
                    // 初角度
                    startAngle: 0.0,
                    // 最終角度
                    endAngle: CGFloat(Double.pi*2),
                    // 反時計回り
                    clockwise: false)
                circleColor_taiju.setFill()
                myCircle_taiju.fill()
                myCircle_taiju.stroke()
            }
            
            count_taiju += 1
            
        }
        

        
        
       
        
        lineColor_sibo.setStroke()
        //体脂肪のグラフ描写
        for datapoint in graphSiboDatas {
            //空白点
            if datapoint == 1000 {
                continue
            }
            
            if Int(count_sibo+1) < graphSiboDatas.count {

                var nowY_sibo: CGFloat = datapoint/yAxisMax * (graphHeight - circleWidth)
                nowY_sibo = graphHeight - nowY_sibo

                if(graphTaijuDatas.min()!<0){
                    nowY_sibo = (datapoint - graphSiboDatas.min()!)/yAxisMax * (graphHeight - circleWidth)
                    nowY_sibo = graphHeight - nowY_sibo
                }

                
                //空白点
                if graphSiboDatas[Int(count_sibo+1)] == 1000 {
                    continue
                }
                
                
                //次のポイントを計算
                var nextY_sibo: CGFloat = 0
                nextY_sibo = graphSiboDatas[Int(count_sibo+1)]/yAxisMax * (graphHeight - circleWidth)
                nextY_sibo = graphHeight - nextY_sibo

                if(graphSiboDatas.min()!<0){
                    nextY_sibo = (graphSiboDatas[Int(count_sibo+1)] - graphSiboDatas.min()!)/yAxisMax * (graphHeight - circleWidth)
                    nextY_sibo = graphHeight - nextY_sibo - circleWidth
                }

                //最初の開始地点を指定
                var circlePoint:CGPoint = CGPoint()
                if Int(count_sibo) == 0 {
                    //体脂肪の初期地点
                    linePath_sibo.move(to: CGPoint(x: count_sibo * memoriMargin + circleWidth, y: nowY_sibo))
                    circlePoint = CGPoint(x: count_sibo * memoriMargin + circleWidth, y: nowY_sibo)
                    myCircle_sibo = UIBezierPath(arcCenter: circlePoint,radius: circleWidth,startAngle: 0.0,endAngle: CGFloat(Double.pi*2),clockwise: false)
                    circleColor_sibo.setFill()
                    myCircle_sibo.fill()
                    myCircle_sibo.stroke()
                }
                
                //描画ポイントを指定
                linePath_sibo.addLine(to: CGPoint(x: (count_sibo+1) * memoriMargin, y: nextY_sibo))

  
                //体脂肪のための円をつくる
                circlePoint = CGPoint(x: (count_sibo+1) * memoriMargin, y: nextY_sibo)
                myCircle_sibo = UIBezierPath(arcCenter: circlePoint,
                    // 半径
                    radius: circleWidth,
                    // 初角度
                    startAngle: 0.0,
                    // 最終角度
                    endAngle: CGFloat(Double.pi*2),
                    // 反時計回り
                    clockwise: false)
                circleColor_sibo.setFill()
                myCircle_sibo.fill()
                myCircle_sibo.stroke()

            }

            count_sibo += 1

        }
   
        lineColor_taiju.setStroke()
        linePath_taiju.stroke()
        lineColor_sibo.setStroke()
        linePath_sibo.stroke()
    }
    
    
    
    
    
}
/*
    // 保持しているDataの中で最大値と最低値の差を求める
    var yAxisMax: CGFloat {
        return graphTaijuDatas.max()!-graphTaijuDatas.min()!
        //return max(graphTaijuDatas.max()!-graphTaijuDatas.min()!,graphSiboDatas.max()!-graphSiboDatas.min()!)
    }

    //グラフ横幅を算出
    func checkWidth() -> CGFloat{
        return CGFloat(graphPoints.count-1) * memoriMargin + (circleWidth * 2)
    }

    //グラフ縦幅を算出
    func checkHeight() -> CGFloat{
        return graphHeight
    }
 */
