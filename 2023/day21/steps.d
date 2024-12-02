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
    int nsteps = 64;
    if(args.length > 2)
        nsteps = args[2].to!int;
    auto input = readText(args[1]).splitter('\n').filter!(v => !v.empty).array;
    bool[][] a = new bool[][](input.length, input[0].length);
    
    foreach(i; 0 .. input.length)
        foreach(j; 0 .. input[0].length)
            if(input[i][j] == 'S')
                a[i][j] = true;
    bool[][] b = new bool[][](input.length, input[0].length);
    bool get(size_t i, size_t j)
    {
        if(i < b.length && j < b[0].length)
            return b[i][j];
        return false;
    }

    foreach(step; 0 .. nsteps)
    {
        swap(a, b);
        foreach(i; 0 .. input.length)
            foreach(j; 0 .. input[0].length)
            {
                if(input[i][j] == '#')
                    a[i][j] = false;
                else
                    a[i][j] = get(i-1, j) || get(i+1, j) || get(i, j-1) || get(i, j + 1);
            }
    }
    writeln(a.joiner.count(true));
}
