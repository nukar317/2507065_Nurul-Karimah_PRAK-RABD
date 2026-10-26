SELECT VERSION() AS versi_mysql;
SELECT CURRENT_USER() AS akun_aktif; 

CREATE DATABASE IF NOT EXISTS praktikum_transaksi;
USE praktikum_transaksi; 
CREATE TABLE IF NOT EXISTS rekening (
	id INT PRIMARY KEY, 
	nama VARCHAR(50) NOT NULL, 
	saldo DECIMAL(12,2) NOT NULL,
	CONSTRAINT chk_saldo_nonnegatif CHECK (saldo >= 0)
) ENGINE=InnoDB;

INSERT INTO rekening (
	id, nama, saldo) VALUES 
	(1, 'Budi', 500000.00), 
	(2, 'Siti', 250000.00);

-- Contoh ilustrasi saja. Jangan jalankan sebagai latihan utama: 
UPDATE rekening SET saldo =  saldo - 100000 WHERE id = 1;
-- Jika aplikasi berhenti di sini, query penambahan saldo Siti belum berjalan.
 UPDATE rekening SET saldo = saldo + 100000 WHERE id = 2;

START TRANSACTION;
UPDATE rekening SET saldo = saldo - 100000.00 WHERE id = 1; 
UPDATE rekening SET saldo = saldo + 100000.00 WHERE id = 2;
SELECT id, nama, saldo FROM rekening ORDER BY id;
COMMIT; 

SELECT id, nama, saldo FROM rekening ORDER BY id;

-- Catat saldo saat ini 
SELECT id, nama, saldo FROM rekening ORDER BY id;
START TRANSACTION;
UPDATE rekening SET saldo = saldo - 50000.00 WHERE id = 1;
SELECT id, nama, saldo FROM rekening ORDER BY id;
ROLLBACK; 
SELECT id, nama, saldo FROM rekening ORDER BY id;

-- saldo awal
SELECT id, nama, saldo FROM rekening ORDER BY id;

START TRANSACTION;

-- Transfer Rp50.000 dari Budi ke Siti
UPDATE rekening
SET saldo = saldo - 50000.00
WHERE id = 1;

UPDATE rekening
SET saldo = saldo + 50000.00
WHERE id = 2;

-- Tandai kondisi setelah transfer utama
SAVEPOINT setelah_transfer;

-- Perubahan tambahan yang ingin dibatalkan
UPDATE rekening
SET saldo = saldo - 10000.00
WHERE id = 1;

-- Batalkan hanya perubahan setelah savepoint
ROLLBACK TO SAVEPOINT setelah_transfer;

-- Simpan transfer utama
COMMIT;  

-- saldo akhir
SELECT id, nama, saldo
FROM rekening
ORDER BY id;

-- saldo awal
SELECT id, nama, saldo FROM rekening ORDER BY id;

START TRANSACTION;

-- Operasi awal
UPDATE rekening SET saldo = saldo - 20000 WHERE id = 1;
SAVEPOINT sp_awal;

-- Operasi tahap kedua
UPDATE rekening SET saldo = saldo + 20000 WHERE id = 2;
SAVEPOINT sp_kedua;

-- Operasi opsional
UPDATE rekening SET saldo = saldo - 5000 WHERE id = 1;

-- Batalkan hanya operasi setelah sp_kedua
ROLLBACK TO SAVEPOINT sp_kedua;

-- Hapus penanda yang tidak diperlukan
RELEASE SAVEPOINT sp_kedua;
COMMIT; 

-- saldo akhir
SELECT id, nama, saldo FROM rekening ORDER BY id;

SELECT DATABASE() AS database_aktif;
SELECT CURRENT_USER() AS akun_aktif;
SHOW TABLE STATUS LIKE 'rekening';
SELECT id, nama, saldo FROM rekening ORDER BY id;
