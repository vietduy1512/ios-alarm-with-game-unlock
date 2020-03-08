//
//  CountDownViewController.swift
//  24_AlarmProject_1512004_1512012_1512068
//
//  Created by Tan on 5/25/18.
//  Copyright © 2018 Duy. All rights reserved.
//

import UIKit

class CountDownViewController: UIViewController {
    @IBOutlet weak var hourLbl: UILabel!
    @IBOutlet weak var minuteLbl: UILabel!
    @IBOutlet weak var secondLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func numpadKeyboard(_ sender: UIButton) {
        if (sender.tag != 10) {
            //Gan gia tri chuoi secondLbl cho bien secondStr, minuteLbl cho bien minuteStr
            var secondStr:String = secondLbl.text!
            var minuteStr:String = minuteLbl.text!
            
            addInputNumber(lbl: hourLbl, s: String(getFirstElement(s: minuteStr)))
            addInputNumber(lbl: minuteLbl, s: String(getFirstElement(s: secondStr)))
            addInputNumber(lbl: secondLbl, s: String(sender.tag))
        }
        else
        {
            deleteNumber()
        }
    }
    
    //Xu ly cac so duoc input
    func addInputNumber(lbl:UILabel, s:String)  //"s" la ky so tu duoc input tu keyboard
    {
        lbl.text?.remove(at: lbl.text!.startIndex)  //Loai bo ky tu dau tien cua chuoi label "lbl"
        lbl.text = lbl.text! + s    //Them ky tu duoc input tu keyboard vao cuoi chuoi lbl
    }
    
    //Ham lay ky tu dau tien trong chuoi s
    func getFirstElement(s:String)->Character {
        //lay index cua ky tu dau tien trong chuoi "s"
        let index = s.index(s.startIndex, offsetBy: 0)
        return s[index];
    }
    
    func deleteNumber() {
        var str:String = hourLbl.text! + minuteLbl.text! + secondLbl.text!
        print("str = \(str)")
        
        str.removeLast()
        print(str)
        str = "0" + str
        print(str)
        
        //Gan moi hai phan tu trong str cho tung label thoi gian tuong ung
        //-- Hai phan tu dau la gia tri hour
        var indexStart = str.index(str.startIndex, offsetBy: 2)
        let hour = str[..<indexStart]
        hourLbl.text = String(hour)
        print(hourLbl.text!)
        
        //-- Hai phan tu tiep cua "str" la gia tri minute
        var indexEnd = str.index(indexStart, offsetBy: 2)
        let minute = str[indexStart..<indexEnd]
        minuteLbl.text = String(minute)
        print(minuteLbl.text!)
        
        //-- Hai phan tu cuoi cua chuoi "str" la gia tri second
        indexStart = str.index(str.startIndex, offsetBy: 4)
        indexEnd = str.index(indexStart, offsetBy: 2)
        let second = str[indexStart..<indexEnd]
        secondLbl.text = String(second)
        print(secondLbl.text!)
        
        hourLbl.text = String(hour)
        minuteLbl.text = String(minute)
        secondLbl.text = String(second)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? StartCountDownViewController {
            destination.hour = hourLbl.text
            destination.minute = minuteLbl.text
            destination.second = secondLbl.text
        }
    }
  

}
