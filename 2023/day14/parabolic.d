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
    auto input = readText(args[1]).splitter('\n').filter!(v => !v.empty).map!(v => v.dup).array;
    size_t total = 0;
    size_t w = input[0].length;
    size_t h = input.length;
    foreach(x; 0 .. w)
    {
        size_t target = 0;
        foreach(y; 0 .. h)
        {
            if(input[y][x] == 'O')
            {
                total += h - target;
                target++;
            }
            else if(input[y][x] == '#')
                target = y + 1;
        }
    }
    writeln(total);

    // part 2
    char[][] parseinput()
    {
        return input.map!(v => v.dup).array;
    }
    char[][] board1 = parseinput;
    char[][] board2 = parseinput;

    void cycle(char[][] b)
    {
        // north
        foreach(x; 0 .. w)
        {
            long target = 0;
            foreach(y; 0 .. h)
            {
                if(b[y][x] == 'O')
                {
                    if(target != y)
                    {
                        b[target][x] = 'O';
                        b[y][x] = '.';
                    }
                    ++target;
                }
                else if(b[y][x] == '#')
                {
                    target = y + 1;
                }
            }
        }
        // west
        foreach(y; 0 .. h)
        {
            long target = 0;
            foreach(x; 0 .. w)
            {
                if(b[y][x] == 'O')
                {
                    if(target != x)
                    {
                        b[y][target] = 'O';
                        b[y][x] = '.';
                    }
                    ++target;
                }
                else if(b[y][x] == '#')
                {
                    target = x + 1;
                }
            }
        }
        // south
        foreach(x; 0 .. w)
        {
            long target = h - 1;
            foreach_reverse(y; 0 .. h)
            {
                if(b[y][x] == 'O')
                {
                    if(target != y)
                    {
                        b[target][x] = 'O';
                        b[y][x] = '.';
                    }
                    --target;
                }
                else if(b[y][x] == '#')
                {
                    target = y - 1;
                }
            }
        }
        // east
        foreach(y; 0 .. h)
        {
            long target = w - 1;
            foreach_reverse(x; 0 .. w)
            {
                if(b[y][x] == 'O')
                {
                    if(target != x)
                    {
                        b[y][target] = 'O';
                        b[y][x] = '.';
                    }
                    --target;
                }
                else if(b[y][x] == '#')
                {
                    target = x - 1;
                }
            }
        }
    }

    size_t cycles = 0;
    size_t cyclelength = 0;
    while(cycles < 1_000_000_000)
    {
        ++cycles;
        cycle(board1);
        cycle(board2);
        cycle(board2);
        if(board1 == board2)
        {
            // found a cycle
            do
            {
                cycle(board1);
                ++cyclelength;
            } while(board1 != board2);
            break;
        }
    }
    // jump through all the cycles, then do the last ones based on mod cyclelength.
    foreach(i; 0 .. (1_000_000_000 - cycles) % cyclelength)
    {
        cycle(board1);
    }
    size_t part2 = 0;
    foreach(x; 0 .. w)
    {
        foreach(y; 0 .. h)
        {
            if(board1[y][x] == 'O')
                part2 += h - y;
        }
    }
    writeln(part2);
}
