import std.stdio;
import std.file : readText;
import std.algorithm;
import std.range;
import std.conv;
import std.string;
import std.format;
import std.ascii;
import std.traits;

void main(string[] args)
{
    auto input = readText(args[1]).splitter('\n').filter!(v => !v.empty).array;
    long[][] terms;
    char[] ops;
    terms = input[0 .. $-1].map!(r => r.splitter.filter!(v => !v.empty).map!(v => v.to!long).array).array;
    ops = input[$-1].splitter.filter!(v => !v.empty).map!(v => char(v[0])).array;

    long total = 0;
    foreach(i; 0 .. terms[0].length)
    {
        if(ops[i] == '*')
        {
            long v = 1;
            foreach(j; 0 .. terms.length)
                v *= terms[j][i];
            total += v;
        }
        else
        {
            long v = 0;
            foreach(j; 0 .. terms.length)
                v += terms[j][i];
            total += v;
        }
    }

    writeln(i"part1: $(total)");

    // transpose everything
    auto maxlen = input.map!(v => v.length).maxElement;
    char[][] transposed = new char[][](maxlen, input.length);
    foreach(ref t; transposed) t[] = ' '; // eliminate any invalid chars
    foreach(i; 0 .. input.length)
        foreach(j; 0 .. input[i].length)
            transposed[j][i] = input[i][j];

    transposed ~= "".dup;
    
    // process them between blank lines
    long[] p2terms;
    long p2total;
    char op;
    foreach(t; transposed.map!(x => x.strip)) {
        if(t.length == 0)
        {
            // calculate
            if(op == '*')
                p2total += p2terms.fold!((x, y) => x * y);
            else
                p2total += p2terms.fold!((x, y) => x + y);
            // reset
            p2terms = null;
            continue;
        }
        if(t[$-1] == '*' || t[$-1] == '+')
        {
            op = t[$-1];
            t = t[0 .. $-1].strip;
        }
        p2terms ~= t.to!long;
    }

    writeln(i"part2: $(p2total)");
}
