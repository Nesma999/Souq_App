import 'package:shop_app/models/login_model.dart';

abstract class SearchStates{}

class InitialSearchState extends SearchStates{}

class LoadingSearchState extends SearchStates{}

class SuccessfulSearchState extends SearchStates{}

class ErrorSearchState extends SearchStates{}





