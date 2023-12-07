import std.stdio;
import std.algorithm;
import std.file : readText;
import std.conv;
import std.format;
import std.string;

void main(string[] args)
{
    string input = readText(args[1]);
    auto sp = input.splitter('\n');

    char[][] cs1;
    while(!sp.empty)
    {
        auto l = sp.front;
        sp.popFront;

        auto firstcrate = l.indexOf('[');
        if(firstcrate == -1)
            // the line of crate numbers
            break;
        auto crateidx = 0;
        while(l.length)
        {
            if(l[0] == '[')
            {
                if(cs1.length <= crateidx)
                    cs1.length = crateidx + 1;
                cs1[crateidx] ~= l[1];
                assert(l[2] == ']');
            }
            if(l.length >= 4)
                l = l[4 .. $];
            else
                l = [];
            ++crateidx;
        }
    }
    // reverse all the crates
    foreach(ref c; cs1)
        c.reverse;

    auto cs2 = cs1.dup;
    foreach(l; sp)
    {
        if(l.strip.length == 0)
            continue;
        int n;
        int start;
        int end;
        l.formattedRead("move %d from %d to %d", &n, &start, &end);
        --end;
        --start;
        foreach(i; 0 .. n)
        {
            cs1[end] ~= cs1[start][$-1];
            cs1[start] = cs1[start][0 .. $-1];
        }
        cs2[end] ~= cs2[start][$-n .. $];
        cs2[start] = cs2[start][0 .. $-n];
    }
    write("part1: ");
    foreach(c; cs1)
        write(c[$-1]);
    writeln();
    write("part2: ");
    foreach(c; cs2)
        write(c[$-1]);
    writeln();
}
