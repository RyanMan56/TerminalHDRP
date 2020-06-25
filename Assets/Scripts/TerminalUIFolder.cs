using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class TerminalUIFolder : MonoBehaviour
{
    public string folderName;
    public TMP_Text text;
    public GameObject icon;
    public bool hovered, selected, open;
    private RectTransform textRectTransform;
    private float baseTextPos = -0.344f;
    private SpriteRenderer iconSpriteRenderer;
    private BoxCollider boxCollider;
    private float boxColliderSizeZ = 0.1f;
    private float boxColliderPaddingY = 0.2f;

    // Start is called before the first frame update
    void Start()
    {
        text.text = folderName;

        Canvas.ForceUpdateCanvases();
        textRectTransform = text.gameObject.GetComponent<RectTransform>();
        textRectTransform.localPosition = new Vector3(0, baseTextPos - textRectTransform.rect.height * textRectTransform.localScale.y / 2);

        iconSpriteRenderer = icon.GetComponent<SpriteRenderer>();
        // topLeft calculated from the width of the text
        Vector3 topLeft = icon.transform.localPosition - new Vector3(textRectTransform.rect.width * textRectTransform.localScale.x / 2, -iconSpriteRenderer.size.y * iconSpriteRenderer.transform.localScale.y / 2);
        Vector3 bottomRight = textRectTransform.transform.localPosition + new Vector3(textRectTransform.rect.width * textRectTransform.localScale.x / 2, -textRectTransform.rect.height * textRectTransform.localScale.y / 2);

        boxCollider = GetComponent<BoxCollider>();
        boxCollider.center = (topLeft + bottomRight) / 2;
        Vector3 size = topLeft - bottomRight;
        size.y = size.y + boxColliderPaddingY;
        size.z = boxColliderSizeZ;
        boxCollider.size = size;
    }    

    // Update is called once per frame
    void Update()
    {
        
    }
}
