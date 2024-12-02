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

void main(string[] args)
{
    auto input = readText(args[1]).splitter('\n').filter!(v => !v.empty).array;
    int[] lefts;
    int[] rights;
    foreach(l; input)
    {
        auto vals = l.split;
        lefts ~= vals[0].to!int;
        rights ~= vals[1].to!int;
    }
    lefts.sort;
    rights.sort;
    int sum = 0;
    foreach(i; 0 .. lefts.length)
    {
        sum += abs(lefts[i] - rights[i]);
    }
    writeln(sum);
    
    // part 2
    int similarity = 0;
    foreach(v; lefts)
    {
        similarity += v * rights.count(v);
    }
    writeln(similarity);
}
