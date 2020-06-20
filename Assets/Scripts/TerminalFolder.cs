using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class TerminalFolder
{
    public string name;
    public TerminalFolder[] folders;
    public TerminalFile[] files;

    public TerminalFolder(string name, TerminalFolder[] folders, TerminalFile[] files)
    {
        this.name = name;
        this.folders = folders;
        this.files = files;
    }
}
