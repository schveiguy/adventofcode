import std.stdio;
import std.file : readText;
import std.algorithm;
import std.range;
import std.conv;
import std.string;
import std.format;
import std.ascii;
import std.traits;

struct Vec
{
    long x;
    long y;

    Vec opBinary(string op : "+")(Vec o) => Vec(x + o.x, y + o.y);
    Vec opUnary(string op : "-")() => Vec(-x, -y);
    Vec left() => Vec(y, -x);
    Vec right() => Vec(-y, x);
}

void main(string[] args)
{
    auto input = readText(args[1]).splitter('\n').filter!(v => !v.empty).map!(v => v.dup).array;
    bool occupied(int x, int y) {
        if (x < 0 || x >= input[0].length || y < 0 || y >= input.length)
            return false;
        return input[y][x] == '@';
    }

    int n;
    foreach(int y; 0 .. input.length.to!int)
        foreach(int x; 0 .. input[0].length.to!int) {
            if(!occupied(x, y)) continue;
            int o = -1; // always occupied at the current location
            foreach(dx; -1 .. 2)
                foreach(dy; -1 .. 2)
                    o += occupied(x + dx, y + dy);
            n += o < 4;
        }
    writeln(i"part1: $(n)");

    n = 0;
    while(true)
    {
        int r = 0;
        foreach(int y; 0 .. input.length.to!int)
            foreach(int x; 0 .. input[0].length.to!int) {
                if(!occupied(x, y)) continue;
                int o = -1; // always occupied at the current location
                foreach(dx; -1 .. 2)
                    foreach(dy; -1 .. 2)
                        o += occupied(x + dx, y + dy);
                if (o < 4) {
                    ++r;
                    input[y][x] = '.'; // rmeoved
                }
            }
        if(r == 0) break;
        n += r;
    }

    writeln(i"part2: $(n)");
}
