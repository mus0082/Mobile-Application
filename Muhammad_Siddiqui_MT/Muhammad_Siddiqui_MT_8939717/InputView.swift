//
//  InputView.swift
//  Muhammad_Siddiqui_MT_8939717
//
//  Created by user229166 on 7/5/23.
//

import UIKit

class InputView: UIViewController {

  
    @IBOutlet weak var userInput: UITextField!
    
    @IBOutlet weak var changeImage: UIImageView!
    
   
    @IBOutlet weak var errorMessages: UILabel!
    
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMessages.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
 
    
  
    @IBAction func disapearKeyboard(_ sender: UITapGestureRecognizer) {
        userInput.resignFirstResponder();
    }
    
    
    @IBAction func disappearKeyboardOnReturn(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    
    
    
    
    @IBAction func finalResult(_ sender: UIButton) {
        if let input = userInput.text {
                    if input == "Toronto" {
                        changeImage.image = UIImage(named: "Toronto")
                        errorMessages.isHidden = true
                    
                    } else if input == "Halifax" {
                        changeImage.image = UIImage(named: "Halifax")
                        errorMessages.isHidden = true
                        
                    } else if input == "Montreal" {
                        changeImage.image = UIImage(named: "Montreal")
                        errorMessages.isHidden = true
                        
                    }else if input == "Calgary" {
                        changeImage.image = UIImage(named: "Calgary")
                        errorMessages.isHidden = true
                        
                    }else if input == "Winnipeg" {
                        changeImage.image = UIImage(named: "Winnipeg")
                        errorMessages.isHidden = true
                        
                    }else if input == "Vancouver" {
                        changeImage.image = UIImage(named: "Vancouver")
                        errorMessages.isHidden = true
                    } else {
                        errorMessages.isHidden = false;
                        errorMessages.text = "Invalid Input"
                        changeImage.image = UIImage(named: "Canada")
                        
                    }
                }
        userInput.text = ""
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
