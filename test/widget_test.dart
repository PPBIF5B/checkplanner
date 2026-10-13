import 'package:checkplanner/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Layar selamat datang tampil', (tester) async {
    await tester.pumpWidget(const CheckPlannerApp());

    expect(find.text('CheckPlanner'), findsOneWidget);
    expect(find.text('Masuk dengan Email'), findsOneWidget);
  });

  testWidgets('Tombol masuk membuka layar login', (tester) async {
    await tester.pumpWidget(const CheckPlannerApp());

    await tester.tap(find.text('Masuk dengan Email'));
    await tester.pumpAndSettle();

    expect(find.text('Selamat Datang Kembali'), findsOneWidget);
  });

  testWidgets('Daftar membuka layar registrasi', (tester) async {
    await tester.pumpWidget(const CheckPlannerApp());

    await tester.tap(find.text('Daftar Akun Baru'));
    await tester.pumpAndSettle();

    expect(find.text('Buat Akun Baru'), findsOneWidget);
  });

  testWidgets('Tamu membuka beranda', (tester) async {
    await tester.pumpWidget(const CheckPlannerApp());

    await tester.tap(find.text('Lanjut sebagai tamu'));
    await tester.pumpAndSettle();

    expect(find.text('Halo, Rina!'), findsOneWidget);
    expect(find.text('Progres hari ini'), findsOneWidget);
    expect(find.text('3 dari 7 tugas selesai'), findsOneWidget);
  });
}
