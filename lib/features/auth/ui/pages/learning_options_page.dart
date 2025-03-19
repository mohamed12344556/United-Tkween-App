import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../widgets/selection_option_chip.dart';
import '../cubits/learning_options/learning_options_cubit.dart';
import '../../../../generated/l10n.dart';

class LearningOptionsPage extends StatefulWidget {
  const LearningOptionsPage({super.key});

  @override
  State<LearningOptionsPage> createState() => _LearningOptionsPageState();
}

class _LearningOptionsPageState extends State<LearningOptionsPage> {
  // Helper method to get localized option text
  String getLocalizedOption(String option) {
    final Map<String, String> optionsMap = {
      'Illustration': context.localeS.illustration,
      'Animation': context.localeS.animation,
      'Fine Art': context.localeS.fine_art,
      'Graphic Design': context.localeS.graphic_design,
      'Lifestyle': context.localeS.lifestyle,
      'Photography': context.localeS.photography,
      'Film & Video': context.localeS.film_and_video,
      'Marketing': context.localeS.marketing,
      'Web Development': context.localeS.web_development,
      'Music': context.localeS.music,
      'UI Design': context.localeS.ui_design,
      'UX Design': context.localeS.ux_design,
      'Business & Management': context.localeS.business_and_management,
      'Productivity': context.localeS.productivity,
    };

    return optionsMap[option] ?? option;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LearningOptionsCubit, LearningOptionsState>(
      listener: (context, state) {
        if (state is LearningOptionsError) {
          context.showErrorSnackBar(state.errorMessage);
        } else if (state is LearningOptionsSuccess) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(Routes.hostView, (route) => false);
        }
      },
      builder: (context, state) {
        final cubit = context.read<LearningOptionsCubit>();
        final isDark = context.isDarkMode;
        final horizontalPadding = context.screenWidth * 0.06;
        final verticalSpacing = context.screenHeight * 0.02;

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeading(context, isDark),
                  SizedBox(height: verticalSpacing * 0.5),
                  _buildSubtitle(context, isDark),
                  SizedBox(height: verticalSpacing),
                  _buildOptionsGrid(context, cubit),
                  _buildContinueButton(context, cubit, state, isDark),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeading(BuildContext context, bool isDark) {
    return Text(
      context.localeS.what_do_you_want_to_learn,
      style: TextStyle(
        fontSize: context.screenWidth * 0.07,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : AppColors.text,
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context, bool isDark) {
    return Text(
      context.localeS.select_your_areas_of_courses_you_would_like_to_learn,
      style: TextStyle(
        fontSize: context.screenWidth * 0.035,
        color: isDark ? Colors.grey[300] : AppColors.textSecondary,
      ),
    );
  }

  Widget _buildOptionsGrid(BuildContext context, LearningOptionsCubit cubit) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3.5,
          crossAxisSpacing: context.screenWidth * 0.03,
          mainAxisSpacing: context.screenHeight * 0.015,
        ),
        itemCount: cubit.options.length,
        itemBuilder: (context, index) {
          final option = cubit.options[index];
          final isSelected = cubit.selectedOptions.contains(option);

          return SelectionOptionChip(
            label: getLocalizedOption(option),
            isSelected: isSelected,
            onTap: () {
              cubit.toggleOption(option);
            },
          );
        },
      ),
    );
  }

  Widget _buildContinueButton(
    BuildContext context,
    LearningOptionsCubit cubit,
    LearningOptionsState state,
    bool isDark,
  ) {
    return AppButton(
      text: context.localeS.continue1,
      backgroundColor: isDark ? AppColors.primary : AppColors.secondary,
      textColor: isDark ? AppColors.secondary : AppColors.background,
      isLoading: state is LearningOptionsLoading,
      onPressed: () {
        cubit.saveOptions( context);
      },
      borderRadius: BorderRadius.circular(context.screenWidth * 0.05),
      height: context.screenHeight * 0.065,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            S.of(context).continue1,
            style: TextStyle(
              fontSize: context.screenWidth * 0.04,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: context.screenWidth * 0.06),
          Icon(
            Icons.arrow_forward,
            color: isDark ? AppColors.secondary : AppColors.focused,
            size: context.screenWidth * 0.05,
          ),
        ],
      ),
    );
  }
}
