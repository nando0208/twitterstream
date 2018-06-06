///Users/fernando.ferreira/Documents/Projects/personal/twitterstream/twitterstream/Modules/Filter/View
// Created by Fernando Ferreira
// Copyright (c) 2018 Fernando Ferreira. All rights reserved.
//

import UIKit
import Cartography

final class FilterView: UIViewController {

    // MARK: - Properties

    let tableView = UITableView()
    let searchBar = UITextField()
    let loadingView = UIActivityIndicatorView()
    let refresh = UIRefreshControl()
    let emptyView: EmptyView? = Bundle.main.loadNibNamed("EmptyView", owner: nil, options: nil)?.first as? EmptyView

    var presenter: FilterPresenterProtocol?

    private let searchHeight: CGFloat = 34.0

    // MARK: - View's Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blueTwitter
        configureTableView()
        configureSearchBar()
        configureEmptyView()
        adjustContraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        presenter?.viewWillAppear()
        tableView.reloadData()
    }

    // MARK: - Layout

    private func configureTableView() {
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "TweetCell", bundle: nil), forCellReuseIdentifier: "TweetCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 400.0
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.bounces = false
        view.addSubview(tableView)

        loadingView.color = .blueTwitter
        loadingView.hidesWhenStopped = true
        tableView.addSubview(loadingView)

        constrain(tableView, loadingView) { tablePx, loadingPx in
            loadingPx.center == tablePx.center
        }

        tableView.addSubview(refresh)
    }

    private func configureSearchBar() {
        searchBar.returnKeyType = .search
        searchBar.enablesReturnKeyAutomatically = true

        searchBar.clearButtonMode = .always
        searchBar.leftViewMode = .always
        let imageView = UIImageView(image: #imageLiteral(resourceName: "icSearch"))
        imageView.frame = CGRect(x: 0.0, y: 0.0, width: searchHeight, height: searchHeight)
        searchBar.leftView = imageView

        searchBar.textColor = .blackTwitter
        searchBar.backgroundColor = .whiteTwitter
        imageView.tintColor = .darkGrayTwitter

        searchBar.layer.cornerRadius = searchHeight * 0.5
        searchBar.clipsToBounds = true

        searchBar.becomeFirstResponder()
        searchBar.delegate = self

        view.addSubview(searchBar)

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func configureEmptyView() {
        guard let emptyView = emptyView else { return }
        emptyView.delegate = self
        view.addSubview(emptyView)
        constrain(tableView, emptyView) { tablePx, emptyPx in
            emptyPx.edges == tablePx.edges
        }
    }

    private func adjustContraints() {
        constrain(view, searchBar, tableView) { viewPx, searchPx, tablePx in
            searchPx.height == searchHeight

            searchPx.top == viewPx.safeAreaLayoutGuide.top + 10.0
            searchPx.left == viewPx.safeAreaLayoutGuide.left + 40.0
            searchPx.right == viewPx.safeAreaLayoutGuide.right - 40.0
            searchPx.bottom == tablePx.top - 10.0

            tablePx.left == viewPx.safeAreaLayoutGuide.left
            tablePx.right == viewPx.safeAreaLayoutGuide.right
            tablePx.bottom == viewPx.safeAreaLayoutGuide.bottom
        }
    }

    // MARK: - Actions

    @objc private func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
}

// MARK: - Stateful

extension FilterView: Stateful {
    func adapt(toState state: StateMachine) {
        switch state {
        case .content:
            emptyView?.isHidden = true
            loadingView.stopAnimating()
            refresh.endRefreshing()

        case .loading:
            emptyView?.isHidden = true
            tableView.reloadData()
            loadingView.startAnimating()
            refresh.endRefreshing()

        case .reconnecting:
            tableView.performBatchUpdates({
                refresh.beginRefreshing()
            }, completion: nil)

        case let .empty(filler), let .error(filler):
            emptyView?.fillEmptyState(filler)
            emptyView?.isHidden = false
        }
    }
}

// MARK: - FilterViewProtocol

extension FilterView: FilterViewProtocol {
    func updateIndices(toInsert: [IndexPath], toDelete: [IndexPath]) {
        tableView.performBatchUpdates({
            tableView.deleteRows(at: toDelete, with: .automatic)
            tableView.insertRows(at: toInsert, with: .automatic)
        }, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension FilterView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfItems(inSection: section) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()

        if let tweetCell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as? TweetCell {
            cell = tweetCell
            presenter?.setContent(toView: tweetCell, atIndexPath: indexPath)
        }

        return cell
    }
}

// MARK: - UITextfieldDelegate

extension FilterView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        presenter?.filterTouched(with: textField.text)
        return true
    }
}

// MARK: - EmptyViewDelegate

extension FilterView: EmptyViewDelegate {
    func emptyButtonTouched() {
        presenter?.tryAgainTouched()
    }
}
