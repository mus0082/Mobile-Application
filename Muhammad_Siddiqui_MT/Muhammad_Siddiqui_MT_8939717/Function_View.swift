//
//  Function_View.swift
//  Muhammad_Siddiqui_MT_8939717
//
//  Created by user229166 on 7/5/23.


import UIKit

class Function_View: UIViewController {

    
    @IBOutlet weak var AInput: UITextField!
    
    
    @IBOutlet weak var BInput: UITextField!
    
    
    @IBOutlet weak var errorMessageAndCvalue: UILabel!
    
      
    @IBOutlet weak var theFInalResult: UILabel!
    
    @IBAction func disapearKeyboard(_ sender: UITapGestureRecognizer) {
        AInput.resignFirstResponder();
        BInput.resignFirstResponder();
   
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func calculatePythagorean(_ sender: Any) {
        var intAInput:Double? = Double(AInput.text!)
        var intBInput:Double? = Double(BInput.text!)
        
        if AInput.text == "" || BInput.text == ""{
                errorMessageAndCvalue.text = "Enter a value for A and B to find C"
        }else if intAInput == nil {
            errorMessageAndCvalue.text = "The value you entered for A is invalid"
        }else if intBInput == nil{
            errorMessageAndCvalue.text = "The value you entered for B is invalid"
        }else if intAInput! >= 0 && intBInput! >= 0 {
            var FinalResultC = sqrt(pow(intAInput!, 2) + pow(intBInput!, 2))
          errorMessageAndCvalue.text = " The value of C according to Pythagorean is "
            theFInalResult.text = String(FinalResultC)
        }
//        }else{
//            errorMessageAndCvalue.text = "Enter a value for A and B to find C"
//        }
        }
    
    @IBAction func clearBtn(_ sender: UIButton) {
        AInput.text = ""
        BInput.text = ""
        errorMessageAndCvalue.text = ""
        theFInalResult.text = ""
    
        
    }
    
    }
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


