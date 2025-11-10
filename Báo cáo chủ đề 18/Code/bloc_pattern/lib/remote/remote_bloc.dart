// lib/bloc/remote_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'remote_event.dart';
import 'remote_state.dart';

class RemoteBloc extends Bloc<RemoteEvent, RemoteState> {
  RemoteBloc() : super(const RemoteState()) {
    on<PowerPressed>(_onPowerPressed);
    on<VolumeUp>(_onVolumeUp);
    on<VolumeDown>(_onVolumeDown);
    on<ChannelUp>(_onChannelUp);
    on<ChannelDown>(_onChannelDown);
    on<MuteToggle>(_onMuteToggle);
    on<NavigationPressed>(_onNavigationPressed);
    on<SelectPressed>(_onSelectPressed);
    on<HomePressed>(_onHomePressed);
    on<SettingsPressed>(_onSettingsPressed);
    on<BackPressed>(_onBackPressed);
    on<MenuPressed>(_onMenuPressed);
    on<InputChanged>(_onInputChanged);
  }
  
  void _onPowerPressed(PowerPressed event, Emitter<RemoteState> emit) {
    emit(state.copyWith(
      isPowerOn: !state.isPowerOn,
      lastCommand: 'Power ${!state.isPowerOn ? "ON" : "OFF"}',
    ));
  }
  
  void _onVolumeUp(VolumeUp event, Emitter<RemoteState> emit) {
    if (!state.isPowerOn) return;
    
    final newVolume = (state.volume + 5).clamp(0, 100);
    emit(state.copyWith(
      volume: newVolume,
      isMuted: false,
      lastCommand: 'Volume Up: $newVolume',
    ));
  }
  
  void _onVolumeDown(VolumeDown event, Emitter<RemoteState> emit) {
    if (!state.isPowerOn) return;
    
    final newVolume = (state.volume - 5).clamp(0, 100);
    emit(state.copyWith(
      volume: newVolume,
      lastCommand: 'Volume Down: $newVolume',
    ));
  }
  
  void _onChannelUp(ChannelUp event, Emitter<RemoteState> emit) {
    if (!state.isPowerOn) return;
    
    final newChannel = state.channel + 1;
    emit(state.copyWith(
      channel: newChannel,
      lastCommand: 'Channel: $newChannel',
    ));
  }
  
  void _onChannelDown(ChannelDown event, Emitter<RemoteState> emit) {
    if (!state.isPowerOn) return;
    
    final newChannel = (state.channel - 1).clamp(1, 999);
    emit(state.copyWith(
      channel: newChannel,
      lastCommand: 'Channel: $newChannel',
    ));
  }
  
  void _onMuteToggle(MuteToggle event, Emitter<RemoteState> emit) {
    if (!state.isPowerOn) return;
    
    emit(state.copyWith(
      isMuted: !state.isMuted,
      lastCommand: state.isMuted ? 'Unmuted' : 'Muted',
    ));
  }
  
  void _onNavigationPressed(NavigationPressed event, Emitter<RemoteState> emit) {
    if (!state.isPowerOn) return;
    
    emit(state.copyWith(
      lastCommand: 'Navigate: ${event.direction.toUpperCase()}',
    ));
  }
  
  void _onSelectPressed(SelectPressed event, Emitter<RemoteState> emit) {
    if (!state.isPowerOn) return;
    
    emit(state.copyWith(
      lastCommand: 'Select/OK',
    ));
  }
  
  void _onHomePressed(HomePressed event, Emitter<RemoteState> emit) {
    if (!state.isPowerOn) return;
    
    emit(state.copyWith(
      lastCommand: 'Home',
    ));
  }
  
  void _onSettingsPressed(SettingsPressed event, Emitter<RemoteState> emit) {
    if (!state.isPowerOn) return;
    
    emit(state.copyWith(
      lastCommand: 'Settings',
    ));
  }
  
  void _onBackPressed(BackPressed event, Emitter<RemoteState> emit) {
    if (!state.isPowerOn) return;
    
    emit(state.copyWith(
      lastCommand: 'Back',
    ));
  }
  
  void _onMenuPressed(MenuPressed event, Emitter<RemoteState> emit) {
    if (!state.isPowerOn) return;
    
    emit(state.copyWith(
      lastCommand: 'Menu',
    ));
  }
  
  void _onInputChanged(InputChanged event, Emitter<RemoteState> emit) {
    if (!state.isPowerOn) return;
    
    emit(state.copyWith(
      currentInput: event.input,
      lastCommand: 'Input: ${event.input.toUpperCase()}',
    ));
  }
}