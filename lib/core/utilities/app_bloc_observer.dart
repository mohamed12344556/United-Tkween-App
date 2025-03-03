import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// `AppBlocObserver` is a custom BLoC observer that provides detailed logging
/// for all BLoC and Cubit state changes, errors, and events throughout the application.
///
/// It can be configured to show different levels of detail depending on your needs.
class AppBlocObserver extends BlocObserver {
  final bool _logOnCreate;
  final bool _logOnChange;
  final bool _logOnClose;
  final bool _logOnError;
  final bool _logOnEvent;
  final bool _logOnTransition;
  final bool _includeStackTrace;

  /// Creates an instance of [AppBlocObserver].
  ///
  /// All logging can be enabled or disabled individually:
  /// - [logOnCreate]: Log when Cubits/Blocs are created
  /// - [logOnChange]: Log when state changes 
  /// - [logOnClose]: Log when Cubits/Blocs are closed
  /// - [logOnError]: Log when errors occur
  /// - [logOnEvent]: Log when events are added to Blocs
  /// - [logOnTransition]: Log during transition between states
  /// - [includeStackTrace]: Include stack trace in error logs
  const AppBlocObserver({
    bool logOnCreate = true,
    bool logOnChange = true,
    bool logOnClose = true,
    bool logOnError = true,
    bool logOnEvent = true,
    bool logOnTransition = true,
    bool includeStackTrace = kDebugMode,
  })  : _logOnCreate = logOnCreate,
        _logOnChange = logOnChange,
        _logOnClose = logOnClose,
        _logOnError = logOnError,
        _logOnEvent = logOnEvent,
        _logOnTransition = logOnTransition,
        _includeStackTrace = includeStackTrace;

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    if (_logOnCreate) {
      log('🟢 onCreate: ${bloc.runtimeType}', name: 'BLOC');
    }
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    if (_logOnEvent) {
      log('⏱️ ${bloc.runtimeType} Event: $event', name: 'BLOC');
    }
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (_logOnChange) {
      log(
        '🔄 ${bloc.runtimeType} State: ${change.currentState.runtimeType} -> ${change.nextState.runtimeType}',
        name: 'BLOC',
      );
      
      // For more detailed state logging
      if (kDebugMode) {
        log('  Current: ${change.currentState}', name: 'BLOC');
        log('  Next: ${change.nextState}', name: 'BLOC');
      }
    }
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    if (_logOnTransition) {
      log(
        '🔀 ${bloc.runtimeType} Transition\n'
        '  Event: ${transition.event.runtimeType}\n'
        '  CurrentState: ${transition.currentState.runtimeType}\n'
        '  NextState: ${transition.nextState.runtimeType}',
        name: 'BLOC',
      );
    }
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    if (_logOnError) {
      log(
        '❌ ${bloc.runtimeType} Error: $error',
        name: 'BLOC',
        error: error,
        stackTrace: _includeStackTrace ? stackTrace : null,
      );
    }
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    if (_logOnClose) {
      log('🔴 onClose: ${bloc.runtimeType}', name: 'BLOC');
    }
  }
}