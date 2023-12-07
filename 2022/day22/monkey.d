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
    auto input = readText(args[1]).split('\n');
    if(input[$-1].length == 0)
        input.popBack;
    auto board = input[0 .. $-2];
    auto moves = input[$-1];
    static struct pos { int x, y;
        pos opBinary(string op)(pos o){
            return mixin("pos(x", op, "o.x,y", op, "o.y)");
        }
        ref pos opOpAssign(string op)(pos o){
            return this = this.opBinary!op(o);
        }
    }

    pos me;
    pos[] dir = [pos(1, 0), pos(0, 1), pos(-1, 0), pos(0, -1)];
    enum right = 0;
    enum down = 1;
    enum left = 2;
    enum up = 3;

    int facing = right;
    char boardc(pos p)
    {
        if(p.y < 0 || p.y >= board.length)
            return ' ';
        if(p.x < 0 || p.x >= board[p.y].length)
            return ' ';
        return board[p.y][p.x];
    }

    pos next()
    {
        auto n = me + dir[facing];
        if(boardc(n) == ' ')
        {
            final switch(facing)
            {
            case right:
                n.x = 0;
                break;
            case down:
                n.y = 0;
                break;
            case left:
                n.x = cast(int)board[n.y].length - 1;
                break;
            case up:
                n.y = cast(int)board.length - 1;
                break;
            }
            while(boardc(n) == ' ')
                n += dir[facing];
        }
        return n;
    }

    while(boardc(me) == ' ')
        me += dir[right];
    pos start = me;

    //writeln("moves: ", moves);
    while(moves.length)
    {
        if(moves[0] == 'R')
        {
            //writeln("turning right");
            facing = (facing + 1) % 4;
            moves.popFront;
        }
        else if(moves[0] == 'L')
        {
            //writeln("turning left");
            facing = (facing + 3) % 4;
            moves.popFront;
        }
        else {
            auto dist = parse!int(moves);
            //writeln("moving ", dist);
            foreach(i; 0 .. dist)
            {
                auto n = next;
                if(boardc(n) == '#')
                    break;
                me = n;
            }
        }
        //writeln(me);
        //writeln(facing);
    }
    writeln("part1: ", 1000 * (me.y + 1) + 4 * (me.x + 1) + facing);

    // reset the sim
    me = start;
    facing = right;
    moves = input[$-1];

    // an edge contains an entry/exit point on the board, and the direction
    // faced when leaving/entering.
    static struct edge {
        pos loc;
        int facing;
    }

    // a mapping of exit edges to entry edges on the board when the cube is folded
    edge[edge] edges;

    // join 2 edges together. The edge location is a simple grid of faces, and
    // the N is the length of each face edge.
    void join(edge e1, edge e2, int N)
    {
        // determine starting points, ending points, and directions for traversing the edges
        // we always traverse clockwise for outgoing edges, and counter-clockwise for incoming edges
        e1.loc *= pos(N, N);
        e2.loc *= pos(N, N);
        pos e1delta = dir[(e1.facing + 1) % 4];
        pos e2delta = dir[(e2.facing + 1) % 4];
        // outgoing - traverse edge clockwise
        final switch(e1.facing)
        {
        case right:
            e1.loc += pos(N-1, 0);
            break;
        case down:
            e1.loc += pos(N-1, N-1);
            break;
        case left:
            e1.loc += pos(0, N-1);
            break;
        case up:
            e1.loc += pos(0, 0);
            break;
        }

        // incoming - traverse edge counter-clockwise
        final switch(e2.facing)
        {
        case right:
            e2.loc += pos(0, 0);
            break;
        case down:
            e2.loc += pos(N-1, 0);
            break;
        case left:
            e2.loc += pos(N-1, N-1);
            break;
        case up:
            e2.loc += pos(0, N-1);
            break;
        }

        foreach(i; 0 .. N)
        {
            //writefln("edge %s goes to edge %s", e1, e2);
            edges[e1] = e2;
            e1.loc += e1delta;
            e2.loc += e2delta;
        }
    }

    if(board.length == 12) // test input
    {
        // folding with this config:
        // ..A.
        // BCD.
        // ..EF

        enum A = pos(2, 0);
        enum B = pos(0, 1);
        enum C = pos(1, 1);
        enum D = pos(2, 1);
        enum E = pos(2, 2);
        enum F = pos(3, 2);

        // top of A goes to top of B
        join(edge(A, up), edge(B, down), 4);
        join(edge(B, up), edge(A, down), 4);

        // left of A goes to top of C
        join(edge(A, left), edge(C, down), 4);
        join(edge(C, up), edge(A, right), 4);

        // right of A goes to right of F
        join(edge(A, right), edge(F, left), 4);
        join(edge(F, right), edge(A, left), 4);

        // left of B goes to bottom of F
        join(edge(B, left), edge(F, up), 4);
        join(edge(F, down), edge(B, right), 4);

        // bottom of B goes to bottom of E
        join(edge(B, down), edge(E, up), 4);
        join(edge(E, down), edge(B, up), 4);

        // bottom of C goes to left of E
        join(edge(C, down), edge(E, right), 4);
        join(edge(E, left), edge(C, up), 4);

        // right of D goes to top of F
        join(edge(D, right), edge(F, down), 4);
        join(edge(F, up), edge(D, left), 4);
    }
    else if(board.length == 200) // my puzzle input
    {
        // folding with this config:
        // .AB
        // .C.
        // DE.
        // F..

        enum A = pos(1, 0);
        enum B = pos(2, 0);
        enum C = pos(1, 1);
        enum D = pos(0, 2);
        enum E = pos(1, 2);
        enum F = pos(0, 3);

        // top of A goes to left of F
        join(edge(A, up), edge(F, right), 50);
        join(edge(F, left), edge(A, down), 50);

        // left of A goes to left of D
        join(edge(A, left), edge(D, right), 50);
        join(edge(D, left), edge(A, right), 50);

        // top of B goes to bottom of F
        join(edge(B, up), edge(F, up), 50);
        join(edge(F, down), edge(B, down), 50);

        // right of B goes to right of E
        join(edge(B, right), edge(E, left), 50);
        join(edge(E, right), edge(B, left), 50);

        // bottom of B goes to right of C
        join(edge(B, down), edge(C, left), 50);
        join(edge(C, right), edge(B, up), 50);

        // left of C goes to top of D
        join(edge(C, left), edge(D, down), 50);
        join(edge(D, up), edge(C, right), 50);

        // bottom of E goes to right of F
        join(edge(E, down), edge(F, left), 50);
        join(edge(F, right), edge(E, up), 50);
    }
    else assert(0, "unknown board!");
    //writeln(edges);

    // process the moves again, this time taking into account the edge movements
    while(moves.length)
    {
        if(moves[0] == 'R')
        {
            //writeln("turning right");
            facing = (facing + 1) % 4;
            moves.popFront;
        }
        else if(moves[0] == 'L')
        {
            //writeln("turning left");
            facing = (facing + 3) % 4;
            moves.popFront;
        }
        else {
            auto dist = parse!int(moves);
            //writeln("moving ", dist);
            foreach(i; 0 .. dist)
            {
                auto n = me + dir[facing];
                int nf = facing;
                if(boardc(n) == ' ')
                {
                    // look up the edge to see where it goes
                    scope(failure) writeln("failed at pos ", me, " facing ", facing);
                    auto e = edges[(edge(me, facing))];
                    n = e.loc;
                    nf = e.facing;
                }
                if(boardc(n) == '#')
                    break;
                me = n;
                facing = nf;
            }
        }
        //writeln(me);
        //writeln(facing);
    }
    writeln("part2: ", 1000 * (me.y + 1) + 4 * (me.x + 1) + facing);
}
