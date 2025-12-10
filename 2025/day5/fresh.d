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
    long[][] freshranges;
    long[] ids;
    foreach(i; input) {
        auto terms = i.split('-');
        if(terms.length == 2)
            freshranges ~= terms.map!(v => v.to!long).array;
        else
            ids ~= terms[0].to!long;
    }

    long nfresh = 0;
    foreach(id; ids)
        foreach(r; freshranges)
            if(id >= r[0] && id <= r[1]) {
                nfresh++;
                break;
            }
    writeln(i"part1: $(nfresh)");

    // merge all the ranges
    long[][] mergedranges;
    freshranges.sort!((r1, r2) => r1[0] < r2[0]);
    mergedranges ~= freshranges[0];
    foreach(r; freshranges[1 .. $]) {
        auto mr = mergedranges[$-1];
        if(r[0] >= mr[0] && r[0] <= mr[1])
            mr[1] = max(mr[1], r[1]);
        else
            mergedranges ~= r;
    }
    nfresh = 0;
    foreach(r; mergedranges)
        nfresh += r[1] - r[0] + 1;
    writeln(i"part2: $(nfresh)");
}
