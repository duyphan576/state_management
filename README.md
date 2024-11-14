# state_management
 
# State Management Custom for Flutter

A lightweight state management package for Flutter that doesn’t rely on any external state management libraries from pub.dev.

## Features

- **Initialization**: Allows you to initialize state with a default value.
- **State Update**: Supports synchronous and asynchronous updates for simple states, lists, maps, and nested states.
- **Nested State Management**: Supports updating values within nested maps.
- **Listeners**: Allows you to add listeners to specific state keys to automatically update UI.
- **Reset State**: Resets state values to `null` or a default value.

## Getting Started

To use this custom state management solution in your Flutter app, follow these steps:

### Step 1: Define State Management Class

```dart
class StateManagement {
  /// Stores states with unique keys and their respective values.
  final Map<String, dynamic> _states = {};

  /// Stores listeners associated with state keys, allowing callback functions
  /// to be triggered when a state is updated.
  final Map<String, Function> _listeners = {};

  /// Initializes a state with a specified key and initial value if it doesn't exist.
  void initState(String key, dynamic initialValue) {
    if (!_states.containsKey(key)) {
      _states[key] = initialValue;
    }
  }

  /// Retrieves the current value of a state given its key.
  dynamic getState(String key) {
    return _states[key];
  }

  /// Updates a state synchronously with a new value, triggering listeners if the state changes.
  /// Handles comparison for lists and maps to avoid unnecessary updates.
  void updateStateSync(String key, dynamic newValue) {
    if (_states[key] is List && newValue is List) {
      // Updates only if lists are not equal
      if (!_listEquals(_states[key], newValue)) {
        _states[key] = List.from(newValue);
        _notifyListeners(key);
      }
    } else if (_states[key] is Map && newValue is Map) {
      // Updates only if maps are not equal
      if (!_mapEquals(_states[key], newValue)) {
        _states[key] = Map.from(newValue);
        _notifyListeners(key);
      }
    } else if (_states[key] != newValue) {
      // Updates for other data types if the value has changed
      _states[key] = newValue;
      _notifyListeners(key);
    }
  }

  /// Helper function to compare two lists for equality.
  bool _listEquals(List a, List b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  /// Helper function to compare two maps for equality.
  bool _mapEquals(Map a, Map b) {
    if (a.length != b.length) return false;
    for (var key in a.keys) {
      if (a[key] != b[key]) return false;
    }
    return true;
  }

  /// Updates a nested state within a Map based on dot-separated keys.
  /// Supports nested key paths like 'parentKey.childKey' and notifies listeners.
  void updateNestedState(String parentKey, String childKey, dynamic newValue) {
    if (_states[parentKey] is Map) {
      final parentMap = _states[parentKey] as Map<dynamic, dynamic>;
      List<String> keys = childKey.split('.');
      dynamic current = parentMap;

      // Traverses nested structure based on key path
      for (int i = 0; i < keys.length - 1; i++) {
        current = current[keys[i]];
      }

      if (current != null) {
        // Updates the final nested key with the new value
        current[keys.last] = newValue;
        _notifyListeners(parentKey);
      }
    }
  }

  /// Asynchronously updates a state with a new value from a Future,
  /// notifying listeners if the state changes.
  Future<void> updateStateAsync(String key, Future<dynamic> newValue) async {
    final resolvedValue = await newValue;
    if (_states[key] != resolvedValue) {
      _states[key] = resolvedValue;
      _notifyListeners(key);
    }
  }

  /// Adds a listener for a specific state key to trigger a callback function upon changes.
  void addListener(String key, Function callback) {
    _listeners[key] = callback;
  }

  /// Internal method to notify listeners of a state change.
  /// Calls the callback function associated with the state key, if it exists.
  void _notifyListeners(String key) {
    if (_listeners.containsKey(key)) {
      _listeners[key]!();
    }
  }

  /// Removes a listener for a specific state key.
  void removeListener(String key) {
    _listeners.remove(key);
  }

  /// Resets the state for a given key to null or a specified default value and notifies listeners.
  void resetState(String key, [dynamic defaultValue]) {
    if (_states.containsKey(key)) {
      _states[key] = defaultValue ?? null;
      _notifyListeners(key);
    }
  }
}
```

### Step 2: Using State Management
Example of using it in a Flutter widget:

```dart
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

    return Column(
      children: [
        Text(
          'City: $city',
          style: TextStyle(fontSize: 24),
        ),
        // Button to change the nested city's value.
        FloatingActionButton(
          onPressed: () {
            stateManagement.updateNestedState(
                'nestedState', 'address.city', 'Ho Chi Minh City');
          },
          tooltip: 'Update Nested State (City)',
          child: const Icon(Icons.location_on),
        ),
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
    );
  }

  @override
  void dispose() {
    // Removes the listener when the widget is disposed.
    stateManagement.removeListener('nestedState');
    super.dispose();
  }
}
```
## Features & Methods
- **initState(String key, dynamic initialValue)**: Initializes a state with the given key and initial value if it hasn't been initialized yet.
- **getState(String key)**: Retrieves the current value of a state by its key.
- **updateStateSync(String key, dynamic newValue)**: Updates a state synchronously with the new value, ensuring proper type handling (lists and maps).
- **updateNestedState(String parentKey, String childKey, dynamic newValue)**: Updates a nested key-value pair within a map using a dot notation key (e.g., address.city).
- **addListener(String key, Function callback)**: Adds a listener to a state, which triggers the callback when the state changes.
- **removeListener(String key)**: Removes a listener from a state.
- **resetState(String key)**: Resets a state to null or its default value.
## Example Usage
To initialize a state:
``` dart
stateManagement.initState('userInfo', {'name': 'John Doe', 'age': 30});
```
To update a state:
``` dart
stateManagement.updateStateSync('userInfo', {'name': 'Jane Doe', 'age': 31});
```
To reset a state:
``` dart
stateManagement.resetState('userInfo');
```
