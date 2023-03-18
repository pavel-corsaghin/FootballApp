//
//  UICollectionView+Extensions.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/14.
//

import UIKit

extension UICollectionView {
    /// SwifterSwift: Register UICollectionReusableView using class name.
    ///
    /// - Parameters:
    ///   - kind: the kind of supplementary view to retrieve. This value is defined by the layout object.
    ///   - name: UICollectionReusableView type.
    func register<T: UICollectionReusableView>(supplementaryViewOfKind kind: String, withClass name: T.Type) {
        register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: name))
    }

    /// SwifterSwift: Register UICollectionViewCell using class name.
    ///
    /// - Parameter name: UICollectionViewCell type.
    func register<T: UICollectionViewCell>(cellWithClass name: T.Type) {
        register(T.self, forCellWithReuseIdentifier: String(describing: name))
    }

    /// SwifterSwift: Dequeue reusable UICollectionViewCell using class name.
    ///
    /// - Parameters:
    ///   - name: UICollectionViewCell type.
    ///   - indexPath: location of cell in collectionView.
    /// - Returns: UICollectionViewCell object with associated class name.
    func dequeueReusableCell<T: UICollectionViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError("Couldn't find UICollectionViewCell for \(String(describing: name)), make sure the cell is registered with collection view")
        }

        return cell
    }

    /// SwifterSwift: Dequeue reusable UICollectionReusableView using class name.
    ///
    /// - Parameters:
    ///   - kind: the kind of supplementary view to retrieve. This value is defined by the layout object.
    ///   - name: UICollectionReusableView type.
    ///   - indexPath: location of cell in collectionView.
    /// - Returns: UICollectionReusableView object with associated class name.
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind kind: String, withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError("Couldn't find UICollectionReusableView for \(String(describing: name)), make sure the view is registered with collection view")
        }

        return cell
    }
}
