class ApiResponse{
  String? _status;
  String? _erroMessage;
  dynamic? _data;

  ApiResponse(
      {String? status = "",
        String? erroMessage = "",
        dynamic? data = null,
       }) {
    if (status != null) {
      this._status = status;
    }
    if (erroMessage != null) {
      this._erroMessage = erroMessage;
    }
    if (data != null) {
      this._data = data;
    }
  }

  String? get status => _status;
  set status(String? status) => _status = status;
  String? get erroMessage => _erroMessage;
  set erroMessage(String? erroMessage) => _erroMessage = erroMessage;
  dynamic? get data => _data;
  set data(dynamic? data) => _data = data;
}