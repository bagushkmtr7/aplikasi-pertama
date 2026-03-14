class PrayerTime {
  final String subuh;
  final String dzuhur;
  final String ashar;
  final String maghrib;
  final String isya;
  final String imsak;

  PrayerTime({
    required this.subuh,
    required this.dzuhur,
    required this.ashar,
    required this.maghrib,
    required this.isya,
    required this.imsak,
  });

  factory PrayerTime.fromJson(Map<String, dynamic> json) {
    return PrayerTime(
      subuh: json['Fajr'],
      dzuhur: json['Dhuhr'],
      ashar: json['Asr'],
      maghrib: json['Maghrib'],
      isya: json['Isha'],
      imsak: json['Imsak'],
    );
  }
}
