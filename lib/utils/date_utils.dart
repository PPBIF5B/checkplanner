const _hari = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
const _bulan = [
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];

String namaHari(DateTime d) => _hari[d.weekday - 1];
String namaBulan(DateTime d) => _bulan[d.month - 1];

/// Contoh: "Rabu, 14 Oktober 2026"
String formatTanggal(DateTime d) =>
    '${namaHari(d)}, ${d.day} ${namaBulan(d)} ${d.year}';

/// Contoh: "23.59"
String formatJam(DateTime d) =>
    '${d.hour.toString().padLeft(2, '0')}.${d.minute.toString().padLeft(2, '0')}';

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
