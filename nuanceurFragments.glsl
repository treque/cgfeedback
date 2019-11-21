#version 410

uniform sampler2D leLutin;
uniform int texnumero;

in Attribs {
    vec4 couleur;
	vec2 texCoord;
} AttribsIn;

out vec4 FragColor;

void main( void )
{
    FragColor = AttribsIn.couleur;

	if (texnumero > 0)
	{
		vec4 couleur = texture( leLutin, AttribsIn.texCoord );
		FragColor = vec4(mix(FragColor.rgb, couleur.rgb, 0.6), couleur.a);
	}
	if (FragColor.a < 0.1) discard;
}