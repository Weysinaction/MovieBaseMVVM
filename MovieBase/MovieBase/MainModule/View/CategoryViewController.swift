// CategoryViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// CategoryViewController-
final class CategoryViewController: UIViewController {
    // MARK: view elements

    private var tableView = UITableView()

    // MARK: private properties

    private let filmCellID = "FilmCell"

    // MARK: public properties

    var viewModel: CategoryViewModelProtocol!
    var router: RouterProtocol?

    // MARK: CategoryViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewController()
        viewModel.getMovies {
            self.tableView.reloadData()
        }
    }

    // MARK: Private methods

    private func setupViewController() {
        view.backgroundColor = .red
        title = "Films"

        setupTableView()
    }

    private func setupTableView() {
        filmTableView = UITableView(frame: view.bounds, style: .plain)
        filmTableView.accessibilityIdentifier = "FilmTableView"
        filmTableView.register(FilmTableViewCell.self, forCellReuseIdentifier: filmCellID)

        filmTableView.delegate = self
        filmTableView.dataSource = self
        view.addSubview(filmTableView)
        filmTableView.translatesAutoresizingMaskIntoConstraints = false
        filmTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        filmTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        filmTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        filmTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.films?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = filmTableView
            .dequeueReusableCell(withIdentifier: filmCellID, for: indexPath) as? FilmTableViewCell
        else { return UITableViewCell() }

        guard let film = viewModel.films?[indexPath.row] else { return UITableViewCell() }
        cell.configureCell(film: film)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let film = viewModel.films?[indexPath.row] else { return }
        router?.showDetail(film: film)
    }
}

// MARK: MainViewProtocol

extension CategoryViewController: MainViewProtocol {
    var filmTableView: UITableView {
        get {
            tableView
        }
        set(newValue) {
            tableView = newValue
        }
    }
}
