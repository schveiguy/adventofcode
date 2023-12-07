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
    auto input = readText(args[1]).split('\n');
    while(input[$-1].length == 0)
        input.popBack;
    int total;
    int[] counts = new int[input.length];
    counts[] = 1;
    foreach(i, line; input)
    {
        auto carddata = line[line.indexOf(':') + 1 .. $].split('|').map!(s => s.split.map!(to!int).array).array;
        bool[int] numbers;
        foreach(v; carddata[1])
            numbers[v] = true;
        int wn = 0;
        foreach(v; carddata[0])
            if(v in numbers)
                ++wn;
        if(wn > 0)
        {
            total += 1 << (wn - 1);
            foreach(n; i + 1 .. i + 1 + wn)
            {
                if(n < counts.length)
                    counts[n] += counts[i];
            }
        }
    }
    writeln(total);
    writeln(sum(counts));
}
