program SistemPemesananHotel;

uses crt;

const
  MAX_ROOMS = 100;

type
  TReservasi = record
    id: integer;
    nama: string;
    kamar: integer;
    hari: integer;
  end;

var
  reservasi: array[1..MAX_ROOMS] of TReservasi;
  totalReservasi: integer;
  fileReservasi: text;

procedure TampilkanKamarTersedia;
var
  i: integer;
begin
  writeln('Daftar Kamar yang Tersedia:');
  for i := 1 to MAX_ROOMS do
    if reservasi[i].kamar = 0 then
      writeln('Kamar ', i, ' tersedia.');
end;

procedure SimpanDataKeFile;
var
  i: integer;
begin
  assign(fileReservasi, 'reservasi.txt');
  rewrite(fileReservasi);
  for i := 1 to totalReservasi do
    writeln(fileReservasi, reservasi[i].id, ' ', reservasi[i].nama, ' ', reservasi[i].kamar, ' ', reservasi[i].hari);
  close(fileReservasi);
end;

procedure MuatDataDariFile;
var
  i: integer;
begin
  assign(fileReservasi, 'reservasi.txt');
  reset(fileReservasi);
  i := 0;
  while not eof(fileReservasi) do
  begin
    inc(i);
    readln(fileReservasi, reservasi[i].id, reservasi[i].nama, reservasi[i].kamar, reservasi[i].hari);
  end;
  totalReservasi := i;
  close(fileReservasi);
end;

function CariKamar(kamar: integer): integer;
begin
  if kamar > MAX_ROOMS then
    CariKamar := -1
  else if reservasi[kamar].kamar = 0 then
    CariKamar := kamar
  else
    CariKamar := CariKamar(kamar + 1);
end;

procedure PesanKamar;
var
  kamar: integer;
  nama: string;
  hari: integer;
  kamarTersedia: integer;
begin
  write('Masukkan nama pemesan: '); readln(nama);
  write('Berapa hari menginap: '); readln(hari);
  kamarTersedia := CariKamar(1);
  if kamarTersedia = -1 then
    writeln('Maaf, tidak ada kamar yang tersedia.')
  else
  begin
    totalReservasi := totalReservasi + 1;
    reservasi[totalReservasi].id := totalReservasi;
    reservasi[totalReservasi].nama := nama;
    reservasi[totalReservasi].kamar := kamarTersedia;
    reservasi[totalReservasi].hari := hari;
    writeln('Kamar ', kamarTersedia, ' telah dipesan.');
  end;
  SimpanDataKeFile;
end;

procedure TampilkanReservasi;
var
  i: integer;
begin
  writeln('Daftar Reservasi:');
  for i := 1 to totalReservasi do
    writeln('ID: ', reservasi[i].id, ' Nama: ', reservasi[i].nama, ' Kamar: ', reservasi[i].kamar, ' Hari: ', reservasi[i].hari);
end;

procedure Menu;
var
  pilihan: integer;
begin
  repeat
    writeln('Menu:');
    writeln('1. Tampilkan Kamar Tersedia');
    writeln('2. Pesan Kamar');
    writeln('3. Tampilkan Reservasi');
    writeln('0. Keluar');
    write('Pilihan: '); readln(pilihan);

    case pilihan of
      1: TampilkanKamarTersedia;
      2: PesanKamar;
      3: TampilkanReservasi;
    end;
  until pilihan = 0;
end;

begin
  clrscr;
  totalReservasi := 0;
  MuatDataDariFile;
  Menu;
end.
