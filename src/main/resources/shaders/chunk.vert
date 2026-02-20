#version 120

/* ========= ATTRIBUTES ========= */
attribute vec3 POS;
attribute vec2 TEXTURE;
attribute vec4 COLOR;
attribute float ENTITY_DATA_1;
attribute vec2 BRIGHTNESS;
attribute vec3 NORMAL;
attribute vec2 MIDTEXTURE;

/* ========= UNIFORMS ========= */
uniform mat4 modelView;
uniform mat4 proj;
uniform vec4 viewport;
uniform vec4 fogColor;
uniform vec2 fogStartEnd;
uniform int fogMode;
uniform float fogDensity;
uniform vec3 renderOffset;

/* ========= VARYINGS ========= */
varying vec2 TexCoord;

#ifdef RPLE
varying vec2 BTexCoordR;
varying vec2 BTexCoordG;
varying vec2 BTexCoordB;
#else
varying vec2 BTexCoord;
#endif

varying vec4 Color;
varying vec4 Viewport;
varying vec4 FogColor;
varying vec2 FogStartEnd;
varying float FogFactor;

void main()
{
    vec4 untransformedPos =
        vec4(aPos, 1.0) +
        vec4(renderOffset.x, renderOffset.y + 0.12, renderOffset.z, 0.0);

    gl_Position = proj * modelView * untransformedPos;

    TexCoord = aTexCoord;

#ifdef RPLE
    BTexCoordR = aBTexCoordR;
    BTexCoordG = aBTexCoordG;
    BTexCoordB = aBTexCoordB;
#else
    BTexCoord = aBTexCoord;
#endif

    Color = aColor;
    Viewport = viewport;
    FogColor = fogColor;

    if (fogStartEnd.x >= 0.0 && fogStartEnd.y >= 0.0)
    {
        float s = fogStartEnd.x;
        float e = fogStartEnd.y;
        float c = length(untransformedPos.xyz);

        float fogFactor =
            (fogMode == 0x2601)
            ? clamp((e - c) / (e - s), 0.0, 1.0) /* GL_LINEAR */
            : exp(-fogDensity * c);             /* GL_EXP */

        FogFactor = fogFactor;
    }
    else
    {
        FogFactor = -1.0;
    }

    FogStartEnd = fogStartEnd;
}