//
//  ViewController.swift
//  s02e06_instruments
//
//  Created by Maxim Kuznetsov on 01.11.2020.
//

import UIKit

class Author {
    var name:String
    var book:Book?
    
    init(name:String,book:Book?) {
        self.name = name
        self.book = book
        print("Author Object was allocated in memory")
    }
    deinit {
        print("Author Object was deallocated")
    }
}

class Book {
    var name:String
    var author:Author
    
    init(name:String,author:Author) {
        self.name = name
        self.author = author
        print("Book object was allocated in memory")
    }
    deinit {
        print("Book Object was deallocated")
    }
}


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func betweenTwoClasses(_ sender: Any) {
        
        let author = Author(name: "Peter", book: nil)
        let book = Book(name:"Swift",author:author)
        author.book = book
    }
    
    @IBAction func protocolRelation(_ sender: Any) {
        let vc = SenderVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func closureCycle(_ sender: Any) {
        let vc = ClosureViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ViewController: RetainCycleProtocol {}
