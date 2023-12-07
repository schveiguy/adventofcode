import std.stdio;
import std.algorithm;
import std.file : readText;
import std.conv;
import std.format;
import std.string;
import std.range;
import std.array;
import std.math;
import std.traits;

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

    static struct blizzard {
        pos loc;
        pos dir;
        pos reset; // place where it should go when hitting a wall
    }

    enum Dir : pos{
        up = pos(0, -1),
        down = pos(0, 1),
        left = pos(-1, 0),
        right = pos(1, 0),
    }
    blizzard[] blizzards;
    foreach(y, ln; input)
    {
        foreach(x, c; ln)
        {
            switch(c)
            {
            case '<':
                blizzards ~= blizzard(pos(cast(int)x, cast(int)y), Dir.left, pos(cast(int)input[0].length - 2, cast(int)y));
                break;
            case '>':
                blizzards ~= blizzard(pos(cast(int)x, cast(int)y), Dir.right, pos(1, cast(int)y));
                break;
            case 'v':
                blizzards ~= blizzard(pos(cast(int)x, cast(int)y), Dir.down, pos(cast(int)x, 1));
                break;
            case '^':
                blizzards ~= blizzard(pos(cast(int)x, cast(int)y), Dir.up, pos(cast(int)x, cast(int)input.length - 2));
                break;
            default:
                break;
            }
        }
    }

    bool[pos] cur;
    int minute = 0;
    const finish = pos(cast(int)input[0].length - 2, cast(int)input.length - 1);
    assert(input[finish.y][finish.x] == '.');
    const start = pos(1, 0);
    assert(input[start.y][start.x] == '.');
    cur[start] = true;
    void run(pos target)
    {
        while(!(target in cur))
        {
            ++minute;
            // move all the blizzards
            bool[pos] occupied;// which spaces are occupied by blizzards
            foreach(ref b; blizzards)
            {
                b.loc += b.dir;
                if(input[b.loc.y][b.loc.x] == '#') // hit a wall
                    b.loc = b.reset;
                occupied[b.loc] = true;
            }

            bool[pos] newpos;
            foreach(curp; cur.byKey)
            {
                if(!(curp in occupied))
                    newpos[curp] = true; // stand still
                static foreach(d; EnumMembers!Dir) {{
                    auto p2 = curp + d;
                    if(p2.y >= 0 && p2.y < input.length && input[p2.y][p2.x] != '#' && !(p2 in occupied))
                        newpos[p2] = true;
                }}
            }
            cur = newpos;
        }
    }
    run(finish);
    writeln("part1: ", minute);

    // go back to the start
    cur.clear;
    cur[finish] = true;
    run(start);
    cur.clear;
    cur[start] = true;
    run(finish);

    writeln("part2: ", minute);
}
