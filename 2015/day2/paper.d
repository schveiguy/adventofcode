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
    int part1;
    int part2;
    foreach(b; input)
    {
        int[] dims = b.splitter("x").map!(to!int).array;
        auto s1 = dims[0] * dims[1];
        auto s2 = dims[0] * dims[2];
        auto s3 = dims[1] * dims[2];
        int t = (s1 + s2 + s3) * 2 + min(s1, s2, s3);
        writeln(dims, " ", t);
        part1 += t;

        int rib1 = (sum(dims) - maxElement(dims)) * 2 + fold!("a * b")(dims);
        writeln(rib1);
        part2 += rib1;
    }
    writeln(part1);
    writeln(part2);
}
