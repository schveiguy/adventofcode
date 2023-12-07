import std.stdio;
import std.file : readText;
import std.algorithm;
import std.string;
import std.conv;
import std.range;
import std.array : array;
import std.format;
import std.container.rbtree;

void go(string msg, inout(char)[][] input)
{
    immutable w = input[0].length;
    immutable h = input.length;
    int[][] costs = new int[][](h, w);
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
    foreach(ref r; costs)
        r[] = -1;
    costs[0][0] = 0;
    pq.insert(Node(0, 0, 0));
    immutable d = [-1, 1, 0, 0];
    while(pq.length > 0)
    {
        auto next = pq.front;
        assert(costs[next.y][next.x] == next.cost, next.to!string);
        pq.removeFront;
        foreach(i; 0 .. 4)
        {
            auto nx = next.x + d[i];
            auto ny = next.y + d[3-i];
            if(nx >= w || ny >= h || costs[ny][nx] != -1)
                continue;
            auto n = Node(input[ny][nx] - '0' + next.cost, nx, ny);
            costs[ny][nx] = n.cost;
            pq.insert(n);
        }
    }
    //writefln("%(%(% 3s%)\n%)", costs);
    writeln(msg, costs[h-1][w-1]);
}
void main(string[] args)
{
    auto input = readText(args[1]).strip.split;
    go("part1: ", input);

    // produce the larger output;
    auto w = input[0].length;
    auto h = input.length;
    char[][] biginput = new char[][](h * 5, w * 5);
    foreach(y; 0 .. biginput.length)
        foreach(x; 0 .. biginput[0].length)
        {
            auto adder = y/h + x/w;
            biginput[y][x] = '1' + (input[y % h][x % h] - '1' + adder) % 9;
        }
    //writefln("%(%-(%s%)\n%)", biginput);
    go("part2: ", biginput);
}
