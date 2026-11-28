import 'package:flutter/material.dart';
import 'package:good_manager/data/app_settings.dart';
import 'package:good_manager/domain/entity/entity.dart';
import 'package:good_manager/util/dimen.dart';

/// Skeleton placeholders for the Home page. Each block mirrors the size of the
/// real block it stands in for, so nothing jumps when the data arrives.

const double _gap = Dimens.cardGap;
// Stat, documents and partner cards use 16; row cards use the shared radius.
const double _blockRadius = 16;
const double _rowRadius = Dimens.cardRadius;
const double _walletFaceRadius = 22;
const double _walletFaceHeight = 156;
const TextStyle _labelStyle = TextStyle(fontSize: 12);

class _PulseScope extends InheritedWidget {
  final Color color;

  const _PulseScope({required this.color, required super.child});

  @override
  bool updateShouldNotify(_PulseScope old) => color != old.color;
}

/// Owns the single pulse animation shared by every [HomeSkeletonBone] below.
class HomeSkeleton extends StatefulWidget {
  final Widget child;

  const HomeSkeleton({super.key, required this.child});

  @override
  State<HomeSkeleton> createState() => _HomeSkeletonState();
}

class _HomeSkeletonState extends State<HomeSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
      _controller.value = 0;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return ExcludeSemantics(
      child: AnimatedBuilder(
        animation: _controller,
        child: widget.child,
        builder: (context, child) => _PulseScope(
          color: onSurface.withValues(
            alpha: 0.06 + 0.06 * Curves.easeInOut.transform(_controller.value),
          ),
          child: child!,
        ),
      ),
    );
  }
}

/// A rounded box in the pulse colour. With [textStyle] it is exactly as tall
/// as one line of that style.
class HomeSkeletonBone extends StatelessWidget {
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final double radius;

  const HomeSkeletonBone({
    super.key,
    this.width,
    this.height,
    this.textStyle,
    this.radius = 6,
  });

  @override
  Widget build(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_PulseScope>();
    assert(scope != null, 'HomeSkeletonBone must be inside a HomeSkeleton');
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scope?.color ?? Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: textStyle == null
          ? SizedBox(width: width, height: height)
          : SizedBox(
              width: width,
              child: Opacity(
                opacity: 0,
                child: Text('0', maxLines: 1, style: textStyle),
              ),
            ),
    );
  }
}

class _IconBoneBox extends StatelessWidget {
  const _IconBoneBox();

  @override
  Widget build(BuildContext context) =>
      const HomeSkeletonBone(width: 38, height: 38, radius: 12);
}

class _SkeletonCard extends StatelessWidget {
  final double radius;
  final Widget child;

  const _SkeletonCard({required this.radius, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Padding(padding: const EdgeInsets.all(12), child: child),
    );
  }
}

/// Mirrors `_buildStatCard` on the Home page.
class HomeStatCardSkeleton extends StatelessWidget {
  const HomeStatCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final titleMedium = Theme.of(context).textTheme.titleMedium;
    return _SkeletonCard(
      radius: _blockRadius,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _IconBoneBox(),
          const SizedBox(height: 8),
          HomeSkeletonBone(width: 28, textStyle: titleMedium),
          const SizedBox(height: 2),
          const HomeSkeletonBone(width: 48, textStyle: _labelStyle),
        ],
      ),
    );
  }
}

/// Two or three stat cards; same decision as the real row.
class HomeStatsRowSkeleton extends StatelessWidget {
  const HomeStatsRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final count = AppSettings.isMinQuantityEnabled() ? 3 : 2;
    return HomeSkeleton(
      child: Row(
        children: [
          for (var i = 0; i < count; i++) ...[
            if (i > 0) const SizedBox(width: _gap),
            const Expanded(child: HomeStatCardSkeleton()),
          ],
        ],
      ),
    );
  }
}

/// Mirrors `_buildDocumentsEntry`: header row plus incoming/outgoing rows.
class HomeDocumentsCardSkeleton extends StatelessWidget {
  const HomeDocumentsCardSkeleton({super.key});

  Widget _summaryRow(BuildContext context, DocumentType type) {
    final theme = Theme.of(context);
    final showAmount =
        AppSettings.getGoodPropertiesSettings().showPriceFor(type);
    return Row(
      children: [
        const _IconBoneBox(),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: HomeSkeletonBone(
              width: 90,
              textStyle: theme.textTheme.titleSmall,
            ),
          ),
        ),
        if (showAmount) ...[
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: HomeSkeletonBone(
                width: 80,
                textStyle: theme.textTheme.titleMedium,
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleMedium = Theme.of(context).textTheme.titleMedium;
    return HomeSkeleton(
      child: _SkeletonCard(
        radius: _blockRadius,
        child: Column(
          children: [
            Row(
              children: [
                const _IconBoneBox(),
                const SizedBox(width: 12),
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: HomeSkeletonBone(width: 100, textStyle: titleMedium),
                  ),
                ),
                HomeSkeletonBone(width: 24, textStyle: titleMedium),
                const SizedBox(width: 28),
              ],
            ),
            const SizedBox(height: _gap),
            _summaryRow(context, DocumentType.incoming),
            const SizedBox(height: _gap),
            _summaryRow(context, DocumentType.outgoing),
          ],
        ),
      ),
    );
  }
}

/// Mirrors the supplier and customer cards of `_buildPartnersSection`.
class HomePartnersCardsSkeleton extends StatelessWidget {
  const HomePartnersCardsSkeleton({super.key});

  Widget _card(TextStyle? titleSmall) => _SkeletonCard(
        radius: _blockRadius,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _IconBoneBox(),
            const SizedBox(height: 12),
            HomeSkeletonBone(width: 72, textStyle: titleSmall),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final titleSmall = Theme.of(context).textTheme.titleSmall;
    return HomeSkeleton(
      child: Row(
        children: [
          Expanded(child: _card(titleSmall)),
          const SizedBox(width: _gap),
          Expanded(child: _card(titleSmall)),
        ],
      ),
    );
  }
}

class _RowCardSkeleton extends StatelessWidget {
  const _RowCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final titleMedium = Theme.of(context).textTheme.titleMedium;
    return _SkeletonCard(
      radius: _rowRadius,
      child: Row(
        children: [
          const _IconBoneBox(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeSkeletonBone(width: 120, textStyle: titleMedium),
                const SizedBox(height: 2),
                const HomeSkeletonBone(width: 80, textStyle: _labelStyle),
              ],
            ),
          ),
          const SizedBox(width: 12),
          HomeSkeletonBone(width: 56, textStyle: titleMedium),
        ],
      ),
    );
  }
}

/// Row cards for recent documents and recent payments.
class HomeRowCardsSkeleton extends StatelessWidget {
  final int rows;

  const HomeRowCardsSkeleton({super.key, this.rows = 3});

  @override
  Widget build(BuildContext context) {
    return HomeSkeleton(child: _RowCardList(rows: rows));
  }
}

class _RowCardList extends StatelessWidget {
  final int rows;

  const _RowCardList({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < rows; i++) ...[
          if (i > 0) const SizedBox(height: _gap),
          const _RowCardSkeleton(),
        ],
      ],
    );
  }
}

/// Everything under the wallets section title: total balance row, one wallet
/// card, the "recent payments" title and three payment rows.
class HomeWalletsSkeleton extends StatelessWidget {
  const HomeWalletsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final titleMedium = Theme.of(context).textTheme.titleMedium;
    return HomeSkeleton(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _RowCardSkeleton(),
          const SizedBox(height: _gap),
          const HomeSkeletonBone(
            height: _walletFaceHeight,
            radius: _walletFaceRadius,
          ),
          const SizedBox(height: _gap),
          HomeSkeletonBone(width: 140, textStyle: titleMedium),
          const SizedBox(height: _gap),
          const _RowCardList(rows: 3),
        ],
      ),
    );
  }
}
