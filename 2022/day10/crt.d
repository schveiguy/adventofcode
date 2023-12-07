import std.stdio;
import std.algorithm;
import std.file : readText;
import std.conv;
import std.format;
import std.string;
import std.range;

void main(string[] args)
{
    auto input = readText(args[1]).strip.split('\n');
    int x = 1;
    int pc = 0;
    bool adding = false;
    int addend = 0;
    int p1;
    auto significants = [20, 60, 100, 140, 180, 220];
    int cycle = 0;
    while(true)
    {
        ++cycle;
        // draw the pixel on the screen
        if((cycle - 1) % 40 >= x - 1 && (cycle - 1) % 40 <= x + 1)
            write('#');
        else
            write(' ');
        if(significants.canFind(cycle))
            p1 += x * cycle;
        if(cycle % 40 == 0)
            writeln;
        if(adding)
        {
            x += addend;
            adding = false;
        }
        else if(pc < input.length)
        {
            if(input[pc] == "noop")
                ++pc;
            else // dddx v
            {
                addend = input[pc][5 .. $].to!int;
                adding = true;
                ++pc;
            }
        }
        else
        {
            // out of input
            break;
        }
    }
    writeln("part1: ", p1);
}
