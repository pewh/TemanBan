<?php

class UsersTableSeeder extends Seeder {
    
    public function run() {
        DB::table('users')->delete();

        $users = [
            'username' => 'admin',
            'password' => Hash::make('admin'),
            'created_at' => new DateTime,
            'updated_at' => new DateTime,
            'role' => 1
        ];

        DB::table('users')->insert($users);
    }
}
