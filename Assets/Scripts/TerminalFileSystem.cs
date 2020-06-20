using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class TerminalFileSystem
{
    public int id;
    public TerminalDrive[] drives;

    public TerminalFileSystem(int id, TerminalDrive[] drives)
    {
        this.id = id;
        this.drives = drives;
    }
}
