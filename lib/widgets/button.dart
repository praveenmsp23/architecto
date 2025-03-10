import 'package:architecto/extensions/theme.dart';
import 'package:flutter/cupertino.dart';

enum ButtonVariant { primary, secondary, destructive, outline, ghost, link }

enum ButtonSize { small, medium, large }

class Button extends StatelessWidget {
  final String text;
  final String? loadingText;
  final bool isLoading;
  final bool isEnabled;
  final ButtonVariant variant;
  final ButtonSize size;
  final VoidCallback? onPressed;

  Button({
    required this.text,
    this.loadingText,
    this.isLoading = false,
    this.isEnabled = true,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    required this.onPressed,
  });

  Color _getBackgroundColor(BuildContext context) {
    switch (variant) {
      case ButtonVariant.primary:
        return context.primaryColor;
      case ButtonVariant.secondary:
        return context.secondaryColor;
      case ButtonVariant.destructive:
        return CupertinoColors.destructiveRed;
      case ButtonVariant.outline:
        return CupertinoColors.transparent;
      case ButtonVariant.ghost:
        return CupertinoColors.transparent;
      case ButtonVariant.link:
        return CupertinoColors.transparent;
    }
  }

  Color _getTextColor(BuildContext context) {
    switch (variant) {
      case ButtonVariant.primary:
        return context.primaryButtonTextColor;
      case ButtonVariant.secondary:
        return context.primaryButtonTextColor;
      case ButtonVariant.destructive:
        return CupertinoColors.white;
      case ButtonVariant.outline:
        return context.primaryTextColor;
      case ButtonVariant.ghost:
        return context.primaryTextColor;
      case ButtonVariant.link:
        return context.primaryTextColor;
    }
  }

  double _getFontSize() {
    switch (size) {
      case ButtonSize.small:
        return 14;
      case ButtonSize.medium:
        return 16;
      case ButtonSize.large:
        return 18;
    }
  }

  EdgeInsets _getPadding() {
    if (variant == ButtonVariant.link) return EdgeInsets.all(0);
    switch (size) {
      case ButtonSize.small:
        return EdgeInsets.all(4);
      case ButtonSize.medium:
        return EdgeInsets.all(6);
      case ButtonSize.large:
        return EdgeInsets.all(8);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled && !isLoading ? onPressed : null,
      child: Container(
        padding: _getPadding(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: _getBackgroundColor(context),
          border: Border.all(
            width: 2,
            color: variant == ButtonVariant.outline
                ? context.secondaryColor
                : CupertinoColors.transparent,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLoading
                ? Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: CupertinoActivityIndicator(
                      color: _getTextColor(context),
                    ),
                  )
                : SizedBox(),
            Text(
              isLoading ? loadingText ?? text : text,
              style: TextStyle(
                decoration: variant == ButtonVariant.link
                    ? TextDecoration.underline
                    : TextDecoration.none,
                fontSize: _getFontSize(),
                color: _getTextColor(context).withAlpha(
                  (!isEnabled || isLoading ? 192 : 255), // 0.75 opacity = 192 alpha, 1.0 = 255
                ),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
