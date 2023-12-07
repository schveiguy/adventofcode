import std.stdio;
import std.file : readText;
import std.algorithm;
import std.string;
import std.conv;
import std.range;
import std.array : array;
import std.format;

void main(string[] args)
{
    auto input = readText(args[1]).strip.split('\n');

    char[char[2]] rules;
    foreach(r; input[2 .. $])
    {
        string a;
        char b;
        r.formattedRead("%s -> %c", &a, &b);
        char[2] p = a;
        rules[p] = b;
    }

    long[char[2]] polymer;
    long[char] freq;
    foreach(i; 0 .. input[0].length)
    {
        ++freq[input[0][i]];
        if(i + 1 < input[0].length)
        {
            char[2] p = input[0][i .. i + 2];
            ++polymer.require(p, 0);
        }
    }

    void display(string msg)
    {
        // writeln("freq: ", freq);
        auto p1 = freq.values.sort;
        writeln(msg, p1[$-1] - p1[0]);
    }
    foreach(iter; 0 .. 40)
    {
        if(iter == 10)
            display("part1: ");
        long[char[2]] newpolymer;
        foreach(k, v; polymer)
        {
            if(auto c = k in rules)
            {
                freq.require(*c, 0) += v;
                char[2] p1 = [k[0], *c];
                char[2] p2 = [*c, k[1]];
                newpolymer.require(p1, 0) += v;
                newpolymer.require(p2, 0) += v;
            }
        }
        polymer = newpolymer;
    }
    display("part2: ");
}
