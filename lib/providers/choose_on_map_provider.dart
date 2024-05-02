import 'package:flutter/material.dart';
class ChooseOnMapProvider extends ChangeNotifier{
  bool isSelected = false;

  void setIsSelectedToFalse(){
    isSelected = false;
    notifyListeners();
  }
  void setIsSelectedToTrue(){
    isSelected = true;
    notifyListeners();
  }
}