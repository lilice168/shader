// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "lilice/shader/RimLight" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_SpecColor ("Specular Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_Spininess ("Shininess", Float) = 10
		_RimColor ("Rim Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_RimPower ("Rim Power", Range(0.1, 10.0)) = 3.0
	}
	SubShader {
		Pass{
			Tags{ "LightMode" = "ForwardBase" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			
			uniform float4 _Color;
			uniform float4 _SpecColor;
			uniform float4 _RimColor;
			uniform float  _Shininess;
			uniform float  _RimPower;
			
			uniform float4 _LightColor0;
			
			struct vertexInput{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};
			
			struct vertexOutput{
				float4 pos : SV_POSITION;
				float4 posWorld : TEXCOORD0;
				float3 normalDir : TEXCOORD1;
			};
			
			vertexOutput vert(vertexInput v){
				vertexOutput o;
				o.posWorld = mul(unity_ObjectToWorld, v.vertex);
				o.normalDir = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
				o.pos = UnityObjectToClipPos(v.vertex);
				return o;
			}
			float4 frag(vertexOutput i) : COLOR
			{
				float3 normalDirection = i.normalDir;
				float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
				float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz); 
				float atten = 1.0;
				
				//lighting
				float3 diffuseReflection = atten * _LightColor0.xyz * saturate(dot(normalDirection, lightDirection));
				float3 specularReflection = atten * _LightColor0.xyz * saturate(dot(normalDirection, lightDirection)) * pow(1-saturate(dot(reflect(-lightDirection, normalDirection),viewDirection)), _Shininess);
				//float3 specularReflection = atten* _SpecColor.rgb * max(0.0f, dot(normalDirection, lightDirection)) * pow(max(0.0f, dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);
				
			
				float rim = 1 - saturate(dot(normalize(viewDirection), normalDirection));
				float rimLighting = atten * _LightColor0.xyz * _RimColor * saturate(dot(normalDirection, lightDirection)) * pow(rim, _RimPower);
				
				float3 lightFinal = rimLighting + diffuseReflection + specularReflection + UNITY_LIGHTMODEL_AMBIENT.rgb;
				
				//float3 lightFinal = rimLighting + diffuseReflection ;
				
				return float4(lightFinal * _Color.xyz, 1.0);
			}
			
			ENDCG
		}
	} 
	//FallBack "Diffuse"
}
