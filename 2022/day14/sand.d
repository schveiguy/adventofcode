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
    static struct pos { int x, y; }
    bool[pos] cave;
    foreach(ln; input)
    {
        auto c = ln.splitter(" -> ").map!((coord) {
                                          pos p;
                                          coord.formattedRead("%d,%d", &p.x, &p.y);
                                          return p;
                                          });
        auto cur = c.front;
        c.popFront;
        foreach(p; c)
        {
            int dx = cur.x == p.x ? 0 : (cur.x > p.x ? -1 : 1);
            int dy = cur.y == p.y ? 0 : (cur.y > p.y ? -1 : 1);
            while(cur != p)
            {
                cave[cur] = true;
                cur.x += dx;
                cur.y += dy;
            }
            cave[cur] = true;
        }
    }
    auto maxy = cave.byKey.fold!((y, p) => max(y, p.y))(0);
    //writeln(maxy);

    auto origlen = cave.length;
    bool part1 = false;
outer:
    while(true)
    {
        // drop some sand
        auto sand = pos(500, 0);
        while(sand.y < maxy+1)
        {
            if(!part1 && sand.y >= maxy)
            {
                writeln("part1: ", cave.length - origlen);
                part1 = true;
            }
            if(pos(sand.x, sand.y+1) in cave)
            {
                if(pos(sand.x-1, sand.y+1) in cave)
                {
                    if(pos(sand.x+1, sand.y+1) in cave)
                    {
                        break;
                    }
                    else
                    {
                        sand.y += 1;
                        sand.x += 1;
                    }
                }
                else
                {
                    sand.y += 1;
                    sand.x -= 1;
                }
            }
            else
            {
                sand.y += 1;
            }
        }
        cave[sand] = true; // stopped
        if(sand.y == 0)
            break;
    }

    writeln("part2: ", cave.length - origlen);
}
