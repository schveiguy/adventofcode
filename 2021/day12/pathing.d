import std.stdio;
import std.file : readText;
import std.algorithm;
import std.string;
import std.conv;
import std.range;
import std.array : array;
import std.format;

struct cave
{
    string name;
    size_t mask = 0;
    cave*[] connections;
}

void main(string[] args) {
    cave[string] caves;
    auto input = readText(args[1]).strip;
    foreach(conn; input.splitter)
    {
        string a, b;
        conn.formattedRead("%s-%s", &a, &b);
        cave *ap = a in caves;
        if(!ap) ap = &(caves[a] = cave(a));
        cave *bp = b in caves;
        if(!bp) bp = &(caves[b] = cave(b));
        ap.connections ~= bp;
        bp.connections ~= ap;
    }

    size_t ncaves;
    foreach(ref c; caves)
    {
        if(c.name[0] > 'Z')
            c.mask = (1 << ncaves++);
    }

    long trace(size_t visited, bool second, cave *cur)
    {
        if(cur.name == "end")
        {
            return 1;
        }
        if(cur.mask & visited)
        {
            if(cur.name == "start" || second)
                return 0;
            second = true;
        }
        else
            visited |= cur.mask;
        long result = 0;
        foreach(c; cur.connections)
            result += trace(visited, second, c);
        return result;
    }

    auto p1 = trace(0, true, &caves["start"]);
    auto p2 = trace(0, false, &caves["start"]);
    writeln("part1: ", p1);
    writeln("part2: ", p2);
}
