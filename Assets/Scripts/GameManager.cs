using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{
    private float timeUntilLightShuffle = 2.0f;
    public Transform serverRoom;
    private FlashServerLights[] servers;

    // Start is called before the first frame update
    void Start()
    {
        SetupFileSystems();
        LoadFileSystems();

        servers = FindObjectsOfType<FlashServerLights>();
    }

    void SetupFileSystems()
    {
        TerminalFile helloWorld = new TerminalFile("Hello World!", "This is the first file ever made in this universe, hello world.");
        TerminalFolder desktop = new TerminalFolder("Desktop", null, new TerminalFile[] { helloWorld });
        TerminalDrive c = new TerminalDrive("C", new TerminalFolder[] { desktop });
        TerminalFileSystem terminal1 = new TerminalFileSystem(1, new TerminalDrive[] { c });

        SaveSystem.SaveFileSystem(terminal1);
    }

    void LoadFileSystems()
    {
        TerminalFileSystem terminal1 = SaveSystem.LoadFileSystem(1);
    }

    // Update is called once per frame
    void Update()
    {
        timeUntilLightShuffle -= Time.deltaTime;
        if (timeUntilLightShuffle < 0)
        {
            foreach (FlashServerLights server in servers)
            {
                server.RandomiseLights();
            }
            timeUntilLightShuffle = 2.0f;
        }
    }
}
