# Bankkartyaszam-ellenorzo alkalmazas

## 1. GitHub (barmelyik terminal)

Elso letoltes:

```
git clone https://github.com/benji-prog/bankkartya-projekt.git
cd bankkartya-projekt
```

Frissites (a projekt mappajaban):

```
git pull
```

## 2/A. Backend (szerver mappa) - 1. terminal

```
cd szerver
composer install
copy .env.example .env
php artisan key:generate
php artisan migrate
php artisan tinker
DB::unprepared(file_get_contents('database/bankkartya-minta.sql'));
exit
php artisan serve
```

## 2/B. Frontend (kliens mappa) - 2. terminal

```
cd kliens
npm install
npm run dev
```
