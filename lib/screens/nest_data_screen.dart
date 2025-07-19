import 'dart:async';
import 'package:flutter/material.dart';
import '../models/app_state.dart';

class NestDataScreen extends StatefulWidget {
  const NestDataScreen({super.key});

  @override
  State<NestDataScreen> createState() => _NestDataScreenState();
}

class _NestDataScreenState extends State<NestDataScreen> {
  late Timer _timer;
  List<String> _notifications = [];
  late AppState _appState;

  @override
  void initState() {
    super.initState();
    _appState = AppState();
    _appState.addListener(_onAppStateChanged);
    _timer = Timer.periodic(const Duration(seconds: 2), (_) => _updateMockData());
  }

  @override
  void dispose() {
    _appState.removeListener(_onAppStateChanged);
    _timer.cancel();
    super.dispose();
  }

  void _onAppStateChanged() {
    setState(() {});
  }

  void _generateMockData() {
    // This method is no longer needed as data comes from AppState
    _updateNotifications();
  }

  void _updateMockData() {
    setState(() {
      for (var nest in _appState.nests) {
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
    _notifications = _appState.nests
        .where((nest) => nest['alert'] == true)
        .map((nest) =>
            'Alerta para ${nest['id']} em ${nest['location']}: ${nest['hatchStatus']}')
        .toList();
  }

  void _showNestDetailsModal(BuildContext context, Map<String, dynamic> nest) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1E3A8A),
                  Color(0xFF0EA5E9),
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with icon and title
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        nest['alert']
                            ? Icons.warning_amber_rounded
                            : Icons.egg_outlined,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nest['id'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            nest['location'],
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Status indicator
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: nest['alert'] 
                        ? Colors.red.withOpacity(0.2)
                        : Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: nest['alert'] 
                          ? Colors.red.withOpacity(0.5)
                          : Colors.white.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        nest['alert'] 
                            ? Icons.warning_amber_rounded
                            : Icons.check_circle_outline,
                        color: nest['alert'] ? Colors.red : Colors.green,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          nest['hatchStatus'],
                          style: TextStyle(
                            color: nest['alert'] ? Colors.red : Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Data grid
                Row(
                  children: [
                    Expanded(
                      child: _buildDataCard(
                        'Temperatura',
                        '${nest['temperature'].toStringAsFixed(1)} °C',
                        Icons.thermostat,
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDataCard(
                        'Umidade',
                        '${nest['humidity'].toStringAsFixed(0)}%',
                        Icons.water_drop,
                        Colors.blue,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Last update info
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Colors.white70,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Última atualização: ${nest['lastUpdate'].hour.toString().padLeft(2, '0')}:${nest['lastUpdate'].minute.toString().padLeft(2, '0')}:${nest['lastUpdate'].second.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Close button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1E3A8A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Fechar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDataCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showAddNestModal(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _nestIdController = TextEditingController();
    final _locationController = TextEditingController();
    
    // State variables for IoT connection simulation
    bool _isConnecting = false;
    bool _isConnected = false;
    double _temperature = 0.0;
    double _humidity = 0.0;
    String _connectionStatus = '';
    Color _connectionColor = Colors.grey;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            // Function to simulate IoT device connection
            Future<void> _connectToIoTDevice(String nestId) async {
              setModalState(() {
                _isConnecting = true;
                _connectionStatus = 'Conectando ao dispositivo IoT...';
                _connectionColor = Colors.orange;
              });
              
              // Simulate connection delay
              await Future.delayed(const Duration(seconds: 2));
              
              // Simulate successful connection with random data
              final random = DateTime.now().millisecondsSinceEpoch;
              final temp = 25.0 + (random % 10) + (random % 10) / 10.0; // 25.0 to 35.0
              final hum = 70.0 + (random % 30); // 70.0 to 100.0
              
              setModalState(() {
                _isConnecting = false;
                _isConnected = true;
                _temperature = temp;
                _humidity = hum;
                _connectionStatus = 'Dispositivo IoT Conectado';
                _connectionColor = Colors.green;
              });
            }
            
            return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1E3A8A),
                  Color(0xFF0EA5E9),
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_location,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Adicionar Novo Ninho',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Configure o dispositivo IoT',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Nest ID
                      TextFormField(
                        controller: _nestIdController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'ID do Ninho',
                          labelStyle: const TextStyle(color: Colors.white70),
                          prefixIcon: const Icon(
                            Icons.tag,
                            color: Colors.white70,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white30),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                        ),
                        onChanged: (value) {
                          // Trigger UI update when text changes
                          setModalState(() {});
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o ID do ninho';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Location
                      TextFormField(
                        controller: _locationController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Localização',
                          labelStyle: const TextStyle(color: Colors.white70),
                          prefixIcon: const Icon(
                            Icons.location_on,
                            color: Colors.white70,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white30),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                        ),
                        onChanged: (value) {
                          // Trigger UI update when text changes
                          setModalState(() {});
                        },
                        onFieldSubmitted: (value) {
                          // Auto-connect after location is entered (2 second delay)
                          if (_nestIdController.text.isNotEmpty && value.isNotEmpty && !_isConnected && !_isConnecting) {
                            Future.delayed(const Duration(seconds: 2), () {
                              if (mounted) {
                                _connectToIoTDevice(_nestIdController.text);
                              }
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira a localização';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // IoT Device Status
                      if (_nestIdController.text.isNotEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _connectionColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _connectionColor.withOpacity(0.5),
                            ),
                          ),
                          child: Row(
                            children: [
                              if (_isConnecting)
                                const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                                  ),
                                )
                              else
                                Icon(
                                  _isConnected ? Icons.sensors : Icons.sensors_off,
                                  color: _connectionColor,
                                  size: 24,
                                ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _connectionStatus.isEmpty 
                                      ? 'Dispositivo não conectado'
                                      : _connectionStatus,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      const SizedBox(height: 16),
                      
                      // Test Connection Button
                      if (_nestIdController.text.isNotEmpty && !_isConnecting)
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: _isConnected 
                                ? null 
                                : () => _connectToIoTDevice(_nestIdController.text),
                            icon: Icon(
                              _isConnected ? Icons.check_circle : Icons.wifi_find,
                              color: _isConnected ? Colors.green : Colors.white,
                            ),
                            label: Text(
                              _isConnected ? 'Dispositivo Conectado' : 'Testar Conexão',
                              style: TextStyle(
                                color: _isConnected ? Colors.green : Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isConnected 
                                  ? Colors.green.withOpacity(0.2)
                                  : const Color(0xFF0EA5E9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: _isConnected ? 0 : 2,
                            ),
                          ),
                        ),
                      
                      // Temperature and Humidity (Read-only)
                      if (_isConnected)
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.thermostat,
                                          color: Colors.orange,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Temperatura',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${_temperature.toStringAsFixed(1)} °C',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      'Dados automáticos do IoT',
                                      style: TextStyle(
                                        color: Colors.white60,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.water_drop,
                                          color: Colors.blue,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Umidade',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${_humidity.toStringAsFixed(0)}%',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      'Dados automáticos do IoT',
                                      style: TextStyle(
                                        color: Colors.white60,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: (_formKey.currentState?.validate() == true && _isConnected)
                            ? () {
                                // Add new nest to the list with automatic IoT data
                                final newNest = {
                                  'id': _nestIdController.text,
                                  'location': _locationController.text,
                                  'temperature': _temperature, // Connected IoT data
                                  'humidity': _humidity, // Connected IoT data
                                  'hatchStatus': 'Encubando',
                                  'lastUpdate': DateTime.now(),
                                  'alert': false,
                                };
                                
                                _appState.addNest(newNest);
                                _updateNotifications();
                                
                                Navigator.of(context).pop();
                                
                                // Show success message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Ninho ${_nestIdController.text} adicionado com sucesso!'),
                                    backgroundColor: Colors.green,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF1E3A8A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          _isConnected ? 'Adicionar' : 'Conecte o dispositivo primeiro',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _isConnected ? const Color(0xFF1E3A8A) : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dados dos Ninhos'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddNestModal(context),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        tooltip: 'Adicionar Novo Ninho',
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
                  itemCount: _appState.nests.length,
                  itemBuilder: (context, index) {
                    final nest = _appState.nests[index];
                    return GestureDetector(
                      onTap: () => _showNestDetailsModal(context, nest),
                      child: Card(
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