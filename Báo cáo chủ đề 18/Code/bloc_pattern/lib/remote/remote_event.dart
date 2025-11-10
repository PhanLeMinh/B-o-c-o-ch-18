// lib/bloc/remote_event.dart

abstract class RemoteEvent {}

class PowerPressed extends RemoteEvent {}

class VolumeUp extends RemoteEvent {}

class VolumeDown extends RemoteEvent {}

class ChannelUp extends RemoteEvent {}

class ChannelDown extends RemoteEvent {}

class MuteToggle extends RemoteEvent {}

class NavigationPressed extends RemoteEvent {
  final String direction; // 'up', 'down', 'left', 'right'
  
  NavigationPressed(this.direction);
}

class SelectPressed extends RemoteEvent {}

class HomePressed extends RemoteEvent {}

class SettingsPressed extends RemoteEvent {}

class BackPressed extends RemoteEvent {}

class MenuPressed extends RemoteEvent {}

class InputChanged extends RemoteEvent {
  final String input; // 'hdmi1', 'hdmi2', 'av', etc.
  
  InputChanged(this.input);
}