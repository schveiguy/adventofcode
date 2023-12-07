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
    auto input = readText(args[1]).strip.split('\n');
    auto p1row = args[2].to!int;
    auto p2maxdist = args[3].to!int;
    static struct val {
        int x, b;
    }

    static struct sensor {
        int x, y, bx, by, dist;
    }

    bool[int] beaconsinrow;
    sensor[] sensors;
    foreach(ln; input)
    {
        sensor s;
        ln.formattedRead("Sensor at x=%s, y=%s: closest beacon is at x=%s, y=%s", &s.x, &s.y, &s.bx, &s.by);
        s.dist = abs(s.x - s.bx) + abs(s.y - s.by);
        sensors ~= s;
    }

    void filldists(ref val[] dists, int row)
    {
        foreach(s; sensors)
        {
            auto rowdist = abs(row - s.y);
            if(rowdist < s.dist)
            {
                auto off = s.dist - rowdist;
                dists ~= val(s.x - off, 1);
                dists ~= val(s.x + off + 1, -1);
            }
        }
        dists.sort!((v1, v2) => v1.x < v2.x);
    }
    val[] dists;
    filldists(dists, p1row);
    foreach(s; sensors.filter!(s => s.by == p1row))
    {
        beaconsinrow[s.bx] = true;
    }

    //writeln(dists);
    int cur = 0;
    int p1 = 0 - cast(int)beaconsinrow.length;
    int lastx = int.min;
    foreach(chunk; dists.chunkBy!((v1, v2) => v1.x == v2.x))
    {
        auto x = chunk.front.x;
        if(cur)
            p1 += x - lastx;
        foreach(v; chunk)
            cur += v.b;
        lastx = x;
    }
    assert(cur == 0);
    writeln("part1: ", p1);

    // part 2
    foreach(i; 0 .. p2maxdist+1)
    {
        dists.length = 0;
        dists.assumeSafeAppend;
        // run the row aglorithm for each 
        dists ~= val(int.min, 1);
        dists ~= val(0, -1);
        filldists(dists, i);
        lastx = int.min;
        cur = 0;
        foreach(v; dists)
        {
            if(v.x != lastx)
            {
                if(cur == 0) // found it
                {
                    writefln("part2 found at %s, %s: %s", lastx, i, lastx * 4_000_000L + i);
                    return;
                }
                lastx = v.x;
            }
            cur += v.b;
        }
    }
    writeln("error beacon not found");
}
