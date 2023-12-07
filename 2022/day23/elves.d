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
    static struct pos { int x, y;
        pos opBinary(string op)(pos o){
            return mixin("pos(x", op, "o.x,y", op, "o.y)");
        }
        ref pos opOpAssign(string op)(pos o){
            return this = this.opBinary!op(o);
        }
    }

    bool[pos] elves;
    foreach(y, ln; input)
    {
        foreach(x, c; ln)
        {
            if(c == '#')
                elves[pos(cast(int)x, cast(int)y)] = true;
        }
    }

    void printmap()
    {
        auto minpos = elves.byKey.fold!((p1, p2) => pos(min(p1.x, p2.x), min(p1.y, p2.y)));
        auto maxpos = elves.byKey.fold!((p1, p2) => pos(max(p1.x, p2.x), max(p1.y, p2.y)));
        foreach(y; minpos.y .. maxpos.y+1)
        {
            writef("% 3s:", y);
            foreach(x; minpos.x .. maxpos.x+1)
            {
                write(elves.get(pos(x, y), false) ? '#' : '.');
            }
            writeln();
        }
    }

    //printmap();

    pos[3][4] proposals = [
        [pos( 0,-1), pos(-1,-1), pos( 1,-1)],
        [pos( 0, 1), pos(-1, 1), pos( 1, 1)],
        [pos(-1, 0), pos(-1,-1), pos(-1, 1)],
        [pos( 1, 0), pos( 1,-1), pos( 1, 1)]
    ];

    int prop = 0;
    auto r = 0;
    bool done = false;
    while(!done)
    {
        ++r;
        pos[pos] proposed;
        int[pos] crowd;
        foreach(curpos; elves.byKey)
        {
            auto selected = -1;
            bool shouldmove = false;
outerloop:
            foreach(p; iota(prop, prop + 4).map!(x => x % 4))
            {
                foreach(d; proposals[p][])
                {
                    if((curpos + d) in elves)
                    {
                        shouldmove = true;
                        continue outerloop; // no good
                    }
                }

                // no problems, move here if crowded
                if(selected == -1)
                    selected = p;
            }

            if(shouldmove && selected != -1)
            {
                auto np = curpos + proposals[selected][0];
                proposed[curpos] = np;
                ++crowd.require(np, 0);
            }
        }
        // move all the elves that should move
        bool[pos] newelves;
        done = true;
        foreach(curpos; elves.byKey)
        {
            if(auto np = curpos in proposed)
            {
                // see if we can move
                if(crowd[*np] == 1)
                {
                    newelves[*np] = true;
                    done = false;
                    continue;
                }
            }

            // stay in the same spot
            newelves[curpos] = true;
        }
        assert(elves.length == newelves.length);
        elves = newelves;
        if(r == 10)
        {
            auto minpos = elves.byKey.fold!((p1, p2) => pos(min(p1.x, p2.x), min(p1.y, p2.y)));
            auto maxpos = elves.byKey.fold!((p1, p2) => pos(max(p1.x, p2.x), max(p1.y, p2.y)));
            writeln("part1: ", (maxpos.y - minpos.y + 1) * (maxpos.x - minpos.x + 1) - elves.length);
        }
        //writeln("step ", r+1);
        //printmap();
        prop = (prop+1) % 4;
    }
    writeln("part2: ", r);
}
