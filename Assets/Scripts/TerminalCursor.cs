using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TerminalCursor : MonoBehaviour
{
    public Transform bottomLeft;
    public Transform topRight;
    private float mouseSpeed = 2.75f;
    public AudioSource clickIn1;
    public AudioSource clickOut1;
    public AudioSource clickIn2;
    public AudioSource clickOut2;
    public SpriteRenderer highlight;

    public Vector3? mouseDownPosition = null; // world position

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public Transform MoveCursor()
    {
        float dx = Input.GetAxis("Mouse X") * mouseSpeed * Time.deltaTime;
        float dy = Input.GetAxis("Mouse Y") * mouseSpeed * Time.deltaTime;

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

    public void Drag()
    {
        Vector3 distance = transform.position - mouseDownPosition.Value;
        highlight.size = new Vector2(distance.x / highlight.transform.localScale.x, distance.y / highlight.transform.localScale.y);
        highlight.transform.localPosition = transform.localPosition - new Vector3(distance.x / 2, distance.y / 2);
    }
}
