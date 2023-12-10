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
    auto lights = new bool[][](1000, 1000);
    auto brightness = new int[][](1000, 1000);
    foreach(inst; input)
    {
        string action;
        int x1, y1, x2, y2;
        size_t firstnum = inst.countUntil!isDigit;
        action = inst[0 .. firstnum - 1];
        inst[firstnum .. $].formattedRead("%s,%s through %s,%s", x1, y1, x2, y2);
        switch(action)
        {
            case "turn on":
                foreach(x; x1 .. x2 + 1)
                {
                    lights[x][y1 .. y2 + 1] = true;
                    brightness[x][y1 .. y2 + 1] += 1;
                }
                break;
            case "turn off":
                foreach(x; x1 .. x2 + 1)
                {
                    lights[x][y1 .. y2 + 1] = false;
                    foreach(y; y1 .. y2 + 1)
                        if(brightness[x][y]) brightness[x][y] -= 1;
                }
                break;
            case "toggle":
                foreach(x; x1 .. x2 + 1)
                {
                    brightness[x][y1 .. y2 + 1] += 2;
                    foreach(y; y1 .. y2 + 1)
                        lights[x][y] = !lights[x][y];
                }
                break;
            default:
                assert(0);
        }
    }
    writeln(lights.joiner.sum);
    writeln(brightness.joiner.sum);
}
