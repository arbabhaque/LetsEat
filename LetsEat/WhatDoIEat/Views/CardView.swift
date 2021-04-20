//
//  CardView.swift
//  WhatDoIEat
//
//  Created by Arbab Haque on 2020-06-10.
//  Copyright © 2020 A. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct CardView: View {
    
    @Binding var rName:String
    @Binding var rRating:String
    @Binding var rWeb:String
    @Binding var rImage:String
    
    var body: some View {
        ZStack{       
            HStack{
           
                AnimatedImage(url: URL(string: rImage))
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
                    .scaledToFit()
                VStack{
                    Text(rName)
                        .bold()
                        .foregroundColor(.white)
                    Text("Rating:\(rRating)")
                        .foregroundColor(.white)
                }
            }
        }
        .padding(10)
        .background(Color.blue)
        .cornerRadius(20)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(rName: Binding.constant("Name"), rRating: Binding.constant("Rating"), rWeb: Binding.constant("Web"), rImage: Binding.constant("Image"))
    }
}
