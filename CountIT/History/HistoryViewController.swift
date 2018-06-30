//
//  HistoryViewController.swift
//  CountIT
//
//  Created by Claudio S. Di Mauro on 30/05/18.
//  Copyright © 2018 Claudio S. Di Mauro. All rights reserved.
//

import UIKit
import CoreData

//classe usata per mostrare un messaggio quando la tableView è vuota
class TableViewHelper {
    class func EmptyMessage(message:String, viewController:UITableViewController) {
        //let rect = CGRect(origin: CGPoint(x: 0, y :0), size: CGSize(width: 60, height: 10))
        let rect = CGRect(x: 0, y: 0, width: 60, height: 10)
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = UIColor.white
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "DamascusBold", size: 22)
        messageLabel.sizeToFit()
        
        viewController.tableView.backgroundView = messageLabel
//      viewController.tableView.separatorStyle = .none -> non mi serve qui, ma mi serve dopo
    }
}


protocol LibraryCollectionViewCellDelegate: class {
    func delete (cell: TableViewCell)
}


class TableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
}


class HistoryViewController: UITableViewController {
    var normalSession: [NormalSession] = []
    var chronoSession: [ChronoSession] = []
    
    var list: [String] = []
    var counList: [Int16] = []
    var dateList: [String] = []
    var timeList: [String] = []
    var emptyTimeList: [String] = []
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.black
        
        tableView.delegate = self
        tableView.dataSource = self
        
        normalSession = CoreDataManager.fetchNormalSession()!
        chronoSession = CoreDataManager.fetchChronoSession()!
        
        
        for ns in normalSession {
            print("Fetched CoreData: " + ns.title! + "\nCount: \(ns.count) \nDate: " + ns.data! + "\n\n")
            
            //per ogni normalSession salvato devo mettere in append nel seguente vettore una stringa vuota, in seguito questo vettore lo passerò alla tableView al posto dello showing del cronometro nelle righe relative a normalSession, in quanto ns non avendo la sezione di cronometro deve mostrare uno spazio vuoto
            emptyTimeList.append(" ")
        }

        
        /**************NOTE***************
         Se voglio aggiungere al segmented control anche la sezione ALL, che mostra nella tableView sia i dati di normal session, sia quelli di chrono session, allora devo farmi dei for:
         -> for ns in normalSession && for cs in chronoSession <-
         All'interno di questi for devo utilizzare i vettori dichiarati sopra:
         var list: [String] = []
         var counList: [Int16] = []
         var dateList: [String] = []
         var timeList: [String] = []
        
         Ad ognuno di questi vettori devo passare in append il valore del coreData, prima per ns e poi per cs, come segue:
         
         for ns in normalSession {
            list.append(ns.title!)
            counList.append(ns.count)
            dateList.append(ns.data!)
            timeList.append(" ") //stringa vuota
         }
         for cs in chronoSession {
            list.append(cs.title!)
            counList.append(cs.count)
            dateList.append(cs.data!)
            timeList.append(cs.time!)
         }
         
         Dopo aver fatto questo i valori dei vettori li passo alle label nella tableView
         
         - - - - - - - - - - - - - - - - -
         A questo ho usato in aggiunta anche un for innestato che probabilmente era inutile -> Da valutare:

         for ns in normalSession {
             list.append(ns.title!)
             counList.append(ns.count)
             dateList.append(ns.data!)
             timeList.append(" ")
 
             for cs in chronoSession {
                 list.append(cs.title!)
                 counList.append(cs.count)
                 dateList.append(cs.data!)
                 timeList.append(cs.time!)
             }
         }
        *********************************/
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        normalSession = CoreDataManager.fetchNormalSession()!
        chronoSession = CoreDataManager.fetchChronoSession()!
        
        
        for ns in normalSession {
            //per ogni normalSession salvato devo mettere in append nel seguente vettore una stringa vuota, in seguito questo vettore lo passerò alla tableView al posto dello showing del cronometro nelle righe relative a normalSession, in quanto ns non avendo la sezione di cronometro deve mostrare uno spazio vuoto
            emptyTimeList.append(" ")
        }
        
        /**************NOTE***************
         La stessa cosa fatta per viewDidLoad la devo fare anche per la didAppear, in quanto ogni volta che riapro la view dove c'è la tableView mi deve ricaricare i dati fetchati dal coreData.
         *********************************/
        
        tableView.reloadData()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            if normalSession.count > 0 {
                return normalSession.count
            }
            else {
                //Nascondo le righe di separazione, disabilito lo scrolling e mostro il messaggio
                TableViewHelper.EmptyMessage(message: "No Normal Sessions saved", viewController: self)
                tableView.isScrollEnabled = false
                self.tableView.separatorStyle = .none;
                return 0
            }
            returnValue = normalSession.count
            break
        case 1:
            if chronoSession.count > 0 {
                return chronoSession.count
            }
            else {
                //Nascondo le righe di separazione, disabilito lo scrolling e mostro il messaggio
                TableViewHelper.EmptyMessage(message: "No Chrono Sessions saved", viewController: self)
                tableView.isScrollEnabled = false
                self.tableView.separatorStyle = .none;
                return 0
            }
            returnValue = chronoSession.count
            break
        default:
            break
        }
        
        return returnValue
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataList", for: indexPath) as! TableViewCell
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            cell.titleLabel?.text = normalSession[indexPath.row].title
            cell.dateLabel?.text = normalSession[indexPath.row].data
            cell.countLabel.text = "\(normalSession[indexPath.row].count)"
            cell.timeLabel?.text = emptyTimeList[indexPath.row]
            
            //Sto dicendo alla tableView che di default mi deve mostrare i separatori e deve essere scrollabile. Inoltre non deve mostrare nessun messaggio, perché considero che di default ci sia almeno una cella piena. Il controllo sul riempimento delle celle lo vado a fare nella numberOfRowsInSection, in cui controllo se i vettori che mostro nella table sono pieni o meno e valuto quando mostrare il testo e quando mostrare i dati salvati
            tableView.separatorStyle = .singleLine
            tableView.isScrollEnabled = true
            TableViewHelper.EmptyMessage(message: " ", viewController: self)
            break
        case 1:
            cell.titleLabel?.text = chronoSession[indexPath.row].title
            cell.dateLabel?.text = chronoSession[indexPath.row].data
            cell.countLabel.text = "\(chronoSession[indexPath.row].count)"
            cell.timeLabel?.text = chronoSession[indexPath.row].time
            
            //sto dicendo alla tableView che di default mi deve mostrare i separatori e deve essere scrollabile. Inoltre non deve mostrare nessun messaggio, perché considero che di default ci sia almeno una cella piena. Il controllo sul riempimento delle celle lo vado a fare nella numberOfRowsInSection, in cui controllo se i vettori che mostro nella table sono pieni o meno e valuto quando mostrare il testo e quando mostrare i dati salvati
            tableView.separatorStyle = .singleLine
            tableView.isScrollEnabled = true
            TableViewHelper.EmptyMessage(message: " ", viewController: self)
            break
        default:
            break
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                CoreDataManager.deleteInCoreData(normalSession: normalSession, title: normalSession[indexPath.row].title!, count: normalSession[indexPath.row].count, date: normalSession[indexPath.row].data!)
                self.normalSession.remove(at: indexPath.row)
                self.emptyTimeList.remove(at: indexPath.row)//rimuovo anche dal vettore di stringhe vuote
                debugPrint("Deleted normal")
                break
            case 1:
                CoreDataManager.deleteChronoInCoreData(chronoSession: chronoSession, title: chronoSession[indexPath.row].title!, count: chronoSession[indexPath.row].count, date: chronoSession[indexPath.row].data!, time: chronoSession[indexPath.row].time!)
                self.chronoSession.remove(at: indexPath.row)
                debugPrint("Deleted chrono")
                break
            default:
                break
            }
            
            DispatchQueue.main.async {
                print("\(indexPath)")
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.tableView.reloadData()
                print("prova")
                self.tableView.endUpdates()
            }

            print("Deleted")
        }
    }
    
    
    //Customizzazione dell'altezza delle celle
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0//Choose your custom row height
    }
    
    
    @IBAction func segmentedControlAction(_ sender: Any) {
        self.tableView.reloadData()
    }
    
}
