import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:united_formation_app/core/utilities/extensions.dart';
import 'package:united_formation_app/generated/l10n.dart';

part 'learning_options_state.dart';

class LearningOptionsCubit extends Cubit<LearningOptionsState> {
  LearningOptionsCubit() : super(LearningOptionsInitial());

  // List of available learning options
  // Note: We keep English keys here and translate in the UI
  final List<String> options = [
    'Illustration',
    'Animation',
    'Fine Art',
    'Graphic Design',
    'Lifestyle',
    'Photography',
    'Film & Video',
    'Marketing',
    'Web Development',
    'Music',
    'UI Design',
    'UX Design',
    'Business & Management',
    'Productivity',
  ];

  // List of selected options by the user
  final List<String> selectedOptions = [];

  // Toggle selection of an option
  void toggleOption(String option) {
    if (selectedOptions.contains(option)) {
      selectedOptions.remove(option);
    } else {
      selectedOptions.add(option);
    }

    // Emit new state with updated selected options
    emit(
      LearningOptionsUpdated(
        allOptions: options,
        selectedOptions: List.from(selectedOptions),
      ),
    );
  }

  // Save selected options and proceed
  Future<void> saveOptions(BuildContext context) async {
    try {
      // Validate if at least one option is selected
      if (selectedOptions.isEmpty) {
        emit(
          LearningOptionsError(
            errorMessage: context.localeS.please_select_at_least_one_option,
          ),
        );
        return;
      }

      // Show loading state
      emit(LearningOptionsLoading());

      // Simulate API call or storage operation
      await Future.delayed(const Duration(seconds: 1));

      // Store the selected options (implementation depends on your storage solution)
      // TODO: Implement storage of selected options

      // Emit success state
      emit(LearningOptionsSuccess(selectedOptions: List.from(selectedOptions)));
    } catch (e) {
      // Handle errors
      emit(
        LearningOptionsError(
          errorMessage: context.localeS.something_went_wrong_please_try_again,
        ),
      );
    }
  }

  // Reset selection
  void resetOptions() {
    selectedOptions.clear();
    emit(LearningOptionsInitial());
  }

  @override
  Future<void> close() {
    // Clean up resources if needed
    return super.close();
  }
}
