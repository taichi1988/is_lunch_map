//
//  RestaurantListViewController.swift
//  is_lunch_map
//
//  Created by 行木太一 on 2018/08/05.
//  Copyright © 2018年 yukit.Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

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
        let restaurant = restaurants[indexPath.row]
        let cell = tableView.dequeueReusableCell(for: indexPath, as: Cell.self)
        cell.set(restaurant: restaurant)
        cell.tabelogLinkButton.rx.tap
            .subscribe(onNext: {
                UIApplication.shared.open(restaurant.tabelogUrl!, options: [:], completionHandler: nil)
            })
            .disposed(by: cell.disposeBag)
        return cell
    }
}

// MARK: - UITableView Delegate methods
extension RestaurantListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let restaurant = restaurants[indexPath.row]
        let googlMapUrl = "comgooglemaps://?center=\(restaurant.latitude),\(restaurant.longitude)&zoom=16"
        UIApplication.shared.open(URL(string: googlMapUrl)!, options: [:], completionHandler: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Cell
extension RestaurantListViewController {
    private final class Cell: UITableViewCell, CellReusable {
        private lazy var thumbView: UIImageView = {
            let imageView = UIImageView()
            imageView.backgroundColor = .gray
            imageView.layer.setCorner(radius: 6)
            return imageView
        }()
        private lazy var nameLabel: UILabel = {
            let label = UILabel ()
            label.font = .boldSystemFont(ofSize: 16)
            label.textColor = .darkText
            return label
        }()
        lazy var tabelogLinkButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(named: "tabelog_log"), for: .normal)
            button.setTitleColor(.blue, for: .normal)
            return button
        }()
        
        var disposeBag = DisposeBag()
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            initLayout()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            disposeBag = DisposeBag()
        }
        
        private func initLayout() {
            contentView.addSubviews(thumbView, nameLabel, tabelogLinkButton)
            thumbView.snp.makeConstraints { make in
                make.top.left.bottom.equalToSuperview().inset(8)
                make.width.equalTo(80)
                make.height.equalTo(thumbView.snp.width)
            }
            nameLabel.setContentCompressionResistancePriority(.required, for: .vertical)
            nameLabel.snp.makeConstraints { make in
                make.top.equalTo(thumbView)
                make.left.equalTo(thumbView.snp.right).offset(8)
                make.right.equalToSuperview().inset(8)
            }
            tabelogLinkButton.snp.makeConstraints { make in
                make.top.equalTo(nameLabel.snp.bottom).offset(8)
                make.left.equalTo(nameLabel)
                make.bottom.equalTo(thumbView)
                make.width.equalTo(tabelogLinkButton.snp.height)
            }
        }
        
        func set(restaurant: Restaurant) {
            nameLabel.text = restaurant.shopName
            tabelogLinkButton.isHidden = restaurant.tabelogUrl.isNil
        }
    }
}
