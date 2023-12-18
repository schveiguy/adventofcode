import std.stdio;
import raylib;

import std.file : readText;
import std.algorithm;
import std.range;
import std.conv;
import std.string;
import std.format;
import std.ascii;
import std.math;
import std.traits;

void main()
{
	InitWindow(1000, 1000, "visual");
	SetTargetFPS(10);
	auto input = readText("../puzzleinput.txt").splitter('\n').filter!(v => !v.empty).array;
	static struct Line
	{
		Vector2 start;
		Vector2 end;
	}
	enum Dir : Vector2 {
		U = Vector2(0, -1),
		D = Vector2(0, 1),
		L = Vector2(-1, 0),
		R = Vector2(1, 0)
	}

	Vector2 pos = Vector2(0, 0);
	Line[] lines;
	Vector2 minpos = pos;
	Vector2 maxpos = pos;
	foreach(inst; input)
	{
            Dir newdir;
            int cnt;
            int color;
            inst.formattedRead("%s %s (#%x)", newdir, cnt, color);
			lines ~= Line(pos, pos + newdir * cnt);
			pos = lines[$-1].end;
			minpos.x = min(minpos.x, pos.x);
			minpos.y = min(minpos.y, pos.y);
			maxpos.x = max(maxpos.x, pos.x);
			maxpos.y = max(maxpos.y, pos.y);
	}

	minpos -= Vector2(10, 10);
	maxpos += Vector2(10, 10);
	writeln(maxpos);
	auto extents = maxpos - minpos;
	writeln(extents);
	float scale = GetScreenWidth() / max(extents.x, extents.y);
	writeln(scale);
	Vector2 offset = Vector2(0, 0);
	while(!WindowShouldClose())
	{
		if(IsMouseButtonPressed(MouseButton.MOUSE_BUTTON_LEFT))
		{
			offset -= (GetMousePosition() - Vector2(GetScreenWidth() / 2, GetScreenHeight() / 2)) / scale;
		}
		if(IsKeyPressed(KeyboardKey.KEY_KP_ADD))
		{
			scale *= 1.5;
		}
		if(IsKeyPressed(KeyboardKey.KEY_KP_SUBTRACT))
		{
			scale /= 1.5;
		}
		BeginDrawing();
		ClearBackground(Colors.WHITE);
		rlPushMatrix();
		scope(exit) rlPopMatrix();
		rlScalef(scale, scale, 1);
		Vector2 translation = offset - minpos;
		rlTranslatef(translation.x, translation.y, 0);
		foreach(y; minpos.y .. maxpos.y)
		{
			DrawLineEx(Vector2(minpos.x, y), Vector2(maxpos.x, y), 1 / scale,  ColorAlpha(Colors.GRAY, 0.5));
		}
		foreach(x; minpos.x .. maxpos.x)
		{
			DrawLineEx(Vector2(x, minpos.y), Vector2(x, maxpos.y), 1 / scale,  ColorAlpha(Colors.GRAY, 0.5));
		}
		foreach(l; lines)
		{
			DrawLineEx(l.start, l.end, 2 / scale, Colors.BLACK);
		}
		DrawCircleV(Vector2(0, 0), 3 / scale, Colors.RED);
		EndDrawing();
	}
}
