import std.stdio;
import std.file : readText;
import std.algorithm;
import std.range;
import std.conv;
import std.string;
import std.format;
import std.ascii;
import std.traits;

void main(string[] args)
{
    auto input = readText(args[1]).splitter('\n').filter!(v => !v.empty).array;
    int cur = 50;
    int pw = 0;
    foreach(v; input) {
        cur = ((cur + (v[0] == 'L' ? -1 : 1) * v[1 .. $].to!int) % 100 + 100) % 100;
        pw += cur == 0;
    }
    writeln(i"part1: $(pw)");

    cur = 50;
    pw = 0;
    foreach(v; input) {
        auto dir = v[0] == 'L' ? 99 : 1;
        auto left = v[1 .. $].to!int;
        while(left > 0)
        {
            cur = (cur + dir) % 100;
            --left;
            pw += cur == 0;
        }
    }
    writeln(i"part2: $(pw)");
}
