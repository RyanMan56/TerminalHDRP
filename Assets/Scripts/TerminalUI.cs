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
    public int terminalId;
    public GameObject elements;
    private MouseActions prevMouseActions;


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
            MouseActions mouseActions = cursor.UpdateCursor(elements);
            if (prevMouseActions != null && mouseActions != prevMouseActions)
            {
                if (prevMouseActions.hoveredElement != mouseActions.hoveredElement)
                {
                    if (prevMouseActions.hoveredElement)
                    {
                        prevMouseActions.hoveredElement.SendMessage("SetHovering", false);
                    }
                    if (mouseActions.hoveredElement)
                    {
                        mouseActions.hoveredElement.SendMessage("SetHovering", true);
                    }
                }
            }            

            prevMouseActions = new MouseActions(mouseActions.hoveredElement, mouseActions.selectedElements, mouseActions.elementToOpen);
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
