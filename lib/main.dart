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
  int energyLevel = 50;
  int _winDuration = 0;
  bool nameSet = false;
  Timer? _hungerTimer, _winTimer;
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startHungerTimer();
  }

  // Hunger automatically increases every 30 seconds
  void _startHungerTimer() {
    _hungerTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        hungerLevel = (hungerLevel + 10).clamp(0, 100);
        _updateHappiness();
        _checkGameOver();
      });
    });
  }

  // Function to update happiness based on hunger level
  void _updateHappiness() {
    setState(() {
      if (hungerLevel >= 80) {
        happinessLevel = (happinessLevel - 15).clamp(0, 100);
      } else if (hungerLevel >= 50) {
        happinessLevel = (happinessLevel - 5).clamp(0, 100);
      } else {
        happinessLevel = (happinessLevel + 5).clamp(0, 100);
      }
      _checkWinCondition();
    });
  }

  // Function to check win condition
  void _checkWinCondition() {
    if (happinessLevel > 80) {
      _winDuration++;
    } else {
      _winDuration = 0;
    }
    if (_winDuration >= 180) {
      _showWinMessage();
      _winTimer?.cancel();
    }
  }

  // Show win message
  void _showWinMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("You Win! 🎉"),
          content: Text("Your pet has been happy for 3 minutes!"),
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

  // Check for game over condition
  void _checkGameOver() {
    if (hungerLevel == 100 && happinessLevel <= 10) {
      _showGameOverMessage();
    }
  }

  // Show game over message
  void _showGameOverMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Game Over 💀"),
          content: Text("Your pet has become too unhappy and hungry."),
          actions: [
            TextButton(
              child: Text("Restart"),
              onPressed: () {
                setState(() {
                  happinessLevel = 50;
                  hungerLevel = 50;
                  energyLevel = 50;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Function to play with the pet
  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      hungerLevel = (hungerLevel + 5).clamp(0, 100);
      energyLevel = (energyLevel - 10).clamp(0, 100);
    });
    _checkGameOver();
    _checkWinCondition();
  }

  // Function to feed the pet
  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      happinessLevel = (happinessLevel + 5).clamp(0, 100);
    });
  }

  // Function to rest the pet
  void _restPet() {
    setState(() {
      energyLevel = (energyLevel + 20).clamp(0, 100);
    });
  }

  // Function to set pet name
  void setPetName() {
    setState(() {
      petName = nameController.text.isNotEmpty ? nameController.text : "Your Pet";
      nameSet = true;
    });
    nameController.clear();
  }

  // Function to determine pet color based on happiness level
  Color _getPetColor() {
    if (happinessLevel > 70) return Colors.green; // Happy
    if (happinessLevel >= 30) return Colors.yellow; // Neutral
    return Colors.red; // Unhappy
  }

  // Function to determine pet mood
  String _getMoodText() {
    if (happinessLevel > 70) return "Happy 😊";
    if (happinessLevel >= 30) return "Neutral 😐";
    return "Unhappy 😢";
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
            if (!nameSet)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: "Enter Pet Name"),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(onPressed: setPetName, child: Text('Set Name')),
                  ],
                ),
              ),
            SizedBox(height: 16.0),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _getPetColor(),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(_getMoodText(), style: TextStyle(fontSize: 14.0, color: Colors.black)),
            ),
            SizedBox(height: 16.0),
            Text('Happiness Level: $happinessLevel', style: TextStyle(fontSize: 20.0)),
            Text('Hunger Level: $hungerLevel', style: TextStyle(fontSize: 20.0)),
            Text('Energy Level: $energyLevel', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: energyLevel / 100,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
              minHeight: 10,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(onPressed: _playWithPet, child: Text('Play with Your Pet')),
            SizedBox(height: 10),
            ElevatedButton(onPressed: _feedPet, child: Text('Feed Your Pet')),
            SizedBox(height: 10),
            ElevatedButton(onPressed: _restPet, child: Text('Rest Your Pet')),
          ],
        ),
      ),
    );
  }
}
