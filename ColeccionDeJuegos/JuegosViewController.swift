//
//  JuegosViewController.swift
//  ColeccionDeJuegos
//
//  Created by Estefany Castro on 24/10/23.
//

import UIKit

class JuegosViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource  {
   
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var tituloTextField: UITextField!
    
    @IBOutlet weak var agregarActualizarBoton: UIButton!
    
    @IBOutlet weak var eliminarBoton: UIButton!
    
    @IBOutlet weak var pickerCategoria: UIPickerView!
    
    @IBOutlet weak var categoriaLabel: UILabel!
    
    @IBAction func mostrarPickerView(_ sender: Any) {
        pickerCategoria.isHidden = false
    }
    
    
    var imagePicker = UIImagePickerController()
    var juego:Juego? = nil
    let categorias = ["Acción", "Aventura", "Estrategia", "Deportes", "Carreras", "Puzzle", "Rol"]
    var selectedCategory = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        pickerCategoria.delegate = self
        pickerCategoria.dataSource = self
        pickerCategoria.isHidden = true
        
        if juego != nil {
              imageView.image = UIImage(data: (juego!.imagen!) as Data)
              tituloTextField.text = juego!.titulo
              let juegoCategoria = juego!.categoria
              if let juego = juego {
                categoriaLabel.text = "Categoría: \(juego.categoria ?? "N/A")"
              }
              if let categoriaIndex = categorias.firstIndex(of: juegoCategoria!) {
                  pickerCategoria.selectRow(categoriaIndex, inComponent: 0, animated: false)
              }
              
              agregarActualizarBoton.setTitle("Actualizar", for: .normal)
              categoriaLabel.isHidden = false // Mostrar el label de categoría al actualizar
          } else {
              categoriaLabel.isHidden = true // Ocultar el label de categoría al agregar
          }
    }
    
    @IBAction func fotosTapped(_ sender: Any) {
        
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func camaraTapped(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categorias.count
    }
    

    // Implementa el método para proporcionar los títulos de las filas en el UIPickerView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categorias[row]
    }

    // Implementa el método para manejar la selección en el UIPickerView
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = categorias[row] // Actualizar la variable de instancia
        categoriaLabel.text = "Categoría: \(selectedCategory)" // Actualizar el texto del label con la categoría seleccionada
           pickerCategoria.isHidden = true
           print("Categoría seleccionada: \(selectedCategory)")
        
    }
    
    @IBAction func agregarTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as!
        AppDelegate).persistentContainer.viewContext
        
        if juego != nil {
                juego!.titulo = tituloTextField.text
                juego!.imagen = imageView.image?.jpegData(compressionQuality: 0.50)
                juego!.categoria = selectedCategory // Asigna la categoría seleccionada
            } else {
                let juego = Juego(context: context)
                juego.titulo = tituloTextField.text
                juego.imagen = imageView.image?.jpegData(compressionQuality: 0.50)
                juego.categoria = selectedCategory // Asigna la categoría seleccionada
            }
            
            do {
                try context.save()
                navigationController?.popViewController(animated: true)
            } catch {
                print("Error al guardar el juego: \(error)")
            }
    }
    
   /*
    @IBAction func eliminarTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext; context.delete(juego!)
        (UIApplication.shared.delegate as! AppDelegate).saveContext(); navigationController?.popViewController(animated: true)
    }
    */
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagenSeleccionada = info[.originalImage] as? UIImage
        imageView.image = imagenSeleccionada
        imagePicker.dismiss(animated: true, completion: nil)
        
    }

}
