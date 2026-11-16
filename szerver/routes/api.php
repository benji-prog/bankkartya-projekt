<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

use App\Http\Controllers\Api\KartyaVezerlo;
Route::post('/ellenorzes', [KartyaVezerlo::class, 'ellenoriz']);
Route::get('/elozmenyek', [KartyaVezerlo::class, 'elozmenyek']);