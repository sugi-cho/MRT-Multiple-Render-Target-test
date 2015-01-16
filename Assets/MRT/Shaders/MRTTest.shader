Shader "Custom/MRTTest" {
	Properties {
		_Color ("color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("texture", 2D) = "white" {}
	}
 
	CGINCLUDE
		#include "UnityCG.cginc"
		sampler2D _MainTex;
		fixed4 _Color;
		
		struct v2f {
			float4 pos : SV_POSITION;
			fixed4 color : COLOR;
			float4 wPos : TEXCOORD1;
			float3 normal : TEXCOORD2;
		};
		
		struct fOut{
			float4 normal:COLOR0;
			float4 position:COLOR1;
			float4 color:COLOR2;
			float4 glow:COLOR3;
			float depth:DEPTH;
		};
 
		v2f vert (appdata_full v)
		{
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.wPos = mul(_Object2World, v.vertex);
			o.normal = normalize(mul(_Object2World, float4(v.normal.xyz,0.0)).xyz);
			o.color = v.color;
			return o;
		}
			
		fOut frag (v2f i)
		{
			fOut o;
			o.normal = float4(i.normal,1);
			o.position = i.wPos;
			o.color = i.color;
			o.glow = 0.0;
			o.depth = 1.0;
			return o;
		}
	ENDCG
	
	SubShader {
		Pass {
			CGPROGRAM
			#pragma glsl
			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			ENDCG 
		}
	}
}