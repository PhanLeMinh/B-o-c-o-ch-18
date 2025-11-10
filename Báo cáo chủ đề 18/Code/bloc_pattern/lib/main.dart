// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_pattern/remote/remote_bloc.dart';
import 'package:bloc_pattern/remote/remote_event.dart';
import 'package:bloc_pattern/remote/remote_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remote Control',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1a1a2e),
        primaryColor: const Color(0xFF0f3460),
      ),
      home: BlocProvider(
        create: (context) => RemoteBloc(),
        child: const RemoteControlScreen(),
      ),
    );
  }
}

class RemoteControlScreen extends StatelessWidget {
  const RemoteControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote Control'),
        centerTitle: true,
        backgroundColor: const Color(0xFF0f3460),
      ),
      body: BlocBuilder<RemoteBloc, RemoteState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Status Display
                _buildStatusCard(state),
                const SizedBox(height: 20),
                
                // Power Button
                _buildPowerButton(context),
                const SizedBox(height: 20),
                
                // Navigation Pad
                _buildNavigationPad(context, state),
                const SizedBox(height: 20),
                
                // Volume & Channel Controls
                _buildVolumeChannelControls(context, state),
                const SizedBox(height: 20),
                
                // Bottom Controls
                _buildBottomControls(context, state),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildStatusCard(RemoteState state) {
    return Card(
      color: const Color(0xFF16213e),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: state.connectionStatus == ConnectionStatus.connected
                            ? Colors.green
                            : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('Connected'),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: state.isPowerOn
                        ? Colors.green.withOpacity(0.2)
                        : Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    state.isPowerOn ? 'ON' : 'OFF',
                    style: TextStyle(
                      color: state.isPowerOn ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (state.isPowerOn) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Channel'),
                  Text(
                    '${state.channel}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Volume'),
                  Row(
                    children: [
                      Icon(
                        state.isMuted ? Icons.volume_off : Icons.volume_up,
                        color: state.isMuted ? Colors.red : Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        state.isMuted ? 'Muted' : '${state.volume}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
            if (state.lastCommand.isNotEmpty) ...[
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Last Command:',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    state.lastCommand,
                    style: const TextStyle(color: Colors.blueAccent),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildPowerButton(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: ElevatedButton(
        onPressed: () {
          context.read<RemoteBloc>().add(PowerPressed());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(20),
        ),
        child: const Icon(Icons.power_settings_new, size: 32),
      ),
    );
  }
  
  Widget _buildNavigationPad(BuildContext context, RemoteState state) {
    return Card(
      color: const Color(0xFF16213e),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Up button
            _buildNavButton(
              context,
              Icons.keyboard_arrow_up,
              () => context.read<RemoteBloc>().add(NavigationPressed('up')),
              state.isPowerOn,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Left button
                _buildNavButton(
                  context,
                  Icons.keyboard_arrow_left,
                  () => context.read<RemoteBloc>().add(NavigationPressed('left')),
                  state.isPowerOn,
                ),
                const SizedBox(width: 8),
                // Select/OK button
                SizedBox(
                  width: 80,
                  height: 80,
                  child: ElevatedButton(
                    onPressed: state.isPowerOn
                        ? () => context.read<RemoteBloc>().add(SelectPressed())
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: const CircleBorder(),
                    ),
                    child: const Text('OK', style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(width: 8),
                // Right button
                _buildNavButton(
                  context,
                  Icons.keyboard_arrow_right,
                  () => context.read<RemoteBloc>().add(NavigationPressed('right')),
                  state.isPowerOn,
                ),
              ],
            ),
            // Down button
            _buildNavButton(
              context,
              Icons.keyboard_arrow_down,
              () => context.read<RemoteBloc>().add(NavigationPressed('down')),
              state.isPowerOn,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNavButton(
    BuildContext context,
    IconData icon,
    VoidCallback onPressed,
    bool enabled,
  ) {
    return SizedBox(
      width: 70,
      height: 70,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0f3460),
          shape: const CircleBorder(),
        ),
        child: Icon(icon, size: 32),
      ),
    );
  }
  
  Widget _buildVolumeChannelControls(BuildContext context, RemoteState state) {
    return Row(
      children: [
        Expanded(
          child: Card(
            color: const Color(0xFF16213e),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const Text('CHANNEL', style: TextStyle(fontSize: 12)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: state.isPowerOn
                        ? () => context.read<RemoteBloc>().add(ChannelUp())
                        : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('CH +'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: state.isPowerOn
                        ? () => context.read<RemoteBloc>().add(ChannelDown())
                        : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('CH -'),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            color: const Color(0xFF16213e),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const Text('VOLUME', style: TextStyle(fontSize: 12)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: state.isPowerOn
                        ? () => context.read<RemoteBloc>().add(VolumeUp())
                        : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('VOL +'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: state.isPowerOn
                        ? () => context.read<RemoteBloc>().add(VolumeDown())
                        : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('VOL -'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildBottomControls(BuildContext context, RemoteState state) {
    return Card(
      color: const Color(0xFF16213e),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildIconButton(
              context,
              Icons.home,
              'Home',
              () => context.read<RemoteBloc>().add(HomePressed()),
              state.isPowerOn,
            ),
            _buildIconButton(
              context,
              state.isMuted ? Icons.volume_off : Icons.volume_up,
              'Mute',
              () => context.read<RemoteBloc>().add(MuteToggle()),
              state.isPowerOn,
            ),
            _buildIconButton(
              context,
              Icons.menu,
              'Menu',
              () => context.read<RemoteBloc>().add(MenuPressed()),
              state.isPowerOn,
            ),
            _buildIconButton(
              context,
              Icons.settings,
              'Settings',
              () => context.read<RemoteBloc>().add(SettingsPressed()),
              state.isPowerOn,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildIconButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onPressed,
    bool enabled,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: enabled ? onPressed : null,
          icon: Icon(icon, size: 28),
          style: IconButton.styleFrom(
            backgroundColor: const Color(0xFF0f3460),
            padding: const EdgeInsets.all(12),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}