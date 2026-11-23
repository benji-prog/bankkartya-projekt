-- ============================================================================
-- Bankkártyaszám-ellenőrző alkalmazás: minta SQLite-adatbázis
-- (tábla + 20 mintasor, a feladatlap B2. lépéséhez)
-- ============================================================================
--
-- MIT CSINÁL?
--   1. Létrehozza a kartya_ellenorzesek táblát, ha még nincs meg. A szerkezet
--      karakterre megegyezik azzal, amit a feladatlap migrációja hoz létre.
--   2. Beszúr 20 ellenőrzést (helyes és hibás számok, Visa, MasterCard és egyéb).
--
-- A SZÁMOKRÓL
--   Mind nyilvános TESZT-kártyaszám (fizetési szolgáltatók dokumentációiból),
--   illetve ezek szándékosan elrontott változata. Valódi kártyaszámot soha ne
--   írjon be az alkalmazásba!
--
-- BETÖLTÉS (válasszon egyet; a szerver/ mappában állva):
--   a) Laravel tinkerrel (minden gépen működik, külön program nélkül):
--        php artisan tinker
--        DB::unprepared(file_get_contents('database/bankkartya-minta.sql'));
--        exit
--      (Előtte másolja ezt a fájlt a szerver/database/ mappába.)
--   b) sqlite3 parancssorral (ha telepítve van):
--        sqlite3 database/database.sqlite < database/bankkartya-minta.sql
--   c) DB Browser for SQLite vagy a VS Code SQLite-bővítménye:
--        nyissa meg a database/database.sqlite fájlt, és futtassa le ezt a fájlt.
--
-- SORREND
--   A szokásos út: előbb  php artisan migrate,  utána ez a fájl (a CREATE TABLE
--   ilyenkor nem csinál semmit, csak a sorok kerülnek be).
--   Vészkijárat: ha a migráció nem sikerül, ez a fájl a táblát is létrehozza,
--   így a többi feladaton tovább lehet dolgozni. Ilyenkor a migrációt később
--   a  php artisan migrate:fresh  paranccsal futtassa (ez MINDEN táblát töröl
--   és újra létrehoz), majd töltse be újra ezt a fájlt.
--
-- ÚJRATÖLTÉS
--   Kétszeri betöltéskor a sorok kétszer kerülnek be. Előtte üríthet:
--     DELETE FROM kartya_ellenorzesek;
-- ============================================================================

CREATE TABLE IF NOT EXISTS "kartya_ellenorzesek" (
  "id" integer primary key autoincrement not null,
  "kartyaszam" varchar not null,
  "kartyatarsasag" varchar not null,
  "ervenyes" tinyint(1) not null,
  "luhn_osszeg" integer not null,
  "elvart_ellenorzo_jegy" integer not null,
  "created_at" datetime,
  "updated_at" datetime
);

INSERT INTO kartya_ellenorzesek
  (kartyaszam, kartyatarsasag, ervenyes, luhn_osszeg, elvart_ellenorzo_jegy, created_at, updated_at)
VALUES
('4111111111111111', 'Visa', 1, 30, 1, '2026-11-02 08:00:00', '2026-11-02 08:00:00'),
('5555555555554444', 'MasterCard', 1, 60, 4, '2026-11-02 08:07:00', '2026-11-02 08:07:00'),
('4539148803436462', 'Visa', 0, 75, 7, '2026-11-02 08:14:00', '2026-11-02 08:14:00'),
('4242424242424242', 'Visa', 1, 80, 2, '2026-11-02 08:21:00', '2026-11-02 08:21:00'),
('2223003122003222', 'MasterCard', 1, 40, 2, '2026-11-02 08:28:00', '2026-11-02 08:28:00'),
('4111111111111112', 'Visa', 0, 31, 1, '2026-11-02 08:35:00', '2026-11-02 08:35:00'),
('5105105105105100', 'MasterCard', 1, 20, 0, '2026-11-02 08:42:00', '2026-11-02 08:42:00'),
('6011111111111117', 'Egyéb kártyatársaság', 1, 30, 7, '2026-11-02 08:49:00', '2026-11-02 08:49:00'),
('4012888888881881', 'Visa', 1, 90, 1, '2026-11-02 08:56:00', '2026-11-02 08:56:00'),
('5555555555554443', 'MasterCard', 0, 59, 4, '2026-11-02 09:03:00', '2026-11-02 09:03:00'),
('5200828282828210', 'MasterCard', 1, 50, 0, '2026-11-02 09:10:00', '2026-11-02 09:10:00'),
('2223003122003223', 'MasterCard', 0, 41, 2, '2026-11-02 09:17:00', '2026-11-02 09:17:00'),
('4000056655665556', 'Visa', 1, 50, 6, '2026-11-02 09:24:00', '2026-11-02 09:24:00'),
('3566002020360505', 'Egyéb kártyatársaság', 1, 50, 5, '2026-11-02 09:31:00', '2026-11-02 09:31:00'),
('4242424242424241', 'Visa', 0, 79, 2, '2026-11-02 09:38:00', '2026-11-02 09:38:00'),
('5454545454545454', 'MasterCard', 1, 40, 4, '2026-11-02 09:45:00', '2026-11-02 09:45:00'),
('6011111111111118', 'Egyéb kártyatársaság', 0, 31, 7, '2026-11-02 09:52:00', '2026-11-02 09:52:00'),
('2223000048400011', 'MasterCard', 1, 40, 1, '2026-11-02 09:59:00', '2026-11-02 09:59:00'),
('5105105105105109', 'MasterCard', 0, 29, 0, '2026-11-02 10:06:00', '2026-11-02 10:06:00'),
('4539148803436467', 'Visa', 1, 80, 7, '2026-11-02 10:13:00', '2026-11-02 10:13:00');
