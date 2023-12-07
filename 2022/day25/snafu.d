import std.stdio;
import std.algorithm;
import std.file : readText;
import std.conv;
import std.format;
import std.string;
import std.range;
import std.array;
import std.math;
import std.traits;

void main(string[] args)
{
    auto input = readText(args[1]).strip.split;
    long readSnafu(string s)
    {
        long result = 0;
        foreach(c; s)
        {
            result *= 5;
            final switch(c) {
            case '=':
                result -= 2;
                break;
            case '-':
                result -= 1;
                break;
            case '0':
            case '1':
            case '2':
                result += (c - '0');
                break;
            }
        }
        return result;
    }

    long sum;
    foreach(ln; input)
    {
        auto n = readSnafu(ln);
        //writefln("ln: %s, snafu: %s", ln, readSnafu(ln));
        sum += n;
    }

    char[] makeSnafu(long val)
    {
        char[] result;
        while(val)
        {
            final switch(val % 5)
            {
            case 0:
            case 1:
            case 2:
                result ~= char('0' + val % 5);
                val -= val % 5;
                break;
            case 3:
                result ~= '=';
                val += 2;
                break;
            case 4:
                result ~= '-';
                val += 1;
                break;
            }
            assert(val % 5 == 0);
            val /= 5;
        }
        result.reverse;
        return result;
    }

    writeln("part1: ", makeSnafu(sum));
}
