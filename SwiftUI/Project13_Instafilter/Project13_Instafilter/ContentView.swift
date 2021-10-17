//
//  ContentView.swift
//  Project13_Instafilter
//
//  Created by Tyler Edwards on 10/17/21.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var filterRadius = 100.0
    @State private var filterScale = 5.0
    
    @State private var showingFilterSheet = false
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    @State private var showingErrorAlert = false
    @State private var errorTitle = ""
    @State private var errorMsg = ""
    
    var body: some View {
        let intensity = Binding<Double>(
            get: { filterIntensity },
            set: {
                filterIntensity = $0
                applyProcessing()
            }
        )
        
        let radius = Binding<Double>(
            get: { filterRadius },
            set: {
                filterRadius = $0
                applyProcessing()
            }
        )
        
        let scale = Binding<Double>(
            get: { filterScale },
            set: {
                filterScale = $0
                applyProcessing()
            }
        )
        
        return NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.secondary)
                    
                    if image != nil {
                        image?
                            .resizable()
                            .scaledToFit()
                    } else {
                        Text("Tap to Select an Image")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
                .onTapGesture {
                    showingImagePicker = true
                }
                
                VStack {
                    let inputKeys = currentFilter.inputKeys
                    
                    if inputKeys.contains(kCIInputIntensityKey) {
                        HStack {
                            Text("Intensity")
                            Slider(value: intensity)
                        }
                    }
                    
                    if inputKeys.contains(kCIInputRadiusKey) {
                        HStack {
                            Text("Radius")
                            Slider(value: radius, in: 0...200)
                        }
                        .padding(.vertical)
                    }
                    
                    if inputKeys.contains(kCIInputScaleKey) {
                        HStack {
                            Text("Scale")
                            Slider(value: scale, in: 0...10)
                        }
                    }
                }
                .padding(.vertical)
                
                HStack {
                    Button(currentFilter.name) {
                        showingFilterSheet = true
                    }
                    
                    Spacer()
                    
                    Button("Save") {
                        if let processedImage = processedImage {
                            let imageSaver = ImageSaver()
                            imageSaver.successHandler = { print("Yay!") }
                            
                            imageSaver.errorHandler = {
                                errorTitle = "Oops. Something went wrong."
                                errorMsg = $0.localizedDescription
                                showingErrorAlert = true
                            }
                            
                            imageSaver.writeToPhotoAlbum(image: processedImage)
                        } else {
                            errorTitle = "No Image Selected"
                            errorMsg = ""
                            showingErrorAlert = true
                        }
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .navigationBarTitle("Instafilter")
            .alert(isPresented: $showingErrorAlert) {
                Alert(title: Text(errorTitle),
                      message: Text(errorMsg),
                      dismissButton: .default(Text("OK")))
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: $inputImage)
            }
            .actionSheet(isPresented: $showingFilterSheet) {
                ActionSheet(title: Text("Select a Filter"),
                            buttons: [
                                .default(Text("Crystallize")) { setFilter(CIFilter.crystallize()) },
                                .default(Text("Edges")) { setFilter(CIFilter.edges()) },
                                .default(Text("Gaussian Blur")) { setFilter(CIFilter.gaussianBlur()) },
                                .default(Text("Pixellate")) { setFilter(CIFilter.pixellate()) },
                                .default(Text("Sepia Tone")) { setFilter(CIFilter.sepiaTone()) },
                                .default(Text("Unsharp Mask")) { setFilter(CIFilter.unsharpMask()) },
                                .default(Text("Vignette")) { setFilter(CIFilter.vignette()) },
                                .cancel()
                            ])
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterRadius, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterScale, forKey: kCIInputScaleKey) }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgImage)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
