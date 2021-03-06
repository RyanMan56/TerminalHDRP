﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Monitor : MonoBehaviour
{
    public GameObject screen;
    public Transform cameraTarget;
    private GameObject player;
    private PlayerController playerController;
    public GameObject ui;
    public TerminalUI terminalUI;
    public bool on = true;
    public bool carried = false;
    public int terminalId;

    // Start is called before the first frame update
    void Start()
    {
        player = GameObject.Find("Player");
        playerController = player.GetComponent<PlayerController>();
        terminalUI = ui.GetComponent<TerminalUI>();
        terminalUI.terminalId = terminalId;
    }

    // Update is called once per frame
    void Update()
    {
        if (playerController.canMove)
        {
            CheckTouchStart();
        }
    }

    void CheckTouchStart()
    {
        if (on)
        {
            if (Input.GetMouseButtonDown(0) && !carried)
            {
                Ray ray = Camera.main.ScreenPointToRay(new Vector2((Screen.width - 1) / 2, (Screen.height - 1) / 2));
                RaycastHit hit;
                int layerMask = ~(1 << 11); // Layer 11 is "Terminal UI"
                if (Physics.Raycast(ray, out hit, 1.5f, layerMask))
                {
                    if (hit.collider.Equals(screen.GetComponent<MeshCollider>()))
                    {
                        playerController.SetUsingTerminal(true, this);
                        terminalUI.UsingTerminal(true);

                    }
                }
            }
        }
    }    
}
