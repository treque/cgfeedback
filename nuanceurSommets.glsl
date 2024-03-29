#version 410

uniform mat4 matrModel;
uniform mat4 matrVisu;
uniform mat4 matrProj;

uniform float pointsize;

layout(location=0) in vec4 Vertex;
layout(location=3) in vec4 Color;
layout(location=4) in vec3 vitesse;
layout(location=5) in float tempsDeVieRestant;

out Attribs {
    vec4 couleur;
    float tempsDeVieRestant;
    float sens; // du vol
} AttribsOut;

void main( void )
{
    // transformation standard du sommet
    gl_Position = matrVisu * matrModel * Vertex;

    AttribsOut.tempsDeVieRestant = tempsDeVieRestant;

    // couleur du sommet
    AttribsOut.couleur = Color;

    // assigner la taille des points (en pixels)
    gl_PointSize = pointsize;

	AttribsOut.sens = sign(vitesse.x);
}
