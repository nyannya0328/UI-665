//
//  Home.swift
//  UI-665
//
//  Created by nyannyan0328 on 2022/09/10.
//

import SwiftUI

struct Home: View {
    @State var showDetail : Bool = false
    @State var currentIndex : Int = 0
    
    @State var selectedImage : MilkShake?
    @Namespace var animation
    
    
    @State var currentTabs : Tab = tabs[1]
    var body: some View {
        VStack{
            
            HeaderView()
            
            VStack(spacing: 13) {
                
                Text(TopAttString)
                    .font(.largeTitle.weight(.light))
                
                Text(BottmAttString)
                    .font(.largeTitle.weight(.light))
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .opacity(showDetail ? 0 : 1)
            .padding(.horizontal)
            
            GeometryReader{proxy in
                
                let size = proxy.size
                
                CrouselView(size: size)
                
            }
            .zIndex(-10)
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .top)
        .background{
            
            Color("LightGreen")
                .ignoresSafeArea()
        }
        .overlay {
            
            if let selectedImage,showDetail{
                
                DetailView(animation: animation, milkShake: selectedImage, showDetail: $showDetail)
            }
        }
    }
    @ViewBuilder
    func CrouselView (size : CGSize)->some View{
        
        
        VStack(spacing:-50){
            
            CustomCrousel(index: $currentIndex, items: milkShakes, id: \.id) { miikShake, _ in
                
                VStack(spacing:16) {
                    ZStack{
                        if showDetail, selectedImage?.id == miikShake.id{
                            
                            Image(miikShake.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                               .opacity(0)
                            
                        }
                        else{
                            
                            Image(miikShake.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .matchedGeometryEffect(id: miikShake.id, in: animation)
                        }
                        
                    }
                    .rotationEffect(.init(degrees: -2))
                    .background{
                        
                        RoundedRectangle(cornerRadius: size.height / 10, style: .continuous)
                            .fill(Color("LightGreen-1"))
                            .padding(.top,50)
                            .padding(.horizontal,-40)
                            .offset(y:-10)
                    }
                    
                    Text(miikShake.title)
                        .font(.title.weight(.semibold))
                    
                    Text(miikShake.price)
                        .font(.title3.weight(.semibold))
                        .foregroundColor(Color("LightGreen"))
                    
                    
                }
                .onTapGesture {
                    
                    withAnimation(.easeIn(duration: 0.3)){
                        selectedImage = miikShake
                        showDetail = true
                    }
                }
                
                
                
                
                
            }
            .frame(height:size.height * 0.8)
            
            Indicator()
            
            
            
            
        }
        .opacity(showDetail ? 0 : 1)
        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .bottom)
        .background{
            
            CustomShape()
                .fill(.white)
                .scaleEffect(showDetail ? 2 : 1,anchor: .bottomLeading)
                .overlay(alignment: .topLeading) {
                    
                    TabMenu()
                        .opacity(showDetail ? 0 : 1)
                }
                .padding(.top,40)
                .ignoresSafeArea()
            
        }
        
        
    }
    @ViewBuilder
    func TabMenu ()->some View{
        
        HStack(spacing:15){
            
            ForEach(tabs){tab in
                
                Image(tab.tabImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 45,height: 45)
                    .padding(10)
                    .background{
                        
                        Circle()
                            .fill(Color("LightGreen-1"))
                        
                    }
                    .background{
                        
                        Circle()
                            .fill(.white)
                    }
                    .shadow(color: .black.opacity(0.07), radius: 5,x:5,y:5)
                    .scaleEffect(currentTabs.id == tab.id ? 1.2 : 1)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        
                        withAnimation(.spring()){
                            
                            currentTabs = tab
                        }
                    }
                    .offset(tab.tabOffset)
                
            }
            
            
        }
        .padding(.leading,10)
        
        
    }
    @ViewBuilder
    func Indicator ()->some View{
        
        HStack(spacing:12){
            
            ForEach(milkShakes.indices,id:\.self){index in
                
                Circle()
                    .fill(Color("LightGreen"))
                    .frame(width: currentIndex == index ? 10 : 5,height: currentIndex == index ? 10 : 5)
                    .overlay {
                        
                        if currentIndex == index{
                            
                            Circle()
                                .stroke(Color("LightGreen"))
                                .padding(-5)
                        }
                    }
                
                
                
            }
            
            
        }
        .animation(.linear(duration: 0.5), value: currentIndex)
        
    }
    var TopAttString : AttributedString{
        
        var atr = AttributedString("Good Food,")
        if let range = atr.range(of: "Food"){
            
            atr[range].foregroundColor = .white
        }
        return atr
        
    }
    
    var BottmAttString : AttributedString{
        
        var atr = AttributedString("Good Mood.")
        if let range = atr.range(of: "Good"){
            
            atr[range].foregroundColor = .white
        }
        return atr
        
    }
    @ViewBuilder
    func HeaderView ()->some View{
        
        HStack{
            
            
            Button {
                
            } label: {
                
                HStack(spacing: 10) {
                    
                    
                    Image("Pic")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40,height: 40)
                        .clipShape(Circle())
                        .opacity(showDetail ? 0 : 1)
                    
                    Text("Jenny Doe")
                        .font(.callout.weight(.semibold))
                        .foregroundColor(.primary)
                }
                .padding(.horizontal,5)
                .padding(.vertical,5)
                .padding([.leading,.trailing],5)
                .background{
                    
                    Capsule()
                        .fill(Color("LightGreen-1"))
                }
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .opacity(showDetail ? 0 : 1)
            
            
            
            Button {
                
            } label: {
                
                Image(systemName: "cart.fill")
                    .font(.title)
                    .foregroundColor(.black)
                    .overlay(alignment: .topTrailing) {
                        
                        Circle()
                            .fill(.red)
                            .frame(width: 16,height: 16)
                            .offset(x:5,y:-10)
                        
                    }
                
            }
            
            
            
            
            
            
        }
        .padding(15)
        
        
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct DetailView : View{
    var animation : Namespace.ID
    var milkShake : MilkShake
    @Binding var showDetail : Bool
    
    @State var activeOrer : String = "Active Order"
    
    @State var animatedImage : Bool = false
    
    var body: some View{
        
        VStack{
            
            HStack{
                
                Button {
                    
                    withAnimation(.easeOut.delay(0.3).delay(0.2)){
                        
                        animatedImage = false
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        
                        withAnimation(.easeOut.delay(0.3)){
                            
                            showDetail = false
                        }
                    }
                    
                } label: {
                    
                    
                    Image(systemName: "arrow.left")
                        .font(.title3)
                        .foregroundColor(.black)
                        .padding(15)
                    
                }
                .frame(maxWidth: .infinity,alignment: .leading)
            }
            .overlay {
                Text("Details")
                    .font(.title3.bold())
            }
            .padding(.top,7)
            .opacity(animatedImage ? 1 : 0)
            
            HStack(spacing:15){
                ForEach(["Active Order","Past Order"],id:\.self){order in
                    
                    
                    Text(order)
                        .font(.callout.weight(.ultraLight))
                        .foregroundColor(.black)
                        .padding(.vertical,10)
                        .padding(.horizontal,15)
                        .background{
                            
                            
                            if activeOrer == order{
                                Capsule()
                                    .fill(Color("LightGreen-1"))
                                    .matchedGeometryEffect(id: "ORDER", in: animation)
                            }
                            
                        }
                        .onTapGesture {
                            
                            withAnimation {
                                activeOrer = order
                            }
                            
                            
                            
                        }
                    
                    
                }
            }
            .padding(.leading,15)
            .frame(maxWidth: .infinity,alignment: .leading)
            
            
            Image(milkShake.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .matchedGeometryEffect(id: milkShake.id, in: animation)
                .opacity(animatedImage ? 1 : 0)
            
            GeometryReader{proxy in
                
                let size = proxy.size
             
                MilkShakeDetailsView()
                    .offset(y:animatedImage ? 0 : size.height + 50)
                
            
            }
            
            
            
            
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .top)
        .transition(.asymmetric(insertion: .identity, removal: .offset(y:0.5)))
        .onAppear{
            
            
            withAnimation(.easeOut.delay(0.3)){
                
                animatedImage = true
            }
            
        }
    }
    @ViewBuilder
    func MilkShakeDetailsView ()->some View{
        
        VStack{
            
            VStack{
                
                Text("#512D Code")
                    .font(.title3.bold())
                
                Text(milkShake.title)
                    .font(.largeTitle.weight(.black))
                
                Text(milkShake.price)
                    .font(.caption)
                    .foregroundColor(Color("LightGreen-1"))
                
                Text("20 min Deleivery")
                    .font(.caption.weight(.ultraLight))
                
                
                HStack(spacing:20){
                    
                    Text("Quantity:")
                        .font(.caption.weight(.semibold))
                    
                    Button {
                        
                    } label: {
                     
                         Image(systemName: "minus")
                        
                        
                    }
                    
                    Text("0")
                        .font(.system(size: 90))
                    
                    Button {
                        
                    } label: {
                     
                         Image(systemName: "plus")
                        
                    }
                }
                
                
                Button {
                    
                } label: {
                 
                    Text("Add to Cart")
                        .font(.title2.bold())
                        .foregroundColor(.black)
                       
                       
                    
                }
               
                .padding(.vertical,10)
                .padding(.horizontal,25)
                .background{
                 Capsule()
                        .fill(Color("LightGreen"))
                }
                
                
            }
            .padding(.vertical,20)
            .frame(maxWidth: .infinity)
            .background{
             
                  RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color("LightGreen-1"))
                    .ignoresSafeArea()
                 
            }
            .padding(.horizontal,60)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      
        
        
    }
}
