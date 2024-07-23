//
//  ImageResizeViewModelTests.swift
//
//
//  Created by Terry Kuo on 2024/7/23.
//

import XCTest
@testable import ImageResizeFeature
@testable import Models

class ImageResizeViewModelTests: XCTestCase {
    
    var viewModel: ImageResizeViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = ImageResizeViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testSwapWidthHeight() {
        // Given
        let initialWidth: CGFloat = 1290
        let initialHeight: CGFloat = 2796
        
        // When
        viewModel.swapWidthHeight()
        
        // Then
        XCTAssertEqual(viewModel.resizedWidth, initialHeight)
        XCTAssertEqual(viewModel.resizedHeight, initialWidth)
    }
    
    @MainActor func testResizeAndSaveImagesWithEmptyArray() {
            // Given
            let images: [ImageFile] = []
            
            // When
            viewModel.resizeAndSaveImages(images: images)
            
            // Then
            XCTAssertEqual(viewModel.outputState, .idle)
        }
        
    @MainActor func testResizeAndSaveImagesWithImages() {
            // Given
            let image = NSImage(size: NSSize(width: 100, height: 100))
            let images: [ImageFile] = [ImageFile(image: image, fileName: "Test", pixelWidth: 2049, pixelHeight: 2349)]
            viewModel.downloadsFolderUrl = FileManager.default.temporaryDirectory
            
            // When
            viewModel.resizeAndSaveImages(images: images)
            
            // Then
            XCTAssertEqual(viewModel.outputState, .loading)
            
            // Expect outputState to change after async operation
            let expectation = self.expectation(description: "Output state should change to success")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                XCTAssertEqual(self.viewModel.outputState, .success)
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 4, handler: nil)
        }
    
    func testSetDeviceSize() {
           // Given
        let device: DeviceTypes = .iphone6_5
           
           // When
           viewModel.setDeviceSize(device: device)
           
           // Then
           XCTAssertEqual(viewModel.resizedWidth, 1242)
           XCTAssertEqual(viewModel.resizedHeight, 2688)
       }
}
