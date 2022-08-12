import 'package:flutter/material.dart';


var verticleDivider = VerticalDivider(width: 20,thickness: 2,color: Colors.grey,);

dynamic checkAndGetValue(Map<String,dynamic> data, String key,{dynamic defaultValue}){
  if(data.containsKey(key)){
    return data[key];
  }
  return defaultValue;
}