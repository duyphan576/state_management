import 'package:flutter/material.dart';
import 'package:state_management/state_management_package.dart';

/// Creates an instance of the StateManagement class for managing app state.
final stateManagement = StateManagement();

void main() {
  // Initializes states with predefined values for testing and display purposes.
  stateManagement.initState('numbers', [1, 2, 3]);
  stateManagement.initState('userInfo', {'name': 'Alice', 'age': 30});
  stateManagement.initState('nestedState', {
    'address': {'city': 'Hanoi', 'zip': '100000'}
  });

  // Runs the Flutter app.
  runApp(const MyApp());
}

/// Main application widget.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('State Management')),
        body: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            NumbersListWidget(), // Displays the list of numbers.
            UserInfoWidget(), // Displays user information.
            NestedStateWidget(), // Displays nested state information.
          ],
        ),
        // Floating action buttons for interacting with different states.
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Button to add a new number to the list.
                FloatingActionButton(
                  onPressed: () {
                    List<int> currentNumbers = List<int>.from(
                        stateManagement.getState('numbers') ?? []);
                    int newNumber =
                        currentNumbers.isEmpty ? 1 : currentNumbers.last + 1;
                    stateManagement.updateStateSync(
                        'numbers', [...currentNumbers, newNumber]);
                  },
                  tooltip: 'Add Number',
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 10),
                // Button to reset the numbers list.
                FloatingActionButton(
                  onPressed: () {
                    stateManagement.resetState('numbers');
                  },
                  tooltip: 'Reset Numbers',
                  child: const Icon(Icons.refresh),
                ),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Button to increment the user's age.
                FloatingActionButton(
                  onPressed: () {
                    Map<String, dynamic> currentUserInfo =
                        Map<String, dynamic>.from(
                            stateManagement.getState('userInfo') ?? {});
                    if (currentUserInfo.containsKey('age') &&
                        currentUserInfo['age'] is int) {
                      currentUserInfo['age'] = currentUserInfo['age'] + 1;
                      stateManagement.updateStateSync(
                          'userInfo', currentUserInfo);
                    }
                  },
                  tooltip: 'Update User Age',
                  child: const Icon(Icons.edit),
                ),
                const SizedBox(height: 10),
                // Button to reset user info to default values.
                FloatingActionButton(
                  onPressed: () {
                    stateManagement
                        .resetState('userInfo', {'name': 'Alice', 'age': 30});
                  },
                  tooltip: 'Reset User Info',
                  child: const Icon(Icons.refresh),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Button to change the nested city's value.
                FloatingActionButton(
                  onPressed: () {
                    stateManagement.updateNestedState(
                        'nestedState', 'address.city', 'Ho Chi Minh City');
                  },
                  tooltip: 'Update Nested State (City)',
                  child: const Icon(Icons.location_on),
                ),
                const SizedBox(height: 10),
                // Button to reset the nested state to default values.
                FloatingActionButton(
                  onPressed: () {
                    stateManagement.resetState('nestedState', {
                      'address': {'city': 'Hanoi', 'zip': '100000'}
                    });
                  },
                  tooltip: 'Reset Nested State',
                  child: const Icon(Icons.refresh),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget that displays a list of numbers and their total.
class NumbersListWidget extends StatefulWidget {
  const NumbersListWidget({super.key});

  @override
  _NumbersListWidgetState createState() => _NumbersListWidgetState();
}

class _NumbersListWidgetState extends State<NumbersListWidget> {
  @override
  void initState() {
    super.initState();
    // Adds a listener to update the widget when the 'numbers' state changes.
    stateManagement.addListener('numbers', () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // Retrieves and displays the list of numbers and their sum.
    List<int> numbers =
        List<int>.from(stateManagement.getState('numbers') ?? []);
    return Column(
      children: [
        Text(
          'Numbers: ${numbers.join(', ')}',
          style: const TextStyle(fontSize: 24),
        ),
        Text(
          'Total: ${numbers.isNotEmpty ? numbers.reduce((value, element) => value + element) : 0}',
          style: const TextStyle(fontSize: 24),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Removes the listener when the widget is disposed.
    stateManagement.removeListener('numbers');
    super.dispose();
  }
}

/// Widget that displays user information (name and age).
class UserInfoWidget extends StatefulWidget {
  const UserInfoWidget({super.key});

  @override
  _UserInfoWidgetState createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  @override
  void initState() {
    super.initState();
    // Adds a listener to update the widget when the 'userInfo' state changes.
    stateManagement.addListener('userInfo', () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // Retrieves and displays user info such as name and age.
    Map<dynamic, dynamic> userInfo = stateManagement.getState('userInfo') ?? {};
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Name: ${userInfo['name']}',
            style: const TextStyle(fontSize: 24),
          ),
          Text(
            'Age: ${userInfo['age']}',
            style: const TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Removes the listener when the widget is disposed.
    stateManagement.removeListener('userInfo');
    super.dispose();
  }
}

/// Widget that displays a nested state value (city).
class NestedStateWidget extends StatefulWidget {
  const NestedStateWidget({super.key});

  @override
  _NestedStateWidgetState createState() => _NestedStateWidgetState();
}

class _NestedStateWidgetState extends State<NestedStateWidget> {
  @override
  void initState() {
    super.initState();
    // Adds a listener to update the widget when the 'nestedState' changes.
    stateManagement.addListener('nestedState', () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // Retrieves and displays the city from the nested state.
    Map<dynamic, dynamic> nestedState =
        stateManagement.getState('nestedState') ?? {};
    String city = nestedState['address']?['city'] ?? 'Unknown';
    return Text(
      'City: $city',
      style: const TextStyle(fontSize: 24),
    );
  }

  @override
  void dispose() {
    // Removes the listener when the widget is disposed.
    stateManagement.removeListener('nestedState');
    super.dispose();
  }
}
