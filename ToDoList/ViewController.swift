import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    // к-во ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemName.count
    }
    // заполнение ячеек
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = itemName[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ToDoListTableViewCell
        cell.textLabelCell?.text = title.value(forKey: "title") as? String
        cell.imageCell?.image = #imageLiteral(resourceName: "New")
        return cell
    }
    

    @IBOutlet var notesTable: UITableView!

    // Кнопка добавления нотаток
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add your new task", message: "Add your name task below", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Save", style: .default, handler: self.save)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        alert.addTextField(configurationHandler: titleTextField)
        self.present(alert, animated: true, completion: nil)
    }
    
    // Кнопка удаления
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.itemName.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
                context.delete(itemName[indexPath.row])
                itemName.remove(at: indexPath.row)

            do
            {
                try context.save()
            }
            catch
            {
                print("There was error in delete")
            }
        }
    }
    // Сохранение данных
    func save(alert: UIAlertAction!){
        guard let newText = titleTextField.text, !newText.isEmpty  else {
            AlertError(with: ErrorMessege.emptyFields)
            return
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Title", in: context)!
        let theTitle = NSManagedObject(entity: entity, insertInto: context)
        theTitle.setValue(titleTextField.text, forKey: "title")
        
        do
        {
          try context.save()
            itemName.append(theTitle)
        }
        catch
        {
         print("There was error in saving")
        }
       
        self.notesTable.reloadData()
    }
    
    func AlertError(with type: ErrorMessege) {
        let myAlert = UIAlertController(title: "Error", message: type.rawValue, preferredStyle: .alert)
        let okeyAction = UIAlertAction(title: "Okey", style: .default, handler: nil)
        myAlert.addAction(okeyAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    var itemName: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.lightBlue
    }

    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Title")
        do
        {
            itemName = try context.fetch(fetchRequest )
        }
        catch
        {
             print("Error in  loading data")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var titleTextField: UITextField!
    
    // В добавлении нотатки поле для текста
    func titleTextField(textField: UITextField!){
        titleTextField = textField
        // Пред текст
        titleTextField.placeholder = "Add a to-do..."
    }
}

