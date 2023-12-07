import std.stdio;
import std.file : readText;
import std.algorithm;
import std.range;
import std.conv;
import std.string;
import std.format;
import std.ascii;

void main(string[] args)
{
    auto input = readText(args[1]).splitter('\n').filter!(v => !v.empty).array;
    auto times = input[0].find(" ").splitter.map!(to!int).array;
    auto dist = input[1].find(" ").splitter.map!(to!int).array;
    long part1 = 1;
    foreach(i; 0 .. times.length)
    {
        int n = 0;
        foreach(j; 1 .. times[i])
        {
            if(j * (times[i] - j) > dist[i])
                ++n;
        }
        //writeln(n);
        part1 *= n;
    }
    writeln(part1);

    auto time2 = input[0].find(" ").splitter.joiner.to!long;
    auto dist2 = input[1].find(" ").splitter.joiner.to!long;
    //writeln(time2, " ", dist2);

    long getDist(long ms) => ms * (time2 - ms);

    // the graph for this function y = x * (N - x) where N is a constant, is a
    // parabola, with the maximum at N / 2
    // so we do a binary search from 0 to N / 2, and from N / 2 to N to find
    // where the values are larger than the record.

    long min = 0;
    long max = time2 / 2;
    while(min + 1 < max)
    {
        auto x = (min + max) / 2;
        if(getDist(x) <= dist2)
            // higher
            min = x;
        else
            // lower
            max = x;
    }
    long low = getDist(min) > dist2 ? min : max;

    min = time2 / 2;
    max = time2;
    while(min + 1 < max)
    {
        auto x = (min + max) / 2;
        if(getDist(x) <= dist2)
            // lower
            max = x;
        else
            // higher
            min = x;
    }
    long high = getDist(max) > dist2 ? max : min;
    //writeln(low, " ", high);
    writeln(high + 1 - low);
}
