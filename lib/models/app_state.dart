import 'package:flutter/foundation.dart';

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  List<Map<String, dynamic>> _nests = [];
  List<Map<String, dynamic>> _devices = [];

  // Getters
  List<Map<String, dynamic>> get nests => _nests;
  List<Map<String, dynamic>> get devices => _devices;
  
  int get nestCount => _nests.length;
  int get deviceCount => _devices.length;
  int get onlineDeviceCount => _devices.where((d) => d['status'] == 'online').length;
  int get alertCount => _nests.where((n) => n['alert'] == true).length;

  // Initialize with default data
  void initialize() {
    _initializeNests();
    _initializeDevices();
  }

  void _initializeNests() {
    _nests = [
      {
        'id': 'Nest-001',
        'location': 'Beach A',
        'temperature': 29.5,
        'humidity': 78,
        'hatchStatus': 'Encubando',
        'lastUpdate': DateTime.now(),
        'alert': false,
      },
      {
        'id': 'Nest-002',
        'location': 'Beach B',
        'temperature': 31.2,
        'humidity': 82,
        'hatchStatus': 'Eclodindo em breve',
        'lastUpdate': DateTime.now(),
        'alert': true,
      },
      {
        'id': 'Nest-003',
        'location': 'Beach C',
        'temperature': 28.7,
        'humidity': 75,
        'hatchStatus': 'Encubando',
        'lastUpdate': DateTime.now(),
        'alert': false,
      },
    ];
  }

  void _initializeDevices() {
    _devices = [
      {
        'id': 'IoT-001',
        'name': 'Sensor de Temperatura',
        'location': 'Beach A',
        'status': 'online',
        'lastSeen': DateTime.now().subtract(const Duration(minutes: 2)),
        'battery': 85,
        'signal': 'strong',
      },
      {
        'id': 'IoT-002',
        'name': 'Sensor de Umidade',
        'location': 'Beach B',
        'status': 'online',
        'lastSeen': DateTime.now().subtract(const Duration(minutes: 1)),
        'battery': 92,
        'signal': 'strong',
      },
      {
        'id': 'IoT-003',
        'name': 'Sensor de Movimento',
        'location': 'Beach C',
        'status': 'offline',
        'lastSeen': DateTime.now().subtract(const Duration(hours: 3)),
        'battery': 15,
        'signal': 'weak',
      },
      {
        'id': 'IoT-004',
        'name': 'Câmera de Monitoramento',
        'location': 'Beach A',
        'status': 'online',
        'lastSeen': DateTime.now().subtract(const Duration(minutes: 5)),
        'battery': 78,
        'signal': 'medium',
      },
      {
        'id': 'IoT-005',
        'name': 'Sensor de Temperatura',
        'location': 'Beach D',
        'status': 'maintenance',
        'lastSeen': DateTime.now().subtract(const Duration(days: 1)),
        'battery': 45,
        'signal': 'none',
      },
      {
        'id': 'IoT-006',
        'name': 'Sensor de Umidade',
        'location': 'Beach E',
        'status': 'online',
        'lastSeen': DateTime.now().subtract(const Duration(minutes: 30)),
        'battery': 67,
        'signal': 'medium',
      },
      {
        'id': 'IoT-007',
        'name': 'Sensor de Movimento',
        'location': 'Beach F',
        'status': 'online',
        'lastSeen': DateTime.now().subtract(const Duration(minutes: 10)),
        'battery': 88,
        'signal': 'strong',
      },
      {
        'id': 'IoT-008',
        'name': 'Câmera de Monitoramento',
        'location': 'Beach G',
        'status': 'online',
        'lastSeen': DateTime.now().subtract(const Duration(minutes: 15)),
        'battery': 95,
        'signal': 'strong',
      },
    ];
  }

  // Nest operations
  void addNest(Map<String, dynamic> nest) {
    _nests.add(nest);
    notifyListeners();
  }

  void removeNest(String nestId) {
    _nests.removeWhere((nest) => nest['id'] == nestId);
    notifyListeners();
  }

  void updateNest(String nestId, Map<String, dynamic> updatedNest) {
    final index = _nests.indexWhere((nest) => nest['id'] == nestId);
    if (index != -1) {
      _nests[index] = updatedNest;
      notifyListeners();
    }
  }

  void updateNestAlerts() {
    // Update alert count based on current nest data
    notifyListeners();
  }

  // Device operations
  void addDevice(Map<String, dynamic> device) {
    _devices.add(device);
    notifyListeners();
  }

  void removeDevice(String deviceId) {
    _devices.removeWhere((device) => device['id'] == deviceId);
    notifyListeners();
  }

  void updateDevice(String deviceId, Map<String, dynamic> updatedDevice) {
    final index = _devices.indexWhere((device) => device['id'] == deviceId);
    if (index != -1) {
      _devices[index] = updatedDevice;
      notifyListeners();
    }
  }
} 