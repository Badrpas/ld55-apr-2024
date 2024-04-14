package main

import "core:fmt"
import rl "vendor:raylib"

main :: proc () {
    fmt.println("yoba!");

    using rl;

    
    InitWindow(1000, 836, "Bbibola!");
    SetTargetFPS(60);
    SetTraceLogLevel(LOG_WARNING); 

    x :i32= 10

    for ! WindowShouldClose() {
        BeginDrawing();
        defer EndDrawing();
        ClearBackground(BLACK);
        DrawRectangle( x, 10, 100, 100, rl.GREEN)

        x += 10;
    }
}

