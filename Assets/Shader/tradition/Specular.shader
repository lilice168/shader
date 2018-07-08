﻿// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "lilice/shader/Specular"{
	Properties{
		_Color("Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_SpecColor("Specular Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_Shininess("Shininess", Float) = 10
	}
	
	SubShader{
		Tags{ "LightMode" = "ForwardBase" }
		Pass{
			CGPROGRAM
			
			//pragmas
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			
			uniform float4 _Color;
			uniform float4 _SpecColor;
			uniform float _Shininess;
			
			uniform float4 _LightColor0;
			
			struct vertexInput{
				float4 vertex:POSITION;
				float3 normal:NORMAL;
			};
			
			struct vertexOutput{
				float4 pos:SV_POSITION;
				float4 col:COLOR;
			};
			
			vertexOutput vert(vertexInput v){
				vertexOutput o;
				
				//vertex function
				float3 normalDirection = mul(float4(v.normal, 0.0), unity_WorldToObject).xyz;
				float3 viewDirection = normalize(float3(float4(_WorldSpaceCameraPos.xyz, 1.0) - mul(unity_ObjectToWorld, v.vertex).xyz));
				float3 lightDirection;
				float  atten = 1.0f;
				
				//Lighting
				lightDirection = normalize(_WorldSpaceLightPos0.xyz);
				float3 diffuseReflection = atten * _LightColor0.xyz * max(0.0f, dot(normalDirection, lightDirection));
				float3 specularReflection = atten* _SpecColor.rgb * max(0.0f, dot(normalDirection, lightDirection)) * pow(max(0.0f, dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);
				float3 lightFinal = diffuseReflection + specularReflection + UNITY_LIGHTMODEL_AMBIENT.xyz;
				
				o.col = float4(lightFinal * _Color.rgb, 1.0);
				o.pos = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			float4 frag(vertexOutput i):COLOR{
				return i.col;
			}
			ENDCG
		}
	}
	
	//fallback "Diffuse"
}