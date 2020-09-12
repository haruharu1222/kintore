//
//  graph.swift
//  fat
//
//  Created by 山口遥陽 on 2020/08/26.
//  Copyright © 2020 山口遥陽. All rights reserved.
//



import UIKit


//配列拡張　値を指定すると，その値を削除
extension Array where Element: Equatable {
    mutating func remove(value: Element) {
        for _ in 0...self.count{
            if let i = self.firstIndex(of: value) {
                self.remove(at: i)
            }
        }
    }
}



class Graph: UIView {
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
    
    
    var lineWidth:CGFloat = 3.0 //グラフ線の太さ
    var lineColor_taiju:UIColor = UIColor(red:0.088,  green:0.501,  blue:0.979, alpha:1) //グラフ線の色
    var lineColor_sibo:UIColor = UIColor(red:0.088,  green:0.501,  blue:0, alpha:1) //グラフ線の色
    var circleWidth:CGFloat = 4.0 //円の半径
    var circleColor_taiju:UIColor = UIColor(red:0.088,  green:0.501,  blue:0.979, alpha:1) //円の色
    var circleColor_sibo:UIColor = UIColor(red:0.088,  green:0.501,  blue:0, alpha:1) //円の色

    var memoriMargin: CGFloat = 100 //横目盛の間隔
    var graphHeight: CGFloat = 400 //グラフの高さ
    let firstpoint_memori:CGFloat = 30
    
    var graphPoints: [String] = []
    var graphTaijuDatas: [CGFloat] = []
    var graphSiboDatas: [CGFloat] = []

    //入力がない
     let notin:CGFloat = 1000
    /* データの値が１０００だった場合，入力されていないとして，その部分はグラフが空白になるようにします．*/

    


     //グラフ横幅を算出
     func checkWidth() -> CGFloat{
        //return CGFloat(graphPoints.count-1) * memoriMargin + (circleWidth * 2) + (firstpoint_memori * 2)
         return CGFloat(graphPoints.count) * memoriMargin + (circleWidth * 2) + (firstpoint_memori * 2)
     }

     //グラフ縦幅を算出
     func checkHeight() -> CGFloat{
         return graphHeight
     }
    
    
    func drawLineGraph()
    {
        let ud = UserDefaults.standard

        
        if ud.integer(forKey: "length") != -1{
            for i in 0...ud.integer(forKey: "length") {
                let data_hairetu = ud.array(forKey: "\(i)") as! [String]
                graphPoints += [data_hairetu[0]]
                graphTaijuDatas += [CGFloat(Int(atof(data_hairetu[1])))]
                graphSiboDatas += [CGFloat(Int(atof(data_hairetu[2])))]
            }
        }
    
        
        GraphFrame()
        MemoriGraphDraw()
    }
    

    
    // 保持しているDataの中で最大値と最低値の差を求める
     var yAxisMax: CGFloat {
         //return max(graphTaijuDatas.max()!-graphTaijuDatas.min()!,graphSiboDatas.max()!-graphSiboDatas.min()!)
        var a:[CGFloat] = graphTaijuDatas
        var b:[CGFloat] = graphSiboDatas
         a.remove(value: notin)
         b.remove(value: notin)
        if a.max()==nil && b.max() == nil{
            return 100
        }else if a.max()==nil{
            return b.max()! + 10
        }else if b.max()==nil{
            return a.max()! + 10
        }else{
            return max(a.max()! + 10, b.max()! + 10)
        }
        //return max(graphTaijuDatas.max()! + 10, graphSiboDatas.max()! + 10)
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
            label.font = UIFont.systemFont(ofSize: 20)

            //ラベルのサイズを取得
            let frame = CGSize(width: 250, height: CGFloat.greatestFiniteMagnitude)
            let rect = label.sizeThatFits(frame)

            //ラベルの位置
            var lebelX = (count * memoriMargin) - rect.width/2 + firstpoint_memori

            //最初のラベル
            if Int(count) == 0{
                lebelX = (count * memoriMargin) + firstpoint_memori / 2
            }

            //最後のラベル
            if Int(count+1) == graphPoints.count && Int(count) != 0{
                lebelX = (count * memoriMargin)-rect.width + firstpoint_memori * 2
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
        var linePath_taiju = UIBezierPath()
        var linePath_sibo = UIBezierPath()
        var myCircle_taiju = UIBezierPath()
        var myCircle_sibo = UIBezierPath()
        
        var nodata_taiju:Int = 0
        var nodata_sibo:Int = 0

        linePath_taiju.lineWidth = lineWidth
        linePath_sibo.lineWidth = lineWidth
        
        
        
        
        
        //体重のグラフ描写
        for datapoint in graphTaijuDatas {
            //空白点
            if datapoint == notin {
                lineColor_taiju.setStroke()
                linePath_taiju.stroke()
                linePath_taiju = UIBezierPath()
                linePath_taiju.lineWidth = lineWidth
                nodata_taiju = 0
                count_taiju += 1
                continue
            }
            
            //データの座標の計算等
            if Int(count_taiju+1) < graphTaijuDatas.count {
                
                var nowY_taiju: CGFloat = datapoint/yAxisMax * (graphHeight - circleWidth)
                nowY_taiju = graphHeight - nowY_taiju

                if graphTaijuDatas.min()! < 0 {
                    nowY_taiju = (datapoint - graphTaijuDatas.min()!)/yAxisMax * (graphHeight - circleWidth)
                    nowY_taiju = graphHeight - nowY_taiju
                }

                //最初の開始地点を指定
                var circlePoint:CGPoint = CGPoint()
                if nodata_taiju == 0{
                    //体重の初期地点
                    linePath_taiju.move(to: CGPoint(x: count_taiju * memoriMargin + circleWidth + firstpoint_memori, y: nowY_taiju))
                    circlePoint = CGPoint(x: count_taiju * memoriMargin + circleWidth + firstpoint_memori, y: nowY_taiju)
                    myCircle_taiju = UIBezierPath(arcCenter: circlePoint,radius: circleWidth,startAngle: 0.0,endAngle: CGFloat(Double.pi*2),clockwise: false)
                    circleColor_taiju.setFill()
                    myCircle_taiju.fill()
                    myCircle_taiju.stroke()
                    
                    nodata_taiju = 1
                }
                
                //次のデータポイントが空白点
                if graphTaijuDatas[Int(count_taiju+1)] == notin {
                   count_taiju += 1
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

                //描画ポイントを指定
                linePath_taiju.addLine(to: CGPoint(x: (count_taiju+1) * memoriMargin + firstpoint_memori, y: nextY_taiju))

                //体重のための円をつくる
                circlePoint = CGPoint(x: (count_taiju+1) * memoriMargin + firstpoint_memori, y: nextY_taiju)
                myCircle_taiju = UIBezierPath(arcCenter: circlePoint, radius: circleWidth, startAngle: 0.0, endAngle: CGFloat(Double.pi*2), clockwise: false)
                circleColor_taiju.setFill()
                myCircle_taiju.fill()
                myCircle_taiju.stroke()
                
            }else if graphTaijuDatas.count == 1{
                var nowY_taiju: CGFloat = datapoint/yAxisMax * (graphHeight - circleWidth)
                nowY_taiju = graphHeight - nowY_taiju

                if graphTaijuDatas.min()! < 0 {
                    nowY_taiju = (datapoint - graphTaijuDatas.min()!)/yAxisMax * (graphHeight - circleWidth)
                    nowY_taiju = graphHeight - nowY_taiju
                }
                var circlePoint:CGPoint = CGPoint()
                linePath_taiju.move(to: CGPoint(x: count_taiju * memoriMargin + circleWidth + firstpoint_memori, y: nowY_taiju))
                circlePoint = CGPoint(x: count_taiju * memoriMargin + circleWidth + firstpoint_memori, y: nowY_taiju)
                myCircle_taiju = UIBezierPath(arcCenter: circlePoint,radius: circleWidth,startAngle: 0.0,endAngle: CGFloat(Double.pi*2),clockwise: false)
                circleColor_taiju.setFill()
                myCircle_taiju.fill()
                myCircle_taiju.stroke()
            }
            
            count_taiju += 1
            
        }
        lineColor_taiju.setStroke()
        linePath_taiju.stroke()
        


        
        
        //体脂肪のグラフ描写
        for datapoint in graphSiboDatas {
  
            //空白点
            if datapoint == notin {
                lineColor_sibo.setStroke()
                linePath_sibo.stroke()
                linePath_sibo = UIBezierPath()
                linePath_sibo.lineWidth = lineWidth
                nodata_sibo = 0
                count_sibo += 1
                continue
            }
            
            //データの座標の計算等
            if Int(count_sibo+1) < graphSiboDatas.count {

                var nowY_sibo: CGFloat = datapoint/yAxisMax * (graphHeight - circleWidth)
                nowY_sibo = graphHeight - nowY_sibo

                if(graphTaijuDatas.min()!<0){
                    nowY_sibo = (datapoint - graphSiboDatas.min()!)/yAxisMax * (graphHeight - circleWidth)
                    nowY_sibo = graphHeight - nowY_sibo
                }
                
                //最初の開始地点を指定
                var circlePoint:CGPoint = CGPoint()
                if nodata_sibo == 0 {
                    //体脂肪の初期地点
                    linePath_sibo.move(to: CGPoint(x: count_sibo * memoriMargin + circleWidth + firstpoint_memori, y: nowY_sibo))
                    circlePoint = CGPoint(x: count_sibo * memoriMargin + circleWidth + firstpoint_memori, y: nowY_sibo)
                    myCircle_sibo = UIBezierPath(arcCenter: circlePoint,radius: circleWidth,startAngle: 0.0,endAngle: CGFloat(Double.pi*2),clockwise: false)
                    circleColor_sibo.setFill()
                    myCircle_sibo.fill()
                    myCircle_sibo.stroke()
                    
                    nodata_sibo = 1
                }
     
                //次のデータポイントが空白点
                if graphSiboDatas[Int(count_sibo+1)] == notin {
                    count_sibo += 1
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
                
                //描画ポイントを指定
                linePath_sibo.addLine(to: CGPoint(x: (count_sibo+1) * memoriMargin + firstpoint_memori, y: nextY_sibo))

                //体脂肪のための円をつくる
                circlePoint = CGPoint(x: (count_sibo+1) * memoriMargin + firstpoint_memori, y: nextY_sibo)
                myCircle_sibo = UIBezierPath(arcCenter: circlePoint, radius: circleWidth, startAngle: 0.0, endAngle: CGFloat(Double.pi*2), clockwise: false)
                circleColor_sibo.setFill()
                myCircle_sibo.fill()
                myCircle_sibo.stroke()
            }else if graphSiboDatas.count == 1{
                var nowY_sibo: CGFloat = datapoint/yAxisMax * (graphHeight - circleWidth)
                nowY_sibo = graphHeight - nowY_sibo

                if(graphTaijuDatas.min()!<0){
                    nowY_sibo = (datapoint - graphSiboDatas.min()!)/yAxisMax * (graphHeight - circleWidth)
                    nowY_sibo = graphHeight - nowY_sibo
                }
                var circlePoint:CGPoint = CGPoint()
                    linePath_sibo.move(to: CGPoint(x: count_sibo * memoriMargin + circleWidth + firstpoint_memori, y: nowY_sibo))
                    circlePoint = CGPoint(x: count_sibo * memoriMargin + circleWidth + firstpoint_memori, y: nowY_sibo)
                    myCircle_sibo = UIBezierPath(arcCenter: circlePoint,radius: circleWidth,startAngle: 0.0,endAngle: CGFloat(Double.pi*2),clockwise: false)
                    circleColor_sibo.setFill()
                    myCircle_sibo.fill()
                    myCircle_sibo.stroke()
            }

            count_sibo += 1

        }
        lineColor_sibo.setStroke()
        linePath_sibo.stroke()
    }
}
