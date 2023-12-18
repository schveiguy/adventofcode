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

struct Vec
{
    long x;
    long y;

    Vec opBinary(string op : "+")(Vec o) => Vec(x + o.x, y + o.y);
    Vec opBinary(string op : "-")(Vec o) => Vec(x - o.x, y - o.y);
    Vec opOpAssign(string op)(Vec o) if(op == "-" || op == "+") => mixin("this = this ", op, " o");
    Vec opBinary(string op : "*")(long o) => Vec(x * o, y * o);
    Vec opBinaryRight(string op : "*")(long o) => Vec(x * o, y * o);
    Vec opOpAssign(string op : "*")(long o) => this = this * o;
    Vec opUnary(string op : "-")() => Vec(-x, -y);
    Vec left() => Vec(y, -x);
    Vec right() => Vec(-y, x);
    long length() => abs(x) + abs(y);
}

enum dir : Vec {
    U = Vec(0, -1),
    D = Vec(0, 1),
    L = Vec(-1, 0),
    R = Vec(1, 0)
}

void main(string[] args)
{
    auto input = readText(args[1]).splitter('\n').filter!(v => !v.empty).array;
    // this is the code I used to solve part 1, but obviously would not do for part 2.
    version(original) {
        bool[Vec] filled;
        Vec lastDir;
        Vec lastPos;
        int rightTurns = 0;
        filled[lastPos] = true;
        foreach(inst; input)
        {
            dir newdir;
            int cnt;
            int color;
            inst.formattedRead("%s %s (#%x)", newdir, cnt, color);
            if(lastDir.right == newdir)
                ++rightTurns;
            else if(lastDir.left == newdir)
                --rightTurns;
            lastDir = newdir;
            foreach(i; 0 .. cnt)
            {
                filled[lastPos += newdir] = true;
            }
        }

        // fill in the inside
        lastPos = Vec(0, 0);
        Vec[] edges;
        void addEdge(Vec pos)
        {
            if(pos in filled)
                return;
            filled[pos] = true;
            edges ~= pos;
        }
        foreach(inst; input)
        {
            dir newdir;
            int cnt;
            int color;
            inst.formattedRead("%s %s (#%x)", newdir, cnt, color);
            addEdge(lastPos + (rightTurns > 0 ? newdir.right : newdir.left));
            foreach(i; 0 .. cnt)
            {
                lastPos += newdir;
                addEdge(lastPos + (rightTurns > 0 ? newdir.right : newdir.left));
            }
        }

        while(edges.length > 0)
        {
            auto oldedges = edges;
            edges = null;
            foreach(e; oldedges)
            {
                addEdge(e + dir.L);
                addEdge(e + dir.U);
                addEdge(e + dir.D);
                addEdge(e + dir.R);
            }
        }
        writeln(filled.length);
    }

    // find all y coordinates where turns happen
    static struct Line {
        Vec start;
        Vec end;
        Vec d;
        long top()
        {
            return d == dir.D ? start.y : end.y;
        }
        long bottom()
        {
            return d == dir.U ? start.y : end.y;
        }

        void reverse()
        {
            swap(start, end);
            d = -d;
        }
    }

    long solve(Line[] lines)
    {
        bool[long] ypos;
        ypos[0] = true;
        // see if we are right handed or left handed
        Vec lastdir = lines[$-1].d;
        int rightTurns = 0;
        foreach(ln; lines)
        {
            if(ln.d == lastdir.right) ++rightTurns;
            else --rightTurns;
            lastdir = ln.d;
            // keep all the y endpoints, along with one greater or one less, since the horizontal lines are special.
            ypos[ln.top] = true;
            ypos[ln.top + 1] = true;
            ypos[ln.top - 1] = true;
        }

        if(rightTurns < 0)
        {
            // swap all the endpoints/directions so it's right-handed
            foreach(ref l; lines)
                l.reverse;
        }

        long total = 0;

        // add all horizontal lines where the vertical line that hooks to it on
        // the left side is going down. These lines would not be counted in the
        // later algorithm, because lines going down turn off the counting.
        foreach(i; 0 .. lines.length)
        {
            Line cur = lines[i];
            Line prev = lines[(i + ($-1)) % $];
            Line next = lines[(i + 1) % $];
            if((cur.d == dir.L && next.d == dir.D) || (cur.d == dir.R && prev.d == dir.D))
                // the -1 is because the vertical lines handle the ends of the horizontal line.
                total += (cur.start - cur.end).length - 1;
        }

        // keep only the vertical lines.
        lines = lines.filter!(ln => ln.d == dir.U || ln.d == dir.D).array;

        // sort by x
        lines.sort!((a, b) => a.start.x < b.start.x);

        // sort the list of y values to check
        long[] ylist = ypos.keys.sort.release;
        long lasty = ylist[0];
        long n = 0;
        foreach(y; ylist)
        {
            //writefln("%s: adding %s x %s", y, n, (y - lasty));
            total += n * (y - lasty);
            Line prev;
            n = 0;
            foreach(ln; lines.filter!(a => a.top <= y && a.bottom >= y))
            {
                // the previous line was going up, so everything to its right gets counted
                if(prev.d == dir.U)
                {
                    //writefln("adding inside stuff from %s to %s", lastx, ln.start.x);
                    n += ln.start.x - prev.start.x;
                }
                else // down line
                {
                    ++n; // count the edge
                }
                prev = ln;
            }
            lasty = y;
        }
        // always add the last piece.
        return total + n;
    }

    long part1()
    {
        Line[] lines;
        Vec pos;
        foreach(inst; input)
        {
            dir newdir;
            int cnt;
            int color;
            inst.formattedRead("%s %s (#%x)", newdir, cnt, color);
            lines ~= Line(pos, pos + (cnt * newdir), newdir);
            pos += cnt * newdir;
        }
        return solve(lines);
    }
    long part2()
    {
        Line[] lines;
        Vec pos;
        dir[] realdirs = [dir.R, dir.D, dir.L, dir.U];
        foreach(inst; input)
        {
            dir newdir;
            int cnt;
            int color;
            inst.formattedRead("%s %s (#%x)", newdir, cnt, color);
            // ignore cnt and dir
            newdir = realdirs[color & 0x0f];
            cnt = color >> 4;
            lines ~= Line(pos, pos + (cnt * newdir), newdir);
            pos += cnt * newdir;
        }
        return solve(lines);
    }
    writeln(part1());
    writeln(part2());
}
