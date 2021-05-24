//
//  NewOrderViewController.swift
//  HotCoffee
//
//  Created by MAC on 04/04/2021.
//

import Foundation
import UIKit

protocol AddCoffeeOrderDelegate {
    func addCoffeeOrderViewControllerDidSave(order: Order, controller: UIViewController)
    func addCoffeeOrderViewControllerDidClose(controller: UIViewController)
    
}

class NewOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    private var vm = AddCoffeeOrderViewModel()
    private var coffeeSizesSegmentedControl: UISegmentedControl!
    
    var delegate: AddCoffeeOrderDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI(){
        coffeeSizesSegmentedControl = UISegmentedControl(items: vm.sizes)
        coffeeSizesSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(coffeeSizesSegmentedControl)
        
        self.coffeeSizesSegmentedControl.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 20).isActive = true
        
        self.coffeeSizesSegmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.vm.types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeTypeTableViewCell", for: indexPath)
        cell.textLabel?.text = self.vm.types[indexPath.row]
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    @IBAction func close(){
        if let delegate = self.delegate {
            delegate.addCoffeeOrderViewControllerDidClose(controller: self)
        }
    }
    
    @IBAction func save(){
        let name = self.nameTextField.text
        let email = self.emailTextField.text
        
        guard let indexPath = self.tableView.indexPathForSelectedRow else { fatalError("Coffee not selected") }
        
        let selectedSize = self.coffeeSizesSegmentedControl.titleForSegment(at: self.coffeeSizesSegmentedControl.selectedSegmentIndex)
        
        self.vm.name = name
        self.vm.email = email
        self.vm.selectedSize = selectedSize
        self.vm.selectedType = vm.types[indexPath.row]
        
        WebServices().load(resource: Order.create(vm)) { result in
            switch result{
                case .success(let order):
                    if let order = order, let delegate = self.delegate {
                        DispatchQueue.main.async {
                            delegate.addCoffeeOrderViewControllerDidSave(order: order, controller: self)
                        }

                    }
                case .failure(let error):
                    print(error)
                
            }
        }
    }
    
    
}
