using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FlashServerLights : MonoBehaviour
{
    public Transform topLights;
    public Transform bottomLights;
    private ArrayList topLightsMeshRenderers, bottomLightsMeshRenderers;
    public MeshRenderer rack;

    // Start is called before the first frame update
    void Start()
    {
        topLightsMeshRenderers = new ArrayList();
        bottomLightsMeshRenderers = new ArrayList();

        foreach (Transform topLight in topLights)
        {
            MeshRenderer meshRenderer = topLight.GetComponent<MeshRenderer>();
            topLightsMeshRenderers.Add(meshRenderer);
        }
        foreach (Transform bottomLight in bottomLights)
        {
            MeshRenderer meshRenderer = bottomLight.GetComponent<MeshRenderer>();
            bottomLightsMeshRenderers.Add(meshRenderer);
        }

        RandomiseLights();        
    }

    public void RandomiseLights()
    {
        if (rack.isVisible)
        {
            RandomiseLights(topLights, topLightsMeshRenderers);
            RandomiseLights(bottomLights, bottomLightsMeshRenderers);
        }
    }

    public void RandomiseLights(Transform section, ArrayList meshRenderers)
    {
        int count = section.childCount - 1;
        int maxLights = count / 2;
        ArrayList childIndexes = new ArrayList();
        while (childIndexes.Count < maxLights)
        {
            int num = Random.Range(0, count);
            if (!childIndexes.Contains(num))
            {
                childIndexes.Add(num);
            }
        }

        for (int i = 0; i < count; i++)
        {
            bool active = childIndexes.Contains(i);
            //section.GetChild(i).gameObject.SetActive(active);
            MeshRenderer meshRenderer = meshRenderers[i] as MeshRenderer;
            meshRenderer.enabled = active;
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
