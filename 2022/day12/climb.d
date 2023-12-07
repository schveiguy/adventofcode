import std.stdio;
import std.algorithm;
import std.file : readText;
import std.conv;
import std.format;
import std.string;
import std.range;
import std.array;
import std.container.rbtree;
import std.math;

void main(string[] args)
{
    static struct Node {
        int cost;
        size_t x;
        size_t y;
        int opCmp(const(Node) other) const
        {
            import std.typecons;
            return tuple(this.tupleof).opCmp(tuple(other.tupleof));
        }
    }
    auto pq = new RedBlackTree!Node;
    if(args.length < 3)
    {
        writeln("usage: climb filename part");
        writeln("part must be 'part1' or 'part2'");
        return;
    }
    auto input = cast(char[][])readText(args[1]).strip.split;
    auto part1 = args[2] == "part1";
    auto w = input[0].length;
    auto h = input.length;
    int[][] costs = new int[][](h, w);
    foreach(ref r; costs)
        r[] = -1;
    // find the start and end position
    size_t endx, endy;
    foreach(y, r; input)
        foreach(x, ref c; r)
        {
            if(c == 'S' || (c == 'a' && !part1))
            {
                c = 'a';
                costs[y][x] = 0;
                pq.insert(Node(0, x, y));
            }
            else if(c == 'E')
            {
                c = 'z';
                endx = x;
                endy = y;
            }
        }

    immutable d = [-1, 1, 0, 0];
    while(pq.length != 0)
    {
        auto next = pq.front;
        pq.removeFront;
        foreach(i; 0 .. 4)
        {
            auto nx = next.x + d[i];
            auto ny = next.y + d[3-i];
            if(nx >= w || ny >= h || costs[ny][nx] != -1)
                continue;
            if(input[ny][nx] - input[next.y][next.x] <= 1)
            {
                costs[ny][nx] = next.cost + 1;
                pq.insert(Node(next.cost + 1, nx, ny));
            }
        }
    }

    //writefln("%(%-(%s%)\n%)", costs.map!(arr => arr.map!(v => v == -1 ? '.' : '*')));
    writefln("%s: %s", part1 ? "part1" : "part2",  costs[endy][endx]);
}
