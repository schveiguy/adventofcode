import std.stdio;
import std.file : readText;
import std.algorithm;
import std.range;
import std.conv;
import std.string;
import std.format;
import std.ascii;
import std.utf;


void main(string[] args)
{
    auto input = args[1];
    static struct DigitString
    {
        char digit;
        size_t length;
    }
    void parse(ref DigitString[] str, string s)
    {
        foreach(c; s)
        {
            if(str.length == 0 || str[$-1].digit != c)
                str ~= DigitString(c, 1);
            else
                ++str[$-1].length;
        }
    }
    DigitString[] iterate(DigitString[] vals)
    {
        DigitString[] result;
        foreach(d; vals)
        {
            string s = format("%s%s", d.length, d.digit);
            parse(result, s);
        }
        return result;
    }
    DigitString[] state;
    parse(state, input);
    foreach(i; 0 .. 40)
    {
        state = iterate(state);
    }
    writeln(state.map!(v => v.length).sum);
    foreach(i; 0 .. 10)
    {
        state = iterate(state);
    }
    writeln(state.length);
    writeln(state.map!(v => v.length).sum);
}
