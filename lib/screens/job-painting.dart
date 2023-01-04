import 'package:final_year_project/models/data_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './search.dart';
import '../maps/location_input.dart';
import './rating_screen.dart';
import '../maps/place.dart';
import '../providers/users.dart';
import '../providers/auth.dart';

class Painting extends StatefulWidget {
  String fcm;

  Painting(this.fcm);
  static const routeName = '/Painting';

  @override
  _PaintingState createState() => _PaintingState(this.fcm);
}

class _PaintingState extends State<Painting> {
  String fcm;

  _PaintingState(this.fcm);
  TextEditingController _addressController = TextEditingController();
  TextEditingController _problemController = TextEditingController();
  PlaceLocation _pickedLocation;
  double latitude;
  double longitude;
  UserModel usermod;

  void _selectPlace(double lat, double long) {
    latitude = lat;
    longitude = long;
    _pickedLocation = PlaceLocation(latitude: lat, longitude: long);
  }

  var _isLoading = false;
  var _isinit = true;

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context);
    final user = Provider.of<Users>(context, listen: false);
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Painters'),
      ),
      body: Container(
        color: Colors.blue[900],
        child: Column(
          children: <Widget>[
            Container(
              height: (MediaQuery.of(context).size.height) * 0.2,
              decoration: BoxDecoration(
                image: new DecorationImage(
                    image: new AssetImage('images/splash1.png'),
                    fit: BoxFit.contain),
              ),
            ),
            //SizedBox(height: 30),
            Flexible(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                // elevation: 2.0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  //constraints: BoxConstraints(minHeight: 260),
                  width: double.infinity,
                  // padding: EdgeInsets.all(1.0),
                  child: Form(
                    // key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Describe the Problem'),
                            maxLines: 4,
                            keyboardType: TextInputType.multiline,
                            controller: _problemController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter the description';
                              }
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Address'),
                            maxLines: 4,
                            keyboardType: TextInputType.multiline,
                            controller: _addressController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please Enter your Address';
                              }
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          LocationInput(_selectPlace),
                          if (_isLoading)
                            CircularProgressIndicator()
                          else
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 8.0),

                              child: ElevatedButton(
                                child: Text('Submit',
                                style: TextStyle(color:Theme.of(context)
                                .primaryTextTheme
                                   .button
                                  .color,
                                backgroundColor:Theme.of(context).primaryColor, ),
                                ),
                                onPressed: () async {
                                  if (authData.userId != null &&
                                      user.userName != null &&
                                      user.phoneNumber != null) {
                                    await Provider.of<Users>(context).sortTechs(
                                        lat: latitude,
                                        long: longitude,
                                        type: "Painting");
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => Search(
                                          lat: latitude,
                                          long: longitude,
                                          type: 'Painting',
                                          address: _addressController.text,
                                          description: _problemController.text,
                                          username: user.userName,
                                          phoneNumber: user.phoneNumber,
                                          authToken: authData.token,
                                          userId: authData.userId,
                                        ),
                                      ),
                                    );
                                  } else
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: Text('Error'),
                                              content: Text(
                                                  'Please Add your Data in Profile section '),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text('Okay'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                )
                                              ],
                                            ));
                                },
                                // shape: RoundedRectangleBorder(
                                //   borderRadius: BorderRadius.circular(30),
                                // ),



                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
