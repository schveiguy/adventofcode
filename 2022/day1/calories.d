import std.stdio;
import std.file : readText;
import std.algorithm;
import std.conv;
import std.string;

void main(string[] args)
{
    auto input = readText(args[1]);
    int n = 1;
    if(args.length > 2)
        n = args[2].to!int;
    int[] best = new int[n + 1];
    int total = 0;
    foreach(l; input.splitter('\n').map!strip)
    {
        if(l.length == 0) {
            best[0] = total;
            best.sort;
            total = 0;
        }
        else
            total += l.to!int;
    }
    best[0] = total;
    best.sort;
    writeln(best[1 .. $].sum);
}
