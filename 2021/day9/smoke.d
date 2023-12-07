import std.stdio;
import std.file : readText;
import std.algorithm;
import std.string;
import std.conv;
import std.range;
import std.array : array;

void main(string[] args)
{
    auto input = readText(args[1]).strip.split;
    int get(size_t i, size_t j)
    {
        if(i >= input.length || j >= input[i].length)
            return '9' + 10;
        return input[i][j];
    }

    int p1 = 0;
    static immutable df = [-1, 1, 0, 0];
    foreach(i; 0 .. input.length)
    {
        foreach(j; 0 .. input[i].length)
        {
            bool low = true;
            foreach(d; 0 .. 4)
                if(get(i + df[d], j + df[3-d]) <= input[i][j])
                {
                    low = false;
                    break;
                }

            if(low)  p1 += input[i][j] - '0' + 1;
        }
    }
    writeln("part1: ", p1);
    bool[][] basins = new bool[][](input.length, input[0].length);
    int findbasin(size_t i, size_t j)
    {
        auto v = get(i, j);
        if(v >= '9') return 0;
        if(basins[i][j]) return 0;
        basins[i][j] = true;
        int result = 1;
        foreach(d; 0 .. 4)
            result += findbasin(i + df[d], j + df[3-d]);
        return result;
    }
    auto p2 = [0, 0, 0, 0];
    foreach(i; 0 .. input.length)
        foreach(j; 0 .. input[0].length)
        {
            auto b = findbasin(i, j);
            if(b != 0)
            {
                p2[0] = b;
                p2.sort;
            }
        }
    writeln("part2: ", p2[1] * p2[2] * p2[3]);
}
