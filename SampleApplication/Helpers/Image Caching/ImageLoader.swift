//
//  ImageLoader.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/15.
//

import UIKit
import Combine

final class ImageLoader {
    
    static let shared = ImageLoader()
    private init() {}

    private let cache: ImageCacheProtocol = ImageCache()
    
    func loadImage(from url: String) -> AnyPublisher<UIImage?, Never> {
        guard let _url = URL(string: url) else {
            return Just(nil).eraseToAnyPublisher()
        }
        
        return loadImage(from: _url)
    }

    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        if let image = cache[url] {
            return Just(image).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { data, response -> UIImage? in return UIImage(data: data) }
            .catch { error in return Just(nil) }
            .handleEvents(receiveOutput: {[unowned self] image in
                guard let image = image else { return }
                cache[url] = image
            })
            .subscribe(on: backgroundQueue)
            .receive(on: mainQueue)
            .eraseToAnyPublisher()
    }
}
