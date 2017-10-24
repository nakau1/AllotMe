// *****************************************************************************
// AllotMe
// (c) NAKAYASU Yuichi all rights reserves.
// *****************************************************************************
import Foundation
import CoreLocation

/*
 TD:  Tokyo Datum
 WGS: World Geodetic System
 */

extension CLLocationCoordinate2D {
    
    init(latitudeOnTD latitude: CLLocationDegrees, longitudeOnTD longitude: CLLocationDegrees) {
        self.latitude  = latitude.latitudeTDtoWGS(longitude: longitude)
        self.longitude = longitude.longitudeTDtoWGS(latitude: latitude)
    }
    
    var tokyoDatum: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude:  self.latitude.latitudeWGStoTD(longitude: self.longitude),
            longitude: self.longitude.longitudeWGStoTD(latitude: self.latitude)
        )
    }
}

// http://co-co-wa.com/lat-lng-change-program/
extension Double {

    /*
     日本測地系→世界測地系への変換
     
     $jy = ミリ秒単位の日本測地系の緯度 / 3600000;
     $jx = ミリ秒単位の日本測地系の経度 / 3600000;
     $lat = $jy - $jy * 0.00010695 + $jx * 0.000017464 + 0.0046017;
     $lng = $jx - $jy * 0.000046038 - $jx * 0.000083043 + 0.010040;
     ミリ秒単位の日本測地系緯度経度から世界測地系に変換する時の計算式がこちら。数値がミリ秒単位でなければ、上の2行は不要です。
     */
    
    /// 日本測地系緯度 => 世界測地系緯度
    func latitudeTDtoWGS(longitude: Double) -> Double {
        let lat = self / 3600
        let lng = longitude / 3600
        return lat - lat * 0.00010695 + lng * 0.000017464 + 0.0046017
    }
    
    /// 日本測地系経度 => 世界測地系経度
    func longitudeTDtoWGS(latitude: Double) -> Double {
        let lat = latitude / 3600
        let lng = self / 3600
        return lng - lat * 0.000046038 - lng * 0.000083043 + 0.010040
    }
    
    /*
     世界測地系→日本測地系への変換
     
     $jy = ceil(($lat * 1.000106961 - $lng * 0.000017467 - 0.004602017) * 3600000);
     $jx = ceil(($lng * 1.000083049 + $lat * 0.000046047 - 0.010041046) * 3600000);
     変数の意味は以下の通りです。
     
     $lat：世界測地系の緯度
     $lng：世界測地系の経度
     $jy：日本測地系の緯度
     $jx：日本測地系の経度
     複雑な計算を行っていますが、こうらしいです。全体の式をさらに3,600,000で掛け算しているのはミリ秒単位に変換している式です。ミリ秒単位の計算が不要の場合は3,600,000での掛け算は不要です。ceilは小数点以下を切り上げしています。
     */
    
    /// 世界測地系緯度 => 日本測地系緯度
    func latitudeWGStoTD(longitude: Double) -> Double {
        print(ceil((self * 1.000106961 - longitude * 0.000017467 - 0.004602017) * 360000) / 100)
        return ceil((self * 1.000106961 - longitude * 0.000017467 - 0.004602017) * 360000) / 100
    }
    
    /// 世界測地系経度 => 日本測地系経度
    func longitudeWGStoTD(latitude: Double) -> Double {
        print(ceil((self * 1.000083049 + latitude * 0.000046047 - 0.010041046) * 360000) / 100)
        return ceil((self * 1.000083049 + latitude * 0.000046047 - 0.010041046) * 360000) / 100
    }
}
