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
    int nice;
    foreach(str; input)
    {
        int vowels = 0;
        string[] forbidden = ["ab", "cd", "pq", "xy"];
        bool hasDouble = false;
        bool hasForbidden = false;
        foreach(i; 0 .. str.length)
        {
            if("aeiou".canFind(str[i]))
                ++vowels;
            if(i + 1 < str.length)
            {
                if(str[i] == str[i+1])
                    hasDouble = true;
                if(forbidden.canFind(str[i .. i + 2]))
                {
                    hasForbidden = true;
                    break;
                }
            }
        }
        //writefln("%s: vowels: %s, hasdouble: %s, hasForbidden: %s", str, vowels, hasDouble, hasForbidden);
        if(vowels >= 3 && hasDouble && !hasForbidden)
            ++nice;
    }
    writeln("part1: ", nice);

    nice = 0;
    foreach(str; input)
    {
        bool hasduppair = false;
        bool hasrepeat = false;
        foreach(i; 0 .. str.length)
        {
            if(i + 3 < str.length)
            {
                if(str[i + 2 .. $].canFind(str[i .. i + 2]))
                    hasduppair = true;
            }
            if(i + 2 < str.length)
            {
                if(str[i] == str[i + 2])
                    hasrepeat = true;
            }
        }
        if(hasduppair && hasrepeat)
            ++nice;
    }
    writeln("part2: ", nice);
}
