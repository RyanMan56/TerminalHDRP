﻿Shader "PBR Master"
{
	Properties
	{
		Color_46CEA66D("Base Color", Color) = (0.25178, 0.6139501, 0.7735849, 0)
		[NoScaleOffset]Texture2D_241AF3EA("Hologram Texture", 2D) = "white" {}
		Vector2_B2FA17D2("Hologram Texture Tiling", Vector) = (1, 3, 0, 0)
		Vector1_9ED319E4("Scroll Speed", Float) = 0.1
		Color_5451798F("Fresnel Color", Color) = (4.015687, 9.850981, 12.36078, 0)
		[NoScaleOffset]Texture2D_F72EB8A8("Texture", 2D) = "white" {}
		[NoScaleOffset]Texture2D_3CF11457("Texture Black & White", 2D) = "white" {}
	}
		SubShader
	{
		Tags
		{
			"RenderPipeline" = "HDRenderPipeline"
			"RenderType" = "Transparent"
			"Queue" = "Transparent+0"
			"IgnoreProjector" = "True"
		}

		Pass
		{
		// based on HDPBRPass.template
		Name "ShadowCaster"
		Tags { "LightMode" = "ShadowCaster" }

		//-------------------------------------------------------------------------------------
		// Render Modes (Blend, Cull, ZTest, Stencil, etc)
		//-------------------------------------------------------------------------------------
		Blend One Zero

		Cull Off


		ZWrite Off

		ZTest Equal



		ColorMask 0

		//-------------------------------------------------------------------------------------
		// End Render Modes
		//-------------------------------------------------------------------------------------

		HLSLPROGRAM

		#pragma target 4.5
		#pragma only_renderers d3d11 playstation xboxone vulkan metal switch
		//#pragma enable_d3d11_debug_symbols

		#pragma multi_compile_instancing
	#pragma instancing_options renderinglayer

		#pragma multi_compile _ LOD_FADE_CROSSFADE

		//-------------------------------------------------------------------------------------
		// Graph Defines
		//-------------------------------------------------------------------------------------
				// Shared Graph Keywords
			#define SHADERPASS SHADERPASS_SHADOWS
			// ACTIVE FIELDS:
			//   DoubleSided
			//   DoubleSided.Mirror
			//   FragInputs.isFrontFace
			//   features.NormalDropOffTS
			//   SurfaceType.Transparent
			//   BlendMode.Alpha
			//   AlphaFog
			//   SurfaceDescriptionInputs.ScreenPosition
			//   SurfaceDescriptionInputs.TangentSpaceNormal
			//   SurfaceDescriptionInputs.uv0
			//   SurfaceDescriptionInputs.TimeParameters
			//   VertexDescriptionInputs.ObjectSpaceNormal
			//   VertexDescriptionInputs.ObjectSpaceTangent
			//   VertexDescriptionInputs.ObjectSpacePosition
			//   SurfaceDescription.Alpha
			//   SurfaceDescription.AlphaClipThreshold
			//   VaryingsMeshToPS.cullFace
			//   SurfaceDescriptionInputs.WorldSpacePosition
			//   FragInputs.texCoord0
			//   AttributesMesh.normalOS
			//   AttributesMesh.tangentOS
			//   AttributesMesh.positionOS
			//   FragInputs.positionRWS
			//   VaryingsMeshToPS.texCoord0
			//   VaryingsMeshToPS.positionRWS
			//   AttributesMesh.uv0
		//-------------------------------------------------------------------------------------
		// End Defines
		//-------------------------------------------------------------------------------------

		//-------------------------------------------------------------------------------------
		// Variant Definitions (active field translations to HDRP defines)
		//-------------------------------------------------------------------------------------

		// #define _MATERIAL_FEATURE_SPECULAR_COLOR 1
		#define _SURFACE_TYPE_TRANSPARENT 1
		#define _BLENDMODE_ALPHA 1
		// #define _BLENDMODE_ADD 1
		// #define _BLENDMODE_PRE_MULTIPLY 1
		#define _DOUBLESIDED_ON 1
		#define _NORMAL_DROPOFF_TS	1
		// #define _NORMAL_DROPOFF_OS	1
		// #define _NORMAL_DROPOFF_WS	1

		//-------------------------------------------------------------------------------------
		// End Variant Definitions
		//-------------------------------------------------------------------------------------

		#pragma vertex Vert
		#pragma fragment Frag

		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"

		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"

		// define FragInputs structure
		#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
		#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"

		//-------------------------------------------------------------------------------------
		// Active Field Defines
		//-------------------------------------------------------------------------------------

		// this translates the new dependency tracker into the old preprocessor definitions for the existing HDRP shader code
		#define ATTRIBUTES_NEED_NORMAL
		#define ATTRIBUTES_NEED_TANGENT
		#define ATTRIBUTES_NEED_TEXCOORD0
		// #define ATTRIBUTES_NEED_TEXCOORD1
		// #define ATTRIBUTES_NEED_TEXCOORD2
		// #define ATTRIBUTES_NEED_TEXCOORD3
		// #define ATTRIBUTES_NEED_COLOR
		#define VARYINGS_NEED_POSITION_WS
		// #define VARYINGS_NEED_TANGENT_TO_WORLD
		#define VARYINGS_NEED_TEXCOORD0
		// #define VARYINGS_NEED_TEXCOORD1
		// #define VARYINGS_NEED_TEXCOORD2
		// #define VARYINGS_NEED_TEXCOORD3
		// #define VARYINGS_NEED_COLOR
		#define VARYINGS_NEED_CULLFACE
		// #define HAVE_MESH_MODIFICATION

		//-------------------------------------------------------------------------------------
		// End Defines
		//-------------------------------------------------------------------------------------


		#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
		#ifdef DEBUG_DISPLAY
			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
		#endif

		#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"

	#if (SHADERPASS == SHADERPASS_FORWARD)
		#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Lighting.hlsl"

		#define HAS_LIGHTLOOP

		#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
		#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
		#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoop.hlsl"
	#else
		#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
	#endif

		#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
		#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
		#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
		#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
		#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"

		//Used by SceneSelectionPass
		int _ObjectId;
		int _PassValue;

		//-------------------------------------------------------------------------------------
		// Interpolator Packing And Struct Declarations
		//-------------------------------------------------------------------------------------
		// Generated Type: AttributesMesh
		struct AttributesMesh
		{
			float3 positionOS : POSITION;
			float3 normalOS : NORMAL; // optional
			float4 tangentOS : TANGENT; // optional
			float4 uv0 : TEXCOORD0; // optional
			#if UNITY_ANY_INSTANCING_ENABLED
			uint instanceID : INSTANCEID_SEMANTIC;
			#endif // UNITY_ANY_INSTANCING_ENABLED
		};
		// Generated Type: VaryingsMeshToPS
		struct VaryingsMeshToPS
		{
			float4 positionCS : SV_POSITION;
			float3 positionRWS; // optional
			float4 texCoord0; // optional
			#if UNITY_ANY_INSTANCING_ENABLED
			uint instanceID : CUSTOM_INSTANCE_ID;
			#endif // UNITY_ANY_INSTANCING_ENABLED
			#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
			FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
			#endif // defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		};

		// Generated Type: PackedVaryingsMeshToPS
		struct PackedVaryingsMeshToPS
		{
			float4 positionCS : SV_POSITION; // unpacked
			#if UNITY_ANY_INSTANCING_ENABLED
			uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
			#endif // conditional
			float3 interp00 : TEXCOORD0; // auto-packed
			float4 interp01 : TEXCOORD1; // auto-packed
			#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
			FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // unpacked
			#endif // conditional
		};

		// Packed Type: VaryingsMeshToPS
		PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
		{
			PackedVaryingsMeshToPS output = (PackedVaryingsMeshToPS)0;
			output.positionCS = input.positionCS;
			output.interp00.xyz = input.positionRWS;
			output.interp01.xyzw = input.texCoord0;
			#if UNITY_ANY_INSTANCING_ENABLED
			output.instanceID = input.instanceID;
			#endif // conditional
			#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
			output.cullFace = input.cullFace;
			#endif // conditional
			return output;
		}

		// Unpacked Type: VaryingsMeshToPS
		VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
		{
			VaryingsMeshToPS output = (VaryingsMeshToPS)0;
			output.positionCS = input.positionCS;
			output.positionRWS = input.interp00.xyz;
			output.texCoord0 = input.interp01.xyzw;
			#if UNITY_ANY_INSTANCING_ENABLED
			output.instanceID = input.instanceID;
			#endif // conditional
			#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
			output.cullFace = input.cullFace;
			#endif // conditional
			return output;
		}
		// Generated Type: VaryingsMeshToDS
		struct VaryingsMeshToDS
		{
			float3 positionRWS;
			float3 normalWS;
			#if UNITY_ANY_INSTANCING_ENABLED
			uint instanceID : CUSTOM_INSTANCE_ID;
			#endif // UNITY_ANY_INSTANCING_ENABLED
		};

		// Generated Type: PackedVaryingsMeshToDS
		struct PackedVaryingsMeshToDS
		{
			#if UNITY_ANY_INSTANCING_ENABLED
			uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
			#endif // conditional
			float3 interp00 : TEXCOORD0; // auto-packed
			float3 interp01 : TEXCOORD1; // auto-packed
		};

		// Packed Type: VaryingsMeshToDS
		PackedVaryingsMeshToDS PackVaryingsMeshToDS(VaryingsMeshToDS input)
		{
			PackedVaryingsMeshToDS output = (PackedVaryingsMeshToDS)0;
			output.interp00.xyz = input.positionRWS;
			output.interp01.xyz = input.normalWS;
			#if UNITY_ANY_INSTANCING_ENABLED
			output.instanceID = input.instanceID;
			#endif // conditional
			return output;
		}

		// Unpacked Type: VaryingsMeshToDS
		VaryingsMeshToDS UnpackVaryingsMeshToDS(PackedVaryingsMeshToDS input)
		{
			VaryingsMeshToDS output = (VaryingsMeshToDS)0;
			output.positionRWS = input.interp00.xyz;
			output.normalWS = input.interp01.xyz;
			#if UNITY_ANY_INSTANCING_ENABLED
			output.instanceID = input.instanceID;
			#endif // conditional
			return output;
		}
		//-------------------------------------------------------------------------------------
		// End Interpolator Packing And Struct Declarations
		//-------------------------------------------------------------------------------------

		//-------------------------------------------------------------------------------------
		// Graph generated code
		//-------------------------------------------------------------------------------------
				// Shared Graph Properties (uniform inputs)
				CBUFFER_START(UnityPerMaterial)
				float4 Color_46CEA66D;
				float2 Vector2_B2FA17D2;
				float Vector1_9ED319E4;
				float4 Color_5451798F;
				CBUFFER_END
				TEXTURE2D(Texture2D_241AF3EA); SAMPLER(samplerTexture2D_241AF3EA); float4 Texture2D_241AF3EA_TexelSize;
				TEXTURE2D(Texture2D_F72EB8A8); SAMPLER(samplerTexture2D_F72EB8A8); float4 Texture2D_F72EB8A8_TexelSize;
				TEXTURE2D(Texture2D_3CF11457); SAMPLER(samplerTexture2D_3CF11457); float4 Texture2D_3CF11457_TexelSize;
				SAMPLER(_SampleTexture2D_BA125A02_Sampler_3_Linear_Repeat);
				SAMPLER(_SampleTexture2D_56E80683_Sampler_3_Linear_Repeat);

				// Pixel Graph Inputs
					struct SurfaceDescriptionInputs
					{
						float3 TangentSpaceNormal; // optional
						float3 WorldSpacePosition; // optional
						float4 ScreenPosition; // optional
						float4 uv0; // optional
						float3 TimeParameters; // optional
					};
					// Pixel Graph Outputs
						struct SurfaceDescription
						{
							float Alpha;
							float AlphaClipThreshold;
						};

						// Shared Graph Node Functions

							void Unity_Multiply_float(float A, float B, out float Out)
							{
								Out = A * B;
							}

							void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
							{
								Out = UV * Tiling + Offset;
							}

							void Unity_Add_float4(float4 A, float4 B, out float4 Out)
							{
								Out = A + B;
							}

							void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
							{
								Out = A * B;
							}

							// Pixel Graph Evaluation
								SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
								{
									SurfaceDescription surface = (SurfaceDescription)0;
									float4 _SampleTexture2D_BA125A02_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_F72EB8A8, samplerTexture2D_F72EB8A8, IN.uv0.xy);
									float _SampleTexture2D_BA125A02_R_4 = _SampleTexture2D_BA125A02_RGBA_0.r;
									float _SampleTexture2D_BA125A02_G_5 = _SampleTexture2D_BA125A02_RGBA_0.g;
									float _SampleTexture2D_BA125A02_B_6 = _SampleTexture2D_BA125A02_RGBA_0.b;
									float _SampleTexture2D_BA125A02_A_7 = _SampleTexture2D_BA125A02_RGBA_0.a;
									float4 _ScreenPosition_140DE9D9_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
									float2 _Property_FE000B08_Out_0 = Vector2_B2FA17D2;
									float _Property_87B635FF_Out_0 = Vector1_9ED319E4;
									float _Multiply_BA304D1B_Out_2;
									Unity_Multiply_float(IN.TimeParameters.x, _Property_87B635FF_Out_0, _Multiply_BA304D1B_Out_2);
									float2 _TilingAndOffset_51A73928_Out_3;
									Unity_TilingAndOffset_float((_ScreenPosition_140DE9D9_Out_0.xy), _Property_FE000B08_Out_0, (_Multiply_BA304D1B_Out_2.xx), _TilingAndOffset_51A73928_Out_3);
									float4 _SampleTexture2D_56E80683_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_241AF3EA, samplerTexture2D_241AF3EA, _TilingAndOffset_51A73928_Out_3);
									float _SampleTexture2D_56E80683_R_4 = _SampleTexture2D_56E80683_RGBA_0.r;
									float _SampleTexture2D_56E80683_G_5 = _SampleTexture2D_56E80683_RGBA_0.g;
									float _SampleTexture2D_56E80683_B_6 = _SampleTexture2D_56E80683_RGBA_0.b;
									float _SampleTexture2D_56E80683_A_7 = _SampleTexture2D_56E80683_RGBA_0.a;
									float4 _Add_24501FC7_Out_2;
									Unity_Add_float4(_SampleTexture2D_BA125A02_RGBA_0, _SampleTexture2D_56E80683_RGBA_0, _Add_24501FC7_Out_2);
									float4 _Multiply_A3EB48BE_Out_2;
									Unity_Multiply_float((_SampleTexture2D_BA125A02_A_7.xxxx), _Add_24501FC7_Out_2, _Multiply_A3EB48BE_Out_2);
									surface.Alpha = (_Multiply_A3EB48BE_Out_2).x;
									surface.AlphaClipThreshold = 0;
									return surface;
								}

								//-------------------------------------------------------------------------------------
								// End graph generated code
								//-------------------------------------------------------------------------------------

							// $include("VertexAnimation.template.hlsl")

							//-------------------------------------------------------------------------------------
								// TEMPLATE INCLUDE : SharedCode.template.hlsl
								//-------------------------------------------------------------------------------------

								#if !defined(SHADER_STAGE_RAY_TRACING)
									FragInputs BuildFragInputs(VaryingsMeshToPS input)
									{
										FragInputs output;
										ZERO_INITIALIZE(FragInputs, output);

										// Init to some default value to make the computer quiet (else it output 'divide by zero' warning even if value is not used).
										// TODO: this is a really poor workaround, but the variable is used in a bunch of places
										// to compute normals which are then passed on elsewhere to compute other values...
										output.tangentToWorld = k_identity3x3;
										output.positionSS = input.positionCS;       // input.positionCS is SV_Position

										output.positionRWS = input.positionRWS;
										// output.tangentToWorld = BuildTangentToWorld(input.tangentWS, input.normalWS);
										output.texCoord0 = input.texCoord0;
										// output.texCoord1 = input.texCoord1;
										// output.texCoord2 = input.texCoord2;
										// output.texCoord3 = input.texCoord3;
										// output.color = input.color;
										#if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
										output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
										#elif SHADER_STAGE_FRAGMENT
										output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
										#endif // SHADER_STAGE_FRAGMENT

										return output;
									}
								#endif
									SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
									{
										SurfaceDescriptionInputs output;
										ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

										// output.WorldSpaceNormal =            input.tangentToWorld[2].xyz;	// normal was already normalized in BuildTangentToWorld()
										// output.ObjectSpaceNormal =           normalize(mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_M));           // transposed multiplication by inverse matrix to handle normal scale
										// output.ViewSpaceNormal =             mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_I_V);         // transposed multiplication by inverse matrix to handle normal scale
										output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
										// output.WorldSpaceTangent =           input.tangentToWorld[0].xyz;
										// output.ObjectSpaceTangent =          TransformWorldToObjectDir(output.WorldSpaceTangent);
										// output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
										// output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
										// output.WorldSpaceBiTangent =         input.tangentToWorld[1].xyz;
										// output.ObjectSpaceBiTangent =        TransformWorldToObjectDir(output.WorldSpaceBiTangent);
										// output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
										// output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
										// output.WorldSpaceViewDirection =     normalize(viewWS);
										// output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
										// output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
										// float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
										// output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
										output.WorldSpacePosition = input.positionRWS;
										// output.ObjectSpacePosition =         TransformWorldToObject(input.positionRWS);
										// output.ViewSpacePosition =           TransformWorldToView(input.positionRWS);
										// output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
										// output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionRWS);
										output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionRWS), _ProjectionParams.x);
										output.uv0 = input.texCoord0;
										// output.uv1 =                         input.texCoord1;
										// output.uv2 =                         input.texCoord2;
										// output.uv3 =                         input.texCoord3;
										// output.VertexColor =                 input.color;
										// output.FaceSign =                    input.isFrontFace;
										output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value

										return output;
									}

								#if !defined(SHADER_STAGE_RAY_TRACING)

									// existing HDRP code uses the combined function to go directly from packed to frag inputs
									FragInputs UnpackVaryingsMeshToFragInputs(PackedVaryingsMeshToPS input)
									{
										UNITY_SETUP_INSTANCE_ID(input);
										VaryingsMeshToPS unpacked = UnpackVaryingsMeshToPS(input);
										return BuildFragInputs(unpacked);
									}
								#endif

									//-------------------------------------------------------------------------------------
									// END TEMPLATE INCLUDE : SharedCode.template.hlsl
									//-------------------------------------------------------------------------------------



									void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData)
									{
										// setup defaults -- these are used if the graph doesn't output a value
										ZERO_INITIALIZE(SurfaceData, surfaceData);
										surfaceData.ambientOcclusion = 1.0;
										surfaceData.specularOcclusion = 1.0; // This need to be init here to quiet the compiler in case of decal, but can be override later.

										// copy across graph values, if defined
										// surfaceData.baseColor =             surfaceDescription.Albedo;
										// surfaceData.perceptualSmoothness =  surfaceDescription.Smoothness;
										// surfaceData.ambientOcclusion =      surfaceDescription.Occlusion;
										// surfaceData.metallic =              surfaceDescription.Metallic;
										// surfaceData.specularColor =         surfaceDescription.Specular;

										// These static material feature allow compile time optimization
										surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
								#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
										surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
								#endif

										float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
										// doubleSidedConstants = float3(-1.0, -1.0, -1.0);
										doubleSidedConstants = float3(1.0,  1.0, -1.0);

										// normal delivered to master node
										float3 normalSrc = float3(0.0f, 0.0f, 1.0f);
										// normalSrc = surfaceDescription.Normal;

										// compute world space normal
								#if _NORMAL_DROPOFF_TS
										GetNormalWS(fragInputs, normalSrc, surfaceData.normalWS, doubleSidedConstants);
								#elif _NORMAL_DROPOFF_OS
										surfaceData.normalWS = TransformObjectToWorldNormal(normalSrc);
								#elif _NORMAL_DROPOFF_WS
										surfaceData.normalWS = normalSrc;
								#endif

										surfaceData.geomNormalWS = fragInputs.tangentToWorld[2];
										surfaceData.tangentWS = normalize(fragInputs.tangentToWorld[0].xyz);    // The tangent is not normalize in tangentToWorld for mikkt. TODO: Check if it expected that we normalize with Morten. Tag: SURFACE_GRADIENT

								#if HAVE_DECALS
										if (_EnableDecals)
										{
											// Both uses and modifies 'surfaceData.normalWS'.
											DecalSurfaceData decalSurfaceData = GetDecalSurfaceData(posInput, surfaceDescription.Alpha);
											ApplyDecalToSurfaceData(decalSurfaceData, surfaceData);
										}
								#endif

										surfaceData.tangentWS = Orthonormalize(surfaceData.tangentWS, surfaceData.normalWS);

								#ifdef DEBUG_DISPLAY
										if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
										{
											// TODO: need to update mip info
											surfaceData.metallic = 0;
										}

										// We need to call ApplyDebugToSurfaceData after filling the surfarcedata and before filling builtinData
										// as it can modify attribute use for static lighting
										ApplyDebugToSurfaceData(fragInputs.tangentToWorld, surfaceData);
								#endif

										// By default we use the ambient occlusion with Tri-ace trick (apply outside) for specular occlusion as PBR master node don't have any option
										surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion(ClampNdotV(dot(surfaceData.normalWS, V)), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness(surfaceData.perceptualSmoothness));
									}

									void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
									{
								#ifdef LOD_FADE_CROSSFADE // enable dithering LOD transition if user select CrossFade transition in LOD group
										LODDitheringTransition(ComputeFadeMaskSeed(V, posInput.positionSS), unity_LODFade.x);
								#endif

										float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
										// doubleSidedConstants = float3(-1.0, -1.0, -1.0);
										doubleSidedConstants = float3(1.0,  1.0, -1.0);

										ApplyDoubleSidedFlipOrMirror(fragInputs, doubleSidedConstants);

										SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
										SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);

										// Perform alpha test very early to save performance (a killed pixel will not sample textures)
										// TODO: split graph evaluation to grab just alpha dependencies first? tricky..
										// DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);

										BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData);

										// Builtin Data
										// For back lighting we use the oposite vertex normal
										InitBuiltinData(posInput, surfaceDescription.Alpha, surfaceData.normalWS, -fragInputs.tangentToWorld[2], fragInputs.texCoord1, fragInputs.texCoord2, builtinData);

										// builtinData.emissiveColor = surfaceDescription.Emission;

										PostInitBuiltinData(V, posInput, surfaceData, builtinData);
									}

									//-------------------------------------------------------------------------------------
									// Pass Includes
									//-------------------------------------------------------------------------------------
										#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPassDepthOnly.hlsl"
									//-------------------------------------------------------------------------------------
									// End Pass Includes
									//-------------------------------------------------------------------------------------

									ENDHLSL
								}

								Pass
								{
										// based on HDPBRPass.template
										Name "META"
										Tags { "LightMode" = "META" }

										//-------------------------------------------------------------------------------------
										// Render Modes (Blend, Cull, ZTest, Stencil, etc)
										//-------------------------------------------------------------------------------------

										Cull Off






										//-------------------------------------------------------------------------------------
										// End Render Modes
										//-------------------------------------------------------------------------------------

										HLSLPROGRAM

										#pragma target 4.5
										#pragma only_renderers d3d11 playstation xboxone vulkan metal switch
										//#pragma enable_d3d11_debug_symbols

										#pragma multi_compile_instancing
									#pragma instancing_options renderinglayer

										#pragma multi_compile _ LOD_FADE_CROSSFADE

										//-------------------------------------------------------------------------------------
										// Graph Defines
										//-------------------------------------------------------------------------------------
												// Shared Graph Keywords
											#define SHADERPASS SHADERPASS_LIGHT_TRANSPORT
											// ACTIVE FIELDS:
											//   DoubleSided
											//   DoubleSided.Mirror
											//   FragInputs.isFrontFace
											//   features.NormalDropOffTS
											//   SurfaceType.Transparent
											//   BlendMode.Alpha
											//   AlphaFog
											//   SurfaceDescriptionInputs.ScreenPosition
											//   SurfaceDescriptionInputs.WorldSpaceNormal
											//   SurfaceDescriptionInputs.TangentSpaceNormal
											//   SurfaceDescriptionInputs.WorldSpaceViewDirection
											//   SurfaceDescriptionInputs.uv0
											//   SurfaceDescriptionInputs.TimeParameters
											//   VertexDescriptionInputs.ObjectSpaceNormal
											//   VertexDescriptionInputs.ObjectSpaceTangent
											//   VertexDescriptionInputs.ObjectSpacePosition
											//   SurfaceDescription.Albedo
											//   SurfaceDescription.Normal
											//   SurfaceDescription.Metallic
											//   SurfaceDescription.Emission
											//   SurfaceDescription.Smoothness
											//   SurfaceDescription.Occlusion
											//   SurfaceDescription.Alpha
											//   SurfaceDescription.AlphaClipThreshold
											//   AttributesMesh.normalOS
											//   AttributesMesh.tangentOS
											//   AttributesMesh.uv0
											//   AttributesMesh.uv1
											//   AttributesMesh.color
											//   AttributesMesh.uv2
											//   VaryingsMeshToPS.cullFace
											//   SurfaceDescriptionInputs.WorldSpacePosition
											//   FragInputs.tangentToWorld
											//   FragInputs.positionRWS
											//   FragInputs.texCoord0
											//   AttributesMesh.positionOS
											//   VaryingsMeshToPS.tangentWS
											//   VaryingsMeshToPS.normalWS
											//   VaryingsMeshToPS.positionRWS
											//   VaryingsMeshToPS.texCoord0
										//-------------------------------------------------------------------------------------
										// End Defines
										//-------------------------------------------------------------------------------------

										//-------------------------------------------------------------------------------------
										// Variant Definitions (active field translations to HDRP defines)
										//-------------------------------------------------------------------------------------

										// #define _MATERIAL_FEATURE_SPECULAR_COLOR 1
										#define _SURFACE_TYPE_TRANSPARENT 1
										#define _BLENDMODE_ALPHA 1
										// #define _BLENDMODE_ADD 1
										// #define _BLENDMODE_PRE_MULTIPLY 1
										#define _DOUBLESIDED_ON 1
										#define _NORMAL_DROPOFF_TS	1
										// #define _NORMAL_DROPOFF_OS	1
										// #define _NORMAL_DROPOFF_WS	1

										//-------------------------------------------------------------------------------------
										// End Variant Definitions
										//-------------------------------------------------------------------------------------

										#pragma vertex Vert
										#pragma fragment Frag

										#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"

										#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"

										// define FragInputs structure
										#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
										#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"

										//-------------------------------------------------------------------------------------
										// Active Field Defines
										//-------------------------------------------------------------------------------------

										// this translates the new dependency tracker into the old preprocessor definitions for the existing HDRP shader code
										#define ATTRIBUTES_NEED_NORMAL
										#define ATTRIBUTES_NEED_TANGENT
										#define ATTRIBUTES_NEED_TEXCOORD0
										#define ATTRIBUTES_NEED_TEXCOORD1
										#define ATTRIBUTES_NEED_TEXCOORD2
										// #define ATTRIBUTES_NEED_TEXCOORD3
										#define ATTRIBUTES_NEED_COLOR
										#define VARYINGS_NEED_POSITION_WS
										#define VARYINGS_NEED_TANGENT_TO_WORLD
										#define VARYINGS_NEED_TEXCOORD0
										// #define VARYINGS_NEED_TEXCOORD1
										// #define VARYINGS_NEED_TEXCOORD2
										// #define VARYINGS_NEED_TEXCOORD3
										// #define VARYINGS_NEED_COLOR
										#define VARYINGS_NEED_CULLFACE
										// #define HAVE_MESH_MODIFICATION

										//-------------------------------------------------------------------------------------
										// End Defines
										//-------------------------------------------------------------------------------------


										#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
										#ifdef DEBUG_DISPLAY
											#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
										#endif

										#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"

									#if (SHADERPASS == SHADERPASS_FORWARD)
										#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Lighting.hlsl"

										#define HAS_LIGHTLOOP

										#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
										#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
										#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoop.hlsl"
									#else
										#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
									#endif

										#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
										#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
										#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
										#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
										#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"

										//Used by SceneSelectionPass
										int _ObjectId;
										int _PassValue;

										//-------------------------------------------------------------------------------------
										// Interpolator Packing And Struct Declarations
										//-------------------------------------------------------------------------------------
										// Generated Type: AttributesMesh
										struct AttributesMesh
										{
											float3 positionOS : POSITION;
											float3 normalOS : NORMAL; // optional
											float4 tangentOS : TANGENT; // optional
											float4 uv0 : TEXCOORD0; // optional
											float4 uv1 : TEXCOORD1; // optional
											float4 uv2 : TEXCOORD2; // optional
											float4 color : COLOR; // optional
											#if UNITY_ANY_INSTANCING_ENABLED
											uint instanceID : INSTANCEID_SEMANTIC;
											#endif // UNITY_ANY_INSTANCING_ENABLED
										};
										// Generated Type: VaryingsMeshToPS
										struct VaryingsMeshToPS
										{
											float4 positionCS : SV_POSITION;
											float3 positionRWS; // optional
											float3 normalWS; // optional
											float4 tangentWS; // optional
											float4 texCoord0; // optional
											#if UNITY_ANY_INSTANCING_ENABLED
											uint instanceID : CUSTOM_INSTANCE_ID;
											#endif // UNITY_ANY_INSTANCING_ENABLED
											#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
											FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
											#endif // defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
										};

										// Generated Type: PackedVaryingsMeshToPS
										struct PackedVaryingsMeshToPS
										{
											float4 positionCS : SV_POSITION; // unpacked
											#if UNITY_ANY_INSTANCING_ENABLED
											uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
											#endif // conditional
											float3 interp00 : TEXCOORD0; // auto-packed
											float3 interp01 : TEXCOORD1; // auto-packed
											float4 interp02 : TEXCOORD2; // auto-packed
											float4 interp03 : TEXCOORD3; // auto-packed
											#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
											FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // unpacked
											#endif // conditional
										};

										// Packed Type: VaryingsMeshToPS
										PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
										{
											PackedVaryingsMeshToPS output = (PackedVaryingsMeshToPS)0;
											output.positionCS = input.positionCS;
											output.interp00.xyz = input.positionRWS;
											output.interp01.xyz = input.normalWS;
											output.interp02.xyzw = input.tangentWS;
											output.interp03.xyzw = input.texCoord0;
											#if UNITY_ANY_INSTANCING_ENABLED
											output.instanceID = input.instanceID;
											#endif // conditional
											#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
											output.cullFace = input.cullFace;
											#endif // conditional
											return output;
										}

										// Unpacked Type: VaryingsMeshToPS
										VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
										{
											VaryingsMeshToPS output = (VaryingsMeshToPS)0;
											output.positionCS = input.positionCS;
											output.positionRWS = input.interp00.xyz;
											output.normalWS = input.interp01.xyz;
											output.tangentWS = input.interp02.xyzw;
											output.texCoord0 = input.interp03.xyzw;
											#if UNITY_ANY_INSTANCING_ENABLED
											output.instanceID = input.instanceID;
											#endif // conditional
											#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
											output.cullFace = input.cullFace;
											#endif // conditional
											return output;
										}
										// Generated Type: VaryingsMeshToDS
										struct VaryingsMeshToDS
										{
											float3 positionRWS;
											float3 normalWS;
											#if UNITY_ANY_INSTANCING_ENABLED
											uint instanceID : CUSTOM_INSTANCE_ID;
											#endif // UNITY_ANY_INSTANCING_ENABLED
										};

										// Generated Type: PackedVaryingsMeshToDS
										struct PackedVaryingsMeshToDS
										{
											#if UNITY_ANY_INSTANCING_ENABLED
											uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
											#endif // conditional
											float3 interp00 : TEXCOORD0; // auto-packed
											float3 interp01 : TEXCOORD1; // auto-packed
										};

										// Packed Type: VaryingsMeshToDS
										PackedVaryingsMeshToDS PackVaryingsMeshToDS(VaryingsMeshToDS input)
										{
											PackedVaryingsMeshToDS output = (PackedVaryingsMeshToDS)0;
											output.interp00.xyz = input.positionRWS;
											output.interp01.xyz = input.normalWS;
											#if UNITY_ANY_INSTANCING_ENABLED
											output.instanceID = input.instanceID;
											#endif // conditional
											return output;
										}

										// Unpacked Type: VaryingsMeshToDS
										VaryingsMeshToDS UnpackVaryingsMeshToDS(PackedVaryingsMeshToDS input)
										{
											VaryingsMeshToDS output = (VaryingsMeshToDS)0;
											output.positionRWS = input.interp00.xyz;
											output.normalWS = input.interp01.xyz;
											#if UNITY_ANY_INSTANCING_ENABLED
											output.instanceID = input.instanceID;
											#endif // conditional
											return output;
										}
										//-------------------------------------------------------------------------------------
										// End Interpolator Packing And Struct Declarations
										//-------------------------------------------------------------------------------------

										//-------------------------------------------------------------------------------------
										// Graph generated code
										//-------------------------------------------------------------------------------------
												// Shared Graph Properties (uniform inputs)
												CBUFFER_START(UnityPerMaterial)
												float4 Color_46CEA66D;
												float2 Vector2_B2FA17D2;
												float Vector1_9ED319E4;
												float4 Color_5451798F;
												CBUFFER_END
												TEXTURE2D(Texture2D_241AF3EA); SAMPLER(samplerTexture2D_241AF3EA); float4 Texture2D_241AF3EA_TexelSize;
												TEXTURE2D(Texture2D_F72EB8A8); SAMPLER(samplerTexture2D_F72EB8A8); float4 Texture2D_F72EB8A8_TexelSize;
												TEXTURE2D(Texture2D_3CF11457); SAMPLER(samplerTexture2D_3CF11457); float4 Texture2D_3CF11457_TexelSize;
												SAMPLER(_SampleTexture2D_BA125A02_Sampler_3_Linear_Repeat);
												SAMPLER(_SampleTexture2D_56E80683_Sampler_3_Linear_Repeat);

												// Pixel Graph Inputs
													struct SurfaceDescriptionInputs
													{
														float3 WorldSpaceNormal; // optional
														float3 TangentSpaceNormal; // optional
														float3 WorldSpaceViewDirection; // optional
														float3 WorldSpacePosition; // optional
														float4 ScreenPosition; // optional
														float4 uv0; // optional
														float3 TimeParameters; // optional
													};
													// Pixel Graph Outputs
														struct SurfaceDescription
														{
															float3 Albedo;
															float3 Normal;
															float Metallic;
															float3 Emission;
															float Smoothness;
															float Occlusion;
															float Alpha;
															float AlphaClipThreshold;
														};

														// Shared Graph Node Functions

															void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
															{
																Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
															}

															void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
															{
																Out = A * B;
															}

															void Unity_Multiply_float(float A, float B, out float Out)
															{
																Out = A * B;
															}

															void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
															{
																Out = UV * Tiling + Offset;
															}

															void Unity_OneMinus_float4(float4 In, out float4 Out)
															{
																Out = 1 - In;
															}

															void Unity_Add_float4(float4 A, float4 B, out float4 Out)
															{
																Out = A + B;
															}

															void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
															{
																 float randomno = frac(sin(dot(Seed, float2(12.9898, 78.233)))*43758.5453);
																 Out = lerp(Min, Max, randomno);
															}

															void Unity_Comparison_Greater_float(float A, float B, out float Out)
															{
																Out = A > B ? 1 : 0;
															}

															void Unity_Branch_float(float Predicate, float True, float False, out float Out)
															{
																Out = Predicate ? True : False;
															}

															// Pixel Graph Evaluation
																SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
																{
																	SurfaceDescription surface = (SurfaceDescription)0;
																	float4 _SampleTexture2D_BA125A02_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_F72EB8A8, samplerTexture2D_F72EB8A8, IN.uv0.xy);
																	float _SampleTexture2D_BA125A02_R_4 = _SampleTexture2D_BA125A02_RGBA_0.r;
																	float _SampleTexture2D_BA125A02_G_5 = _SampleTexture2D_BA125A02_RGBA_0.g;
																	float _SampleTexture2D_BA125A02_B_6 = _SampleTexture2D_BA125A02_RGBA_0.b;
																	float _SampleTexture2D_BA125A02_A_7 = _SampleTexture2D_BA125A02_RGBA_0.a;
																	float4 _Property_2BA146F9_Out_0 = Color_5451798F;
																	float _FresnelEffect_1783DBC8_Out_3;
																	Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, 3, _FresnelEffect_1783DBC8_Out_3);
																	float4 _Multiply_41A6FFB8_Out_2;
																	Unity_Multiply_float(_Property_2BA146F9_Out_0, (_FresnelEffect_1783DBC8_Out_3.xxxx), _Multiply_41A6FFB8_Out_2);
																	float4 _Property_FB158B5C_Out_0 = Color_46CEA66D;
																	float4 _ScreenPosition_140DE9D9_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
																	float2 _Property_FE000B08_Out_0 = Vector2_B2FA17D2;
																	float _Property_87B635FF_Out_0 = Vector1_9ED319E4;
																	float _Multiply_BA304D1B_Out_2;
																	Unity_Multiply_float(IN.TimeParameters.x, _Property_87B635FF_Out_0, _Multiply_BA304D1B_Out_2);
																	float2 _TilingAndOffset_51A73928_Out_3;
																	Unity_TilingAndOffset_float((_ScreenPosition_140DE9D9_Out_0.xy), _Property_FE000B08_Out_0, (_Multiply_BA304D1B_Out_2.xx), _TilingAndOffset_51A73928_Out_3);
																	float4 _SampleTexture2D_56E80683_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_241AF3EA, samplerTexture2D_241AF3EA, _TilingAndOffset_51A73928_Out_3);
																	float _SampleTexture2D_56E80683_R_4 = _SampleTexture2D_56E80683_RGBA_0.r;
																	float _SampleTexture2D_56E80683_G_5 = _SampleTexture2D_56E80683_RGBA_0.g;
																	float _SampleTexture2D_56E80683_B_6 = _SampleTexture2D_56E80683_RGBA_0.b;
																	float _SampleTexture2D_56E80683_A_7 = _SampleTexture2D_56E80683_RGBA_0.a;
																	float4 _OneMinus_5CE264A2_Out_1;
																	Unity_OneMinus_float4(_SampleTexture2D_56E80683_RGBA_0, _OneMinus_5CE264A2_Out_1);
																	float4 _Multiply_3A07838F_Out_2;
																	Unity_Multiply_float(_Property_FB158B5C_Out_0, _OneMinus_5CE264A2_Out_1, _Multiply_3A07838F_Out_2);
																	float4 _Add_D52D51E2_Out_2;
																	Unity_Add_float4(_Multiply_41A6FFB8_Out_2, _Multiply_3A07838F_Out_2, _Add_D52D51E2_Out_2);
																	float _RandomRange_D3C402AD_Out_3;
																	Unity_RandomRange_float((IN.TimeParameters.x.xx), 0, 1, _RandomRange_D3C402AD_Out_3);
																	float _Comparison_2A79ACE2_Out_2;
																	Unity_Comparison_Greater_float(_RandomRange_D3C402AD_Out_3, 0.9, _Comparison_2A79ACE2_Out_2);
																	float _Branch_555CFD86_Out_3;
																	Unity_Branch_float(_Comparison_2A79ACE2_Out_2, 1, 0.8, _Branch_555CFD86_Out_3);
																	float4 _Multiply_3CF6A289_Out_2;
																	Unity_Multiply_float(_Add_D52D51E2_Out_2, (_Branch_555CFD86_Out_3.xxxx), _Multiply_3CF6A289_Out_2);
																	float4 _Add_E56C841_Out_2;
																	Unity_Add_float4(_SampleTexture2D_BA125A02_RGBA_0, _Multiply_3CF6A289_Out_2, _Add_E56C841_Out_2);
																	float4 _Add_24501FC7_Out_2;
																	Unity_Add_float4(_SampleTexture2D_BA125A02_RGBA_0, _SampleTexture2D_56E80683_RGBA_0, _Add_24501FC7_Out_2);
																	float4 _Multiply_A3EB48BE_Out_2;
																	Unity_Multiply_float((_SampleTexture2D_BA125A02_A_7.xxxx), _Add_24501FC7_Out_2, _Multiply_A3EB48BE_Out_2);
																	surface.Albedo = (_SampleTexture2D_BA125A02_RGBA_0.xyz);
																	surface.Normal = IN.TangentSpaceNormal;
																	surface.Metallic = 0;
																	surface.Emission = (_Add_E56C841_Out_2.xyz);
																	surface.Smoothness = 0.5;
																	surface.Occlusion = 1;
																	surface.Alpha = (_Multiply_A3EB48BE_Out_2).x;
																	surface.AlphaClipThreshold = 0;
																	return surface;
																}

																//-------------------------------------------------------------------------------------
																// End graph generated code
																//-------------------------------------------------------------------------------------

															// $include("VertexAnimation.template.hlsl")

															//-------------------------------------------------------------------------------------
																// TEMPLATE INCLUDE : SharedCode.template.hlsl
																//-------------------------------------------------------------------------------------

																#if !defined(SHADER_STAGE_RAY_TRACING)
																	FragInputs BuildFragInputs(VaryingsMeshToPS input)
																	{
																		FragInputs output;
																		ZERO_INITIALIZE(FragInputs, output);

																		// Init to some default value to make the computer quiet (else it output 'divide by zero' warning even if value is not used).
																		// TODO: this is a really poor workaround, but the variable is used in a bunch of places
																		// to compute normals which are then passed on elsewhere to compute other values...
																		output.tangentToWorld = k_identity3x3;
																		output.positionSS = input.positionCS;       // input.positionCS is SV_Position

																		output.positionRWS = input.positionRWS;
																		output.tangentToWorld = BuildTangentToWorld(input.tangentWS, input.normalWS);
																		output.texCoord0 = input.texCoord0;
																		// output.texCoord1 = input.texCoord1;
																		// output.texCoord2 = input.texCoord2;
																		// output.texCoord3 = input.texCoord3;
																		// output.color = input.color;
																		#if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
																		output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
																		#elif SHADER_STAGE_FRAGMENT
																		output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
																		#endif // SHADER_STAGE_FRAGMENT

																		return output;
																	}
																#endif
																	SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
																	{
																		SurfaceDescriptionInputs output;
																		ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

																		output.WorldSpaceNormal = input.tangentToWorld[2].xyz;	// normal was already normalized in BuildTangentToWorld()
																		// output.ObjectSpaceNormal =           normalize(mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_M));           // transposed multiplication by inverse matrix to handle normal scale
																		// output.ViewSpaceNormal =             mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_I_V);         // transposed multiplication by inverse matrix to handle normal scale
																		output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
																		// output.WorldSpaceTangent =           input.tangentToWorld[0].xyz;
																		// output.ObjectSpaceTangent =          TransformWorldToObjectDir(output.WorldSpaceTangent);
																		// output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
																		// output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
																		// output.WorldSpaceBiTangent =         input.tangentToWorld[1].xyz;
																		// output.ObjectSpaceBiTangent =        TransformWorldToObjectDir(output.WorldSpaceBiTangent);
																		// output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
																		// output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
																		output.WorldSpaceViewDirection = normalize(viewWS);
																		// output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
																		// output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
																		// float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
																		// output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
																		output.WorldSpacePosition = input.positionRWS;
																		// output.ObjectSpacePosition =         TransformWorldToObject(input.positionRWS);
																		// output.ViewSpacePosition =           TransformWorldToView(input.positionRWS);
																		// output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
																		// output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionRWS);
																		output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionRWS), _ProjectionParams.x);
																		output.uv0 = input.texCoord0;
																		// output.uv1 =                         input.texCoord1;
																		// output.uv2 =                         input.texCoord2;
																		// output.uv3 =                         input.texCoord3;
																		// output.VertexColor =                 input.color;
																		// output.FaceSign =                    input.isFrontFace;
																		output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value

																		return output;
																	}

																#if !defined(SHADER_STAGE_RAY_TRACING)

																	// existing HDRP code uses the combined function to go directly from packed to frag inputs
																	FragInputs UnpackVaryingsMeshToFragInputs(PackedVaryingsMeshToPS input)
																	{
																		UNITY_SETUP_INSTANCE_ID(input);
																		VaryingsMeshToPS unpacked = UnpackVaryingsMeshToPS(input);
																		return BuildFragInputs(unpacked);
																	}
																#endif

																	//-------------------------------------------------------------------------------------
																	// END TEMPLATE INCLUDE : SharedCode.template.hlsl
																	//-------------------------------------------------------------------------------------



																	void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData)
																	{
																		// setup defaults -- these are used if the graph doesn't output a value
																		ZERO_INITIALIZE(SurfaceData, surfaceData);
																		surfaceData.ambientOcclusion = 1.0;
																		surfaceData.specularOcclusion = 1.0; // This need to be init here to quiet the compiler in case of decal, but can be override later.

																		// copy across graph values, if defined
																		surfaceData.baseColor = surfaceDescription.Albedo;
																		surfaceData.perceptualSmoothness = surfaceDescription.Smoothness;
																		surfaceData.ambientOcclusion = surfaceDescription.Occlusion;
																		surfaceData.metallic = surfaceDescription.Metallic;
																		// surfaceData.specularColor =         surfaceDescription.Specular;

																		// These static material feature allow compile time optimization
																		surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
																#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
																		surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
																#endif

																		float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
																		// doubleSidedConstants = float3(-1.0, -1.0, -1.0);
																		doubleSidedConstants = float3(1.0,  1.0, -1.0);

																		// normal delivered to master node
																		float3 normalSrc = float3(0.0f, 0.0f, 1.0f);
																		normalSrc = surfaceDescription.Normal;

																		// compute world space normal
																#if _NORMAL_DROPOFF_TS
																		GetNormalWS(fragInputs, normalSrc, surfaceData.normalWS, doubleSidedConstants);
																#elif _NORMAL_DROPOFF_OS
																		surfaceData.normalWS = TransformObjectToWorldNormal(normalSrc);
																#elif _NORMAL_DROPOFF_WS
																		surfaceData.normalWS = normalSrc;
																#endif

																		surfaceData.geomNormalWS = fragInputs.tangentToWorld[2];
																		surfaceData.tangentWS = normalize(fragInputs.tangentToWorld[0].xyz);    // The tangent is not normalize in tangentToWorld for mikkt. TODO: Check if it expected that we normalize with Morten. Tag: SURFACE_GRADIENT

																#if HAVE_DECALS
																		if (_EnableDecals)
																		{
																			// Both uses and modifies 'surfaceData.normalWS'.
																			DecalSurfaceData decalSurfaceData = GetDecalSurfaceData(posInput, surfaceDescription.Alpha);
																			ApplyDecalToSurfaceData(decalSurfaceData, surfaceData);
																		}
																#endif

																		surfaceData.tangentWS = Orthonormalize(surfaceData.tangentWS, surfaceData.normalWS);

																#ifdef DEBUG_DISPLAY
																		if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
																		{
																			// TODO: need to update mip info
																			surfaceData.metallic = 0;
																		}

																		// We need to call ApplyDebugToSurfaceData after filling the surfarcedata and before filling builtinData
																		// as it can modify attribute use for static lighting
																		ApplyDebugToSurfaceData(fragInputs.tangentToWorld, surfaceData);
																#endif

																		// By default we use the ambient occlusion with Tri-ace trick (apply outside) for specular occlusion as PBR master node don't have any option
																		surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion(ClampNdotV(dot(surfaceData.normalWS, V)), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness(surfaceData.perceptualSmoothness));
																	}

																	void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
																	{
																#ifdef LOD_FADE_CROSSFADE // enable dithering LOD transition if user select CrossFade transition in LOD group
																		LODDitheringTransition(ComputeFadeMaskSeed(V, posInput.positionSS), unity_LODFade.x);
																#endif

																		float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
																		// doubleSidedConstants = float3(-1.0, -1.0, -1.0);
																		doubleSidedConstants = float3(1.0,  1.0, -1.0);

																		ApplyDoubleSidedFlipOrMirror(fragInputs, doubleSidedConstants);

																		SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
																		SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);

																		// Perform alpha test very early to save performance (a killed pixel will not sample textures)
																		// TODO: split graph evaluation to grab just alpha dependencies first? tricky..
																		// DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);

																		BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData);

																		// Builtin Data
																		// For back lighting we use the oposite vertex normal
																		InitBuiltinData(posInput, surfaceDescription.Alpha, surfaceData.normalWS, -fragInputs.tangentToWorld[2], fragInputs.texCoord1, fragInputs.texCoord2, builtinData);

																		builtinData.emissiveColor = surfaceDescription.Emission;

																		PostInitBuiltinData(V, posInput, surfaceData, builtinData);
																	}

																	//-------------------------------------------------------------------------------------
																	// Pass Includes
																	//-------------------------------------------------------------------------------------
																		#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPassLightTransport.hlsl"
																	//-------------------------------------------------------------------------------------
																	// End Pass Includes
																	//-------------------------------------------------------------------------------------

																	ENDHLSL
																}

																Pass
																{
																		// based on HDPBRPass.template
																		Name "SceneSelectionPass"
																		Tags { "LightMode" = "SceneSelectionPass" }

																		//-------------------------------------------------------------------------------------
																		// Render Modes (Blend, Cull, ZTest, Stencil, etc)
																		//-------------------------------------------------------------------------------------

																		Cull Off


																		ZWrite Off



																		ColorMask 0

																		//-------------------------------------------------------------------------------------
																		// End Render Modes
																		//-------------------------------------------------------------------------------------

																		HLSLPROGRAM

																		#pragma target 4.5
																		#pragma only_renderers d3d11 playstation xboxone vulkan metal switch
																		//#pragma enable_d3d11_debug_symbols

																		#pragma multi_compile_instancing
																	#pragma instancing_options renderinglayer

																		#pragma multi_compile _ LOD_FADE_CROSSFADE

																		//-------------------------------------------------------------------------------------
																		// Graph Defines
																		//-------------------------------------------------------------------------------------
																				// Shared Graph Keywords
																			#define SHADERPASS SHADERPASS_DEPTH_ONLY
																			#define SCENESELECTIONPASS
																			#pragma editor_sync_compilation
																			// ACTIVE FIELDS:
																			//   DoubleSided
																			//   DoubleSided.Mirror
																			//   FragInputs.isFrontFace
																			//   features.NormalDropOffTS
																			//   SurfaceType.Transparent
																			//   BlendMode.Alpha
																			//   AlphaFog
																			//   SurfaceDescriptionInputs.ScreenPosition
																			//   SurfaceDescriptionInputs.TangentSpaceNormal
																			//   SurfaceDescriptionInputs.uv0
																			//   SurfaceDescriptionInputs.TimeParameters
																			//   VertexDescriptionInputs.ObjectSpaceNormal
																			//   VertexDescriptionInputs.ObjectSpaceTangent
																			//   VertexDescriptionInputs.ObjectSpacePosition
																			//   SurfaceDescription.Alpha
																			//   SurfaceDescription.AlphaClipThreshold
																			//   VaryingsMeshToPS.cullFace
																			//   SurfaceDescriptionInputs.WorldSpacePosition
																			//   FragInputs.texCoord0
																			//   AttributesMesh.normalOS
																			//   AttributesMesh.tangentOS
																			//   AttributesMesh.positionOS
																			//   FragInputs.positionRWS
																			//   VaryingsMeshToPS.texCoord0
																			//   VaryingsMeshToPS.positionRWS
																			//   AttributesMesh.uv0
																		//-------------------------------------------------------------------------------------
																		// End Defines
																		//-------------------------------------------------------------------------------------

																		//-------------------------------------------------------------------------------------
																		// Variant Definitions (active field translations to HDRP defines)
																		//-------------------------------------------------------------------------------------

																		// #define _MATERIAL_FEATURE_SPECULAR_COLOR 1
																		#define _SURFACE_TYPE_TRANSPARENT 1
																		#define _BLENDMODE_ALPHA 1
																		// #define _BLENDMODE_ADD 1
																		// #define _BLENDMODE_PRE_MULTIPLY 1
																		#define _DOUBLESIDED_ON 1
																		#define _NORMAL_DROPOFF_TS	1
																		// #define _NORMAL_DROPOFF_OS	1
																		// #define _NORMAL_DROPOFF_WS	1

																		//-------------------------------------------------------------------------------------
																		// End Variant Definitions
																		//-------------------------------------------------------------------------------------

																		#pragma vertex Vert
																		#pragma fragment Frag

																		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"

																		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"

																		// define FragInputs structure
																		#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
																		#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"

																		//-------------------------------------------------------------------------------------
																		// Active Field Defines
																		//-------------------------------------------------------------------------------------

																		// this translates the new dependency tracker into the old preprocessor definitions for the existing HDRP shader code
																		#define ATTRIBUTES_NEED_NORMAL
																		#define ATTRIBUTES_NEED_TANGENT
																		#define ATTRIBUTES_NEED_TEXCOORD0
																		// #define ATTRIBUTES_NEED_TEXCOORD1
																		// #define ATTRIBUTES_NEED_TEXCOORD2
																		// #define ATTRIBUTES_NEED_TEXCOORD3
																		// #define ATTRIBUTES_NEED_COLOR
																		#define VARYINGS_NEED_POSITION_WS
																		// #define VARYINGS_NEED_TANGENT_TO_WORLD
																		#define VARYINGS_NEED_TEXCOORD0
																		// #define VARYINGS_NEED_TEXCOORD1
																		// #define VARYINGS_NEED_TEXCOORD2
																		// #define VARYINGS_NEED_TEXCOORD3
																		// #define VARYINGS_NEED_COLOR
																		#define VARYINGS_NEED_CULLFACE
																		// #define HAVE_MESH_MODIFICATION

																		//-------------------------------------------------------------------------------------
																		// End Defines
																		//-------------------------------------------------------------------------------------


																		#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
																		#ifdef DEBUG_DISPLAY
																			#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
																		#endif

																		#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"

																	#if (SHADERPASS == SHADERPASS_FORWARD)
																		#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Lighting.hlsl"

																		#define HAS_LIGHTLOOP

																		#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
																		#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
																		#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoop.hlsl"
																	#else
																		#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
																	#endif

																		#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
																		#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
																		#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
																		#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
																		#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"

																		//Used by SceneSelectionPass
																		int _ObjectId;
																		int _PassValue;

																		//-------------------------------------------------------------------------------------
																		// Interpolator Packing And Struct Declarations
																		//-------------------------------------------------------------------------------------
																		// Generated Type: AttributesMesh
																		struct AttributesMesh
																		{
																			float3 positionOS : POSITION;
																			float3 normalOS : NORMAL; // optional
																			float4 tangentOS : TANGENT; // optional
																			float4 uv0 : TEXCOORD0; // optional
																			#if UNITY_ANY_INSTANCING_ENABLED
																			uint instanceID : INSTANCEID_SEMANTIC;
																			#endif // UNITY_ANY_INSTANCING_ENABLED
																		};
																		// Generated Type: VaryingsMeshToPS
																		struct VaryingsMeshToPS
																		{
																			float4 positionCS : SV_POSITION;
																			float3 positionRWS; // optional
																			float4 texCoord0; // optional
																			#if UNITY_ANY_INSTANCING_ENABLED
																			uint instanceID : CUSTOM_INSTANCE_ID;
																			#endif // UNITY_ANY_INSTANCING_ENABLED
																			#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
																			FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
																			#endif // defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
																		};

																		// Generated Type: PackedVaryingsMeshToPS
																		struct PackedVaryingsMeshToPS
																		{
																			float4 positionCS : SV_POSITION; // unpacked
																			#if UNITY_ANY_INSTANCING_ENABLED
																			uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
																			#endif // conditional
																			float3 interp00 : TEXCOORD0; // auto-packed
																			float4 interp01 : TEXCOORD1; // auto-packed
																			#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
																			FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // unpacked
																			#endif // conditional
																		};

																		// Packed Type: VaryingsMeshToPS
																		PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
																		{
																			PackedVaryingsMeshToPS output = (PackedVaryingsMeshToPS)0;
																			output.positionCS = input.positionCS;
																			output.interp00.xyz = input.positionRWS;
																			output.interp01.xyzw = input.texCoord0;
																			#if UNITY_ANY_INSTANCING_ENABLED
																			output.instanceID = input.instanceID;
																			#endif // conditional
																			#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
																			output.cullFace = input.cullFace;
																			#endif // conditional
																			return output;
																		}

																		// Unpacked Type: VaryingsMeshToPS
																		VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
																		{
																			VaryingsMeshToPS output = (VaryingsMeshToPS)0;
																			output.positionCS = input.positionCS;
																			output.positionRWS = input.interp00.xyz;
																			output.texCoord0 = input.interp01.xyzw;
																			#if UNITY_ANY_INSTANCING_ENABLED
																			output.instanceID = input.instanceID;
																			#endif // conditional
																			#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
																			output.cullFace = input.cullFace;
																			#endif // conditional
																			return output;
																		}
																		// Generated Type: VaryingsMeshToDS
																		struct VaryingsMeshToDS
																		{
																			float3 positionRWS;
																			float3 normalWS;
																			#if UNITY_ANY_INSTANCING_ENABLED
																			uint instanceID : CUSTOM_INSTANCE_ID;
																			#endif // UNITY_ANY_INSTANCING_ENABLED
																		};

																		// Generated Type: PackedVaryingsMeshToDS
																		struct PackedVaryingsMeshToDS
																		{
																			#if UNITY_ANY_INSTANCING_ENABLED
																			uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
																			#endif // conditional
																			float3 interp00 : TEXCOORD0; // auto-packed
																			float3 interp01 : TEXCOORD1; // auto-packed
																		};

																		// Packed Type: VaryingsMeshToDS
																		PackedVaryingsMeshToDS PackVaryingsMeshToDS(VaryingsMeshToDS input)
																		{
																			PackedVaryingsMeshToDS output = (PackedVaryingsMeshToDS)0;
																			output.interp00.xyz = input.positionRWS;
																			output.interp01.xyz = input.normalWS;
																			#if UNITY_ANY_INSTANCING_ENABLED
																			output.instanceID = input.instanceID;
																			#endif // conditional
																			return output;
																		}

																		// Unpacked Type: VaryingsMeshToDS
																		VaryingsMeshToDS UnpackVaryingsMeshToDS(PackedVaryingsMeshToDS input)
																		{
																			VaryingsMeshToDS output = (VaryingsMeshToDS)0;
																			output.positionRWS = input.interp00.xyz;
																			output.normalWS = input.interp01.xyz;
																			#if UNITY_ANY_INSTANCING_ENABLED
																			output.instanceID = input.instanceID;
																			#endif // conditional
																			return output;
																		}
																		//-------------------------------------------------------------------------------------
																		// End Interpolator Packing And Struct Declarations
																		//-------------------------------------------------------------------------------------

																		//-------------------------------------------------------------------------------------
																		// Graph generated code
																		//-------------------------------------------------------------------------------------
																				// Shared Graph Properties (uniform inputs)
																				CBUFFER_START(UnityPerMaterial)
																				float4 Color_46CEA66D;
																				float2 Vector2_B2FA17D2;
																				float Vector1_9ED319E4;
																				float4 Color_5451798F;
																				CBUFFER_END
																				TEXTURE2D(Texture2D_241AF3EA); SAMPLER(samplerTexture2D_241AF3EA); float4 Texture2D_241AF3EA_TexelSize;
																				TEXTURE2D(Texture2D_F72EB8A8); SAMPLER(samplerTexture2D_F72EB8A8); float4 Texture2D_F72EB8A8_TexelSize;
																				TEXTURE2D(Texture2D_3CF11457); SAMPLER(samplerTexture2D_3CF11457); float4 Texture2D_3CF11457_TexelSize;
																				SAMPLER(_SampleTexture2D_BA125A02_Sampler_3_Linear_Repeat);
																				SAMPLER(_SampleTexture2D_56E80683_Sampler_3_Linear_Repeat);

																				// Pixel Graph Inputs
																					struct SurfaceDescriptionInputs
																					{
																						float3 TangentSpaceNormal; // optional
																						float3 WorldSpacePosition; // optional
																						float4 ScreenPosition; // optional
																						float4 uv0; // optional
																						float3 TimeParameters; // optional
																					};
																					// Pixel Graph Outputs
																						struct SurfaceDescription
																						{
																							float Alpha;
																							float AlphaClipThreshold;
																						};

																						// Shared Graph Node Functions

																							void Unity_Multiply_float(float A, float B, out float Out)
																							{
																								Out = A * B;
																							}

																							void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
																							{
																								Out = UV * Tiling + Offset;
																							}

																							void Unity_Add_float4(float4 A, float4 B, out float4 Out)
																							{
																								Out = A + B;
																							}

																							void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
																							{
																								Out = A * B;
																							}

																							// Pixel Graph Evaluation
																								SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
																								{
																									SurfaceDescription surface = (SurfaceDescription)0;
																									float4 _SampleTexture2D_BA125A02_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_F72EB8A8, samplerTexture2D_F72EB8A8, IN.uv0.xy);
																									float _SampleTexture2D_BA125A02_R_4 = _SampleTexture2D_BA125A02_RGBA_0.r;
																									float _SampleTexture2D_BA125A02_G_5 = _SampleTexture2D_BA125A02_RGBA_0.g;
																									float _SampleTexture2D_BA125A02_B_6 = _SampleTexture2D_BA125A02_RGBA_0.b;
																									float _SampleTexture2D_BA125A02_A_7 = _SampleTexture2D_BA125A02_RGBA_0.a;
																									float4 _ScreenPosition_140DE9D9_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
																									float2 _Property_FE000B08_Out_0 = Vector2_B2FA17D2;
																									float _Property_87B635FF_Out_0 = Vector1_9ED319E4;
																									float _Multiply_BA304D1B_Out_2;
																									Unity_Multiply_float(IN.TimeParameters.x, _Property_87B635FF_Out_0, _Multiply_BA304D1B_Out_2);
																									float2 _TilingAndOffset_51A73928_Out_3;
																									Unity_TilingAndOffset_float((_ScreenPosition_140DE9D9_Out_0.xy), _Property_FE000B08_Out_0, (_Multiply_BA304D1B_Out_2.xx), _TilingAndOffset_51A73928_Out_3);
																									float4 _SampleTexture2D_56E80683_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_241AF3EA, samplerTexture2D_241AF3EA, _TilingAndOffset_51A73928_Out_3);
																									float _SampleTexture2D_56E80683_R_4 = _SampleTexture2D_56E80683_RGBA_0.r;
																									float _SampleTexture2D_56E80683_G_5 = _SampleTexture2D_56E80683_RGBA_0.g;
																									float _SampleTexture2D_56E80683_B_6 = _SampleTexture2D_56E80683_RGBA_0.b;
																									float _SampleTexture2D_56E80683_A_7 = _SampleTexture2D_56E80683_RGBA_0.a;
																									float4 _Add_24501FC7_Out_2;
																									Unity_Add_float4(_SampleTexture2D_BA125A02_RGBA_0, _SampleTexture2D_56E80683_RGBA_0, _Add_24501FC7_Out_2);
																									float4 _Multiply_A3EB48BE_Out_2;
																									Unity_Multiply_float((_SampleTexture2D_BA125A02_A_7.xxxx), _Add_24501FC7_Out_2, _Multiply_A3EB48BE_Out_2);
																									surface.Alpha = (_Multiply_A3EB48BE_Out_2).x;
																									surface.AlphaClipThreshold = 0;
																									return surface;
																								}

																								//-------------------------------------------------------------------------------------
																								// End graph generated code
																								//-------------------------------------------------------------------------------------

																							// $include("VertexAnimation.template.hlsl")

																							//-------------------------------------------------------------------------------------
																								// TEMPLATE INCLUDE : SharedCode.template.hlsl
																								//-------------------------------------------------------------------------------------

																								#if !defined(SHADER_STAGE_RAY_TRACING)
																									FragInputs BuildFragInputs(VaryingsMeshToPS input)
																									{
																										FragInputs output;
																										ZERO_INITIALIZE(FragInputs, output);

																										// Init to some default value to make the computer quiet (else it output 'divide by zero' warning even if value is not used).
																										// TODO: this is a really poor workaround, but the variable is used in a bunch of places
																										// to compute normals which are then passed on elsewhere to compute other values...
																										output.tangentToWorld = k_identity3x3;
																										output.positionSS = input.positionCS;       // input.positionCS is SV_Position

																										output.positionRWS = input.positionRWS;
																										// output.tangentToWorld = BuildTangentToWorld(input.tangentWS, input.normalWS);
																										output.texCoord0 = input.texCoord0;
																										// output.texCoord1 = input.texCoord1;
																										// output.texCoord2 = input.texCoord2;
																										// output.texCoord3 = input.texCoord3;
																										// output.color = input.color;
																										#if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
																										output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
																										#elif SHADER_STAGE_FRAGMENT
																										output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
																										#endif // SHADER_STAGE_FRAGMENT

																										return output;
																									}
																								#endif
																									SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
																									{
																										SurfaceDescriptionInputs output;
																										ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

																										// output.WorldSpaceNormal =            input.tangentToWorld[2].xyz;	// normal was already normalized in BuildTangentToWorld()
																										// output.ObjectSpaceNormal =           normalize(mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_M));           // transposed multiplication by inverse matrix to handle normal scale
																										// output.ViewSpaceNormal =             mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_I_V);         // transposed multiplication by inverse matrix to handle normal scale
																										output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
																										// output.WorldSpaceTangent =           input.tangentToWorld[0].xyz;
																										// output.ObjectSpaceTangent =          TransformWorldToObjectDir(output.WorldSpaceTangent);
																										// output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
																										// output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
																										// output.WorldSpaceBiTangent =         input.tangentToWorld[1].xyz;
																										// output.ObjectSpaceBiTangent =        TransformWorldToObjectDir(output.WorldSpaceBiTangent);
																										// output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
																										// output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
																										// output.WorldSpaceViewDirection =     normalize(viewWS);
																										// output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
																										// output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
																										// float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
																										// output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
																										output.WorldSpacePosition = input.positionRWS;
																										// output.ObjectSpacePosition =         TransformWorldToObject(input.positionRWS);
																										// output.ViewSpacePosition =           TransformWorldToView(input.positionRWS);
																										// output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
																										// output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionRWS);
																										output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionRWS), _ProjectionParams.x);
																										output.uv0 = input.texCoord0;
																										// output.uv1 =                         input.texCoord1;
																										// output.uv2 =                         input.texCoord2;
																										// output.uv3 =                         input.texCoord3;
																										// output.VertexColor =                 input.color;
																										// output.FaceSign =                    input.isFrontFace;
																										output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value

																										return output;
																									}

																								#if !defined(SHADER_STAGE_RAY_TRACING)

																									// existing HDRP code uses the combined function to go directly from packed to frag inputs
																									FragInputs UnpackVaryingsMeshToFragInputs(PackedVaryingsMeshToPS input)
																									{
																										UNITY_SETUP_INSTANCE_ID(input);
																										VaryingsMeshToPS unpacked = UnpackVaryingsMeshToPS(input);
																										return BuildFragInputs(unpacked);
																									}
																								#endif

																									//-------------------------------------------------------------------------------------
																									// END TEMPLATE INCLUDE : SharedCode.template.hlsl
																									//-------------------------------------------------------------------------------------



																									void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData)
																									{
																										// setup defaults -- these are used if the graph doesn't output a value
																										ZERO_INITIALIZE(SurfaceData, surfaceData);
																										surfaceData.ambientOcclusion = 1.0;
																										surfaceData.specularOcclusion = 1.0; // This need to be init here to quiet the compiler in case of decal, but can be override later.

																										// copy across graph values, if defined
																										// surfaceData.baseColor =             surfaceDescription.Albedo;
																										// surfaceData.perceptualSmoothness =  surfaceDescription.Smoothness;
																										// surfaceData.ambientOcclusion =      surfaceDescription.Occlusion;
																										// surfaceData.metallic =              surfaceDescription.Metallic;
																										// surfaceData.specularColor =         surfaceDescription.Specular;

																										// These static material feature allow compile time optimization
																										surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
																								#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
																										surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
																								#endif

																										float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
																										// doubleSidedConstants = float3(-1.0, -1.0, -1.0);
																										doubleSidedConstants = float3(1.0,  1.0, -1.0);

																										// normal delivered to master node
																										float3 normalSrc = float3(0.0f, 0.0f, 1.0f);
																										// normalSrc = surfaceDescription.Normal;

																										// compute world space normal
																								#if _NORMAL_DROPOFF_TS
																										GetNormalWS(fragInputs, normalSrc, surfaceData.normalWS, doubleSidedConstants);
																								#elif _NORMAL_DROPOFF_OS
																										surfaceData.normalWS = TransformObjectToWorldNormal(normalSrc);
																								#elif _NORMAL_DROPOFF_WS
																										surfaceData.normalWS = normalSrc;
																								#endif

																										surfaceData.geomNormalWS = fragInputs.tangentToWorld[2];
																										surfaceData.tangentWS = normalize(fragInputs.tangentToWorld[0].xyz);    // The tangent is not normalize in tangentToWorld for mikkt. TODO: Check if it expected that we normalize with Morten. Tag: SURFACE_GRADIENT

																								#if HAVE_DECALS
																										if (_EnableDecals)
																										{
																											// Both uses and modifies 'surfaceData.normalWS'.
																											DecalSurfaceData decalSurfaceData = GetDecalSurfaceData(posInput, surfaceDescription.Alpha);
																											ApplyDecalToSurfaceData(decalSurfaceData, surfaceData);
																										}
																								#endif

																										surfaceData.tangentWS = Orthonormalize(surfaceData.tangentWS, surfaceData.normalWS);

																								#ifdef DEBUG_DISPLAY
																										if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
																										{
																											// TODO: need to update mip info
																											surfaceData.metallic = 0;
																										}

																										// We need to call ApplyDebugToSurfaceData after filling the surfarcedata and before filling builtinData
																										// as it can modify attribute use for static lighting
																										ApplyDebugToSurfaceData(fragInputs.tangentToWorld, surfaceData);
																								#endif

																										// By default we use the ambient occlusion with Tri-ace trick (apply outside) for specular occlusion as PBR master node don't have any option
																										surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion(ClampNdotV(dot(surfaceData.normalWS, V)), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness(surfaceData.perceptualSmoothness));
																									}

																									void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
																									{
																								#ifdef LOD_FADE_CROSSFADE // enable dithering LOD transition if user select CrossFade transition in LOD group
																										LODDitheringTransition(ComputeFadeMaskSeed(V, posInput.positionSS), unity_LODFade.x);
																								#endif

																										float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
																										// doubleSidedConstants = float3(-1.0, -1.0, -1.0);
																										doubleSidedConstants = float3(1.0,  1.0, -1.0);

																										ApplyDoubleSidedFlipOrMirror(fragInputs, doubleSidedConstants);

																										SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
																										SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);

																										// Perform alpha test very early to save performance (a killed pixel will not sample textures)
																										// TODO: split graph evaluation to grab just alpha dependencies first? tricky..
																										// DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);

																										BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData);

																										// Builtin Data
																										// For back lighting we use the oposite vertex normal
																										InitBuiltinData(posInput, surfaceDescription.Alpha, surfaceData.normalWS, -fragInputs.tangentToWorld[2], fragInputs.texCoord1, fragInputs.texCoord2, builtinData);

																										// builtinData.emissiveColor = surfaceDescription.Emission;

																										PostInitBuiltinData(V, posInput, surfaceData, builtinData);
																									}

																									//-------------------------------------------------------------------------------------
																									// Pass Includes
																									//-------------------------------------------------------------------------------------
																										#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPassDepthOnly.hlsl"
																									//-------------------------------------------------------------------------------------
																									// End Pass Includes
																									//-------------------------------------------------------------------------------------

																									ENDHLSL
																								}

																								Pass
																								{
																										// based on HDPBRPass.template
																										Name "Forward"
																										Tags { "LightMode" = "Forward" }

																										//-------------------------------------------------------------------------------------
																										// Render Modes (Blend, Cull, ZTest, Stencil, etc)
																										//-------------------------------------------------------------------------------------
																										Blend One OneMinusSrcAlpha, One OneMinusSrcAlpha

																										Cull Off




																										// Stencil setup
																									Stencil
																									{
																									   WriteMask 6
																									   Ref  0
																									   Comp Always
																									   Pass Replace
																									}


																										//-------------------------------------------------------------------------------------
																										// End Render Modes
																										//-------------------------------------------------------------------------------------

																										HLSLPROGRAM

																										#pragma target 4.5
																										#pragma only_renderers d3d11 playstation xboxone vulkan metal switch
																										//#pragma enable_d3d11_debug_symbols

																										#pragma multi_compile_instancing
																									#pragma instancing_options renderinglayer

																										#pragma multi_compile _ LOD_FADE_CROSSFADE

																										//-------------------------------------------------------------------------------------
																										// Graph Defines
																										//-------------------------------------------------------------------------------------
																												// Shared Graph Keywords
																											#define SHADERPASS SHADERPASS_FORWARD
																											#pragma only_renderers d3d11 playstation xboxone vulkan metal switch
																											#pragma multi_compile _ DEBUG_DISPLAY
																											#pragma multi_compile _ LIGHTMAP_ON
																											#pragma multi_compile _ DIRLIGHTMAP_COMBINED
																											#pragma multi_compile _ DYNAMICLIGHTMAP_ON
																											#pragma multi_compile _ SHADOWS_SHADOWMASK
																											#pragma multi_compile DECALS_OFF DECALS_3RT DECALS_4RT
																											#define USE_CLUSTERED_LIGHTLIST
																											#pragma multi_compile SHADOW_LOW SHADOW_MEDIUM SHADOW_HIGH
																											#define RAYTRACING_SHADER_GRAPH_HIGH
																											// ACTIVE FIELDS:
																											//   DoubleSided
																											//   DoubleSided.Mirror
																											//   FragInputs.isFrontFace
																											//   features.NormalDropOffTS
																											//   SurfaceType.Transparent
																											//   BlendMode.Alpha
																											//   AlphaFog
																											//   SurfaceDescriptionInputs.ScreenPosition
																											//   SurfaceDescriptionInputs.WorldSpaceNormal
																											//   SurfaceDescriptionInputs.TangentSpaceNormal
																											//   SurfaceDescriptionInputs.WorldSpaceViewDirection
																											//   SurfaceDescriptionInputs.uv0
																											//   SurfaceDescriptionInputs.TimeParameters
																											//   VertexDescriptionInputs.ObjectSpaceNormal
																											//   VertexDescriptionInputs.ObjectSpaceTangent
																											//   VertexDescriptionInputs.ObjectSpacePosition
																											//   SurfaceDescription.Albedo
																											//   SurfaceDescription.Normal
																											//   SurfaceDescription.Metallic
																											//   SurfaceDescription.Emission
																											//   SurfaceDescription.Smoothness
																											//   SurfaceDescription.Occlusion
																											//   SurfaceDescription.Alpha
																											//   SurfaceDescription.AlphaClipThreshold
																											//   FragInputs.tangentToWorld
																											//   FragInputs.positionRWS
																											//   FragInputs.texCoord1
																											//   FragInputs.texCoord2
																											//   VaryingsMeshToPS.cullFace
																											//   SurfaceDescriptionInputs.WorldSpacePosition
																											//   FragInputs.texCoord0
																											//   AttributesMesh.normalOS
																											//   AttributesMesh.tangentOS
																											//   AttributesMesh.positionOS
																											//   VaryingsMeshToPS.tangentWS
																											//   VaryingsMeshToPS.normalWS
																											//   VaryingsMeshToPS.positionRWS
																											//   VaryingsMeshToPS.texCoord1
																											//   VaryingsMeshToPS.texCoord2
																											//   VaryingsMeshToPS.texCoord0
																											//   AttributesMesh.uv1
																											//   AttributesMesh.uv2
																											//   AttributesMesh.uv0
																										//-------------------------------------------------------------------------------------
																										// End Defines
																										//-------------------------------------------------------------------------------------

																										//-------------------------------------------------------------------------------------
																										// Variant Definitions (active field translations to HDRP defines)
																										//-------------------------------------------------------------------------------------

																										// #define _MATERIAL_FEATURE_SPECULAR_COLOR 1
																										#define _SURFACE_TYPE_TRANSPARENT 1
																										#define _BLENDMODE_ALPHA 1
																										// #define _BLENDMODE_ADD 1
																										// #define _BLENDMODE_PRE_MULTIPLY 1
																										#define _DOUBLESIDED_ON 1
																										#define _NORMAL_DROPOFF_TS	1
																										// #define _NORMAL_DROPOFF_OS	1
																										// #define _NORMAL_DROPOFF_WS	1

																										//-------------------------------------------------------------------------------------
																										// End Variant Definitions
																										//-------------------------------------------------------------------------------------

																										#pragma vertex Vert
																										#pragma fragment Frag

																										#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"

																										#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"

																										// define FragInputs structure
																										#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
																										#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"

																										//-------------------------------------------------------------------------------------
																										// Active Field Defines
																										//-------------------------------------------------------------------------------------

																										// this translates the new dependency tracker into the old preprocessor definitions for the existing HDRP shader code
																										#define ATTRIBUTES_NEED_NORMAL
																										#define ATTRIBUTES_NEED_TANGENT
																										#define ATTRIBUTES_NEED_TEXCOORD0
																										#define ATTRIBUTES_NEED_TEXCOORD1
																										#define ATTRIBUTES_NEED_TEXCOORD2
																										// #define ATTRIBUTES_NEED_TEXCOORD3
																										// #define ATTRIBUTES_NEED_COLOR
																										#define VARYINGS_NEED_POSITION_WS
																										#define VARYINGS_NEED_TANGENT_TO_WORLD
																										#define VARYINGS_NEED_TEXCOORD0
																										#define VARYINGS_NEED_TEXCOORD1
																										#define VARYINGS_NEED_TEXCOORD2
																										// #define VARYINGS_NEED_TEXCOORD3
																										// #define VARYINGS_NEED_COLOR
																										#define VARYINGS_NEED_CULLFACE
																										// #define HAVE_MESH_MODIFICATION

																										//-------------------------------------------------------------------------------------
																										// End Defines
																										//-------------------------------------------------------------------------------------


																										#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
																										#ifdef DEBUG_DISPLAY
																											#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
																										#endif

																										#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"

																									#if (SHADERPASS == SHADERPASS_FORWARD)
																										#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Lighting.hlsl"

																										#define HAS_LIGHTLOOP

																										#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
																										#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
																										#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoop.hlsl"
																									#else
																										#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
																									#endif

																										#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
																										#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
																										#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
																										#include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
																										#include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"

																										//Used by SceneSelectionPass
																										int _ObjectId;
																										int _PassValue;

																										//-------------------------------------------------------------------------------------
																										// Interpolator Packing And Struct Declarations
																										//-------------------------------------------------------------------------------------
																										// Generated Type: AttributesMesh
																										struct AttributesMesh
																										{
																											float3 positionOS : POSITION;
																											float3 normalOS : NORMAL; // optional
																											float4 tangentOS : TANGENT; // optional
																											float4 uv0 : TEXCOORD0; // optional
																											float4 uv1 : TEXCOORD1; // optional
																											float4 uv2 : TEXCOORD2; // optional
																											#if UNITY_ANY_INSTANCING_ENABLED
																											uint instanceID : INSTANCEID_SEMANTIC;
																											#endif // UNITY_ANY_INSTANCING_ENABLED
																										};
																										// Generated Type: VaryingsMeshToPS
																										struct VaryingsMeshToPS
																										{
																											float4 positionCS : SV_POSITION;
																											float3 positionRWS; // optional
																											float3 normalWS; // optional
																											float4 tangentWS; // optional
																											float4 texCoord0; // optional
																											float4 texCoord1; // optional
																											float4 texCoord2; // optional
																											#if UNITY_ANY_INSTANCING_ENABLED
																											uint instanceID : CUSTOM_INSTANCE_ID;
																											#endif // UNITY_ANY_INSTANCING_ENABLED
																											#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
																											FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
																											#endif // defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
																										};

																										// Generated Type: PackedVaryingsMeshToPS
																										struct PackedVaryingsMeshToPS
																										{
																											float4 positionCS : SV_POSITION; // unpacked
																											#if UNITY_ANY_INSTANCING_ENABLED
																											uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
																											#endif // conditional
																											float3 interp00 : TEXCOORD0; // auto-packed
																											float3 interp01 : TEXCOORD1; // auto-packed
																											float4 interp02 : TEXCOORD2; // auto-packed
																											float4 interp03 : TEXCOORD3; // auto-packed
																											float4 interp04 : TEXCOORD4; // auto-packed
																											float4 interp05 : TEXCOORD5; // auto-packed
																											#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
																											FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // unpacked
																											#endif // conditional
																										};

																										// Packed Type: VaryingsMeshToPS
																										PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
																										{
																											PackedVaryingsMeshToPS output = (PackedVaryingsMeshToPS)0;
																											output.positionCS = input.positionCS;
																											output.interp00.xyz = input.positionRWS;
																											output.interp01.xyz = input.normalWS;
																											output.interp02.xyzw = input.tangentWS;
																											output.interp03.xyzw = input.texCoord0;
																											output.interp04.xyzw = input.texCoord1;
																											output.interp05.xyzw = input.texCoord2;
																											#if UNITY_ANY_INSTANCING_ENABLED
																											output.instanceID = input.instanceID;
																											#endif // conditional
																											#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
																											output.cullFace = input.cullFace;
																											#endif // conditional
																											return output;
																										}

																										// Unpacked Type: VaryingsMeshToPS
																										VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
																										{
																											VaryingsMeshToPS output = (VaryingsMeshToPS)0;
																											output.positionCS = input.positionCS;
																											output.positionRWS = input.interp00.xyz;
																											output.normalWS = input.interp01.xyz;
																											output.tangentWS = input.interp02.xyzw;
																											output.texCoord0 = input.interp03.xyzw;
																											output.texCoord1 = input.interp04.xyzw;
																											output.texCoord2 = input.interp05.xyzw;
																											#if UNITY_ANY_INSTANCING_ENABLED
																											output.instanceID = input.instanceID;
																											#endif // conditional
																											#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
																											output.cullFace = input.cullFace;
																											#endif // conditional
																											return output;
																										}
																										// Generated Type: VaryingsMeshToDS
																										struct VaryingsMeshToDS
																										{
																											float3 positionRWS;
																											float3 normalWS;
																											#if UNITY_ANY_INSTANCING_ENABLED
																											uint instanceID : CUSTOM_INSTANCE_ID;
																											#endif // UNITY_ANY_INSTANCING_ENABLED
																										};

																										// Generated Type: PackedVaryingsMeshToDS
																										struct PackedVaryingsMeshToDS
																										{
																											#if UNITY_ANY_INSTANCING_ENABLED
																											uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
																											#endif // conditional
																											float3 interp00 : TEXCOORD0; // auto-packed
																											float3 interp01 : TEXCOORD1; // auto-packed
																										};

																										// Packed Type: VaryingsMeshToDS
																										PackedVaryingsMeshToDS PackVaryingsMeshToDS(VaryingsMeshToDS input)
																										{
																											PackedVaryingsMeshToDS output = (PackedVaryingsMeshToDS)0;
																											output.interp00.xyz = input.positionRWS;
																											output.interp01.xyz = input.normalWS;
																											#if UNITY_ANY_INSTANCING_ENABLED
																											output.instanceID = input.instanceID;
																											#endif // conditional
																											return output;
																										}

																										// Unpacked Type: VaryingsMeshToDS
																										VaryingsMeshToDS UnpackVaryingsMeshToDS(PackedVaryingsMeshToDS input)
																										{
																											VaryingsMeshToDS output = (VaryingsMeshToDS)0;
																											output.positionRWS = input.interp00.xyz;
																											output.normalWS = input.interp01.xyz;
																											#if UNITY_ANY_INSTANCING_ENABLED
																											output.instanceID = input.instanceID;
																											#endif // conditional
																											return output;
																										}
																										//-------------------------------------------------------------------------------------
																										// End Interpolator Packing And Struct Declarations
																										//-------------------------------------------------------------------------------------

																										//-------------------------------------------------------------------------------------
																										// Graph generated code
																										//-------------------------------------------------------------------------------------
																												// Shared Graph Properties (uniform inputs)
																												CBUFFER_START(UnityPerMaterial)
																												float4 Color_46CEA66D;
																												float2 Vector2_B2FA17D2;
																												float Vector1_9ED319E4;
																												float4 Color_5451798F;
																												CBUFFER_END
																												TEXTURE2D(Texture2D_241AF3EA); SAMPLER(samplerTexture2D_241AF3EA); float4 Texture2D_241AF3EA_TexelSize;
																												TEXTURE2D(Texture2D_F72EB8A8); SAMPLER(samplerTexture2D_F72EB8A8); float4 Texture2D_F72EB8A8_TexelSize;
																												TEXTURE2D(Texture2D_3CF11457); SAMPLER(samplerTexture2D_3CF11457); float4 Texture2D_3CF11457_TexelSize;
																												SAMPLER(_SampleTexture2D_BA125A02_Sampler_3_Linear_Repeat);
																												SAMPLER(_SampleTexture2D_56E80683_Sampler_3_Linear_Repeat);

																												// Pixel Graph Inputs
																													struct SurfaceDescriptionInputs
																													{
																														float3 WorldSpaceNormal; // optional
																														float3 TangentSpaceNormal; // optional
																														float3 WorldSpaceViewDirection; // optional
																														float3 WorldSpacePosition; // optional
																														float4 ScreenPosition; // optional
																														float4 uv0; // optional
																														float3 TimeParameters; // optional
																													};
																													// Pixel Graph Outputs
																														struct SurfaceDescription
																														{
																															float3 Albedo;
																															float3 Normal;
																															float Metallic;
																															float3 Emission;
																															float Smoothness;
																															float Occlusion;
																															float Alpha;
																															float AlphaClipThreshold;
																														};

																														// Shared Graph Node Functions

																															void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
																															{
																																Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
																															}

																															void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
																															{
																																Out = A * B;
																															}

																															void Unity_Multiply_float(float A, float B, out float Out)
																															{
																																Out = A * B;
																															}

																															void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
																															{
																																Out = UV * Tiling + Offset;
																															}

																															void Unity_OneMinus_float4(float4 In, out float4 Out)
																															{
																																Out = 1 - In;
																															}

																															void Unity_Add_float4(float4 A, float4 B, out float4 Out)
																															{
																																Out = A + B;
																															}

																															void Unity_RandomRange_float(float2 Seed, float Min, float Max, out float Out)
																															{
																																 float randomno = frac(sin(dot(Seed, float2(12.9898, 78.233)))*43758.5453);
																																 Out = lerp(Min, Max, randomno);
																															}

																															void Unity_Comparison_Greater_float(float A, float B, out float Out)
																															{
																																Out = A > B ? 1 : 0;
																															}

																															void Unity_Branch_float(float Predicate, float True, float False, out float Out)
																															{
																																Out = Predicate ? True : False;
																															}

																															// Pixel Graph Evaluation
																																SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
																																{
																																	SurfaceDescription surface = (SurfaceDescription)0;
																																	float4 _SampleTexture2D_BA125A02_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_F72EB8A8, samplerTexture2D_F72EB8A8, IN.uv0.xy);
																																	float _SampleTexture2D_BA125A02_R_4 = _SampleTexture2D_BA125A02_RGBA_0.r;
																																	float _SampleTexture2D_BA125A02_G_5 = _SampleTexture2D_BA125A02_RGBA_0.g;
																																	float _SampleTexture2D_BA125A02_B_6 = _SampleTexture2D_BA125A02_RGBA_0.b;
																																	float _SampleTexture2D_BA125A02_A_7 = _SampleTexture2D_BA125A02_RGBA_0.a;
																																	float4 _Property_2BA146F9_Out_0 = Color_5451798F;
																																	float _FresnelEffect_1783DBC8_Out_3;
																																	Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, 3, _FresnelEffect_1783DBC8_Out_3);
																																	float4 _Multiply_41A6FFB8_Out_2;
																																	Unity_Multiply_float(_Property_2BA146F9_Out_0, (_FresnelEffect_1783DBC8_Out_3.xxxx), _Multiply_41A6FFB8_Out_2);
																																	float4 _Property_FB158B5C_Out_0 = Color_46CEA66D;
																																	float4 _ScreenPosition_140DE9D9_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
																																	float2 _Property_FE000B08_Out_0 = Vector2_B2FA17D2;
																																	float _Property_87B635FF_Out_0 = Vector1_9ED319E4;
																																	float _Multiply_BA304D1B_Out_2;
																																	Unity_Multiply_float(IN.TimeParameters.x, _Property_87B635FF_Out_0, _Multiply_BA304D1B_Out_2);
																																	float2 _TilingAndOffset_51A73928_Out_3;
																																	Unity_TilingAndOffset_float((_ScreenPosition_140DE9D9_Out_0.xy), _Property_FE000B08_Out_0, (_Multiply_BA304D1B_Out_2.xx), _TilingAndOffset_51A73928_Out_3);
																																	float4 _SampleTexture2D_56E80683_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_241AF3EA, samplerTexture2D_241AF3EA, _TilingAndOffset_51A73928_Out_3);
																																	float _SampleTexture2D_56E80683_R_4 = _SampleTexture2D_56E80683_RGBA_0.r;
																																	float _SampleTexture2D_56E80683_G_5 = _SampleTexture2D_56E80683_RGBA_0.g;
																																	float _SampleTexture2D_56E80683_B_6 = _SampleTexture2D_56E80683_RGBA_0.b;
																																	float _SampleTexture2D_56E80683_A_7 = _SampleTexture2D_56E80683_RGBA_0.a;
																																	float4 _OneMinus_5CE264A2_Out_1;
																																	Unity_OneMinus_float4(_SampleTexture2D_56E80683_RGBA_0, _OneMinus_5CE264A2_Out_1);
																																	float4 _Multiply_3A07838F_Out_2;
																																	Unity_Multiply_float(_Property_FB158B5C_Out_0, _OneMinus_5CE264A2_Out_1, _Multiply_3A07838F_Out_2);
																																	float4 _Add_D52D51E2_Out_2;
																																	Unity_Add_float4(_Multiply_41A6FFB8_Out_2, _Multiply_3A07838F_Out_2, _Add_D52D51E2_Out_2);
																																	float _RandomRange_D3C402AD_Out_3;
																																	Unity_RandomRange_float((IN.TimeParameters.x.xx), 0, 1, _RandomRange_D3C402AD_Out_3);
																																	float _Comparison_2A79ACE2_Out_2;
																																	Unity_Comparison_Greater_float(_RandomRange_D3C402AD_Out_3, 0.9, _Comparison_2A79ACE2_Out_2);
																																	float _Branch_555CFD86_Out_3;
																																	Unity_Branch_float(_Comparison_2A79ACE2_Out_2, 1, 0.8, _Branch_555CFD86_Out_3);
																																	float4 _Multiply_3CF6A289_Out_2;
																																	Unity_Multiply_float(_Add_D52D51E2_Out_2, (_Branch_555CFD86_Out_3.xxxx), _Multiply_3CF6A289_Out_2);
																																	float4 _Add_E56C841_Out_2;
																																	Unity_Add_float4(_SampleTexture2D_BA125A02_RGBA_0, _Multiply_3CF6A289_Out_2, _Add_E56C841_Out_2);
																																	float4 _Add_24501FC7_Out_2;
																																	Unity_Add_float4(_SampleTexture2D_BA125A02_RGBA_0, _SampleTexture2D_56E80683_RGBA_0, _Add_24501FC7_Out_2);
																																	float4 _Multiply_A3EB48BE_Out_2;
																																	Unity_Multiply_float((_SampleTexture2D_BA125A02_A_7.xxxx), _Add_24501FC7_Out_2, _Multiply_A3EB48BE_Out_2);
																																	surface.Albedo = (_SampleTexture2D_BA125A02_RGBA_0.xyz);
																																	surface.Normal = IN.TangentSpaceNormal;
																																	surface.Metallic = 0;
																																	surface.Emission = (_Add_E56C841_Out_2.xyz);
																																	surface.Smoothness = 0.5;
																																	surface.Occlusion = 1;
																																	surface.Alpha = (_Multiply_A3EB48BE_Out_2).x;
																																	surface.AlphaClipThreshold = 0;
																																	return surface;
																																}

																																//-------------------------------------------------------------------------------------
																																// End graph generated code
																																//-------------------------------------------------------------------------------------

																															// $include("VertexAnimation.template.hlsl")

																															//-------------------------------------------------------------------------------------
																																// TEMPLATE INCLUDE : SharedCode.template.hlsl
																																//-------------------------------------------------------------------------------------

																																#if !defined(SHADER_STAGE_RAY_TRACING)
																																	FragInputs BuildFragInputs(VaryingsMeshToPS input)
																																	{
																																		FragInputs output;
																																		ZERO_INITIALIZE(FragInputs, output);

																																		// Init to some default value to make the computer quiet (else it output 'divide by zero' warning even if value is not used).
																																		// TODO: this is a really poor workaround, but the variable is used in a bunch of places
																																		// to compute normals which are then passed on elsewhere to compute other values...
																																		output.tangentToWorld = k_identity3x3;
																																		output.positionSS = input.positionCS;       // input.positionCS is SV_Position

																																		output.positionRWS = input.positionRWS;
																																		output.tangentToWorld = BuildTangentToWorld(input.tangentWS, input.normalWS);
																																		output.texCoord0 = input.texCoord0;
																																		output.texCoord1 = input.texCoord1;
																																		output.texCoord2 = input.texCoord2;
																																		// output.texCoord3 = input.texCoord3;
																																		// output.color = input.color;
																																		#if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
																																		output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
																																		#elif SHADER_STAGE_FRAGMENT
																																		output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
																																		#endif // SHADER_STAGE_FRAGMENT

																																		return output;
																																	}
																																#endif
																																	SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
																																	{
																																		SurfaceDescriptionInputs output;
																																		ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

																																		output.WorldSpaceNormal = input.tangentToWorld[2].xyz;	// normal was already normalized in BuildTangentToWorld()
																																		// output.ObjectSpaceNormal =           normalize(mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_M));           // transposed multiplication by inverse matrix to handle normal scale
																																		// output.ViewSpaceNormal =             mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_I_V);         // transposed multiplication by inverse matrix to handle normal scale
																																		output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
																																		// output.WorldSpaceTangent =           input.tangentToWorld[0].xyz;
																																		// output.ObjectSpaceTangent =          TransformWorldToObjectDir(output.WorldSpaceTangent);
																																		// output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
																																		// output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
																																		// output.WorldSpaceBiTangent =         input.tangentToWorld[1].xyz;
																																		// output.ObjectSpaceBiTangent =        TransformWorldToObjectDir(output.WorldSpaceBiTangent);
																																		// output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
																																		// output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
																																		output.WorldSpaceViewDirection = normalize(viewWS);
																																		// output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
																																		// output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
																																		// float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
																																		// output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
																																		output.WorldSpacePosition = input.positionRWS;
																																		// output.ObjectSpacePosition =         TransformWorldToObject(input.positionRWS);
																																		// output.ViewSpacePosition =           TransformWorldToView(input.positionRWS);
																																		// output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
																																		// output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionRWS);
																																		output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionRWS), _ProjectionParams.x);
																																		output.uv0 = input.texCoord0;
																																		// output.uv1 =                         input.texCoord1;
																																		// output.uv2 =                         input.texCoord2;
																																		// output.uv3 =                         input.texCoord3;
																																		// output.VertexColor =                 input.color;
																																		// output.FaceSign =                    input.isFrontFace;
																																		output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value

																																		return output;
																																	}

																																#if !defined(SHADER_STAGE_RAY_TRACING)

																																	// existing HDRP code uses the combined function to go directly from packed to frag inputs
																																	FragInputs UnpackVaryingsMeshToFragInputs(PackedVaryingsMeshToPS input)
																																	{
																																		UNITY_SETUP_INSTANCE_ID(input);
																																		VaryingsMeshToPS unpacked = UnpackVaryingsMeshToPS(input);
																																		return BuildFragInputs(unpacked);
																																	}
																																#endif

																																	//-------------------------------------------------------------------------------------
																																	// END TEMPLATE INCLUDE : SharedCode.template.hlsl
																																	//-------------------------------------------------------------------------------------



																																	void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData)
																																	{
																																		// setup defaults -- these are used if the graph doesn't output a value
																																		ZERO_INITIALIZE(SurfaceData, surfaceData);
																																		surfaceData.ambientOcclusion = 1.0;
																																		surfaceData.specularOcclusion = 1.0; // This need to be init here to quiet the compiler in case of decal, but can be override later.

																																		// copy across graph values, if defined
																																		surfaceData.baseColor = surfaceDescription.Albedo;
																																		surfaceData.perceptualSmoothness = surfaceDescription.Smoothness;
																																		surfaceData.ambientOcclusion = surfaceDescription.Occlusion;
																																		surfaceData.metallic = surfaceDescription.Metallic;
																																		// surfaceData.specularColor =         surfaceDescription.Specular;

																																		// These static material feature allow compile time optimization
																																		surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
																																#ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
																																		surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
																																#endif

																																		float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
																																		// doubleSidedConstants = float3(-1.0, -1.0, -1.0);
																																		doubleSidedConstants = float3(1.0,  1.0, -1.0);

																																		// normal delivered to master node
																																		float3 normalSrc = float3(0.0f, 0.0f, 1.0f);
																																		normalSrc = surfaceDescription.Normal;

																																		// compute world space normal
																																#if _NORMAL_DROPOFF_TS
																																		GetNormalWS(fragInputs, normalSrc, surfaceData.normalWS, doubleSidedConstants);
																																#elif _NORMAL_DROPOFF_OS
																																		surfaceData.normalWS = TransformObjectToWorldNormal(normalSrc);
																																#elif _NORMAL_DROPOFF_WS
																																		surfaceData.normalWS = normalSrc;
																																#endif

																																		surfaceData.geomNormalWS = fragInputs.tangentToWorld[2];
																																		surfaceData.tangentWS = normalize(fragInputs.tangentToWorld[0].xyz);    // The tangent is not normalize in tangentToWorld for mikkt. TODO: Check if it expected that we normalize with Morten. Tag: SURFACE_GRADIENT

																																#if HAVE_DECALS
																																		if (_EnableDecals)
																																		{
																																			// Both uses and modifies 'surfaceData.normalWS'.
																																			DecalSurfaceData decalSurfaceData = GetDecalSurfaceData(posInput, surfaceDescription.Alpha);
																																			ApplyDecalToSurfaceData(decalSurfaceData, surfaceData);
																																		}
																																#endif

																																		surfaceData.tangentWS = Orthonormalize(surfaceData.tangentWS, surfaceData.normalWS);

																																#ifdef DEBUG_DISPLAY
																																		if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
																																		{
																																			// TODO: need to update mip info
																																			surfaceData.metallic = 0;
																																		}

																																		// We need to call ApplyDebugToSurfaceData after filling the surfarcedata and before filling builtinData
																																		// as it can modify attribute use for static lighting
																																		ApplyDebugToSurfaceData(fragInputs.tangentToWorld, surfaceData);
																																#endif

																																		// By default we use the ambient occlusion with Tri-ace trick (apply outside) for specular occlusion as PBR master node don't have any option
																																		surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion(ClampNdotV(dot(surfaceData.normalWS, V)), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness(surfaceData.perceptualSmoothness));
																																	}

																																	void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
																																	{
																																#ifdef LOD_FADE_CROSSFADE // enable dithering LOD transition if user select CrossFade transition in LOD group
																																		LODDitheringTransition(ComputeFadeMaskSeed(V, posInput.positionSS), unity_LODFade.x);
																																#endif

																																		float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
																																		// doubleSidedConstants = float3(-1.0, -1.0, -1.0);
																																		doubleSidedConstants = float3(1.0,  1.0, -1.0);

																																		ApplyDoubleSidedFlipOrMirror(fragInputs, doubleSidedConstants);

																																		SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
																																		SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);

																																		// Perform alpha test very early to save performance (a killed pixel will not sample textures)
																																		// TODO: split graph evaluation to grab just alpha dependencies first? tricky..
																																		// DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);

																																		BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData);

																																		// Builtin Data
																																		// For back lighting we use the oposite vertex normal
																																		InitBuiltinData(posInput, surfaceDescription.Alpha, surfaceData.normalWS, -fragInputs.tangentToWorld[2], fragInputs.texCoord1, fragInputs.texCoord2, builtinData);

																																		builtinData.emissiveColor = surfaceDescription.Emission;

																																		PostInitBuiltinData(V, posInput, surfaceData, builtinData);
																																	}

																																	//-------------------------------------------------------------------------------------
																																	// Pass Includes
																																	//-------------------------------------------------------------------------------------
																																		#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPassForward.hlsl"
																																	//-------------------------------------------------------------------------------------
																																	// End Pass Includes
																																	//-------------------------------------------------------------------------------------

																																	ENDHLSL
																																}

	}
		CustomEditor "UnityEditor.Rendering.HighDefinition.HDPBRLitGUI"
																																		FallBack "Hidden/Shader Graph/FallbackError"
}
