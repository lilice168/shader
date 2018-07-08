﻿// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "lilice/shader/Textures" {
	Properties {
		_Color ("CColor Tint", Color) =(1.0, 1.0, 1.0, 1.0)
		_MainTex ("Diffuse Texture", 2D) = "white"{}
		_SpecColor ("Specular Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_Shininess ("Shininess", Float) = 10
		_RimColor ("Rim Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_RimPower ("Rim Power", Range(0.1, 10.0)) = 3
	}
	SubShader {
		Pass{
			Tags{"LightMode" = "ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma exclude_renderers flash
			
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform float4 _Color;
			uniform float4 _SpecColor;
			uniform float4 _RimColor;
			uniform float _Shininess;
			uniform float _RimPower;
			
			uniform float4 _LightColor0;
			
			struct vertexInput{
					float4 vertex : POSITION;
					float3 normal : NORMAL;
					float4 texcoord : TEXCOORD0;
			};
			
			struct vertexOutput{
					float4 pos : SV_POSITION;
					float4 tex : TEXCOORD0;
					float4 posWorld : TEXCOORD1;
					float3 normalDir :TEXCOORD2;
			};
			
			vertexOutput vert(vertexInput v){
					vertexOutput o;
					
					o.posWorld = mul(unity_ObjectToWorld, v.vertex);
					o.normalDir = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
					o.pos = UnityObjectToClipPos(v.vertex);
					o.tex = v.texcoord;
					
					return o;
			}
			
			float4 frag(vertexOutput i) :COLOR{
			
					float3 normalDirection = i.normalDir;
					float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
					float3 lightDirection;
					float atten;
					
					if(_WorldSpaceLightPos0.w == 0.0){
						atten = 1.0;
						lightDirection = normalize(_WorldSpaceLightPos0.xyz);
					}
					else{
						float3 fragmentToLightSource = _WorldSpaceLightPos0.xyz - i.posWorld.xyz;
						float distance = length(fragmentToLightSource);
						atten = 1.0/distance;
						lightDirection = normalize(fragmentToLightSource);
					}
			
					float3 diffuseReflection = atten * _LightColor0.xyz * saturate(dot(normalDirection, lightDirection));
					float3 specularReflection = diffuseReflection * _SpecColor.xyz * pow(dot(reflect(-lightDirection, normalDirection), viewDirection), _Shininess);
					
					float rim = 1 - saturate(dot(viewDirection, normalDirection));
					float3 rimLighting = saturate(dot(normalDirection, lightDirection) * _RimColor.xyz * _LightColor0.xyz * pow(rim, _RimPower));
					
					float3 lightFinal = UNITY_LIGHTMODEL_AMBIENT.xyz + diffuseReflection + specularReflection + rimLighting;
					
					float4 tex =tex2D(_MainTex, i.tex.xy * _MainTex_ST.xy + _MainTex_ST.zw);
					
					return float4(tex.xyz * lightFinal * _Color.xyz, 1.0);
					

			}
			
			ENDCG
		}
		
		Pass{
			Tags{"LightMode" = "ForwardAdd"}
			Blend One One
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma exclude_renderers flash
			
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform float4 _Color;
			uniform float4 _SpecColor;
			uniform float4 _RimColor;
			uniform float _Shininess;
			uniform float _RimPower;
			
			uniform float4 _LightColor0;
			
			struct vertexInput{
					float4 vertex : POSITION;
					float3 normal : NORMAL;
					float4 texcoord : TEXCOORD0;
			};
			
			struct vertexOutput{
					float4 pos : SV_POSITION;
					float4 tex : TEXCOORD0;
					float4 posWorld : TEXCOORD1;
					float3 normalDir :TEXCOORD2;
			};
			
			vertexOutput vert(vertexInput v){
					vertexOutput o;
					
					o.posWorld = mul(unity_ObjectToWorld, v.vertex);
					o.normalDir = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
					o.pos = UnityObjectToClipPos(v.vertex);
					o.tex = v.texcoord;
					
					return o;
			}
			
			float4 frag(vertexOutput i) :COLOR{
			
					float3 normalDirection = i.normalDir;
					float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
					float3 lightDirection;
					float atten;
					
					if(_WorldSpaceLightPos0.w == 0.0){
						atten = 1.0;
						lightDirection = normalize(_WorldSpaceLightPos0.xyz);
					}
					else{
						float3 fragmentToLightSource = _WorldSpaceLightPos0.xyz - i.posWorld.xyz;
						float distance = length(fragmentToLightSource);
						atten = 1.0/distance;
						lightDirection = normalize(fragmentToLightSource);
					}
			
					float3 diffuseReflection = atten * _LightColor0.xyz * saturate(dot(normalDirection, lightDirection));
					float3 specularReflection = diffuseReflection * _SpecColor.xyz * pow(dot(reflect(-lightDirection, normalDirection), viewDirection), _Shininess);
					
					float rim = 1 - saturate(dot(viewDirection, normalDirection));
					float3 rimLighting = saturate(dot(normalDirection, lightDirection) * _RimColor.xyz * _LightColor0.xyz * pow(rim, _RimPower));
					
					float3 lightFinal = UNITY_LIGHTMODEL_AMBIENT.xyz + diffuseReflection + specularReflection + rimLighting;
					
					float4 tex =tex2D(_MainTex, i.tex.xy * _MainTex_ST.xy + _MainTex_ST.zw);
					
					return float4(tex.xyz * lightFinal * _Color.xyz, 1.0);

			}
			
			ENDCG
		}
	}
}
