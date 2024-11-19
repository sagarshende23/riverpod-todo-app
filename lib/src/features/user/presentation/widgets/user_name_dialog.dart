import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/providers/user_provider.dart';
import '../../../../common/constants/colors.dart';

class UserNameDialog extends ConsumerStatefulWidget {
  const UserNameDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<UserNameDialog> createState() => _UserNameDialogState();
}

class _UserNameDialogState extends ConsumerState<UserNameDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async => false, // Prevent dialog dismissal with back button
      child: AlertDialog(
        backgroundColor:
            isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppStyles.cardRadius),
        ),
        title: Text(
          'Welcome!',
          style: TextStyle(
            color: isDarkMode ? AppColors.textDark : AppColors.textLight,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Please enter your name to get started',
                style: TextStyle(
                  color: isDarkMode
                      ? AppColors.subTextDark
                      : AppColors.subTextLight,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Your Name',
                  filled: true,
                  fillColor: isDarkMode
                      ? AppColors.surfaceDark
                      : AppColors.surfaceLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDarkMode
                          ? AppColors.primaryDark
                          : AppColors.primaryLight,
                      width: 2,
                    ),
                  ),
                  hintStyle: TextStyle(
                    color: isDarkMode
                        ? AppColors.subTextDark
                        : AppColors.subTextLight,
                  ),
                ),
                style: TextStyle(
                  color: isDarkMode ? AppColors.textDark : AppColors.textLight,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final name = _nameController.text.trim();
                await ref.read(userProvider.notifier).saveUserName(name);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              }
            },
            child: Text(
              'Continue',
              style: TextStyle(
                color:
                    isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
