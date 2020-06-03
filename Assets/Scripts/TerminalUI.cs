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
    public Transform cursor;
    private float mouseSpeed = 0.5f;


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
            MoveCursor();
        }
    }

    public void UsingTerminal(bool isUsing) {
        active = isUsing;
    }

    private void MoveCursor()
    {
        float dx = Input.GetAxis("Mouse X") * mouseSpeed;
        float dy = Input.GetAxis("Mouse Y") * mouseSpeed;

        cursor.Translate(new Vector3(dx * mouseSpeed, dy * mouseSpeed, 0), Space.Self);
        float newX = cursor.localPosition.x > topRight.localPosition.x
            ? topRight.localPosition.x
            : cursor.localPosition.x < bottomLeft.localPosition.x
                ? bottomLeft.localPosition.x
                : cursor.localPosition.x;
        float newY = cursor.localPosition.y > topRight.localPosition.y
            ? topRight.localPosition.y
            : cursor.localPosition.y < bottomLeft.localPosition.y
                ? bottomLeft.localPosition.y
                : cursor.localPosition.y;
        Vector3 newLocalPos = new Vector3(newX, newY, cursor.localPosition.z);
        if (!cursor.localPosition.Equals(newLocalPos))
        {
            cursor.localPosition = newLocalPos;
        }
    }


    Vector2 WorldToNormalized(Vector2 world)
    {
        Debug.Log($"world: {world}");
        float normalizedX = (world.x - bottomLeft.localPosition.x) / (topRight.localPosition.x - bottomLeft.localPosition.x);
        float normalizedY = (world.y - bottomLeft.localPosition.y) / (topRight.localPosition.y - bottomLeft.localPosition.y);

        Debug.Log($"nX: {normalizedX}, nY: {normalizedY}");        

        return new Vector2(normalizedX, normalizedY);
    }
}
