import std.stdio;
import std.algorithm;
import std.file : readText;
import std.conv;

int priority(char c)
{
    switch(c)
    {
    case 'A': .. case 'Z': return c - 'A' + 27;
    case 'a': .. case 'z': return c - 'a' + 1;
    default:
              writeln("unknown char! ", c);
              assert(false);
    }
}

void main(string[] args)
{
    auto input = readText(args[1]);
    int priorities;
    int safeties;
    string[3] safetyGroup;
    int safetyidx = 0;
    foreach(rucksack; input.splitter)
    {
        if(rucksack.length == 0)
            continue;
        auto str1 = rucksack[0 .. $/2];
        auto str2 = rucksack[$/2 .. $];
        foreach(c; str1)
            if(str2.canFind(c)) {
                priorities += priority(c);
                break;
            }
        safetyGroup[safetyidx++] = rucksack;
        if(safetyidx == 3)
        {
            // safety group formed
            safetyidx = 0;
            foreach(c; safetyGroup[0])
                if(safetyGroup[1].canFind(c) && safetyGroup[2].canFind(c)) {
                    safeties += priority(c);
                    break;
                }
        }
    }
    writeln(priorities);
    writeln(safeties);
}
