import 'package:flutter_test/flutter_test.dart';
import 'package:lock_app_pattern/main.dart';

void main() {
  testWidgets('shows the pattern setup screen', (tester) async {
    await tester.pumpWidget(const LockAppPatternApp());

    expect(find.text('Buat Kunci Pola'), findsOneWidget);
    expect(find.text('Buat pola baru minimal 4 titik.'), findsOneWidget);
    expect(
      find.text('Pola aktif selama sesi aplikasi berjalan.'),
      findsOneWidget,
    );
  });
}
