class Surah {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String arti;

  Surah({required this.nomor, required this.nama, required this.namaLatin, required this.jumlahAyat, required this.arti});

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      nomor: json['nomor'],
      nama: json['nama'],
      namaLatin: json['namaLatin'],
      jumlahAyat: json['jumlahAyat'],
      arti: json['arti'],
    );
  }
}
