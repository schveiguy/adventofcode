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
    auto input = readText(args[1]).split('\n');
    bool[size_t][size_t] sym;
    int[size_t][size_t] gears;
    int gearnum = 0;
    foreach(r, l; input)
    {
        foreach(c, p; l)
        {
            if(!isDigit(p) && p != '.')
            {
                sym[r-1][c-1] = true;
                sym[r-1][c] = true;
                sym[r-1][c+1] = true;
                sym[r][c-1] = true;
                sym[r][c+1] = true;
                sym[r+1][c-1] = true;
                sym[r+1][c] = true;
                sym[r+1][c+1] = true;
            }
            if(p == '*')
            {
                ++gearnum;
                gears[r-1][c-1] = gearnum;
                gears[r-1][c] = gearnum;
                gears[r-1][c+1] = gearnum;
                gears[r][c-1] = gearnum;
                gears[r][c+1] = gearnum;
                gears[r+1][c-1] = gearnum;
                gears[r+1][c] = gearnum;
                gears[r+1][c+1] = gearnum;
            }
        }
    }

    int sum = 0;
    int[][int] gearlist;
    foreach(r, l; input)
    {
        l ~= '.';
        string n = "";
        bool nextToSymbol = false;
        gearnum = 0;
        foreach(c, p; l)
        {
            if(isDigit(p))
            {
                n ~= p;
                nextToSymbol = nextToSymbol || sym.require(r).require(c);
                if(gears.require(r).require(c))
                {
                    gearnum = gears[r][c];
                }
            }
            else
            {
                if(n.length > 0 && nextToSymbol)
                {
                    sum += n.to!int;
                    if(gearnum)
                        gearlist.require(gearnum) ~= n.to!int;
                }
                n = "";
                nextToSymbol = false;
                gearnum = 0;
            }
        }
    }
    writeln(sum);

    long part2 = 0;
    foreach(gl; gearlist)
    {
        if(gl.length == 2)
            part2 += gl[0] * gl[1];
    }
    writeln(part2);
}
