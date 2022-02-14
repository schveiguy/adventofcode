import std.stdio;
import std.algorithm;
import std.range;
import std.conv;
import std.array;

void main(string[] args)
{
    int mode = args[1] == "add";
    auto crabs = args[2].splitter(',').map!(to!int).array;
    crabs.sort;
    int best;
    int bestfuel = int.max;
    foreach(i; crabs[0] .. crabs[$-1] + 1)
    {
        auto fuel = crabs
            .map!(v => v > i ? v - i : i - v)
            .map!(v => mode ? (1 + v) * v / 2 : v).sum;
        if(fuel < bestfuel)
        {
            best = i;
            bestfuel = fuel;
        }
    }
    writeln("Best spot is ", best, " for fuel ", bestfuel);
}
