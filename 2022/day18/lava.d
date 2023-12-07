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
    auto input = readText(args[1]).strip.split;

    static struct cube {
        int x, y, z;
        cube opBinary(string op)(cube other) {
            cube result;
            mixin("result.x = x ", op, " other.x;");
            mixin("result.y = y ", op, " other.y;");
            mixin("result.z = z ", op, " other.z;");
            return result;
        }
    }
    bool[cube] rock;
    foreach(ln; input)
    {
        cube r;
        ln.formattedRead("%s,%s,%s", &r.x, &r.y, &r.z);
        rock[r] = true;
    }
    cube[] dirs = [
        cube(1, 0, 0),
        cube(-1, 0, 0),
        cube(0, 1, 0),
        cube(0, -1, 0),
        cube(0, 0, 1),
        cube(0, 0, -1)
    ];

    int p1 = 0;
    foreach(c; rock.byKey)
    {
        foreach(d; dirs)
        {
            if(!((c + d) in rock))
                ++p1;
        }
    }
    writeln("part1: ", p1);

    cube maxcube = rock.byKey.fold!((c1, c2) => cube(max(c1.x, c2.x), max(c1.y, c2.y), max(c1.z, c2.z))) + cube(1, 1, 1);
    cube mincube = rock.byKey.fold!((c1, c2) => cube(min(c1.x, c2.x), min(c1.y, c2.y), min(c1.z, c2.z))) - cube(1, 1, 1);
    writeln(maxcube);
    writeln(mincube);

    // fill in all the spaces surrounding the cubes
    bool inrange(cube c) {
        return
            c.x >= mincube.x && c.x <= maxcube.x &&
            c.y >= mincube.y && c.y <= maxcube.y &&
            c.z >= mincube.z && c.z <= maxcube.z;
    }

    cube[] q = [mincube];
    rock[mincube] = true;
    while(q.length)
    {
        auto next = q.front;
        //writeln(next);
        q.popFront;
        foreach(d; dirs)
        {
            auto newc = next + d;
            if(inrange(newc))
            {
                if(!(newc in rock))
                {
                    rock[newc] = true;
                    q ~= newc;
                }
            }
        }
    }

    // now, find all the surface areas again
    int p2;
    foreach(c; rock.byKey)
    {
        foreach(d; dirs)
        {
            auto newc = c + d;
            if(inrange(newc) && !(newc in rock))
                ++p2;
        }
    }
    writeln("part2: ", p1 - p2);
}
