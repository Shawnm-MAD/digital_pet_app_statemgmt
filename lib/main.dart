import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  int energyLevel = 50;  // New property to track energy
  int _winDuration = 0;
  Timer? _timer;

  TextEditingController nameController = TextEditingController();
  bool nameSet = false;
  Timer? hungertimer;

  // Function to increase happiness and update hunger when playing with the pet
  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _updateHunger();
    });
  }

  // Function to decrease hunger and update happiness when feeding the pet
  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      _updateHappiness();
    });
  }

  // Function to increase energy when the pet rests
  void _restPet() {
    setState(() {
      energyLevel = (energyLevel + 20).clamp(0, 100);  // Resting increases energy
    });
  }

  // Update happiness based on hunger level
  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }
  }

  // Increase hunger level slightly when playing with the pet
  void _updateHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    if (hungerLevel > 100) {
      hungerLevel = 100;
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    }
  }

  void setPetName() {
    setState(() {
      petName =
          nameController.text.isNotEmpty ? nameController.text : "Your pet";
      nameSet = true;
    });
    nameController.clear();
  }

  Color petcolor() {
  if (happinessLevel > 70) {
    return Colors.green; // Happy (Green)
  } else if (happinessLevel >= 30) {
    return Colors.yellow; // Neutral (Yellow)
  } else {
    return Colors.red; // Unhappy (Red)
  }
}


  @override
  void initState() {
    super.initState();
    hungertimer = Timer.periodic(Duration(seconds: 30), (timer) {
      inchunger();
    });
  }

  void inchunger() {
    setState(() {
      hungerLevel = (hungerLevel + 10).clamp(0, 100);
    });
  }

  // Start a timer to check if the happiness level stays above 80 for 3 minutes
  void _startWinTimer() {
    _winDuration = 0; // Reset win duration on each play
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (happinessLevel > 80) {
        setState(() {
          _winDuration++;
        });
      } else {
        setState(() {
          _winDuration = 0; // Reset win duration if happiness drops
        });
      }

      if (_winDuration >= 180) { // 3 minutes = 180 seconds
        _showWinMessage();
        _timer?.cancel(); // Stop the timer once win condition is met
      }
    });
  }

  // Show win message
  void _showWinMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("You Win!"),
          content: Text("Your pet has been happy for 3 minutes! 🎉"),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Name: $petName',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Happiness Level: $happinessLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            if (!nameSet)
              Padding(
                padding: const EdgeInsets.symmetric(),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Enter Pet Name",
                      ),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: setPetName,
                      child: Text('Enter'),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 16),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: petcolor(),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Happiness Level: $happinessLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Hunger Level: $hungerLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              'Energy Level: $energyLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            ElevatedButton(
              onPressed: () {
                _playWithPet();
                _startWinTimer(); // Start win timer when playing
              },
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _restPet,
              child: Text('Rest Your Pet'),
            ),
          ],
        ),
      ),
    );
  }
}
