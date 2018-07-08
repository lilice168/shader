// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "lilice/shader/FlatColor"{
	Properties{
		_Color ("Color", Color) = (1.0, 1.0, 1.0, 1.0)
	}
	SubShader{
	
		Pass{
			CGPROGRAM

			//pragmas
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			
			//variables
			uniform float4 _Color;
			
			//structs
			struct vertexInput{
				float4 vertex :POSITION;
			};
			
			struct vertexOutput{
				float4 pos :SV_POSITION;
			};
			
			//vertex function
			vertexOutput vert(vertexInput v)
			{
				vertexOutput o;
				o.pos = UnityObjectToClipPos(v.vertex);
				
				return o;
			}
			
			//fragment funciton
			float4 frag(vertexOutput i):COLOR
			{
				return _Color;
			}
			
			ENDCG
		}
	}
	
	//fallback "Diffuse"
}