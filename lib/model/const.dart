import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

double getMainHeight(BuildContext context)=>MediaQuery.of(context).size.height;

double getMainWidth(BuildContext context)=>MediaQuery.of(context).size.width;

String logoPath()=>"assets/logo.png";

Color mainColor = const Color(0xFF0060FF);

String formatDateTime(String date) => DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(date));
String formatDate(String date) => DateFormat('dd/MM/yyyy').format(DateTime.parse(date));