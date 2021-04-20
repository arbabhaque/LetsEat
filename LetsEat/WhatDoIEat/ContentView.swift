//
//  ContentView.swift
//  WhatDoIEat
//
//  Created by Arbab Haque on 2020-06-10.
//  Copyright © 2020 A. All rights reserved.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @ObservedObject var obs = obserever()
    @ObservedObject var locationManager = LocationManager()
    @State private var restaraunt = " "
    @State var rest =  r(id: " ", name: " ", image: "", rating: "", webUrl: "")
    @State private var showRestaraunt = false
    @State private var showPickARestarauntButton = false
    @State private var buttonAnimationAmmount: CGFloat = 1

    var body: some View {
        
        let coordinate = self.locationManager.location != nil ?
        self.locationManager.location!.coordinate :CLLocationCoordinate2D()
        
        return ZStack{            
            VStack{
                Spacer()
        
                Text("Feeling Hungry?")
                    .foregroundColor(.black)
                    .bold()
                    .onAppear{}
                    
                Spacer()
                    
                Button("Generate list") {
                    self.obs.Rests.removeAll()
                    self.obs.loadwithcoordinates(coordinate: coordinate)
                    self.showPickARestarauntButton = true
                    }.background(Color.blue)
                        .cornerRadius(20)                   
                    
                Spacer()
                if showPickARestarauntButton{
                    Button("What do i eat?") {                       
                        self.restaraunt = self.obs.Rests[Int.random(in: 0...self.obs.Rests.count - 1)].name
                        self.rest = self.obs.Rests[Int.random(in: 0...self.obs.Rests.count - 1)]
                        self.showRestaraunt.toggle()
                    }.background(Color.blue)
                    .cornerRadius(20)
                }
                Spacer()
                                        
                if showRestaraunt {
                    CardView(rName: $rest.name, rRating: $rest.rating, rWeb: $rest.webUrl, rImage: $rest.image)            
                }
                    
                if !showRestaraunt{
                    Spacer()                       
                }                      
                Spacer()                  
            }               
        }       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class obserever : ObservableObject{    
    @Published var Rests = [r]()
    
    init() {}
    
    func load(){
        let url1 = "https://developers.zomato.com/api/v2.1/geocode?lat=0.00&lon=0.00"
        let api = "7f99f4022b4612cf1711ebfd5198d544"
        
        let url = URL(string: url1)
        var request = URLRequest(url: url!)    
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue( api , forHTTPHeaderField: "user-key")
        request.httpMethod = "GET"
        
        let sess = URLSession(configuration: .default)
        sess.dataTask(with: request){ (data, _, _) in
            
            do{
                let fetch = try JSONDecoder().decode(Type.self, from: data!)                
                for i in fetch.nearby_restaurants{                    
                    DispatchQueue.main.async {
                        self.Rests.append(r(id: i.restaurant.id, name: i.restaurant.name, image: i.restaurant.thumb, rating: i.restaurant.user_rating.aggregate_rating, webUrl: i.restaurant.url))
                    }   
                }   
            }
            catch{
                print(error.localizedDescription)
            }
        }.resume()   
    }
    
    func loadwithcoordinates(coordinate: CLLocationCoordinate2D){
        let url1 = "https://developers.zomato.com/api/v2.1/geocode?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)"
        let api = "7f99f4022b4612cf1711ebfd5198d544"
        
        let url = URL(string: url1)
        var request = URLRequest(url: url!)
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue( api , forHTTPHeaderField: "user-key")
        request.httpMethod = "GET"
        
        let sess = URLSession(configuration: .default)
        sess.dataTask(with: request){ (data, _, _) in
            do{
                let fetch = try JSONDecoder().decode(Type.self, from: data!)
                print(coordinate.latitude)
                
                for i in fetch.nearby_restaurants{           
                    DispatchQueue.main.async {
                        self.Rests.append(r(id: i.restaurant.id, name: i.restaurant.name, image: i.restaurant.thumb, rating: i.restaurant.user_rating.aggregate_rating, webUrl: i.restaurant.url))
                    }                 
                }                
            }
            catch{
                print(error.localizedDescription)
            } 
        }.resume()      
    }   
}

struct r : Identifiable{
    var id:String
    var name : String
    var image : String
    var rating : String
    var webUrl : String
}

struct Type : Decodable { 
    var nearby_restaurants : [Type1]
}

struct Type1 : Decodable {
    var restaurant : Type2
}

struct Type2 : Decodable {
    var id : String
    var name : String
    var url : String
    var thumb : String
    var user_rating : Type3
}

struct Type3 : Decodable {
    var aggregate_rating : String
}
