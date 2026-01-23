import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart'; // ← assuming your new emerald palette is here

class CustomDropdown extends StatefulWidget {
  final List<String> items;
  final String? selectedItem;
  final ValueChanged<String> onChanged;
  final String? hint;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.selectedItem,
    this.hint = "Select an option",
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  bool _isOpen = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    _overlayEntry?.remove();
    _overlayEntry = null;
    _animationController.dispose();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    if (!mounted || _isDisposed) return;

    final overlay = Overlay.of(context);
    _overlayEntry = _createOverlayEntry();
    overlay.insert(_overlayEntry!);

    setState(() => _isOpen = true);
    _animationController.forward();
  }

  void _closeDropdown() {
    if (_isDisposed) return;

    _overlayEntry?.remove();
    _overlayEntry = null;

    if (mounted) {
      setState(() => _isOpen = false);
    }

    if (mounted && !_animationController.isDismissed) {
      _animationController.reverse();
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _closeDropdown,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned(
              left: offset.dx,
              top: offset.dy + size.height + 8,
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height + 8),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 280),
                    decoration: BoxDecoration(
                      color: AppColors.kSurface.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.kEmerald.withOpacity(0.2),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.35),
                          blurRadius: 20,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shrinkWrap: true,
                          itemCount: widget.items.length,
                          itemBuilder: (context, index) {
                            final item = widget.items[index];
                            final isSelected = item == widget.selectedItem;
                            return InkWell(
                              onTap: () {
                                if (!mounted || _isDisposed) return;

                                widget.onChanged(item);

                                // Slight delay helps a lot with fast back navigation
                                Future.delayed(
                                  const Duration(milliseconds: 1),
                                  () {
                                    if (mounted && !_isDisposed) {
                                      _closeDropdown();
                                    }
                                  },
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                color: isSelected
                                    ? AppColors.kEmerald.withOpacity(0.15)
                                    : Colors.transparent,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item,
                                        style: TextStyle(
                                          color: isSelected
                                              ? AppColors.kEmerald
                                              : AppColors.kTextPrimary,
                                          fontSize: 15,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    if (isSelected)
                                      Icon(
                                        Icons.check_rounded,
                                        color: AppColors.kEmerald,
                                        size: 20,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.kInputBg.withOpacity(0.85),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isOpen
                  ? AppColors.kEmerald.withOpacity(0.5)
                  : AppColors.kBorderSubtle,
              width: 1.3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.selectedItem ?? widget.hint!,
                style: TextStyle(
                  color: widget.selectedItem != null
                      ? AppColors.kTextPrimary
                      : AppColors.kTextSecondary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              RotationTransition(
                turns: _rotationAnimation,
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: _isOpen
                      ? AppColors.kEmerald
                      : AppColors.kTextSecondary,
                  size: 26,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
