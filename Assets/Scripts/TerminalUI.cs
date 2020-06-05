using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TerminalUI : MonoBehaviour
{
    public Transform bottomLeft;
    public Transform topRight;
    private float width;
    private float height;
    public bool active = false;
    public TerminalCursor cursor;


    // Start is called before the first frame update
    void Start()
    {
        width = topRight.localPosition.x - bottomLeft.localPosition.x;
        height = topRight.localPosition.y - bottomLeft.localPosition.y;
    }

    // Update is called once per frame
    void Update()
    {
        if (active)
        {
            cursor.MoveCursor();
            cursor.Click();
            if (cursor.mouseDownPosition.HasValue)
            {
                cursor.Drag();
            }
        }
    }

    public void UsingTerminal(bool isUsing) {
        active = isUsing;
    }


    Vector2 WorldToNormalized(Vector2 world)
    {
        float normalizedX = (world.x - bottomLeft.localPosition.x) / (topRight.localPosition.x - bottomLeft.localPosition.x);
        float normalizedY = (world.y - bottomLeft.localPosition.y) / (topRight.localPosition.y - bottomLeft.localPosition.y);

        return new Vector2(normalizedX, normalizedY);
    }
}
