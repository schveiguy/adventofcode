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
    bool[] beam = input[0].map!(c => c == 'S').array;
    int hits;
    foreach(lnum, line; input[1 .. $])
    {
        bool[] next = new bool[beam.length];
        foreach(i; 0 .. beam.length)
            if(line[i] == '^' && beam[i])
            {
                next[i-1] = true;
                next[i+1] = true;
                ++hits;
                //writeln(i"hit on line $(lnum) on column $(i)");
            }
            else
            {
                next[i] = next[i] || beam[i];
            }
        beam = next;
        //writeln(beam.map!(b => b ? '|' : '.'));
    }
    writeln(i"part1: $(hits)");

    long[] beamp2 = input[0].map!(c => long(c == 'S')).array;
    foreach(lnum, line; input[1 .. $])
    {
        long[] next = new long[beamp2.length];
        foreach(i; 0 .. beamp2.length)
            if(line[i] == '^' && beamp2[i])
            {
                next[i - 1] += beamp2[i];
                next[i + 1] += beamp2[i];
            }
            else
            {
                next[i] += beamp2[i];
            }
        beamp2 = next;
    }
    writeln(i"part2: $(beamp2.sum)");
}
