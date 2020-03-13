import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  //Within the Network class, define String _url = 'http://localhost:8000/api/v1 this is basically the BASE_URL for our Laravel API.
  final String _url = 'http://127.0.0.1:8000/api/auth';

  //if you are using android studio emulator, change localhost to 10.0.2.2

  //Also, define a variable token, this will store API token for authentication and would be attached to every request that requires authentication.
  var token;

  //This function checks for token stored in the user device and assigns it to the initially defined String token
  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token'))['token'];
  }

  //The authData() function is an asynchronous function that handles all postrequest to our login and register API Endpoint, it takes two arguments, data and apiUrl .
  authData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  //In the getData() function, we build the fullUrl similar to the postData and call the _getToken() to ensure that tokenis set otherwise it will be null, and our endpoint will return unauthorized we didn’t do this for the authData() method because the register and login routes do not require authentication.
  getData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    await _getToken();
    return await http.get(fullUrl, headers: _setHeaders());
  }

  //This makes it reusable and cleaner since we would have to call it here and there while making requests.
  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
}
