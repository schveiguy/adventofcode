import std.stdio;
import std.file : readText;
import std.algorithm;
import std.range;
import std.conv;
import std.string;
import std.format;
import std.ascii;
import std.traits;

struct Vec
{
    long x;
    long y;

    Vec opBinary(string op : "+")(Vec o) => Vec(x + o.x, y + o.y);
    Vec opUnary(string op : "-")() => Vec(-x, -y);
    Vec left() => Vec(y, -x);
    Vec right() => Vec(-y, x);
}

void main(string[] args)
{
    auto input = readText(args[1]).splitter('\n').filter!(v => !v.empty).array;
    enum dir : Vec {
        up = Vec(0, -1),
        down = Vec(0, 1),
        left = Vec(-1, 0),
        right = Vec(1, 0)
    }

    Vec[][char] legend = [
        '.' : [],
        '|' : [dir.up, dir.down],
        'L' : [dir.up, dir.right],
        'J' : [dir.up, dir.left],
        '-' : [dir.left, dir.right],
        '7' : [dir.left, dir.down],
        'F' : [dir.right, dir.down],
        'S' : []
    ];

    Vec[][Vec] map;
    Vec start;
    foreach(y, line; input)
    {
        foreach(x, c; line)
        {
            if(c == 'S')
                start = Vec(x, y);
            map[Vec(x, y)] = legend[c];
        }
    }

    // fill in start
    foreach(d; EnumMembers!dir)
        if(map.get(start + d, []).canFind(-d))
            map[start] ~= d;

    Vec cur = start;
    int n = 0;
    Vec last = Vec(0, 0);
    int rightTurns = 0;
    do
    {
        foreach(d; map[cur])
        {
            if(-d != last)
            {
                cur = cur + d;
                rightTurns += (last.right == d);
                rightTurns -= (last.left == d);
                last = d;
                break;
            }
        }
        ++n;
    } while(cur != start);
    writeln(n / 2);

    int[Vec] fillMap;
    cur = start;
    fillMap[cur] = 1;
    last = Vec(0, 0);
    do
    {
        foreach(d; map[cur])
        {
            if(-d != last)
            {
                Vec fillstart = rightTurns > 0 ? d.right : d.left;
                if(fillMap.get(cur + fillstart, 0) == 0)
                    fillMap[cur + fillstart] = 2;
                cur = cur + d;
                if(fillMap.get(cur + fillstart, 0) == 0)
                    fillMap[cur + fillstart] = 2;
                last = d;
                fillMap[cur] = 1;
                break;
            }
        }
    } while(cur != start);

    /*foreach(y; 0 .. input.length)
    {
        foreach(x; 0 .. input[0].length)
        {
            write(fillMap.get(Vec(x, y), 0));
        }
        writeln();
    }*/

    // now do the fill
    Vec[] edges = fillMap.byKeyValue.filter!(e => e.value == 2).map!(e => e.key).array;
    while(edges.length)
    {
        Vec[] newEdges;
        foreach(e; edges)
        {
            foreach(d; EnumMembers!dir)
            {
                if(!(e + d in map))
                    continue;
                if(fillMap.get(e + d, 0) == 0)
                {
                    newEdges ~= e + d;
                    fillMap[e + d] = 2;
                }
            }
        }
        edges = newEdges;
    }
    writeln(fillMap.byValue.count(2));
}
