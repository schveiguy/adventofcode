import std.stdio;
import std.file : readText;
import std.algorithm;
import std.range;
import std.conv;
import std.string;
import std.format;
import std.ascii;
import std.traits;
import std.math;
import std.typecons;

struct Vec
{
    int x, y, z;
    this(string input) {
        input.formattedRead("%d,%d,%d", &x, &y, &z);
    }
    this(int x, int y, int z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    Vec opBinary(string op : "-")(Vec o) => Vec(x - o.x, y - o.y, z - o.z);

    double length() {
        return sqrt(double(x) * x + double(y) * y + double(z) * z);
    }
}

void main(string[] args)
{
    auto input = readText(args[1]).splitter('\n').filter!(v => !v.empty).map!(x => Vec(x)).array;
    auto n = args[2].to!int;
    int[] groups = iota(cast(int)(input.length)).array;
    static struct Pair {
        double length;
        size_t i;
        size_t j;
        int opCmp(Pair p2) {
            return length < p2.length ? -1 : length > p2.length ? 1 : 0;
        }
    }
    Pair[] pairs;
    foreach(i; 0 .. input.length - 1)
        foreach(j; i + 1 .. input.length)
            pairs ~= Pair((input[i] - input[j]).length, i, j);
    pairs.sort;
    foreach(conn; pairs[0 .. n]) {
        //writeln(i"connecting $(input[conn.i]) and $(input[conn.j]) with length $(conn.length)");
        auto og = groups[conn.j];
        auto ng = groups[conn.i];
        foreach(ref g; groups)
            if(g == og) g = ng;
    }

    int[int] counts;
    foreach(g; groups) counts[g]++;
    auto groupsizes = counts.values;
    groupsizes.sort;
    //writeln(groupsizes);
    auto part1 = groupsizes[$-3 .. $].fold!((a, b) => a * b);
    writeln(i"part1: $(part1)");

    // part 2
    groups = iota(cast(int)(input.length)).array;
    Pair lastconn;
    foreach(conn; pairs) {
        //writeln(i"connecting $(input[conn.i]) and $(input[conn.j]) with length $(conn.length)");
        auto og = groups[conn.j];
        auto ng = groups[conn.i];
        bool done = true;
        foreach(ref g; groups)
            if(g == og) g = ng;
            else if(g != ng) done = false;
        if(done) {
            lastconn = conn;
            break;
        }
    }
    auto part2 = input[lastconn.i].x * input[lastconn.j].x;
    writeln(i"part2: $(part2)");
}
