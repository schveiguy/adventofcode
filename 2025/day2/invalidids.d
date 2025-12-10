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
    auto input = readText(args[1]).strip.splitter(',').map!(v => v.split('-').map!(x => x.to!long).array).array;
    long bad = 0;
    long badpart2 = 0;
    foreach(s; input)
    {
        foreach(l; s[0] .. s[1]+1){
            auto txt = l.to!string;
            if(txt.length % 2 == 0 && txt[0 .. $/2] == txt[$/2 .. $])
                bad += l;
            // part 2
            foreach(i; 1 .. txt.length / 2 + 1) {
                if(txt.length % i != 0) continue;
                auto j = 0;
                while(j < txt.length && txt[0 .. i] == txt[j .. j+i])
                    j += i;
                if(j == txt.length)
                {
                    badpart2 += l;
                    break;
                }
            }
        }
    }
    writeln(i"part1: $(bad)");
    writeln(i"part2: $(badpart2)");
}
