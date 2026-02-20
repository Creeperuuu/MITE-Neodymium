#version 120

#ifdef RPLE
varying vec2 BTexCoordR;
varying vec2 BTexCoordG;
varying vec2 BTexCoordB;
#else
varying vec2 BTexCoord;
#endif

varying vec2 TexCoord;
varying vec4 Color;
varying vec4 Viewport;
varying vec4 FogColor;
varying vec2 FogStartEnd;
varying float FogFactor;

uniform sampler2D atlas;

#ifdef RPLE
uniform sampler2D lightTexR;
uniform sampler2D lightTexG;
uniform sampler2D lightTexB;
#else
uniform sampler2D lightTex;
#endif

void main()
{
    vec4 texColor = texture2D(atlas, TexCoord
#ifdef SHORT_UV
        / 32768.0
#endif
    );

    vec4 colorMult = Color / 256.0;

    vec4 lightyColor =
#ifdef RPLE
        texture2D(lightTexR, (BTexCoordR + 32767.0) / 65535.0) *
        texture2D(lightTexG, (BTexCoordG + 32767.0) / 65535.0) *
        texture2D(lightTexB, (BTexCoordB + 32767.0) / 65535.0);
#else
        texture2D(lightTex, (BTexCoord + 8.0) / 256.0);
#endif

    vec4 rasterColor =
#ifdef PASS_0
        vec4((texColor.xyz * colorMult.xyz) * lightyColor.xyz, texColor.w);
#else
        (texColor * colorMult) * lightyColor;
#endif

#ifdef RENDER_FOG
    gl_FragColor = vec4(mix(FogColor.xyz, rasterColor.xyz, FogFactor), rasterColor.w);
#else
    gl_FragColor = rasterColor;
#endif
}