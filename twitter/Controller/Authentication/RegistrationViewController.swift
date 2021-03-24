//
//  RegistrationViewController.swift
//  twitter
//
//  Created by Rodrigo Santos on 23/03/21.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureUI()
    }
    
    // MARK: - Selectores
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .twitterBlue
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
