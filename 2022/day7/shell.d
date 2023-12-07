import std.stdio;
import std.algorithm;
import std.file : readText;
import std.conv;
import std.format;
import std.string;
import std.range;

enum Type
{
    file,
    dir
}

struct direntry {
    string name;
    Type type;
    size_t size;
    direntry *parent;
    direntry[string] children;

    size_t fillSizes()
    {
        if(type == Type.dir)
        {
            size = 0;
            foreach(ref ch; children)
                size += ch.fillSizes;
        }
        return size;
    }

    void toString(Out)(Out output, size_t indent = 0)
    {
        output.formattedWrite("%s%s (%s, size=%s)\n", repeat("  ", indent).joiner, name, type, size);
        foreach(ch; children)
            ch.toString(output, indent + 1);
    }
}

void main(string[] args)
{
    auto input = readText(args[1]).strip;
    direntry root;
    root.name = "/";
    root.type = Type.dir;
    direntry *cur = &root;
    foreach(ln; input.splitter('\n'))
    {
        if(ln[0] == '$') // command
        {
            string cmd = ln[2 .. 4];
            string dir = ln[4 .. $].strip;
            if(cmd == "cd")
            {
                // cd to a new directory
                if(dir == "..")
                {
                    if(cur.parent !is null)
                        cur = cur.parent;
                }
                else if(dir == "/")
                {
                    cur = &root;
                }
                else
                {
                    cur = &cur.children.require(dir, direntry(dir, Type.dir, 0, cur));
                }
            }
        }
        else
        {
            // a listing
            auto parts = ln.split;
            if(parts[0] == "dir")
            {
                cur.children.require(parts[1], direntry(parts[1], Type.dir, 0, cur));
            }
            else
            {
                cur.children[parts[1]] = direntry(parts[1], Type.file, parts[0].to!size_t, cur);
            }
        }
    }

    // construct the sizes
    root.fillSizes;
    //writeln(root);
    size_t p1;
    auto freespace = 70000000 - root.size;
    auto need = 30000000 - freespace;
    size_t p2 = root.size;
    void exec(ref direntry de) {
        if(de.type == Type.dir)
        {
            if(de.size <= 100000)
                p1 += de.size;
            if(de.size >= need && de.size < p2)
                p2 = de.size;
            foreach(ref ch; de.children)
                exec(ch);
        }
    }
    exec(root);
    writeln("part1: ", p1);
    writeln("part2: ", p2);
}
