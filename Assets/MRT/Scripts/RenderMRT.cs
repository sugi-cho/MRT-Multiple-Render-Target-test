using UnityEngine;
using System.Collections;

[RequireComponent(typeof(Camera))]
public class RenderMRT : MonoBehaviour
{
	public RenderTexture[] rtMRT = new RenderTexture[4];
	public RenderTexture rtCmp;
	public Material compMat;
	RenderBuffer[] rbMRT = new RenderBuffer[4];

	void Start ()
	{
		for (int i = 0; i < rtMRT.Length; i++) {
			rtMRT [i] = new RenderTexture ((int)camera.pixelWidth, (int)camera.pixelHeight, 32, RenderTextureFormat.ARGBFloat);
			rtMRT [i].filterMode = FilterMode.Point;
			rtMRT [i].Create ();
			rbMRT [i] = rtMRT [i].colorBuffer;
		}
		rtCmp = CreateRenderTexture ((int)camera.pixelWidth, (int)camera.pixelHeight);
		compMat.SetTexture ("_nTex", rtMRT [0]);
		compMat.SetTexture ("_pTex", rtMRT [1]);
		compMat.SetTexture ("_cTex", rtMRT [2]);
		compMat.SetTexture ("_gTex", rtMRT [3]);
	}
	void OnDestroy ()
	{
		for (int i = 0; i < rtMRT.Length; i++) {
			ReleaseRenderTexture (rtMRT [i]);
		}
		ReleaseRenderTexture (rtCmp);
	}

	void OnPreRender ()
	{
		Graphics.SetRenderTarget (rbMRT, rtMRT [0].depthBuffer);

	}
	void OnPostRender ()
	{
		Graphics.SetRenderTarget (null);
		GL.Clear (true, true, Color.black);
		compMat.SetPass (0);
		DrawFullscreenQuad ();
		Graphics.SetRenderTarget (null);
	}
//	void OnRenderImage (RenderTexture s, RenderTexture d)
//	{
//		Graphics.Blit (rtCmp, d);
//	}
	
	static public void DrawFullscreenQuad (int pass = 0, float z=1.0f)
	{
		GL.Begin (GL.QUADS);
		GL.Vertex3 (-1.0f, -1.0f, z);
		GL.Vertex3 (1.0f, -1.0f, z);
		GL.Vertex3 (1.0f, 1.0f, z);
		GL.Vertex3 (-1.0f, 1.0f, z);
		
		GL.Vertex3 (-1.0f, 1.0f, z);
		GL.Vertex3 (1.0f, 1.0f, z);
		GL.Vertex3 (1.0f, -1.0f, z);
		GL.Vertex3 (-1.0f, -1.0f, z);
		GL.End ();
	}
	public static RenderTexture CreateRenderTexture (int width, int height)
	{
		RenderTexture rt = new RenderTexture (width, height, 0, RenderTextureFormat.ARGBHalf);
		rt.wrapMode = TextureWrapMode.Repeat;
		rt.filterMode = FilterMode.Bilinear;
		rt.Create ();
		RenderTexture.active = rt;
		GL.Clear (true, true, Color.clear);
		return rt;
	}
	public static void ReleaseRenderTexture (RenderTexture rt)
	{
		if (rt == null)
			return;
		rt.Release ();
		Object.Destroy (rt);
	}
}
