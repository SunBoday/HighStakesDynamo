//
//  ViewController.swift
//  HighStakesDynamo
//
//  Created by SunTory on 2024/9/25.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var stakes_activityView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.stakes_activityView.hidesWhenStopped = true
        self.stakesStartLoad()
        stakesLoadAf()
        // Do any additional setup after loading the view.
    }
    private func stakesStartLoad() {
        self.stakes_activityView.startAnimating()
    }
    
    private func stakesPendLoad() {
        self.stakes_activityView.stopAnimating()
    }
    private func stakesLoadAf() {
        if let adUrl = UserDefaults.standard.string(forKey: "app_afString"), !adUrl.isEmpty{
            showStakesView()
            return
        }
        
        if StakesNetManager.shared().isReachable {
            self.stakesReqAF()
        } else {
            StakesNetManager.shared().setReachabilityStatusChange { status in
                if StakesNetManager.shared().isReachable {
                    self.stakesReqAF()
                    StakesNetManager.shared().stopMonitoring()
                }
            }
            StakesNetManager.shared().startMonitoring()
        }
    }
    
    private func stakesReqAF() {
        guard let bundleId = Bundle.main.bundleIdentifier else {
            return
        }
        guard let url = URL(string:"https://open.silentpath.top" + "/open/getStakesAfString") else {
            fatalError("Invalid URL")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // 请求体数据
        let requestBody: [String: Any] = [
            "appKey": "f14a957e814941729b738a364d980a40",
            "appPackageId": bundleId,
            "appVersion": "1.0"
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            fatalError("Error creating request body: \(error)")
        }

        // 执行请求
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                DispatchQueue.main.async {
                     // 回到主线程更新 UI
                    self.stakesPendLoad()
                 }

                return
            }
            
            guard let data = data else {
                print("No data received")
                DispatchQueue.main.async {
                     // 回到主线程更新 UI
                    self.stakesPendLoad()
                 }
                return
            }
            
            do {
                let responseObject = try JSONSerialization.jsonObject(with: data, options: [])
                print("Response: \(responseObject)")
                DispatchQueue.main.async {
                     // 回到主线程更新 UI
                    self.stakesPendLoad()
                 }
                if let dictionary = responseObject as? [String: Any] {
                    let dataDic = dictionary["data"] as? [String: Any]
                    if let dataDicQ = dataDic as? [String: Any] {
                        let app_afString = dataDicQ["jsonObject"] as? [String: Any]
                        if let jsonData = try? JSONSerialization.data(withJSONObject: app_afString, options: []),
                           let jsonString = String(data: jsonData, encoding: .utf8) {
                            UserDefaults.standard.set(jsonString, forKey: "app_afString")
                            if !jsonString.isEmpty {
                                self.showStakesView()
                            } else {
                                DispatchQueue.main.async {
                                     // 回到主线程更新 UI
                                    self.stakesPendLoad()
                                 }                            }

                        } else {
                            print("Failed to convert dictionary to JSON string.")
                        }


                    }
                  
                }
            } catch {
                DispatchQueue.main.async {
                     // 回到主线程更新 UI
                    self.stakesPendLoad()
                 }
                print("Error parsing response data: \(error)")
            }
        }

        task.resume()
    }

}

