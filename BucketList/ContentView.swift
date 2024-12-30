//
//  ContentView.swift
//  BucketList
//
//  Created by Satinder Singh on 28/12/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var viewModel = ViewModel()

    var body: some View {
        if viewModel.isUnlocked {
            ZStack(alignment: .topLeading) {
                MapReader { proxy in
                    Map() {
                        ForEach(viewModel.locations) { location in
                            Annotation(location.name, coordinate: location.coordinate) {
                                Image(systemName: "star.circle")
                                    .resizable()
                                    .foregroundStyle(.red)
                                    .frame(width: 44, height: 44)
                                    .background(.white)
                                    .clipShape(.circle)
                                    .simultaneousGesture(LongPressGesture(minimumDuration: 1).onEnded { _ in viewModel.selectedPlace = location
                                    })
                            }
                        }
                    }
                    .mapStyle(viewModel.isHybridStyle ? .hybrid : .standard)
                    .onTapGesture { position in
                        if let coordinate = proxy.convert(position, from: .local) {
                            viewModel.addLocation(at: coordinate)
                        }
                    }
                }
                VStack {
                    Picker("Map Style", selection: $viewModel.isHybridStyle) {
                            Text("Standard").tag(false)
                            Text("hybrid").tag(true)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 200)
                        .padding(2)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(8)
                    }
                .padding()
            }
            .sheet(item: $viewModel.selectedPlace) { place in
                EditView(location: place, onSave: viewModel.updateLocation, onDelete: viewModel.deleteLocation)
            }
        } else {
            Button("Unlock places", action: viewModel.authenticate)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
        }
    }
}

#Preview {
    ContentView()
}
