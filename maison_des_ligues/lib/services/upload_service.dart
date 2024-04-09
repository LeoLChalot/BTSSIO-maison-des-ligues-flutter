
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadService {

  Future<bool> uploadImage(XFile? pickedFile, article) async {
    try{
      Dio dio = Dio();

      if(pickedFile != null){
        FormData formData = FormData.fromMap({
          "nom": article["nom"],
          "photo": await MultipartFile.fromFile(pickedFile.path, filename: "image.jpg"),
          "description": article["description"],
          "prix": double.parse(article["prix"]),
          "quantite": int.parse(article["quantite"]),
          "categorie_id": article["categorie_id"]
        });

        Response response = await dio.post(
          "http://192.168.1.30:3000/images",
          data: formData,
        );

        if(response.statusCode == 200){
          debugPrint("File Upload successfully!");
          debugPrint(response.data);
          return true;
        } else {
          debugPrint("Something went wrong ! Error : ${response.statusCode}");
          return false;
        }
      } else {
        return false;
      }
    } catch (error){
      debugPrint("Something went wrong ! Error : $error");
      return false;
    }
  }


}