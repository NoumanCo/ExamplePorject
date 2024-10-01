//
//  DynamicBarViewController.swift
//  ExamplePorject
//
//  Created by MNouman on 01/10/2024.
//

import UIKit

class DynamicBarViewController: UIViewController {
    
    @IBOutlet weak var viewContainer : UIView!

    let dynamicBar = DynamicBarView()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pkBarViewSetup()
    }
    
    private func pkBarViewSetup(){
        // Set up the dynamic bar view
        dynamicBar.frame = viewContainer.bounds
        viewContainer.addSubview(dynamicBar)
        // Set initial values (for example, redValue = 20000, blueValue = 8000, totalValue = 28000)
        dynamicBar.updateBar(redValue: 20000, blueValue: 8000, totalValue: 28000)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.dynamicBar.updateBar(redValue: 24000, blueValue: 4000, totalValue: 28000)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                self.dynamicBar.updateBar(redValue: 8000, blueValue: 20000, totalValue: 28000)
            })
        })
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
