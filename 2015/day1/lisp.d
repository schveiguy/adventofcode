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
    foreach(i; input)
    {
        writeln(cast(long)(i.count('(') - i.count(')')));
        long floor = 0;
        foreach(pos, c; i)
            if(c == '(') ++floor;
            else if(c == ')') {
                if(--floor == -1) {
                    writeln(pos + 1);
                    break;
                }
            }
    }
}
