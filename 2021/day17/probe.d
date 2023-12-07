import std.stdio;
import std.file : readText;
import std.algorithm;
import std.string;
import std.conv;
import std.range;
import std.array : array;
import std.format;

void run(int x1, int x2, int y1, int y2)
{
    // part 1
    {
        auto vy = -y1-1;
        auto y = 0;
        while(vy >= 0)
        {
            y += vy;
            vy -= 1;
        }
        writeln("part1: ", y);
    }

    // part 2.
    int[][int] ysteps;
    foreach(vys; y1 .. -y1)
    {
        auto vy = vys;
        auto y = 0;
        int steps = 0;
        while(y >= y1)
        {
            y += vy;
            ++steps;
            if(y >= y1 && y <= y2)
                ysteps.require(steps) ~= vys;
            vy -= 1;
        }
    }
    auto maxSteps = ysteps.byKey.maxElement;

    static struct iv{int x, y;}
    bool[iv] good;
    foreach(vxs; 0 .. x2 + 1)
    {
        auto vx = vxs;
        auto x = 0;
        auto steps = 0;
        while(vx != 0)
        {
            x += vx;
            --vx;
            ++steps;
            if(x >= x1 && x <= x2)
            {
                foreach(vy; ysteps.get(steps, null))
                    good[iv(vxs, vy)] = true;
            }
        }
        if(x >= x1 && x <= x2)
            while(steps < maxSteps)
                foreach(vy; ysteps.get(++steps, null))
                    good[iv(vxs, vy)] = true;
    }
    writeln("part2: ", good.length);
}

void main(string[] args)
{
    run(20, 30, -10, -5);
    run(111, 161, -154, -101);
}
