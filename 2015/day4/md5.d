import std.digest;
import std.stdio;
import std.format;
import std.digest;
import std.digest.md;
import std.string;

void main(string[] args)
{
    // arg is the puzzle input
    foreach(i; 1 .. int.max)
    {
        auto str = toHexString(md5Of(format("%s%s", args[1], i)));
        if(str[].startsWith("00000"))
        {
            writeln("part1: ", i);
        }
        if(str[].startsWith("000000"))
        {
            writeln("part2: ", i);
            break;
        }
    }
}
