<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class KartyaEllenorzes extends Model
{
    use HasFactory;

    protected $table = 'kartya_ellenorzesek';

    protected $fillable = [
        'kartyaszam',
        'kartyatarsasag',
        'ervenyes',
        'luhn_osszeg',
        'elvart_ellenorzo_jegy'
    ];

    protected $casts = [
        'ervenyes' => 'boolean'
    ];
}
