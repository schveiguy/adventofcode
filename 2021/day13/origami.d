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
    auto input = readText(args[1]).strip;
    static struct pt { int x, y; }
    bool[pt] dots;
    bool pt1done = false;
    foreach(ln; input.splitter('\n'))
    {
        if(ln.strip.length == 0)
            continue;
        if(ln.startsWith("fold along "))
        {
            char xory;
            int coord;
            ln.formattedRead("fold along %c=%d", &xory, &coord);
            foreach(k; dots.keys)
            {
                if(xory == 'x')
                {
                    if(k.x > coord)
                    {
                        dots[pt(coord - (k.x - coord), k.y)] = true;
                        dots.remove(k);
                    }
                }
                else
                {
                    if(k.y > coord)
                    {
                        dots[pt(k.x, coord - (k.y - coord))] = true;
                        dots.remove(k);
                    }
                }
            }
            if(!pt1done)
            {
                pt1done = true;
                writeln("part1: ", dots.length);
            }
        }
        else
        {
            int x, y;
            ln.formattedRead("%s,%s", &x, &y);
            dots[pt(x, y)] = true;
        }
    }

    // find the max x and max y
    int maxx, maxy;
    foreach(k; dots.byKey)
    {
        maxx = max(maxx, k.x);
        maxy = max(maxy, k.y);
    }

    writeln("part2:");
    foreach(y; 0 .. maxy+1)
    {
        foreach(x; 0 .. maxx+1)
        {
            if(pt(x, y) in dots)
                write('#');
            else
                write(' ');
        }
        writeln;
    }
}
