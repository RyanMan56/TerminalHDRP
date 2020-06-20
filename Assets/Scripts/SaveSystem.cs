using UnityEngine;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;

public static class SaveSystem
{
    public static void SaveFileSystem(TerminalFileSystem terminalFileSystem)
    {
        BinaryFormatter formatter = new BinaryFormatter();
        string path = Application.persistentDataPath + $"/{terminalFileSystem.id}.term";
        FileStream stream = new FileStream(path, FileMode.Create);

        formatter.Serialize(stream, terminalFileSystem);
        stream.Close();
    }

    public static TerminalFileSystem LoadFileSystem(int fileSystemId)
    {
        string path = Application.persistentDataPath + $"/{fileSystemId}.term";
        if (File.Exists(path))
        {
            BinaryFormatter formatter = new BinaryFormatter();
            FileStream stream = new FileStream(path, FileMode.Open);

            TerminalFileSystem data = formatter.Deserialize(stream) as TerminalFileSystem;
            stream.Close();

            return data;
        } else
        {
            Debug.LogError($"Save file not found in {path}");
            return null;
        }
    }
}
