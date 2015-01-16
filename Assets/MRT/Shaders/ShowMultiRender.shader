Shader "Custom/ShowMultiRender" {
	Properties {
		_nTex("normal", 2D) = "white"{}
		_pTex("position", 2D) = "white"{}
		_cTex("color", 2D) = "white"{}
		_gTex("glow", 2D) = "white"{}
	}
	CGINCLUDE
		#include "UnityCG.cginc"
 
		sampler2D _nTex,_pTex,_cTex,_gTex;
		half4 _MainTex_TexelSize;
			
			struct appdata
			{
				float4 vertex : POSITION;
			};
			
			struct v2f {
				float4 vertex : SV_POSITION;
				float4 uv : TEXCOORD0;
			};
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = v.vertex;
				o.uv = (v.vertex+1.0)/2.0;
				return o;
			}
			
			half4 frag (v2f i):COLOR
			{
				half t = _Time.w;
				half3 n = tex2D(_nTex, i.uv).xyz;
				half3 pos = tex2D(_pTex, i.uv).xyz;
				half3 lPos = half3(sin(t*6),frac(t)*2-1,cos(t*6));
				half3 d = pos - half3(sin(t*6),frac(t)*2-1,cos(t*6));
				float l = dot(n,normalize(d))/length(d)*length(d);
				return l;
			}
		ENDCG
	
		SubShader {
			Tags { "RenderType"="Opaque" }
			ZTest Always
			ZWrite On
			Cull Back
		
		
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma glsl
			ENDCG
		}
	} 
}
