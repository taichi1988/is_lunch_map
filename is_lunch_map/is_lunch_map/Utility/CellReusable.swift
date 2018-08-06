//
//  CellReusable.swift
//  is_lunch_map
//
//  Created by 行木太一 on 2018/08/07.
//  Copyright © 2018年 yukit.Inc. All rights reserved.
//

import UIKit

private func cast<T, U>(_ object: T) -> U {
    guard let out = object as? U else {
        fatalError("\(object) cannot cast to \(U.self)")
    }
    return out
}

private func defaultCellIdentifier<T: NSObject>(_ clazz: T.Type) -> String {
    return String(describing: clazz)
}

// MARK: - CellReusable
protocol CellReusable {
    static var cellIdentifier: String { get }
}

extension CellReusable where Self: UITableViewCell {
    static var cellIdentifier: String { return defaultCellIdentifier(self) }
}

extension CellReusable where Self: UITableViewHeaderFooterView {
    static var cellIdentifier: String { return defaultCellIdentifier(self) }
}

extension CellReusable where Self: UICollectionReusableView {
    static var cellIdentifier: String { return defaultCellIdentifier(self) }
}

// MARK: - CellReusableXib
protocol CellReusableXib: CellReusable {
    static var nibName: String { get }
    static var nibBundle: Bundle? { get }
}

extension CellReusableXib where Self: UITableViewCell {
    static var nibName: String { return cellIdentifier }
    static var nibBundle: Bundle? { return nil }
}

extension CellReusableXib where Self: UITableViewHeaderFooterView {
    static var nibName: String { return cellIdentifier }
    static var nibBundle: Bundle? { return nil }
}

extension CellReusableXib where Self: UICollectionReusableView {
    static var nibName: String { return cellIdentifier }
    static var nibBundle: Bundle? { return nil }
}

// MARK: - UITableView
extension UITableView {
    func register(_ cellClasses: (UITableViewCell & CellReusable).Type...) {
        for clazz in cellClasses {
            register(clazz, forCellReuseIdentifier: clazz.cellIdentifier)
        }
    }
    
    func register(_ cellClasses: (UITableViewCell & CellReusableXib).Type...) {
        for clazz in cellClasses {
            register(UINib(nibName: clazz.nibName, bundle: clazz.nibBundle),
                     forCellReuseIdentifier: clazz.cellIdentifier)
        }
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: CellReusable {
        return dequeueReusableCell(for: indexPath, as: T.self)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, as cellClass: T.Type) -> T where T: CellReusable {
        return cast(dequeueReusableCell(withIdentifier: cellClass.cellIdentifier, for: indexPath))
    }
}

// MARK: UITableViewHeaderFooterView
extension UITableView {
    func register<T: UITableViewHeaderFooterView>(_ viewClass: T.Type) where T: CellReusable {
        register(viewClass, forHeaderFooterViewReuseIdentifier: viewClass.cellIdentifier)
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T where T: CellReusable {
        return dequeueReusableHeaderFooterView(as: T.self)
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(as viewClass: T.Type) -> T where T: CellReusable {
        return cast(dequeueReusableHeaderFooterView(withIdentifier: viewClass.cellIdentifier))
    }
}

// MARK: - UICollectionView
extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: CellReusable {
        return dequeueReusableCell(for: indexPath, as: T.self)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath, as cellClass: T.Type) -> T where T: CellReusable {
        return cast(dequeueReusableCell(withReuseIdentifier: cellClass.cellIdentifier, for: indexPath))
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind kind: String,
                                                                       for indexPath: IndexPath) -> T where T: CellReusable {
        return dequeueReusableSupplementaryView(ofKind: kind, for: indexPath, as: T.self)
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind kind: String,
                                                                       for indexPath: IndexPath,
                                                                       as viewClass: T.Type) -> T where T: CellReusable {
        return cast(dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: viewClass.cellIdentifier, for: indexPath))
    }
    
    func register<T: UICollectionViewCell>(_ cellClass: T.Type) where T: CellReusable {
        register(cellClass, forCellWithReuseIdentifier: cellClass.cellIdentifier)
    }
    
    func register<T: UICollectionViewCell>(_ cellClass: T.Type) where T: CellReusableXib {
        register(UINib(nibName: cellClass.nibName, bundle: cellClass.nibBundle),
                 forCellWithReuseIdentifier: cellClass.cellIdentifier)
    }
}

