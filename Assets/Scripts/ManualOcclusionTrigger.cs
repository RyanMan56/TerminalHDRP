using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ManualOcclusionTrigger : MonoBehaviour
{
    public Transform[] transforms;

    private void Start()
    {
        foreach (Transform t in transforms)
        {
            t.gameObject.SetActive(false);
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            foreach (Transform t in transforms)
            {
                t.gameObject.SetActive(true);
            }
        }
    }

    private void OnTriggerExit(Collider other)
    {
        Debug.Log("exit");
        if (other.gameObject.tag == "Player")
        {
            Debug.Log("Player exit");
            foreach (Transform t in transforms)
            {
                t.gameObject.SetActive(false);
            }
        }
    }
}
