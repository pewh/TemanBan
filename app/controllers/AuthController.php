<?php

class AuthController extends BaseController {
    public function login() {
        $credentials = [
            'username' => Input::json('username'),
            'password' => Input::json('password')
        ];

        if ( Auth::attempt($credentials) ) {
            return Response::json(Auth::user());
        } else {
            return Response::json(['flash' => 'Username atau password salah'], 500);
        }
    }

    public function logout() {
        Auth::logout();
            return Response::json(['flash' => 'Log out']);
    }
}

