//
//  NetworkLoadViewModel.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 6/24/21.
//

import Foundation
import Network
import Combine

final class NetworkLoadViewModel: ObservableObject {
    typealias Reloader = (@escaping (Bool) -> Void) -> Void

    @Published var isLoading = false
    @Published var isNetworkAvailable: Bool = true
    var anyCancellable: AnyCancellable?
    var dataReload: Reloader
    init(dataReload: @escaping Reloader) {
        self.dataReload = dataReload 
        anyCancellable = $isNetworkAvailable
            .removeDuplicates {prev, current in
                
                //Consider available
                prev == true || prev == current
            }
            .sink {[weak self] isAvailable in
                print("Network available: \(isAvailable)")
                if isAvailable {
                    print("Reload now from network load viewmodel")
                    #warning("Fix me major bug!")
                    //FIXME: Reloading crazy, removeDuplicates not working
                    //self?.reloadDataNow()
                }
        }
        startNetworkMonitorer()
        
    }
    
    func reloadDataNow() {
        //Show indicator while loading
        isLoading = true
        dataReload {success in
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                self.isLoading = false
            }
        }
    }
    
    func startNetworkMonitorer() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = {path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    self.isNetworkAvailable = true
                }
                else {
                    self.isNetworkAvailable = false
                }
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
}
