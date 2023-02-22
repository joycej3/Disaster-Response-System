import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_frontend/services/api.dart';

// /////////
// // Create a Form widget.
class MyCustomForm extends StatefulWidget {
  MyCustomForm({Key? key}) : super(key: key);

  @override
  MyCustomFormState createState() => MyCustomFormState();
}

const List<String> emergencyCategories = <String>[
  'Natural Disaster',
  'Fire Related',
  'Traffic Related',
  'Aliens',
  'Other'
];

const List<String> injuryCategories = <String>[
  'I am not injured',
  'I am injured',
  'I can see injured people',
  'I have one leg hanging off'
];

// ///// Emergency Categories Dorpdown --- START ///////
// class DropdownButtonApp extends StatelessWidget {
//   const DropdownButtonApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: const Center(
//           child: EmergencyCategoryDropdown(),
//         ),
//       ),
//     );
//   }
// }

// class EmergencyCategoryDropdown extends StatefulWidget {
//   const EmergencyCategoryDropdown({super.key});

//   @override
//   State<EmergencyCategoryDropdown> createState() =>
//       _DropdownButtonExampleState();
// }

// class _DropdownButtonExampleState extends State<EmergencyCategoryDropdown> {
//   String cat_dropdownValue = emergencyCategories.first;

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonFormField<String>(
//       decoration: InputDecoration(
//         enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(50),
//             borderSide: BorderSide(color: Colors.red, width: 5)),
//         focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(50),
//             borderSide: BorderSide(color: Colors.red, width: 2)),
//         filled: true,
//         fillColor: Colors.redAccent,
//       ),
//       dropdownColor: Colors.red,
//       value: cat_dropdownValue,
//       icon: const Icon(
//         Icons.arrow_downward,
//         color: Colors.white,
//       ),
//       elevation: 16,
//       style: const TextStyle(color: Colors.white, fontSize: 18),
//       onChanged: (String? value) {
//         // This is called when the user selects an item.
//         setState(() {
//           cat_dropdownValue = value!;
//         });
//       },
//       items: emergencyCategories.map<DropdownMenuItem<String>>((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//     );
//   }
// }

// ////// EMERGENCY CATEGORY DROPDOWN --- END ////

// /////   INJURT DROPDOWN ---- START ////
// class injuryDropApp extends StatelessWidget {
//   const injuryDropApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: const Center(
//           child: injuryCategoryDropdown(),
//         ),
//       ),
//     );
//   }
// }

// class injuryCategoryDropdown extends StatefulWidget {
//   const injuryCategoryDropdown({super.key});

//   @override
//   State<injuryCategoryDropdown> createState() => _injuryDropdownState();
// }

// class _injuryDropdownState extends State<injuryCategoryDropdown> {
//   String inj_dropdownValue = injuryCategories.first;

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonFormField<String>(
//       decoration: InputDecoration(
//         enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(50),
//             borderSide: BorderSide(color: Colors.red, width: 2)),
//         focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(50),
//             borderSide: BorderSide(color: Colors.red, width: 2)),
//         filled: true,
//         fillColor: Colors.redAccent,
//       ),
//       dropdownColor: Colors.red,
//       value: inj_dropdownValue,
//       icon: const Icon(
//         Icons.arrow_downward,
//         color: Colors.white,
//       ),
//       elevation: 16,
//       style: const TextStyle(color: Colors.white, fontSize: 18),
//       // underline: Container(
//       //   height: 2,
//       //   color: Colors.redAccent,
//       //),
//       onChanged: (String? value) {
//         // This is called when the user selects an item.
//         setState(() {
//           inj_dropdownValue = value!;
//         });
//       },
//       items: injuryCategories.map<DropdownMenuItem<String>>((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//     );
//   }
// }
// ////// INJURY CATEGORY DROPDOWN --- END ////

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  String _emrgencyCat = '';
  String _injuryCat = '';
  String inj_dropdownValue = injuryCategories.first;
  String cat_dropdownValue = emergencyCategories.first;

  @override
  Widget build(BuildContext context) {
    ApiHandler apiHandler = ApiHandler();

    // Build a Form widget using the _formKey created above.
    return Scaffold(
        body: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 25),
          Text(
            "Emergency Description",
            style: TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold, fontSize: 26),
          ),
          SizedBox(height: 15),
          //EmergencyCategoryDropdown(),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: Colors.red, width: 5)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: Colors.red, width: 2)),
              filled: true,
              fillColor: Colors.redAccent,
            ),
            dropdownColor: Colors.red,
            value: cat_dropdownValue,
            icon: const Icon(
              Icons.arrow_downward,
              color: Colors.white,
            ),
            elevation: 16,
            style: const TextStyle(color: Colors.white, fontSize: 18),
            onChanged: (String? value) {
              setState(() {
                cat_dropdownValue = value!;
              });
            },
            items: emergencyCategories
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            validator: (value) {
              if (value == null) {
                return 'Please choose an option';
              } else {
                _emrgencyCat = value;
                return null;
              }
            },
          ),
          SizedBox(height: 40),
          Text(
            "Report Injuries",
            style: TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold, fontSize: 26),
          ),
          SizedBox(height: 15),
          //SizedBox(child: Tex)),
          //injuryCategoryDropdown(),
          DropdownButtonFormField<String>(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.red, width: 2)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.red, width: 2)),
                filled: true,
                fillColor: Colors.redAccent,
              ),
              dropdownColor: Colors.red,
              value: inj_dropdownValue,
              icon: const Icon(
                Icons.arrow_downward,
                color: Colors.white,
              ),
              elevation: 16,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              onChanged: (String? value) {
                setState(() {
                  inj_dropdownValue = value!;
                });
              },
              items: injuryCategories
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              validator: (value) {
                if (value == null) {
                  return 'Please choose an option';
                } else {
                  _injuryCat = value;
                  return null;
                }
              }),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  side: BorderSide(width: 3, color: Colors.red),
                  foregroundColor: Colors.white,
                  shadowColor: Colors.red,
                  backgroundColor: Colors.redAccent,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  fixedSize: Size(100, 50)),
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  apiHandler.callApi("database_push", {
                    'Emergency Category': _emrgencyCat,
                    'Injury Category': _injuryCat
                  });

                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    ));
  }
}
//////////
