//
//  SettingsViewController.swift
//  Demo_Code
//
//  Created by Diken Shah on 03/12/20.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onClickHelpButton(sender : UIButton){
        guard let helpVC = self.storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifier.HelpViewController) as? HelpViewController else {
            return
        }
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(helpVC, animated: true)
        self.hidesBottomBarWhenPushed = false
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
