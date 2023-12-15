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
    int part1 = 0;
    int part2 = 0;
    foreach(i; input)
    {
        part1 += i.length;
        bool escape = false;
        int n = 0;
        for(int idx = 1; idx + 1 < i.length; ++idx, ++n)
        {
            auto c = i[idx];
            if(c == '\\')
            {
                ++idx;
                if(i[idx] == 'x')
                {
                    idx += 2;
                }
            }
        }
        part1 -= n;

        // part 2
        part2 += 2 + i.count('\\') + i.count('"');
    }
    writeln(part1);
    writeln(part2);
}
