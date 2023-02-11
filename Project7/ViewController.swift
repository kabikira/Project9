//
//  ViewController.swift
//  Project7
//
//  Created by koala panda on 2023/01/29.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    //second challange:
    var filteredPetitions = [Petition]()
    override func viewDidLoad() {
        let urlString: String
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "filter", style: .plain, target: self, action: #selector(filteredCases))

        navigationItem.rightBarButtonItem = UIBarButtonItem(title:"info", style: .plain, target: self, action: #selector(showCredits))
        
        if navigationController?.tabBarItem.tag == 0 {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        DispatchQueue.global(qos: .userInitiated).async {
            // URLが有効であることを確認するためにif letを使用しています。
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    self.parse(json: data)
                    
                    return
                }
            }
            self.showError()
        }
        
        //second challange: second challange:
//        filteredPetitions = petitions
    }
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
//        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let petition = petitions[indexPath.row]


        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        //second challange:
//        let filterdPetition = filteredPetitions[indexPath.row]
//        cell.textLabel?.text = filterdPetition.title
//        cell.detailTextLabel?.text = filterdPetition.body
        
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        // ここでJsonがDetailViewに渡される
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showError() {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
        
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "This data came from the White House We The People API", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Done", style: .default))
        present(ac, animated: true)
    }
    
    @objc func filteredCases() {
        //　テキストフィールド付きアラート表示
            let ac = UIAlertController(title: "placeholder", message: "placeholder", preferredStyle: .alert)
            ac.addTextField()
            
            // Submitアラートボタン表示
            let submitAction = UIAlertAction(title: "Submit", style: .default) {
                [weak self, weak ac] _ in
                guard let answer = ac?.textFields?[0].text else { return }
                self?.submit(answer)
            }
            ac.addAction(submitAction)
            present(ac, animated: true, completion: nil)
        }
        //　Submitが押されたら行う指定した文字を含むタイトルを見つける
        func submit(_ answer: String) {
            filteredPetitions.removeAll()
            for petition in petitions {
                if petition.title.contains(answer) {
                    filteredPetitions.append(petition)
                }
            }
            tableView.reloadData()
        }
    
}

