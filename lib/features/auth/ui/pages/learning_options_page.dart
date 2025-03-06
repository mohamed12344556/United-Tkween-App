import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/core/core.dart';
import 'package:united_formation_app/features/auth/ui/widgets/selection_option_chip.dart';
import 'package:united_formation_app/features/auth/ui/cubits/learning_options/learning_options_cubit.dart';
import 'package:united_formation_app/generated/locale_keys.g.dart';

class LearningOptionsPage extends StatefulWidget {
  const LearningOptionsPage({super.key});

  @override
  State<LearningOptionsPage> createState() => _LearningOptionsPageState();
}

class _LearningOptionsPageState extends State<LearningOptionsPage> {
  // Helper method to get localized option text
  String getLocalizedOption(String option) {
    final Map<String, String> optionsMap = {
      'Illustration': LocaleKeys.illustration.tr(),
      'Animation': LocaleKeys.animation.tr(),
      'Fine Art': LocaleKeys.fine_art.tr(),
      'Graphic Design': LocaleKeys.graphic_design.tr(),
      'Lifestyle': LocaleKeys.lifestyle.tr(),
      'Photography': LocaleKeys.photography.tr(),
      'Film & Video': LocaleKeys.film_and_video.tr(),
      'Marketing': LocaleKeys.marketing.tr(),
      'Web Development': LocaleKeys.web_development.tr(),
      'Music': LocaleKeys.music.tr(),
      'UI Design': LocaleKeys.ui_design.tr(),
      'UX Design': LocaleKeys.ux_design.tr(),
      'Business & Management': LocaleKeys.business_and_management.tr(),
      'Productivity': LocaleKeys.productivity.tr(),
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
          ).pushNamedAndRemoveUntil(Routes.homeView, (route) => false);
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
      LocaleKeys.what_do_you_want_to_learn.tr(),
      style: TextStyle(
        fontSize: context.screenWidth * 0.07,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : AppColors.text,
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context, bool isDark) {
    return Text(
      LocaleKeys.select_your_areas_of_courses_you_would_like_to_learn.tr(),
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

  Widget _buildContinueButton(BuildContext context, LearningOptionsCubit cubit, LearningOptionsState state, bool isDark) {
    return AppButton(
      text: LocaleKeys.continue1.tr(),
      backgroundColor: isDark ? AppColors.primary : AppColors.secondary,
      textColor: isDark ? AppColors.secondary : AppColors.background,
      isLoading: state is LearningOptionsLoading,
      onPressed: () {
        cubit.saveOptions();
      },
      borderRadius: context.screenWidth * 0.08,
      height: context.screenHeight * 0.065,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            LocaleKeys.continue1.tr(),
            style: TextStyle(
              fontSize: context.screenWidth * 0.04,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: context.screenWidth * 0.02),
          Icon(
            Icons.arrow_forward,
            size: context.screenWidth * 0.05,
          ),
        ],
      ),
    );
  }
}