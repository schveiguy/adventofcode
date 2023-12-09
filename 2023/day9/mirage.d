import std.stdio;
import std.file : readText;
import std.algorithm;
import std.range;
import std.conv;
import std.string;
import std.format;
import std.ascii;

void main(string[] args)
{
    auto input = readText(args[1]).splitter('\n').filter!(v => !v.empty).array;
    int[2] recurse(int[] vals)
    {
        if(vals.canFind!(v => v != 0))
        {
            int[] nv = vals.slide!(No.withPartial)(2).map!(x => x[1] - x[0]).array;
            int[2] r = recurse(nv);
            return [vals[0] - r[0], vals[$-1] + r[1]];
        }
        else
            return [0, 0];
    }
    int[2] answers = 0;
    foreach(m; input)
    {
        int[] vals = m.splitter.map!(to!int).array;
        answers[] += recurse(vals)[];
    }
    writeln(answers);
}
