//
//  RestaurantListViewController.swift
//  is_lunch_map
//
//  Created by 行木太一 on 2018/08/05.
//  Copyright © 2018年 yukit.Inc. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire

// MARK: - ViewController
final class RestaurantListViewController: UIViewController {
    private lazy var tableView = UITableView()
    private let disposeBag = DisposeBag()
    private var restaurants: [Restaurant] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLayout()
        fetchRestaurantList()
    }
    
    private func initLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraintsEqualToSuperview()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.tableFooterView = UIView()
        tableView.register(Cell.self)
    }
    
    private func fetchRestaurantList() {
        ApiClient.request(RestaurantListRequest())
            .subscribe(onSuccess: { [weak self] in
                self?.restaurants = $0.restaurants
                self?.tableView.reloadData()
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UITableView DataSource methods
extension RestaurantListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, as: Cell.self)
        cell.set(shop: restaurants[indexPath.row])
        return cell
    }
}

// MARK: - UITableView Delegate methods
extension RestaurantListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MapViewController()
        show(vc, sender: nil)
    }
}

// MARK: - Cell
extension RestaurantListViewController {
    private final class Cell: UITableViewCell, CellReusable {
        private lazy var shopNameLabel = UILabel()
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            initLayout()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func initLayout() {
            contentView.addSubview(shopNameLabel)
            shopNameLabel.font = .boldSystemFont(ofSize: 14)
            shopNameLabel.textColor = .darkText
            shopNameLabel.snp.makeConstraints { make in
                make.top.left.bottom.equalToSuperview().inset(12)
            }
        }
        
        func set(shop: Restaurant) {
            shopNameLabel.text = shop.shopName
        }
    }
}
