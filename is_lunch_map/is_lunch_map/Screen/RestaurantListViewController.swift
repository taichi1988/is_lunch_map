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
    private var shops: [Shop] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLayout()
        fetchShopList()
    }
    
    private func initLayout() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.tableFooterView = UIView()
        tableView.register(ShopListCell.self)
        tableView.snp.makeConstraintsEqualToSuperview()
    }
    
    private func fetchShopList() {
        ApiClient.request(ShopListRequest())
            .subscribe(onSuccess: { [weak self] shopList in
                self?.shops = shopList.shops
                self?.tableView.reloadData()
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - DataSource
extension RestaurantListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, as: ShopListCell.self)
        cell.set(shop: shops[indexPath.row])
        return cell
    }
}

// MARK: - Delegate
extension RestaurantListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MapViewController()
        show(vc, sender: nil)
    }
}

// MARK: - Cell
private final class ShopListCell: UITableViewCell, CellReusable {
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
    
    func set(shop: Shop) {
        shopNameLabel.text = shop.shopName
    }
}
