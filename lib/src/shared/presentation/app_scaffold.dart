import 'package:flutter/material.dart';

import 'app_design.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.child,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.onSettingsSelected,
    super.key,
  });

  final Widget child;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onSettingsSelected;

  @override
  Widget build(BuildContext context) {
    const destinations = [
      _NavDestination(
        icon: Icons.grid_view_outlined,
        selectedIcon: Icons.grid_view_rounded,
        label: 'Resumen',
      ),
      _NavDestination(
        icon: Icons.receipt_long_outlined,
        selectedIcon: Icons.receipt_long,
        label: 'Movimientos',
      ),
      _NavDestination(
        icon: Icons.donut_large_outlined,
        selectedIcon: Icons.donut_large,
        label: 'Presupuesto',
      ),
      _NavDestination(
        icon: Icons.credit_card_outlined,
        selectedIcon: Icons.credit_card,
        label: 'Tarjetas',
      ),
      _NavDestination(
        icon: Icons.radio_button_checked,
        selectedIcon: Icons.radio_button_checked,
        label: 'Plan',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            child,
            if (selectedIndex == 0 || selectedIndex == 4)
              Positioned(
                top: 10,
                right: 12,
                child: IconButton.filledTonal(
                  tooltip: 'Ajustes',
                  onPressed: onSettingsSelected,
                  style: IconButton.styleFrom(
                    minimumSize: const Size(44, 44),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: AppColors.primary.withAlpha(36),
                  ),
                  icon: const Icon(Icons.settings_outlined),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: _FintechBottomNavigation(
        destinations: destinations,
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}

class _NavDestination {
  const _NavDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

class _FintechBottomNavigation extends StatelessWidget {
  const _FintechBottomNavigation({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final List<_NavDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface.withAlpha(244),
        border: const Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(70),
            blurRadius: 26,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
          child: Row(
            children: [
              for (var index = 0; index < destinations.length; index++)
                Expanded(
                  child: _BottomNavItem(
                    destination: destinations[index],
                    isSelected: selectedIndex == index,
                    textTheme: textTheme,
                    onTap: () => onDestinationSelected(index),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.destination,
    required this.isSelected,
    required this.textTheme,
    required this.onTap,
  });

  final _NavDestination destination;
  final bool isSelected;
  final TextTheme textTheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width <= 430;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isCompact ? 1 : 3),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: isCompact ? 2 : 4,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withAlpha(36)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: isSelected
                  ? Border.all(color: AppColors.primary.withAlpha(34))
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected ? destination.selectedIcon : destination.icon,
                  color:
                      isSelected ? AppColors.primary : AppColors.textSecondary,
                  size: isSelected ? 30 : 26,
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: double.infinity,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      destination.label,
                      maxLines: 1,
                      style: textTheme.labelMedium?.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontSize: isCompact ? 11 : null,
                        fontWeight:
                            isSelected ? FontWeight.w800 : FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
