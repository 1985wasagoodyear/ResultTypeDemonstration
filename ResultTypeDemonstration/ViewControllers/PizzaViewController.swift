//
//  PizzaViewController.swift
//  Created 2/28/20
//  Using Swift 5.0
// 
//  Copyright © 2020 Yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

import UIKit

private let cellReuseID = "pizzaCell"

final class PizzaViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.dataSource = self
        table.fillIn(self.view)
        return table
    }()
    
    var pizzas: [Pizza] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "pizzas", ofType: "json")!
        let myFileURL = URL(fileURLWithPath: path)
        let pResult: Result<[Pizza], Error> = Result(catching: { try [Pizza](file: myFileURL) })
        switch pResult {
            case .success(let pizzas):
                self.pizzas = pizzas
            case .failure:
                showAlert(text: "There was a problem loading the pizzas! :(")
        }
    }

}

extension PizzaViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pizzas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellReuseID)
        if (cell == nil) {
            cell = UITableViewCell(style: .subtitle,
                                   reuseIdentifier: cellReuseID)
        }
        let pizza = pizzas[indexPath.row]
        cell.textLabel?.text = pizza.name
        cell.detailTextLabel?.text = "Price: \(String(format:"%.2f", pizza.price))"
        return cell
    }
}
