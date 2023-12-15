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

size_t hash(string str)
{
    size_t n = 0;
    foreach(c; str)
    {
        n = ((n + c) * 17) & 0xff;
    }
    return n;
}

void main(string[] args)
{
    auto input = readText(args[1]).splitter('\n').filter!(v => !v.empty).join.split(',');
    size_t total;
    foreach(i; input)
    {
        auto n = hash(i);
        total += n;
    }
    writeln(total);

    static struct Box
    {
        string label;
        int focal;
    }

    Box[][256] hashmap;
    foreach(i; input)
    {
        if(i.indexOf('-') != -1)
        {
            auto label = i.split('-')[0];
            auto bn = hash(label);
            hashmap[bn] = hashmap[bn].remove!(b => b.label == label);
        }
        else
        {
            auto vals = i.split('=');
            auto newval = Box(vals[0], vals[1].to!int);
            auto bn = hash(newval.label);
            auto x = hashmap[bn].find!(b => b.label == newval.label);
            if(x.empty)
                hashmap[bn] ~= newval;
            else
                x[0] = newval;
        }
    }
    size_t focus = 0;
    foreach(i, arr; hashmap)
        foreach(j, b; arr)
        {
            focus += (i + 1) * (j + 1) * b.focal;
        }
    writeln(focus);
}
