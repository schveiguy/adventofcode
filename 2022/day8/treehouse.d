import std.stdio;
import std.algorithm;
import std.file : readText;
import std.conv;
import std.format;
import std.string;
import std.range;

void main(string[] args)
{
    auto input = readText(args[1]).strip.split;
    int p1 = 0;
    int p2 = 0;
    immutable long h = input.length;
    immutable long w = input[0].length;
    bool check(R)(char t, R coords)
    {
        foreach(x, y; coords)
        {
            if(input[y][x] >= t)
                return false;
        }
        return true;
    }

    int check2(R)(char t, R coords)
    {
        int result;
        foreach(x, y; coords)
        {
            ++result;
            if(input[y][x] >= t)
                break;
        }
        return result;
    }

    foreach(y; 0 .. h) 
    {
        foreach(x; 0 .. w)
        {
            auto t = input[y][x];

            bool visible = 
                check(t, zip(iota(x), repeat(y))) |
                check(t, zip(iota(x + 1, w), repeat(y))) |
                check(t, zip(repeat(x), iota(y))) |
                check(t, zip(repeat(x), iota(y + 1, h)));

            if(visible)
                ++p1;

            int score = 
                check2(t, zip(iota(x-1, -1, -1), repeat(y))) *
                check2(t, zip(iota(x + 1, w), repeat(y))) *
                check2(t, zip(repeat(x), iota(y-1, -1, -1))) *
                check2(t, zip(repeat(x), iota(y+1, h)));
            p2 = max(p2, score);
        }
    }

    writeln("part1: ", p1);
    writeln("part2: ", p2);
}
