import 'package:flutter/material.dart';
import '../models/app_state.dart';

class IoTStatusScreen extends StatefulWidget {
  const IoTStatusScreen({super.key});

  @override
  State<IoTStatusScreen> createState() => _IoTStatusScreenState();
}

class _IoTStatusScreenState extends State<IoTStatusScreen> {
  late AppState _appState;

  @override
  void initState() {
    super.initState();
    _appState = AppState();
    _appState.addListener(_onAppStateChanged);
  }

  @override
  void dispose() {
    _appState.removeListener(_onAppStateChanged);
    super.dispose();
  }

  void _onAppStateChanged() {
    setState(() {});
  }

  void _generateMockDevices() {
    // This method is no longer needed as data comes from AppState
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'online':
        return Colors.green;
      case 'offline':
        return Colors.red;
      case 'maintenance':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'online':
        return Icons.check_circle;
      case 'offline':
        return Icons.error;
      case 'maintenance':
        return Icons.build;
      default:
        return Icons.help;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'online':
        return 'Online';
      case 'offline':
        return 'Offline';
      case 'maintenance':
        return 'Manutenção';
      default:
        return 'Desconhecido';
    }
  }

  Color _getBatteryColor(int battery) {
    if (battery > 70) return Colors.green;
    if (battery > 30) return Colors.orange;
    return Colors.red;
  }

  Color _getSignalColor(String signal) {
    switch (signal) {
      case 'strong':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'weak':
        return Colors.red;
      case 'none':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getSignalText(String signal) {
    switch (signal) {
      case 'strong':
        return 'Forte';
      case 'medium':
        return 'Médio';
      case 'weak':
        return 'Fraco';
      case 'none':
        return 'Sem sinal';
      default:
        return 'Desconhecido';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status dos Dispositivos IoT'),
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
              // Summary Stats
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                                         _buildStatItem(
                       'Total',
                       '${_appState.deviceCount}',
                       Icons.devices,
                       Colors.white,
                     ),
                     _buildStatItem(
                       'Online',
                       '${_appState.onlineDeviceCount}',
                       Icons.check_circle,
                       Colors.green,
                     ),
                     _buildStatItem(
                       'Offline',
                       '${_appState.devices.where((d) => d['status'] == 'offline').length}',
                       Icons.error,
                       Colors.red,
                     ),
                     _buildStatItem(
                       'Manutenção',
                       '${_appState.devices.where((d) => d['status'] == 'maintenance').length}',
                       Icons.build,
                       Colors.orange,
                     ),
                  ],
                ),
              ),
              
              // Device List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _appState.devices.length,
                  itemBuilder: (context, index) {
                    final device = _appState.devices[index];
                    return Card(
                      color: Colors.white.withOpacity(0.9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Device Header
                            Row(
                              children: [
                                Icon(
                                  _getStatusIcon(device['status']),
                                  color: _getStatusColor(device['status']),
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        device['name'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        device['id'],
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(device['status']).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: _getStatusColor(device['status']),
                                    ),
                                  ),
                                  child: Text(
                                    _getStatusText(device['status']),
                                    style: TextStyle(
                                      color: _getStatusColor(device['status']),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 12),
                            
                            // Device Details
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDetailItem(
                                    'Localização',
                                    device['location'],
                                    Icons.location_on,
                                  ),
                                ),
                                Expanded(
                                  child: _buildDetailItem(
                                    'Bateria',
                                    '${device['battery']}%',
                                    Icons.battery_full,
                                    color: _getBatteryColor(device['battery']),
                                  ),
                                ),
                                Expanded(
                                  child: _buildDetailItem(
                                    'Sinal',
                                    _getSignalText(device['signal']),
                                    Icons.wifi,
                                    color: _getSignalColor(device['signal']),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 8),
                            
                            // Last Seen
                            Text(
                              'Última atividade: ${_formatLastSeen(device['lastSeen'])}',
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

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: color ?? Colors.black54,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: color ?? Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatLastSeen(DateTime lastSeen) {
    final now = DateTime.now();
    final difference = now.difference(lastSeen);
    
    if (difference.inMinutes < 1) {
      return 'Agora mesmo';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min atrás';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} h atrás';
    } else {
      return '${difference.inDays} dias atrás';
    }
  }
} 