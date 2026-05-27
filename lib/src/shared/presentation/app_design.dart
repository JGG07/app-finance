import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const background = Color(0xFF07110F);
  static const backgroundAlt = Color(0xFF0A1411);
  static const surface = Color(0xFF101A16);
  static const surfaceElevated = Color(0xFF13231D);
  static const surfaceSoft = Color(0xFF182820);
  static const primary = Color(0xFF8BE0B0);
  static const primaryDark = Color(0xFF1F6F4A);
  static const textPrimary = Color(0xFFF1F5F3);
  static const textSecondary = Color(0xFFAAB7B0);
  static const border = Color(0x14FFFFFF);

  static const debt = Color(0xFFE76F51);
  static const apartado = Color(0xFF4EA8DE);
  static const saving = Color(0xFF74C69D);
  static const investment = Color(0xFFA3B18A);
  static const freeUse = Color(0xFFE9C46A);
  static const pending = Color(0xFFD6A84F);
  static const danger = Color(0xFFEF4444);
}

class AppSpacing {
  const AppSpacing._();

  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
}

class AppRadii {
  const AppRadii._();

  static const sm = 10.0;
  static const md = 16.0;
  static const lg = 22.0;
  static const xl = 26.0;
  static const pill = 999.0;
}

class AppShadows {
  const AppShadows._();

  static List<BoxShadow> get card => [
        BoxShadow(
          color: Colors.black.withAlpha(42),
          blurRadius: 22,
          offset: const Offset(0, 12),
        ),
      ];

  static List<BoxShadow> get glow => [
        BoxShadow(
          color: AppColors.primary.withAlpha(28),
          blurRadius: 28,
          offset: const Offset(0, 14),
        ),
      ];
}

enum AppCardVariant {
  normal,
  highlighted,
  compact,
}

enum AppButtonVariant {
  primary,
  secondary,
  ghost,
  danger,
  pill,
}

class AppScreen extends StatelessWidget {
  const AppScreen({
    required this.children,
    this.padding = const EdgeInsets.fromLTRB(16, 18, 16, 24),
    this.maxWidth = 920,
    super.key,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.background,
            AppColors.backgroundAlt,
            AppColors.background,
          ],
        ),
      ),
      child: ListView(
        padding: padding,
        children: [
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppHeader extends StatelessWidget {
  const AppHeader({
    required this.title,
    required this.subtitle,
    this.action,
    super.key,
  });

  final String title;
  final String subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(right: action == null ? 0 : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          if (action != null) ...[
            const SizedBox(width: AppSpacing.md),
            action!,
          ],
        ],
      ),
    );
  }
}

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.variant = AppCardVariant.normal,
    this.padding,
    this.onTap,
    super.key,
  });

  final Widget child;
  final AppCardVariant variant;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding ??
        EdgeInsets.all(
          variant == AppCardVariant.compact ? AppSpacing.md : AppSpacing.lg,
        );
    final decoration = BoxDecoration(
      color: variant == AppCardVariant.compact
          ? AppColors.surface
          : AppColors.surfaceElevated,
      borderRadius: BorderRadius.circular(
        variant == AppCardVariant.compact ? AppRadii.md : AppRadii.lg,
      ),
      border: Border.all(color: AppColors.border),
      gradient: variant == AppCardVariant.highlighted
          ? const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryDark,
                AppColors.surfaceElevated,
                AppColors.surface,
              ],
            )
          : null,
      boxShadow: variant == AppCardVariant.compact
          ? null
          : variant == AppCardVariant.highlighted
              ? AppShadows.glow
              : AppShadows.card,
    );

    final content = Container(
      padding: effectivePadding,
      decoration: decoration,
      child: child,
    );

    if (onTap == null) {
      return content;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        child: content,
      ),
    );
  }
}

class AppIconBubble extends StatelessWidget {
  const AppIconBubble({
    required this.icon,
    this.color = AppColors.primary,
    this.size = 38,
    super.key,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withAlpha(30),
        border: Border.all(color: color.withAlpha(84)),
      ),
      child: Icon(icon, color: color, size: size * 0.52),
    );
  }
}

class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    required this.title,
    this.subtitle,
    this.action,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle!,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (action != null) ...[
          const SizedBox(width: AppSpacing.sm),
          action!,
        ],
      ],
    );
  }
}

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primary,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final labelWidget = Text(label);
    final iconWidget = icon == null ? null : Icon(icon, size: 18);

    switch (variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.pill:
        return iconWidget == null
            ? FilledButton(onPressed: onPressed, child: labelWidget)
            : FilledButton.icon(
                onPressed: onPressed,
                icon: iconWidget,
                label: labelWidget,
              );
      case AppButtonVariant.secondary:
        return iconWidget == null
            ? OutlinedButton(onPressed: onPressed, child: labelWidget)
            : OutlinedButton.icon(
                onPressed: onPressed,
                icon: iconWidget,
                label: labelWidget,
              );
      case AppButtonVariant.ghost:
        return iconWidget == null
            ? TextButton(onPressed: onPressed, child: labelWidget)
            : TextButton.icon(
                onPressed: onPressed,
                icon: iconWidget,
                label: labelWidget,
              );
      case AppButtonVariant.danger:
        return TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(foregroundColor: AppColors.danger),
          child: labelWidget,
        );
    }
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({
    required this.label,
    this.color = AppColors.primary,
    super.key,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: Border.all(color: color.withAlpha(90)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
    );
  }
}

class FinancialListItem extends StatelessWidget {
  const FinancialListItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    this.iconColor = AppColors.primary,
    this.amountColor,
    this.status,
    this.onTap,
    this.trailing,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;
  final Color iconColor;
  final Color? amountColor;
  final Widget? status;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      variant: AppCardVariant.compact,
      padding: const EdgeInsets.all(AppSpacing.md),
      onTap: onTap,
      child: Row(
        children: [
          AppIconBubble(icon: icon, color: iconColor),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (status != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  status!,
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                amount,
                textAlign: TextAlign.right,
                style: textTheme.bodyMedium?.copyWith(
                  color: amountColor ?? AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          if (onTap != null)
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({
    required this.title,
    required this.value,
    required this.icon,
    this.subtitle,
    this.color = AppColors.primary,
    super.key,
  });

  final String title;
  final String value;
  final IconData icon;
  final String? subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      variant: AppCardVariant.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIconBubble(icon: icon, color: color),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: textTheme.labelLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle ?? ' ',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
