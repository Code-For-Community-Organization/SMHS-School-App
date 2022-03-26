//
//  NetworkLoadViewModel.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 6/24/21.
//

import Foundation
import Network
import Combine

//Class that manages monitoring the network status with
//NWPathMonitor, and automatically refetches data whenever
//the user's device's connection changes from bad to good
final class NetworkLoadViewModel: ObservableObject {

    @Published var isLoading = false
    @Published var lastStatus: NWPath.Status = .satisfied
    
    var didReload = false
    var isNetworkAvailable: Bool {
        lastStatus == .satisfied
    }
    
    typealias Reloader = (Date, @escaping (Bool) -> Void) -> Void
    var dataReload: Reloader
    
    init(dataReload: @escaping Reloader) {
        self.dataReload = dataReload
        startNetworkMonitorer()
        
    }
    
    func reloadDataNow() {
        //Show indicator while loading
        isLoading = true
        dataReload(Date()) {success in
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                self.isLoading = false
            }
        }
    }
    
    func startNetworkMonitorer() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = {path in
            DispatchQueue.main.async {                
//                if self.lastStatus != .satisfied {
//                    self.isLoading = false
//                    //Condition where there was previously no connectivity,
//                    //but now just changed to connected, and did not already
//                    //refetch
//                    if path.status == .satisfied &&
//                        !self.didReload {
//                        print("Reload now from network load viewmodel")
//                        self.reloadDataNow()
//
//                        //Avoid duplicate refetches before
//                        //the network status changes
//                        self.didReload = true
//                    }
//
//                }
//                //Reset didReload if status becomes satisfied
//                //will reload next time connection drops
//                else if self.lastStatus == .satisfied &&
//                            path.status == .satisfied {
//                    self.didReload = false
//                }
                self.lastStatus = path.status
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
}
