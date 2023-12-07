import std.stdio;
import std.algorithm;
import std.file : readText;
import std.conv;
import std.format;
import std.string;
import std.range;
import std.math;

void main(string[] args)
{
    auto input = readText(args[1]).strip.split('\n');
    static struct pos { int x, y; }
    bool[pos] p1;
    bool[pos] p2;
    pos head;
    pos[9] tail = head;
    p1[tail[0]] = true;
    p2[tail[8]] = true;
    enum Dir : pos {
        R = pos(1, 0),
        L = pos(-1, 0),
        U = pos(0, 1),
        D = pos(0, -1)
    }

    void printboard()
    {
        char[pos] items;
        items[pos(0, 0)] = 's';
        foreach_reverse(i, p; tail)
        {
            items[p] = cast(char)('1'+i);
        }
        items[head] = 'H';
        pos hi, lo;
        foreach(p; items.byKey)
        {
            hi.x = max(hi.x, p.x);
            hi.y = max(hi.y, p.y);
            lo.x = min(lo.x, p.x);
            lo.y = min(lo.y, p.y);
        }

        writeln("board:");
        foreach_reverse(y; lo.y .. hi.y + 1)
        {
            foreach(x; lo.x .. hi.x + 1)
            {
                write(items.get(pos(x, y), '.'));
            }
            writeln;
        }
    }
    foreach(m; input)
    {
        Dir d;
        int cnt;
        m.formattedRead("%s %s", &d, &cnt);
        foreach(i; 0 .. cnt)
        {
            head.x += d.x;
            head.y += d.y;
            pos *h = &head;
            foreach(ref t; tail)
            {
                int dx = h.x - t.x;
                int dy = h.y - t.y;
                if(abs(dx) == 2)
                {
                    t.x += dx/2;
                    if(abs(dy) == 2)
                        t.y += dy/2;
                    else
                        t.y = h.y;
                }
                else if(abs(dy) == 2)
                {
                    t.y += dy/2;
                    t.x = h.x;
                }
                h = &t;
            }
            p1[tail[0]] = true;
            p2[tail[8]] = true;
        }
        //printboard();
    }
    writeln("part1: ", p1.length);
    writeln("part2: ", p2.length);
}
