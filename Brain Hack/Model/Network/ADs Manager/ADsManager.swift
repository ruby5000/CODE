import Foundation
import UIKit
import GoogleMobileAds

class ADsManager: NSObject, GADFullScreenContentDelegate {
    
    public var interstitial: GADInterstitialAd?
    public var rewardedAd: GADRewardedAd?
    
    static let shared = ADsManager()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - InterstitialADs
    func InterstitialADs() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: CONSTANT.GoogleAD_Interstitial_ID,
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ad
        }
        )
    }
    
    // MARK: - Reward ASs
    func loadRewardedAd() {
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: CONSTANT.GoogleAD_Reward_ID,
                           request: request,
                           completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                return
            } else {
                
            }
            rewardedAd = ad
            let options = GADServerSideVerificationOptions()
            options.customRewardString = "SAMPLE_CUSTOM_DATA_STRING"
            rewardedAd!.serverSideVerificationOptions = options
        }
        )
    }
}


extension ADsManager {
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        
    }
    
    func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillPresentScreen(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillDismissScreen(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdDidDismissScreen(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillLeaveApplication(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
}
