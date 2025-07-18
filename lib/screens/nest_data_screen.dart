import 'dart:async';
import 'package:flutter/material.dart';

class NestDataScreen extends StatefulWidget {
  const NestDataScreen({super.key});

  @override
  State<NestDataScreen> createState() => _NestDataScreenState();
}

class _NestDataScreenState extends State<NestDataScreen> {
  late Timer _timer;
  List<Map<String, dynamic>> _nests = [];
  List<String> _notifications = [];

  @override
  void initState() {
    super.initState();
    _generateMockData();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) => _updateMockData());
  }

  void _generateMockData() {
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
    _updateNotifications();
  }

  void _updateMockData() {
    setState(() {
      for (var nest in _nests) {
        // Simulate temperature and humidity changes
        nest['temperature'] += (0.5 - (1.0 * (DateTime.now().second % 2)) * 0.2);
        nest['humidity'] += (0.5 - (1.0 * (DateTime.now().second % 2)) * 0.5);
        nest['lastUpdate'] = DateTime.now();
        // Randomly trigger an alert for demonstration
        if (nest['id'] == 'Nest-002' && DateTime.now().second % 10 < 2) {
          nest['alert'] = true;
          nest['hatchStatus'] = 'Alerta: Alta temperatura';
        } else if (nest['id'] == 'Nest-002') {
          nest['alert'] = false;
          nest['hatchStatus'] = 'Eclodindo em breve';
        }
      }
      _updateNotifications();
    });
  }

  void _updateNotifications() {
    _notifications = _nests
        .where((nest) => nest['alert'] == true)
        .map((nest) =>
            'Alerta para ${nest['id']} em ${nest['location']}: ${nest['hatchStatus']}')
        .toList();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dados dos Ninhos'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E3A8A),
              Color(0xFF0EA5E9),
              Color(0xFF06B6D4),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              if (_notifications.isNotEmpty)
                Container(
                  width: double.infinity,
                  color: Colors.red.withOpacity(0.8),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Notificações',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      ..._notifications.map((n) => Text(
                            n,
                            style: const TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _nests.length,
                  itemBuilder: (context, index) {
                    final nest = _nests[index];
                    return Card(
                      color: Colors.white.withOpacity(0.9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  nest['alert']
                                      ? Icons.warning_amber_rounded
                                      : Icons.egg_outlined,
                                  color: nest['alert']
                                      ? Colors.red
                                      : const Color(0xFF1E3A8A),
                                  size: 32,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  nest['id'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: nest['alert']
                                        ? Colors.red
                                        : const Color(0xFF1E3A8A),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  nest['location'],
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.thermostat, size: 18, color: Colors.orange),
                                const SizedBox(width: 4),
                                Text(
                                  '${nest['temperature'].toStringAsFixed(1)} °C',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(width: 16),
                                const Icon(Icons.water_drop, size: 18, color: Colors.blue),
                                const SizedBox(width: 4),
                                Text(
                                  '${nest['humidity'].toStringAsFixed(0)}%',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Status: ${nest['hatchStatus']}',
                              style: TextStyle(
                                color: nest['alert'] ? Colors.red : Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Última atualização: ${nest['lastUpdate'].hour.toString().padLeft(2, '0')}:${nest['lastUpdate'].minute.toString().padLeft(2, '0')}:${nest['lastUpdate'].second.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                color: Colors.black45,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 