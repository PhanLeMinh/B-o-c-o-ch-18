// test/bloc_test/remote_bloc_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_pattern/remote/remote_bloc.dart';
import 'package:bloc_pattern/remote/remote_event.dart';
import 'package:bloc_pattern/remote/remote_state.dart';

void main() {
  group('RemoteBloc', () {
    late RemoteBloc remoteBloc;

    setUp(() {
      // Khởi tạo BLoC trước mỗi test
      remoteBloc = RemoteBloc();
    });

    tearDown(() {
      // Đóng BLoC sau mỗi test để tránh memory leak
      remoteBloc.close();
    });

    // Test 1: Kiểm tra initial state
    test('initial state should be RemoteState with default values', () {
      expect(remoteBloc.state, const RemoteState());
      expect(remoteBloc.state.isPowerOn, false);
      expect(remoteBloc.state.volume, 50);
      expect(remoteBloc.state.channel, 1);
    });

    // Test 2: Power Button Toggle
    blocTest<RemoteBloc, RemoteState>(
      'emits [isPowerOn: true] when PowerPressed event is added',
      build: () => remoteBloc,
      act: (bloc) => bloc.add(PowerPressed()),
      expect: () => [
        const RemoteState(
          isPowerOn: true,
          lastCommand: 'Power ON',
        ),
      ],
    );

    blocTest<RemoteBloc, RemoteState>(
      'emits [isPowerOn: false] when PowerPressed twice',
      build: () => remoteBloc,
      act: (bloc) {
        bloc.add(PowerPressed()); // ON
        bloc.add(PowerPressed()); // OFF
      },
      expect: () => [
        const RemoteState(
          isPowerOn: true,
          lastCommand: 'Power ON',
        ),
        const RemoteState(
          isPowerOn: false,
          lastCommand: 'Power OFF',
        ),
      ],
    );

    // Test 3: Volume Control
    blocTest<RemoteBloc, RemoteState>(
      'emits increased volume when VolumeUp is added and power is ON',
      build: () => remoteBloc,
      seed: () => const RemoteState(isPowerOn: true, volume: 50),
      act: (bloc) => bloc.add(VolumeUp()),
      expect: () => [
        const RemoteState(
          isPowerOn: true,
          volume: 55,
          lastCommand: 'Volume Up: 55',
        ),
      ],
    );

    blocTest<RemoteBloc, RemoteState>(
      'does NOT change volume when VolumeUp is added but power is OFF',
      build: () => remoteBloc,
      seed: () => const RemoteState(isPowerOn: false, volume: 50),
      act: (bloc) => bloc.add(VolumeUp()),
      expect: () => [],
    );

    blocTest<RemoteBloc, RemoteState>(
      'volume should not exceed 100',
      build: () => remoteBloc,
      seed: () => const RemoteState(isPowerOn: true, volume: 98),
      act: (bloc) => bloc.add(VolumeUp()),
      expect: () => [
        const RemoteState(
          isPowerOn: true,
          volume: 100,
          isMuted: false,
          lastCommand: 'Volume Up: 100',
        ),
      ],
    );

    blocTest<RemoteBloc, RemoteState>(
      'emits decreased volume when VolumeDown is added',
      build: () => remoteBloc,
      seed: () => const RemoteState(isPowerOn: true, volume: 50),
      act: (bloc) => bloc.add(VolumeDown()),
      expect: () => [
        const RemoteState(
          isPowerOn: true,
          volume: 45,
          lastCommand: 'Volume Down: 45',
        ),
      ],
    );

    blocTest<RemoteBloc, RemoteState>(
      'volume should not go below 0',
      build: () => remoteBloc,
      seed: () => const RemoteState(isPowerOn: true, volume: 3),
      act: (bloc) => bloc.add(VolumeDown()),
      expect: () => [
        const RemoteState(
          isPowerOn: true,
          volume: 0,
          lastCommand: 'Volume Down: 0',
        ),
      ],
    );

    // Test 4: Mute Toggle
    blocTest<RemoteBloc, RemoteState>(
      'emits muted state when MuteToggle is added',
      build: () => remoteBloc,
      seed: () => const RemoteState(isPowerOn: true, isMuted: false),
      act: (bloc) => bloc.add(MuteToggle()),
      expect: () => [
        const RemoteState(
          isPowerOn: true,
          isMuted: true,
          lastCommand: 'Muted',
        ),
      ],
    );

    blocTest<RemoteBloc, RemoteState>(
      'unmutes when volume up is pressed while muted',
      build: () => remoteBloc,
      seed: () => const RemoteState(isPowerOn: true, volume: 50, isMuted: true),
      act: (bloc) => bloc.add(VolumeUp()),
      expect: () => [
        const RemoteState(
          isPowerOn: true,
          volume: 55,
          isMuted: false,
          lastCommand: 'Volume Up: 55',
        ),
      ],
    );

    // Test 5: Channel Control
    blocTest<RemoteBloc, RemoteState>(
      'emits increased channel when ChannelUp is added',
      build: () => remoteBloc,
      seed: () => const RemoteState(isPowerOn: true, channel: 5),
      act: (bloc) => bloc.add(ChannelUp()),
      expect: () => [
        const RemoteState(
          isPowerOn: true,
          channel: 6,
          lastCommand: 'Channel: 6',
        ),
      ],
    );

    blocTest<RemoteBloc, RemoteState>(
      'emits decreased channel when ChannelDown is added',
      build: () => remoteBloc,
      seed: () => const RemoteState(isPowerOn: true, channel: 5),
      act: (bloc) => bloc.add(ChannelDown()),
      expect: () => [
        const RemoteState(
          isPowerOn: true,
          channel: 4,
          lastCommand: 'Channel: 4',
        ),
      ],
    );

    blocTest<RemoteBloc, RemoteState>(
      'channel should not go below 1',
      build: () => remoteBloc,
      seed: () => const RemoteState(isPowerOn: true, channel: 1),
      act: (bloc) => bloc.add(ChannelDown()),
      expect: () => [
        const RemoteState(
          isPowerOn: true,
          channel: 1,
          lastCommand: 'Channel: 1',
        ),
      ],
    );

    // Test 6: Navigation
    blocTest<RemoteBloc, RemoteState>(
      'emits navigation command when NavigationPressed is added',
      build: () => remoteBloc,
      seed: () => const RemoteState(isPowerOn: true),
      act: (bloc) => bloc.add(NavigationPressed('up')),
      expect: () => [
        const RemoteState(
          isPowerOn: true,
          lastCommand: 'Navigate: UP',
        ),
      ],
    );

    // Test 7: Select Button
    blocTest<RemoteBloc, RemoteState>(
      'emits select command when SelectPressed is added',
      build: () => remoteBloc,
      seed: () => const RemoteState(isPowerOn: true),
      act: (bloc) => bloc.add(SelectPressed()),
      expect: () => [
        const RemoteState(
          isPowerOn: true,
          lastCommand: 'Select/OK',
        ),
      ],
    );

    // Test 8: Multiple Events Sequence
    blocTest<RemoteBloc, RemoteState>(
      'handles multiple events in sequence correctly',
      build: () => remoteBloc,
      act: (bloc) {
        bloc.add(PowerPressed()); // Turn ON
        bloc.add(VolumeUp()); // Volume 55
        bloc.add(ChannelUp()); // Channel 2
        bloc.add(MuteToggle()); // Mute
      },
      expect: () => [
        const RemoteState(
          isPowerOn: true,
          lastCommand: 'Power ON',
        ),
        const RemoteState(
          isPowerOn: true,
          volume: 55,
          lastCommand: 'Volume Up: 55',
        ),
        const RemoteState(
          isPowerOn: true,
          volume: 55,
          channel: 2,
          lastCommand: 'Channel: 2',
        ),
        const RemoteState(
          isPowerOn: true,
          volume: 55,
          channel: 2,
          isMuted: true,
          lastCommand: 'Muted',
        ),
      ],
    );

    // Test 9: Power OFF blocks other commands
    blocTest<RemoteBloc, RemoteState>(
      'ignores VolumeUp when power is OFF',
      build: () => remoteBloc,
      seed: () => const RemoteState(isPowerOn: false, volume: 50),
      act: (bloc) {
        bloc.add(VolumeUp());
        bloc.add(ChannelUp());
        bloc.add(MuteToggle());
      },
      expect: () => [], // No state changes
    );

    // Test 10: Home & Settings
    blocTest<RemoteBloc, RemoteState>(
      'emits home command when HomePressed',
      build: () => remoteBloc,
      seed: () => const RemoteState(isPowerOn: true),
      act: (bloc) => bloc.add(HomePressed()),
      expect: () => [
        const RemoteState(
          isPowerOn: true,
          lastCommand: 'Home',
        ),
      ],
    );

    blocTest<RemoteBloc, RemoteState>(
      'emits settings command when SettingsPressed',
      build: () => remoteBloc,
      seed: () => const RemoteState(isPowerOn: true),
      act: (bloc) => bloc.add(SettingsPressed()),
      expect: () => [
        const RemoteState(
          isPowerOn: true,
          lastCommand: 'Settings',
        ),
      ],
    );
  });
}