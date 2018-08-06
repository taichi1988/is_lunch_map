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

final class RestaurantListViewController: UIViewController {
    private lazy var tableView = UITableView()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLayout()
        fetchShopList()
    }
    
    private func initLayout() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.snp.makeConstraintsEqualToSuperview()
    }
    
    private func fetchShopList() {
        ApiClient.request(ShopListRequest())
            .subscribe(onSuccess: { [weak self] shops in
                print(shops)
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
}

extension RestaurantListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension RestaurantListViewController: UITableViewDelegate {
}
