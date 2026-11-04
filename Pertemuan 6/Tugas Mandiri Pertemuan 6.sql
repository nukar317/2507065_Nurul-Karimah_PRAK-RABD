USE perpustakaan;

-- Soal 1: v_buku
CREATE VIEW v_buku AS
SELECT b.id_buku AS kode_buku,
       b.judul_buku,
       b.penerbit_buku AS penerbit,
       p.nama_penulis AS penulis,
       p.email
FROM Buku b
JOIN Penulis p ON b.id_penulis = p.id_penulis;

-- Soal 2: v_pinjam
CREATE VIEW v_pinjam AS
SELECT a.nama_anggota AS nama_peminjam,
       pm.tanggal_peminjaman,
       b.judul_buku
FROM Peminjaman pm
JOIN Anggota a ON pm.id_anggota = a.id_anggota
JOIN Detail_Peminjaman dp ON pm.id_peminjaman = dp.id_peminjaman
JOIN Buku b ON dp.id_buku = b.id_buku;

-- Soal 3: v_detail
CREATE VIEW v_detail AS
SELECT p.nama_penulis,
       SUM(db.jumlah_buku) AS total_buku
FROM Penulis p
JOIN Buku b ON p.id_penulis = b.id_penulis
JOIN Detail_Buku db ON b.id_buku = db.id_buku
GROUP BY p.id_penulis, p.nama_penulis;

-- Soal 4: Pendapatan per tanggal
CREATE VIEW v_pendapatan AS
SELECT pm.tanggal_peminjaman,
       SUM(db.harga_sewa) AS jumlah_pendapatan
FROM Peminjaman pm
JOIN Detail_Peminjaman dp ON pm.id_peminjaman = dp.id_peminjaman
JOIN Detail_Buku db ON dp.id_buku = db.id_buku
GROUP BY pm.tanggal_peminjaman;

-- Soal 5: Stok buku per tahun terbit
CREATE VIEW v_stok_tahun AS
SELECT b.tahun_terbit,
       SUM(db.jumlah_buku) AS total_buku
FROM Buku b
JOIN Detail_Buku db ON b.id_buku = db.id_buku
WHERE b.tahun_terbit IN (2013, 2014, 2015)
GROUP BY b.tahun_terbit;

-- Soal 6: Data peminjaman lengkap
CREATE VIEW v_peminjaman_lengkap AS
SELECT pm.id_peminjaman AS id_pinjam,
       pm.tanggal_peminjaman AS tgl_pinjam,
       a.nama_anggota AS peminjam,
       CONCAT(a.alamat_anggota, ', ', a.kota_anggota) AS alamat,
       a.telp_anggota AS telp
FROM Peminjaman pm
JOIN Anggota a ON pm.id_anggota = a.id_anggota;

-- Soal 7: Demografi anggota per kota
CREATE VIEW v_demografi_kota AS
SELECT kota_anggota,
       COUNT(*) AS jumlah_anggota
FROM Anggota
GROUP BY kota_anggota;

SELECT * FROM v_buku;
SELECT * FROM v_pinjam;
SELECT * FROM v_detail;
SELECT * FROM v_pendapatan;
SELECT * FROM v_stok_tahun;
SELECT * FROM v_peminjaman_lengkap;
SELECT * FROM v_demografi_kota;