import std.stdio;
import std.algorithm;
import std.file : readText;
import std.conv;
import std.format;
import std.string;

size_t startPacket(string msg)
{
outer:
    foreach(i; 0 .. msg.length - 3)
    {
        auto header = msg[i .. i + 4];
        foreach(j; 0 .. 3)
        {
            foreach(k; j+1 .. 4)
            {
                if(header[j] == header[k])
                    continue outer;
            }
        }
        return i+4;
    }
    return -1;
}

size_t startMessage(string msg)
{
outer:
    foreach(i; 0 .. msg.length - 13)
    {
        auto header = msg[i .. i + 14];
        foreach(j; 0 .. 13)
        {
            foreach(k; j+1 .. 14)
            {
                if(header[j] == header[k])
                    continue outer;
            }
        }
        return i+14;
    }
    return -1;
}

void main(string[] args)
{
    auto str = args[1];
    writeln("part1: ", startPacket(str));
    writeln("part2: ", startMessage(str));
}
