using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MouseActions
{
    public List<GameObject> hoveredElements;
    public List<GameObject> selectedElements;
    public GameObject elementToOpen;

    public MouseActions(List<GameObject> hoveredElements, List<GameObject> selectedElements, GameObject elementToOpen)
    {
        this.hoveredElements = hoveredElements;
        this.selectedElements = selectedElements;
        this.elementToOpen = elementToOpen;
    }
}

public class TerminalCursor : MonoBehaviour
{
    public Transform bottomLeft;
    public Transform topRight;
    //private float mouseSpeed = 2.75f;
    private float mouseSpeed = 0.275f;
    public AudioSource clickIn1;
    public AudioSource clickOut1;
    public AudioSource clickIn2;
    public AudioSource clickOut2;
    public SpriteRenderer highlight;
    private int cursorLayerMask = 9;
    private int canvasLayerMask = 10;

    public Vector3? mouseDownPosition = null; // world position

    public MouseActions UpdateCursor(GameObject elements)
    {
        List<GameObject> selectedElements = new List<GameObject>();

        MoveCursor();
        Click();
        selectedElements = Drag(elements);

        MouseActions mouseActions = new MouseActions(null, selectedElements, null);
        return mouseActions;
    }

    public Transform MoveCursor()
    {
        float dx = Input.GetAxis("Mouse X") * mouseSpeed;
        float dy = Input.GetAxis("Mouse Y") * mouseSpeed;

        transform.Translate(new Vector3(dx * mouseSpeed, dy * mouseSpeed, 0), Space.Self);
        float newX = transform.localPosition.x > topRight.localPosition.x
            ? topRight.localPosition.x
            : transform.localPosition.x < bottomLeft.localPosition.x
                ? bottomLeft.localPosition.x
                : transform.localPosition.x;
        float newY = transform.localPosition.y > topRight.localPosition.y
            ? topRight.localPosition.y
            : transform.localPosition.y < bottomLeft.localPosition.y
                ? bottomLeft.localPosition.y
                : transform.localPosition.y;
        Vector3 newLocalPos = new Vector3(newX, newY, transform.localPosition.z);
        if (!transform.localPosition.Equals(newLocalPos))
        {
            transform.localPosition = newLocalPos;
        }

        return transform;
    }

    public void Click()
    {
        if (Input.GetMouseButtonDown(0) || Input.GetMouseButtonDown(1))
        {
            bool randomBool = (Random.value > 0.5f);
            if (randomBool)
            {
                clickIn1.Play();
            }
            else
            {
                clickIn2.Play();
            }
        }
        if (Input.GetMouseButtonUp(0) || Input.GetMouseButtonUp(1))
        {
            bool randomBool = (Random.value > 0.5f);
            if (randomBool)
            {
                clickOut1.Play();
            }
            else
            {
                clickOut2.Play();
            }
        }

        if (Input.GetMouseButtonDown(0))
        {
            mouseDownPosition = transform.position; // world position
        }
        if (Input.GetMouseButtonUp(0))
        {
            mouseDownPosition = null;
            highlight.size = Vector2.zero;
        }
    }

    public List<GameObject> Drag(GameObject elements)
    {
        if (mouseDownPosition.HasValue)
        {
            Vector3 distance = transform.position - mouseDownPosition.Value;
            highlight.size = new Vector2(distance.x / highlight.transform.localScale.x, distance.y / highlight.transform.localScale.y);
            Vector3 newHighlightLocalPosition = transform.localPosition - new Vector3(distance.x / 2, distance.y / 2);
            highlight.transform.localPosition = new Vector3(newHighlightLocalPosition.x, newHighlightLocalPosition.y, highlight.transform.localPosition.z);
            Bounds highlightBounds = new Bounds(transform.position, highlight.size);

            List<GameObject> selectedElements = new List<GameObject>();
            foreach (GameObject e in elements.transform)
            {
                if (highlightBounds.Contains(e.transform.position))
                {
                    selectedElements.Add(e);
                }
            }

            return selectedElements;
        }

        return null;
    }

    public RaycastHit? Raycast()
    {
        // Check raycast against all layers except cursorLayerMask
        int layerMask = ~(1 << cursorLayerMask | 1 << canvasLayerMask);

        RaycastHit hit;
        if (Physics.Raycast(transform.position, transform.TransformDirection(Vector3.back), out hit, 1.0f, layerMask))
        {
            return hit;
        }

        return null;
    }
}
