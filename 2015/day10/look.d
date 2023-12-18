import std.stdio;
import std.file : readText;
import std.algorithm;
import std.range;
import std.conv;
import std.string;
import std.format;
import std.ascii;
import std.utf;


void main(string[] args)
{
    auto input = args[1];
    string iterate(string vals)
    {
        Appender!string result;
        foreach(r; vals.byChar.chunkBy!((a, b) => a == b))
        {
            result.formattedWrite("%s%s", r.walkLength, r.front);
        }
        return result.data;
    }
    auto s = input;
    foreach(i; 0 .. 40)
    {
        s = iterate(s);
    }
    writeln(s.length);
    foreach(i; 0 .. 10)
    {
        s = iterate(s);
    }
    writeln(s.length);
}
