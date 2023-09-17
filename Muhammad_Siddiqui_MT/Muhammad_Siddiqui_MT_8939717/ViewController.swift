//
//  ViewController.swift
//  Muhammad_Siddiqui_MT_8939717
//
//  Created by user229166 on 7/5/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    var myCount = 0
    var Step = 1
    var Reset = 0
    
    @IBOutlet weak var Count: UILabel!
    
    
    @IBAction func Increment(_ sender: Any) {
        myCount = myCount + Step
        Count.text = String(myCount)
    }
    
    
    @IBAction func Decrement(_ sender: Any) {
        myCount = myCount - Step
        Count.text = String(myCount)
    }
    
    
    @IBAction func Reset(_ sender: Any) {
        myCount = 0
        Count.text = String(myCount)
    }
    
    @IBAction func Step2(_ sender: Any) {
        if(Step == 1){
        Step = 2
        }else{
            Step = 1
        }
        Count.text = String(myCount)
        
    }
}

