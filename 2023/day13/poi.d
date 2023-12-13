import std.stdio;
import std.file : readText;
import std.algorithm;
import std.range;
import std.conv;
import std.string;
import std.format;
import std.ascii;
import std.math;
import std.traits;

void main(string[] args)
{
    auto input = readText(args[1]).splitter('\n').array;
    if(input[$-1].length != 0)
        input ~= "";

    char[][] section;
    char[][] transposed;
    size_t part1;
    size_t part2;
    foreach(i; input)
    {
        if(i.length == 0)
        {
            size_t curv = 0;
            size_t reflectionPoint(char[][] sec, size_t forbidden)
            {
                size_t w = sec[0].length;
                foreach(x; 1 .. w)
                {
                    if(forbidden == x)
                        continue;
                    bool good = true;
                    foreach(l; sec)
                    {
                        size_t check = min(x, w - x);
                        if(!equal(l[x .. x + check], l[x - check .. x].retro))
                        {
                            good = false;
                            break;
                        }
                    }
                    if(good)
                    {
                        return x;
                    }
                }
                return 0;
            }
            if(auto v = reflectionPoint(section, 0))
                part1 += curv = v;
            else if(auto v = reflectionPoint(transposed, 0))
                part1 += curv = 100 * v;

            // swap every character, until we find a line
part2loop:
            foreach(x; 0 .. section[0].length)
                foreach(y; 0 .. section.length)
                {
                    char cur = section[y][x];
                    char newc = cur == '.' ? '#' : '.';
                    section[y][x] = transposed[x][y] = newc;
                    if(auto v = reflectionPoint(section, curv))
                    {
                        part2 += v;
                        break part2loop;
                    }
                    else if(auto v = reflectionPoint(transposed, curv / 100))
                    {
                        part2 += 100 * v;
                        break part2loop;
                    }
                    section[y][x] = transposed[x][y] = cur;
                }
            section = null;
            transposed = null;
        }
        else
        {
            if(transposed.length == 0)
            {
                transposed = repeat(cast(char[])null, i.length).array;
            }
            section ~= i.dup;
            foreach(idx, c; i)
            {
                transposed[idx] ~= c;
            }
        }
    }
    writeln(part1);
    writeln(part2);
}
