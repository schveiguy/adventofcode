import std.stdio;
import std.algorithm;
import std.file : readText;
import std.conv;
import std.format;
import std.string;
import std.range;
import std.array;
import std.math;

void main(string[] args)
{
    auto input = readText(args[1]).strip.splitter.map!(v => v.to!long).array;
    void moveItem(size_t[] arr, long i, long dist)
    {
        auto target = (i + dist) % cast(long)(arr.length - 1);
        if(target < 0)
            target += (arr.length - 1);
        if(target == 0 && i + 1 == arr.length)
            // don't need to move it to the front
            return;

        // move the memory
        auto cur = arr[i];
        import core.stdc.string : memmove;
        if(target < i)
            memmove(&arr[target+1], &arr[target], (i - target) * size_t.sizeof);
        else if(target > i)
            memmove(&arr[i], &arr[i+1], (target - i) * size_t.sizeof);
        arr[target] = cur;
        //auto offset = target < i ? -1 : 1;
        /*foreach(idx; iota(i, target, offset))
        {
            swap(arr[idx], arr[idx + offset]);
        }*/
    }
    auto idxs = iota(input.length).array;
    void mix(long key)
    {
        foreach(i; 0 .. input.length)
        {
            auto realidx = idxs.countUntil(i);
            moveItem(idxs, realidx, key * input[i]);
            //writeln(idxs.map!(v => input[v]));
        }
    }

    mix(1);
    void printgrove(string part, long key)
    {
        auto zeroidx = idxs.map!(i => input[i]).countUntil(0);
        auto i1 = zeroidx + 1000;
        auto i2 = zeroidx + 2000;
        auto i3 = zeroidx + 3000;
        writefln("%s: %s", part, key * (input[idxs[i1 % $]] + input[idxs[i2 % $]] + input[idxs[i3 % $]]));
    }
    printgrove("part1", 1);

    enum key = 811589153;

    // start over with the multiplier
    idxs = iota(input.length).array;
    foreach(i; 0 .. 10)
        mix(key);

    printgrove("part2", key);
}
