import std.stdio;
import std.algorithm;
import std.file : readText;
import std.conv;
import std.format;
import std.string;

void main(string[] args)
{
    auto input = readText(args[1]).strip;
    int p1 = 0;
    int p2 = 0;
    foreach(l; input.splitter)
    {
        int r1, r2, r3, r4;
        formattedRead(l, "%s-%s,%s-%s", &r1, &r2, &r3, &r4);
        if(r1 >= r3 && r2 <= r4 ||
           r3 >= r1 && r4 <= r2)
            ++p1;
        if(r2 >= r3 && r1 <= r4)
            ++p2;
    }
    writeln("part1: ", p1);
    writeln("part2: ", p2);
}
