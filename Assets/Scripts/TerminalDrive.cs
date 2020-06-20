using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class TerminalDrive
{
    public string name;
    public TerminalFolder[] folders;

    public TerminalDrive(string name, TerminalFolder[] folders)
    {
        this.name = name;
        this.folders = folders;
    }
}
