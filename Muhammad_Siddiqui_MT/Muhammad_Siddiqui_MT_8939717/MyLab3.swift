//
//  MyLab3.swift
//  Muhammad_Siddiqui_MT_8939717
//
//  Created by user229166 on 7/6/23.
//

import UIKit

class MyLab3: UIViewController {

    
    
    @IBOutlet weak var firstName: UITextField!
    
    
    @IBOutlet weak var lastName: UITextField!
    
    
    
    
    @IBOutlet weak var country: UITextField!
    
    
    
    
    @IBOutlet weak var age: UITextField!
    
    
    @IBOutlet weak var userMessage: UILabel!
    
    
    
    @IBOutlet weak var detailText: UITextView!
       

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func validate() -> Bool{
        if(firstName.text == "" || lastName.text == "" || country.text == "" || age.text == ""){
            return false
        
        }
        else{
            return true
        }
    }
    
    @IBAction func setAddbutton(_ sender: UIButton) {
        //firstName.text = "test"
        var userInfo = firstName.text! + "" + lastName.text! + "\n"/*forlinebreak*/ + country.text! + "\n"
        userInfo += age.text!
        // update text from textView
        detailText.text =  userInfo
    }
    
    
    @IBAction func submitValid(_ sender: UIButton) {
        if validate(){
            userMessage.text =  "Successfully submitted"
        }
        else {
            userMessage.text = "complete the missing info"
        }
    }
    
    
    
    @IBAction func clear(_ sender: UIButton) {
        firstName.text = ""
        lastName.text = ""
        country.text = ""
        age.text = ""
        userMessage.text = ""
        detailText.text = ""
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
