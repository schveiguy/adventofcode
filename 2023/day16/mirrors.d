import std.stdio;
import std.file : readText;
import std.algorithm;
import std.range;
import std.conv;
import std.string;
import std.format;
import std.ascii;
import std.math;
import std.traits;

struct Vec
{
    long x;
    long y;

    Vec opBinary(string op : "+")(Vec o) => Vec(x + o.x, y + o.y);
    Vec opBinary(string op : "-")(Vec o) => Vec(x - o.x, y - o.y);
    Vec opBinary(string op : "*")(long o) => Vec(x * o, y * o);
    Vec opUnary(string op : "-")() => Vec(-x, -y);
    Vec left() => Vec(y, -x);
    Vec right() => Vec(-y, x);
    long length() => abs(x) + abs(y);
}

enum dir : Vec {
    up = Vec(0, -1),
    down = Vec(0, 1),
    left = Vec(-1, 0),
    right = Vec(1, 0)
}

void main(string[] args)
{
    auto input = readText(args[1]).splitter('\n').filter!(v => !v.empty).array;
    auto w = input[0].length;
    auto h = input.length;
    static struct State
    {
        Vec pos;
        Vec velocity;
        State move()
        {
            return State(pos + velocity, velocity);
        }
        State move(Vec newv)
        {
            return State(pos + newv, newv);
        }
    }
    size_t run(State start)
    {
        bool[State] visited;
        bool[Vec] energized;
        State[] edges = [start];
        visited[start] = true;
        energized[start.pos] = true;
        while(edges.length > 0)
        {
            State[] newEdges;
            void addEdge(State s)
            {
                if(s.pos.x >= 0 && s.pos.x < w && s.pos.y >= 0 && s.pos.y < h && !(s in visited))
                {
                    visited[s] = true;
                    energized[s.pos] = true;
                    newEdges ~= s;
                }
            }
            foreach(s; edges)
            {
                char c = input[s.pos.y][s.pos.x];
                bool passthru = true;
                if(c == '\\')
                {
                    passthru = false;
                    addEdge(s.move(s.velocity.x != 0 ? s.velocity.right : s.velocity.left));
                }
                else if(c == '/')
                {
                    passthru = false;
                    addEdge(s.move(s.velocity.x != 0 ? s.velocity.left : s.velocity.right));
                }
                else if(c == '-')
                {
                    if(s.velocity.y != 0)
                    {
                        passthru = false;
                        addEdge(s.move(dir.left));
                        addEdge(s.move(dir.right));
                    }
                }
                else if(c == '|')
                {
                    if(s.velocity.x != 0)
                    {
                        passthru = false;
                        addEdge(s.move(dir.up));
                        addEdge(s.move(dir.down));
                    }
                }
                if(passthru)
                {
                    addEdge(s.move);
                }
            }
            edges = newEdges;
        }
        return energized.length;
    }
    size_t part2 = 0;
    foreach(i; 0 .. h)
    {
        auto x = run(State(Vec(0, i), Vec(1, 0)));
        if(i == 0)
            writeln("part1 : ", x);
        part2 = max(part2, x);
        part2 = max(part2, run(State(Vec(w-1, i), Vec(-1, 0))));
    }
    foreach(i; 0 .. w)
    {
        part2 = max(part2, run(State(Vec(i, 0), Vec(0, 1))));
        part2 = max(part2, run(State(Vec(i, h-1), Vec(0, -1))));
    }
    writeln("part2 : ", part2);
}
