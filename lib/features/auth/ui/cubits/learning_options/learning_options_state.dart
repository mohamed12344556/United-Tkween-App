part of 'learning_options_cubit.dart';

@immutable
abstract class LearningOptionsState {}

// Initial state
class LearningOptionsInitial extends LearningOptionsState {}

// Loading state (when saving options or performing operations)
class LearningOptionsLoading extends LearningOptionsState {}

// State representing updated selections
class LearningOptionsUpdated extends LearningOptionsState {
  final List<String> allOptions;
  final List<String> selectedOptions;
  
  LearningOptionsUpdated({
    required this.allOptions,
    required this.selectedOptions,
  });
}

// Success state after saving options
class LearningOptionsSuccess extends LearningOptionsState {
  final List<String> selectedOptions;
  
  LearningOptionsSuccess({
    required this.selectedOptions,
  });
}

// Error state
class LearningOptionsError extends LearningOptionsState {
  final String errorMessage;
  
  LearningOptionsError({
    required this.errorMessage,
  });
}