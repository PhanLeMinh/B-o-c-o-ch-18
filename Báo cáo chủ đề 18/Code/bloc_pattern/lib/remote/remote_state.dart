// lib/bloc/remote_state.dart

import 'package:equatable/equatable.dart';

class RemoteState extends Equatable {
  final bool isPowerOn;
  final int volume;
  final bool isMuted;
  final int channel;
  final String currentInput;
  final String lastCommand;
  final ConnectionStatus connectionStatus;
  
  const RemoteState({
    this.isPowerOn = false,
    this.volume = 50,
    this.isMuted = false,
    this.channel = 1,
    this.currentInput = 'hdmi1',
    this.lastCommand = '',
    this.connectionStatus = ConnectionStatus.connected,
  });
  
  RemoteState copyWith({
    bool? isPowerOn,
    int? volume,
    bool? isMuted,
    int? channel,
    String? currentInput,
    String? lastCommand,
    ConnectionStatus? connectionStatus,
  }) {
    return RemoteState(
      isPowerOn: isPowerOn ?? this.isPowerOn,
      volume: volume ?? this.volume,
      isMuted: isMuted ?? this.isMuted,
      channel: channel ?? this.channel,
      currentInput: currentInput ?? this.currentInput,
      lastCommand: lastCommand ?? this.lastCommand,
      connectionStatus: connectionStatus ?? this.connectionStatus,
    );
  }
  
  @override
  List<Object?> get props => [
    isPowerOn,
    volume,
    isMuted,
    channel,
    currentInput,
    lastCommand,
    connectionStatus,
  ];
}

enum ConnectionStatus {
  connected,
  disconnected,
  connecting,
}