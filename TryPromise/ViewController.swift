//
//  ViewController.swift
//  TryPromise
//
//  Created by Olarn U. on 11/6/2559 BE.
//  Copyright © 2559 Olarn U. All rights reserved.
//

// References :-
//   pod PromiseKit       :- https://libraries.io/cocoapods/PromiseKit
//   PromiseKit/AlamiFire :- https://github.com/PromiseKit/Alamofire
//   Related Doc          :- http://promisekit.org/docs/making-promises/

import UIKit
import PromiseKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet var lblStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let url = "https://jsonplaceholder.typicode.com/posts/"

    @IBAction func touchInsideRefreshButton(_ sender: Any) {
        
        _ = firstly {
                self.getData(url: "\(self.url)1")
    
            }.then { dict -> Void in
                self.lblStatus.text = "Status: callback from 1"
                print(dict)
            
            }.then { dict -> Promise<NSDictionary> in
                self.getData(url: "\(self.url)2")
            
            }.then { dict -> Void in
                self.lblStatus.text = "\(self.lblStatus.text!), 2"
                print(dict)
            
            }.then { dict -> Promise<NSDictionary> in
                self.getData(url: "\(self.url)3")
            
            }.then { dict -> Void in
                self.lblStatus.text = "\(self.lblStatus.text!), 3"
                print(dict)
            
            }.always {
                print("done")
        }
    }
}

extension ViewController {
 
    func getData(url: String) -> Promise<NSDictionary> {
        return Promise { fulfill, reject in
            Alamofire
                .request(url)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let data):
                        fulfill(data as! NSDictionary)
                    case .failure(let error):
                        reject(error as NSError)
                    }
            }
        }
    }
    
}
