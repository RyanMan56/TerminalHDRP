using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class TerminalUIFolder : MonoBehaviour
{
    public string folderName;
    public TMP_Text text;

    // Start is called before the first frame update
    void Start()
    {
        text.text = folderName;
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
