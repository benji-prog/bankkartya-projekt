<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\KartyaVezerlo;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::post('/ellenorzes', [KartyaVezerlo::class, 'ellenorzes']);
Route::get('/elozmenyek', [KartyaVezerlo::class, 'elozmenyek']);
Route::get('/statisztika', [KartyaVezerlo::class, 'statisztika']);