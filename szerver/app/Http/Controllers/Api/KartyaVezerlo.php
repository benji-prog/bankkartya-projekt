<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\KartyaEllenorzes;
use Illuminate\Http\Request;

class KartyaVezerlo extends Controller
{
    public function ellenorzes(Request $request)
    {
        $validated = $request->validate([
            'kartyaszam' => 'required|string|digits:16'
        ], [
            'kartyaszam.required' => 'A kártyaszám megadása kötelező.',
            'kartyaszam.string' => 'A kártyaszámot szövegként kell küldeni.',
            'kartyaszam.digits' => 'A kártyaszám pontosan 16 számjegyből álljon.'
        ]);

        $szam = $validated['kartyaszam'];
        $kartyatarsasag = $this->kartyatarsasag($szam);

        if ($kartyatarsasag === 'American Express') {
            return response()->json(['error' => 'Az American Express kártyaszáma 15 jegyű, ezt az alkalmazás nem kezeli.'], 400);
        }

        $luhnOsszeg = $this->luhnOsszeg($szam);
        $elvartJegy = (10 - $this->luhnOsszeg(substr($szam, 0, 15) . '0') % 10) % 10;

        $maszkolt = substr($szam, 0, 6) . str_repeat('*', 6) . substr($szam, -4);

        $ellenorzes = KartyaEllenorzes::create([
            'kartyaszam' => $maszkolt,
            'kartyatarsasag' => $kartyatarsasag,
            'ervenyes' => $luhnOsszeg % 10 === 0,
            'luhn_osszeg' => $luhnOsszeg,
            'elvart_ellenorzo_jegy' => $elvartJegy
        ]);

        return response()->json($ellenorzes, 201);
    }

    public function elozmenyek()
    {
        $elozmenyek = KartyaEllenorzes::latest('id')->take(10)->get();
        return response()->json($elozmenyek, 200);
    }

    public function statisztika()
    {
        $kartyatarsasagok = KartyaEllenorzes::selectRaw('kartyatarsasag, count(*) as darab')
            ->groupBy('kartyatarsasag')
            ->orderByDesc('darab')
            ->get();

        return response()->json([
            'osszes' => KartyaEllenorzes::count(),
            'helyes' => KartyaEllenorzes::where('ervenyes', true)->count(),
            'kartyatarsasagok' => $kartyatarsasagok
        ], 200);
    }

    private function kartyatarsasag(string $szam): string
    {
        $elso2 = (int) substr($szam, 0, 2);
        $elso4 = (int) substr($szam, 0, 4);

        if ($szam[0] === '4') return 'Visa';
        if (($elso2 >= 51 && $elso2 <= 55) || ($elso4 >= 2221 && $elso4 <= 2720)) return 'MasterCard';
        if ($elso2 === 34 || $elso2 === 37) return 'American Express';
        return 'Egyéb kártyatársaság';
    }

    private function luhnOsszeg(string $szam): int
    {
        $osszeg = 0;
        $hossz = strlen($szam);
        for ($i = 0; $i < $hossz; $i++) {
            $jegy = (int) $szam[$hossz - 1 - $i];
            if ($i % 2 === 1) {
                $jegy *= 2;
                if ($jegy > 9) $jegy -= 9;
            }
            $osszeg += $jegy;
        }
        return $osszeg;
    }
}