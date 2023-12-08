import std.stdio;
import std.file : readText;
import std.algorithm;
import std.range;
import std.conv;
import std.string;
import std.format;
import std.ascii;

long gcd(long a, long b)
{
    if(a < b)
        swap(a, b);
    while(b != 0)
    {
        a = a % b;
        swap(a, b);
    }
    return a;
}

long lcm(long a, long b)
{
    return a / gcd(a, b) * b;
}

void main(string[] args)
{
    auto input = readText(args[1]).splitter('\n').filter!(v => !v.empty).array;
    auto inst = input[0];
    string[2][string] themap;
    foreach(i; input[1 .. $])
    {
        string src;
        string[2] dest;
        i.formattedRead("%s = (%s, %s)", src, dest[0], dest[1]);
        themap[src] = dest;
    }
    int n;
    string cur = "AAA";
    foreach(i; inst.cycle)
    {
        //writeln(i);
        cur = themap[cur][i == 'R'];
        //writeln(cur);
        ++n;
        if(cur == "ZZZ") break;
    }
    writeln(n);

    // part 2

    // find cycles
    struct state {
        string node;
        int idx;
        void next()
        {
            node = themap[node][inst[idx] == 'R'];
            idx = (idx + 1) % inst.length.to!int;
        }
    }

    string[] p2;
    foreach(k; themap.byKey)
    {
        if(k[2] == 'A')
        {
            p2 ~= k;
        }
    }
    long answer = 1;
    // NOTE: this depends on my puzzle input, I found that the cycle in each
    // case had no initial lead-in, and always repeated at the Z state. That is,
    // the cycle was always
    // A -> B -> C -> ... -> Z -> B -> ...
    // a different input could easily fail this, but I only needed one answer!
    // I also could skip the T&H algorithm knowing this, but I decided to leave
    // it in.
    foreach(start; p2)
    {
        state s = state(start, 0);
        state s2 = state(start, 0);
        n = 0;
        int z;
        do
        {
            s.next();
            s2.next(); s2.next();
            ++n;
            if(s.node[2] == 'Z')
                z = n;
        }
        while(s != s2);
        assert(z == n);
        answer = lcm(answer, n);
    }
    writeln(answer);
}
