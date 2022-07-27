class AppData {
  static final AppData instance = AppData._internal();
  AppData._internal();
  var _userData;
  dynamic get userData => _userData;
  setUserData(userData) {
    _userData = userData;
  }

  var _employeeData;
  dynamic get employeeData => _employeeData;
  setEmployeeData(userData) {
    _employeeData = employeeData;
  }
}
