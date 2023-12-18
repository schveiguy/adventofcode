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
    static struct State
    {
        Vec pos;
        Vec vel;
        int streak;
        State move()
        {
            return State(pos + vel, vel, streak + 1);
        }
        State moveRight()
        {
            return State(pos + vel.right, vel.right, 1);
        }
        State moveLeft()
        {
            return State(pos + vel.left, vel.left, 1);
        }
    }
    State[] edges = [
        State(Vec(0, 0), Vec(1, 0))
    ];
    int[State] result;
    result[edges[0]] = 0;
    bool inMap(Vec pos)
    {
        return pos.x >= 0 && pos.x < cast(int)input[0].length && pos.y >= 0 && pos.y < cast(int)input.length;
    }
    while(edges.length > 0)
    {
        State[] newEdges;
        void addState(State s, int heat)
        {
            if(inMap(s.pos))
            {
                heat += input[s.pos.y][s.pos.x] - '0';
                auto cur = s in result;
                if(!cur)
                {
                    result[s] = heat;
                    newEdges ~= s;
                }
                else if(*cur > heat)
                {
                    *cur = heat;
                    newEdges ~= s;
                }
            }
        }
        foreach(e; edges)
        {
            auto h = result[e];
            if(e.streak != 3)
                addState(e.move(), h);
            addState(e.moveLeft(), h);
            addState(e.moveRight(), h);
        }
        edges = newEdges;
    }
    int part1 = int.max;
    foreach(k, v; result)
    {
        if(k.pos == Vec(input[0].length - 1, input.length - 1))
            part1 = min(part1, v);
    }
    writeln(part1);

    // part 2
    result.clear;
    edges = [
        State(Vec(0, 0), Vec(1, 0))
    ];
    result[edges[0]] = 0;

    while(edges.length > 0)
    {
        State[] newEdges;
        void addState(State s, int heat)
        {
            if(inMap(s.pos))
            {
                heat += input[s.pos.y][s.pos.x] - '0';
                auto cur = s in result;
                if(!cur)
                {
                    result[s] = heat;
                    newEdges ~= s;
                }
                else if(*cur > heat)
                {
                    *cur = heat;
                    newEdges ~= s;
                }
            }
        }
        foreach(e; edges)
        {
            auto h = result[e];
            if(e.streak != 10)
                addState(e.move(), h);
            if(e.streak >= 4)
            {
                addState(e.moveLeft(), h);
                addState(e.moveRight(), h);
            }
        }
        edges = newEdges;
    }
    int part2 = int.max;
    foreach(k, v; result)
    {
        if(k.pos == Vec(input[0].length - 1, input.length - 1) && k.streak >= 4)
            part2 = min(part2, v);
    }
    writeln(part2);
}
