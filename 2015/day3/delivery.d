import std.stdio;
import std.file : readText;
import std.algorithm;
import std.range;
import std.conv;
import std.string;
import std.format;
import std.ascii;


void main(string[] args)
{
    auto input = readText(args[1]).splitter('\n').filter!(v => !v.empty).array;
    static struct loc {
        int x;
        int y;
    }
    foreach(i; input)
    {
        bool[loc] houses;
        loc cur = loc(0, 0);
        houses[cur] = true;
        foreach(d; i)
        {
            switch(d)
            {
                case '<':
                    cur.x -= 1;
                    break;
                case '>':
                    cur.x += 1;
                    break;
                case '^':
                    cur.y -= 1;
                    break;
                case 'v':
                    cur.y += 1;
                    break;
                default:
                    assert(0);
            }
            houses[cur] = true;
        }
        writeln("p1: ", houses.length);

        // part 2
        houses.clear;
        cur = loc(0, 0);
        loc robot = loc(0, 0);
        houses[cur] = true;
        foreach(idx, d; i)
        {
            loc *v = (idx % 2) ? &cur : &robot;
            switch(d)
            {
                case '<':
                    v.x -= 1;
                    break;
                case '>':
                    v.x += 1;
                    break;
                case '^':
                    v.y -= 1;
                    break;
                case 'v':
                    v.y += 1;
                    break;
                default:
                    assert(0);
            }
            houses[*v] = true;
        }
        writeln("p2: ", houses.length);
    }
}
