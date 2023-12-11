import std.stdio;
import std.file : readText;
import std.algorithm;
import std.range;
import std.conv;
import std.string;
import std.format;
import std.ascii;
import std.math;
import std.traits;

struct Vec
{
    long x;
    long y;

    Vec opBinary(string op : "+")(Vec o) => Vec(x + o.x, y + o.y);
    Vec opBinary(string op : "-")(Vec o) => Vec(x - o.x, y - o.y);
    Vec opBinary(string op : "*")(long o) => Vec(x * o, y * o);
    Vec opUnary(string op : "-")() => Vec(-x, -y);
    Vec left() => Vec(y, -x);
    Vec right() => Vec(-y, x);
    long length() => abs(x) + abs(y);
}

void main(string[] args)
{
    auto input = readText(args[1]).splitter('\n').filter!(v => !v.empty).array;
    auto scale = args[2].to!long;

    bool[] missingx = repeat(true, input[0].length).array;
    bool[] missingy = repeat(true, input.length).array;
    foreach(y, ln; input)
    {
        foreach(x, c; ln)
        {
            if(c == '#')
            {
                missingy[y] = false;
                missingx[x] = false;
            }
        }
    }

    // now, create the map
    Vec[] map;
    Vec offset;
    foreach(y, ln; input)
    {
        if(missingy[y]) offset.y += scale - 1;
        offset.x = 0;
        foreach(x, c; ln)
        {
            if(missingx[x]) offset.x += scale - 1;
            if(c == '#')
            {
                map ~= Vec(x, y) + offset;
            }
        }
    }
    long total = 0;
    foreach(i, beg; map)
        foreach(end; map[i + 1 .. $])
        {
            total += (end - beg).length;
        }
    writeln(total);
}
