using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class TerminalFile
{
    public string name;
    public string contents;

    public TerminalFile(string name, string contents)
    {
        this.name = name;
        this.contents = contents;
    }
}
