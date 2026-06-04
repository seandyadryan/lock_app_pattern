import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() {
  runApp(const LockAppPatternApp());
}

class LockAppPatternApp extends StatelessWidget {
  const LockAppPatternApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF0E7C7B);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lock App Pattern',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF11151C),
        useMaterial3: true,
      ),
      home: const PatternLockPage(),
    );
  }
}

class PatternLockPage extends StatefulWidget {
  const PatternLockPage({super.key});

  @override
  State<PatternLockPage> createState() => _PatternLockPageState();
}

class _PatternLockPageState extends State<PatternLockPage> {
  static const _minimumPatternLength = 4;

  final List<AppLockItem> _apps = [
    AppLockItem(name: 'WhatsApp', icon: Icons.chat_rounded, locked: true),
    AppLockItem(
      name: 'Galeri',
      icon: Icons.photo_library_rounded,
      locked: true,
    ),
    AppLockItem(name: 'Pengaturan', icon: Icons.settings_rounded),
    AppLockItem(name: 'Mobile Banking', icon: Icons.account_balance_rounded),
    AppLockItem(name: 'Email', icon: Icons.mail_rounded),
  ];

  List<int>? _savedPattern;
  List<int>? _newPattern;
  bool _isUnlocked = false;
  int _failedAttempts = 0;
  String _message = 'Buat pola baru minimal 4 titik.';

  bool get _needsSetup => _savedPattern == null;
  bool get _isConfirmingNewPattern => _needsSetup && _newPattern != null;

  void _clearPattern() {
    setState(() {
      _savedPattern = null;
      _newPattern = null;
      _isUnlocked = false;
      _failedAttempts = 0;
      _message = 'Buat pola baru minimal 4 titik.';
    });
  }

  void _handlePatternComplete(List<int> pattern) {
    if (pattern.length < _minimumPatternLength) {
      setState(() {
        _message = 'Pola terlalu pendek. Gunakan minimal 4 titik.';
      });
      return;
    }

    if (_needsSetup) {
      if (_newPattern == null) {
        setState(() {
          _newPattern = pattern;
          _message = 'Ulangi pola yang sama untuk konfirmasi.';
        });
        return;
      }

      if (_listEquals(_newPattern!, pattern)) {
        setState(() {
          _savedPattern = pattern;
          _newPattern = null;
          _isUnlocked = true;
          _message = 'Pola berhasil dibuat.';
        });
      } else {
        setState(() {
          _newPattern = null;
          _message = 'Konfirmasi tidak cocok. Buat pola lagi.';
        });
      }
      return;
    }

    if (_listEquals(_savedPattern!, pattern)) {
      setState(() {
        _isUnlocked = true;
        _failedAttempts = 0;
        _message = 'Berhasil dibuka.';
      });
    } else {
      setState(() {
        _failedAttempts += 1;
        _message = 'Pola salah. Coba lagi.';
      });
    }
  }

  bool _listEquals(List<int> first, List<int> second) {
    if (first.length != second.length) {
      return false;
    }

    for (var index = 0; index < first.length; index += 1) {
      if (first[index] != second[index]) {
        return false;
      }
    }

    return true;
  }

  void _lockAgain() {
    setState(() {
      _isUnlocked = false;
      _message = 'Gambar pola untuk membuka aplikasi.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _isUnlocked ? _buildDashboard(context) : _buildLockScreen(),
        ),
      ),
    );
  }

  Widget _buildLockScreen() {
    return Padding(
      key: const ValueKey('lock-screen'),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      child: Column(
        children: [
          _Header(
            icon: _needsSetup
                ? Icons.add_moderator_rounded
                : Icons.lock_rounded,
            title: _needsSetup ? 'Buat Kunci Pola' : 'Aplikasi Terkunci',
            subtitle: _message,
          ),
          const Spacer(),
          PatternInput(
            onCompleted: _handlePatternComplete,
            activeColor: _isConfirmingNewPattern
                ? const Color(0xFFFFB703)
                : const Color(0xFF2DD4BF),
          ),
          const Spacer(),
          _StatusStrip(
            text: _needsSetup
                ? 'Pola aktif selama sesi aplikasi berjalan.'
                : 'Percobaan gagal: $_failedAttempts',
            icon: _needsSetup
                ? Icons.verified_user_rounded
                : Icons.warning_amber_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(BuildContext context) {
    final lockedCount = _apps.where((app) => app.locked).length;

    return ListView(
      key: const ValueKey('dashboard'),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      children: [
        _Header(
          icon: Icons.shield_rounded,
          title: 'Lock App Pattern',
          subtitle: '$lockedCount aplikasi ditandai terkunci.',
          trailing: IconButton.filledTonal(
            tooltip: 'Kunci lagi',
            onPressed: _lockAgain,
            icon: const Icon(Icons.lock_outline_rounded),
          ),
        ),
        const SizedBox(height: 18),
        _SummaryPanel(lockedCount: lockedCount, totalCount: _apps.length),
        const SizedBox(height: 18),
        Text(
          'Aplikasi Tambahan',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        for (final app in _apps)
          _AppLockTile(
            app: app,
            onChanged: (value) {
              setState(() {
                app.locked = value;
              });
            },
          ),
        const SizedBox(height: 14),
        FilledButton.icon(
          onPressed: _clearPattern,
          icon: const Icon(Icons.restart_alt_rounded),
          label: const Text('Reset pola'),
        ),
      ],
    );
  }
}

class PatternInput extends StatefulWidget {
  const PatternInput({
    required this.onCompleted,
    required this.activeColor,
    super.key,
  });

  final ValueChanged<List<int>> onCompleted;
  final Color activeColor;

  @override
  State<PatternInput> createState() => _PatternInputState();
}

class _PatternInputState extends State<PatternInput> {
  final List<int> _selected = [];
  Offset? _pointerPosition;
  List<Offset> _dotCenters = [];

  void _handleDrag(Offset globalPosition) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return;
    }

    final localPosition = renderBox.globalToLocal(globalPosition);
    final hitIndex = _hitTestDot(localPosition);

    setState(() {
      _pointerPosition = localPosition;
      if (hitIndex != null && !_selected.contains(hitIndex)) {
        _selected.add(hitIndex);
      }
    });
  }

  void _finishPattern() {
    final completedPattern = List<int>.from(_selected);

    setState(() {
      _selected.clear();
      _pointerPosition = null;
    });

    if (completedPattern.isNotEmpty) {
      widget.onCompleted(completedPattern);
    }
  }

  int? _hitTestDot(Offset position) {
    for (var index = 0; index < _dotCenters.length; index += 1) {
      if ((position - _dotCenters[index]).distance <= 34) {
        return index;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final side = math.min(constraints.maxWidth, 360.0);
        _dotCenters = _calculateDotCenters(side);

        return Center(
          child: GestureDetector(
            onPanStart: (details) => _handleDrag(details.globalPosition),
            onPanUpdate: (details) => _handleDrag(details.globalPosition),
            onPanEnd: (_) => _finishPattern(),
            onPanCancel: _finishPattern,
            child: SizedBox.square(
              dimension: side,
              child: CustomPaint(
                painter: PatternPainter(
                  centers: _dotCenters,
                  selected: _selected,
                  pointerPosition: _pointerPosition,
                  activeColor: widget.activeColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Offset> _calculateDotCenters(double side) {
    final gap = side / 4;
    final centers = <Offset>[];

    for (var row = 1; row <= 3; row += 1) {
      for (var column = 1; column <= 3; column += 1) {
        centers.add(Offset(gap * column, gap * row));
      }
    }

    return centers;
  }
}

class PatternPainter extends CustomPainter {
  PatternPainter({
    required this.centers,
    required this.selected,
    required this.pointerPosition,
    required this.activeColor,
  });

  final List<Offset> centers;
  final List<int> selected;
  final Offset? pointerPosition;
  final Color activeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = activeColor
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 8;
    final inactivePaint = Paint()..color = const Color(0xFF2D3748);
    final selectedPaint = Paint()..color = activeColor;
    final centerPaint = Paint()..color = const Color(0xFFEDF2F7);
    final haloPaint = Paint()..color = activeColor.withValues(alpha: 0.18);

    if (selected.length > 1) {
      final path = Path()
        ..moveTo(centers[selected.first].dx, centers[selected.first].dy);
      for (final index in selected.skip(1)) {
        path.lineTo(centers[index].dx, centers[index].dy);
      }
      canvas.drawPath(path, linePaint);
    }

    if (selected.isNotEmpty && pointerPosition != null) {
      canvas.drawLine(centers[selected.last], pointerPosition!, linePaint);
    }

    for (var index = 0; index < centers.length; index += 1) {
      final isSelected = selected.contains(index);
      final center = centers[index];

      if (isSelected) {
        canvas.drawCircle(center, 32, haloPaint);
      }

      canvas.drawCircle(center, 18, isSelected ? selectedPaint : inactivePaint);
      canvas.drawCircle(center, 6, centerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant PatternPainter oldDelegate) {
    return oldDelegate.selected != selected ||
        oldDelegate.pointerPosition != pointerPosition ||
        oldDelegate.activeColor != activeColor;
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF1F2937),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF2DD4BF)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFFB8C2CC),
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 10), trailing!],
      ],
    );
  }
}

class _StatusStrip extends StatelessWidget {
  const _StatusStrip({required this.text, required this.icon});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2430),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFFFFB703)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _SummaryPanel extends StatelessWidget {
  const _SummaryPanel({required this.lockedCount, required this.totalCount});

  final int lockedCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2430),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.security_rounded,
            color: Color(0xFF2DD4BF),
            size: 34,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$lockedCount dari $totalCount aplikasi aktif',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Fondasi UI untuk memilih aplikasi tambahan yang akan dilindungi.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFFB8C2CC),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AppLockTile extends StatelessWidget {
  const _AppLockTile({required this.app, required this.onChanged});

  final AppLockItem app;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF17202B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: app.locked ? const Color(0xFF2DD4BF) : const Color(0xFF334155),
        ),
      ),
      child: SwitchListTile(
        value: app.locked,
        onChanged: onChanged,
        secondary: Icon(
          app.icon,
          color: app.locked ? const Color(0xFF2DD4BF) : null,
        ),
        title: Text(app.name),
        subtitle: Text(app.locked ? 'Dikunci dengan pola' : 'Tidak dikunci'),
      ),
    );
  }
}

class AppLockItem {
  AppLockItem({required this.name, required this.icon, this.locked = false});

  final String name;
  final IconData icon;
  bool locked;
}
