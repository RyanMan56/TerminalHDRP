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
    private MeshCollider iconSpriteRenderer;
    private BoxCollider boxCollider;
    private float boxColliderSizeZ = 0.1f;
    private float boxColliderPaddingY = 0.2f;
    public SpriteRenderer hoverSpriteRenderer, selectSpriteRenderer;

    // Start is called before the first frame update
    void Start()
    {       
        text.text = folderName;        
        
        textRectTransform = text.gameObject.GetComponent<RectTransform>();        
        textRectTransform.sizeDelta = new Vector2(textRectTransform.sizeDelta.x, text.GetPreferredValues().y);
        textRectTransform.localPosition = new Vector3(0, baseTextPos - textRectTransform.rect.height * textRectTransform.localScale.y / 2);

        iconSpriteRenderer = icon.GetComponent<MeshCollider>();
        // topLeft calculated from the width of the text
        Vector3 topLeft = icon.transform.localPosition - new Vector3(textRectTransform.rect.width * textRectTransform.localScale.x / 2, -iconSpriteRenderer.bounds.size.y * iconSpriteRenderer.transform.localScale.y / 2);
        Vector3 bottomRight = textRectTransform.transform.localPosition + new Vector3(textRectTransform.rect.width * textRectTransform.localScale.x / 2, -textRectTransform.rect.height * textRectTransform.localScale.y / 2);

        boxCollider = GetComponent<BoxCollider>();
        boxCollider.center = (topLeft + bottomRight) / 2;
        Vector3 size = topLeft - bottomRight;
        size.y = size.y + boxColliderPaddingY;
        size.z = boxColliderSizeZ;
        boxCollider.size = new Vector3(Mathf.Abs(size.x), Mathf.Abs(size.y), Mathf.Abs(size.z));
        
        hoverSpriteRenderer.transform.localPosition = new Vector3(boxCollider.center.x, boxCollider.center.y, hoverSpriteRenderer.transform.localPosition.z);
        hoverSpriteRenderer.size = new Vector2(boxCollider.size.x / hoverSpriteRenderer.transform.localScale.x, boxCollider.size.y / hoverSpriteRenderer.transform.localScale.y);
        hoverSpriteRenderer.enabled = false;

        selectSpriteRenderer.transform.localPosition = hoverSpriteRenderer.transform.localPosition;
        selectSpriteRenderer.size = hoverSpriteRenderer.size;
        selectSpriteRenderer.enabled = hoverSpriteRenderer.enabled;
    }

    // Update is called once per frame
    void Update()
    {
    }

    public void SetHovering(bool hovering)
    {
        this.hovered = hovering;
        hoverSpriteRenderer.enabled = hovering;
    }

    public void SetSelected(bool selected)
    {
        this.selected = selected;
        selectSpriteRenderer.enabled = selected;
    }
}
