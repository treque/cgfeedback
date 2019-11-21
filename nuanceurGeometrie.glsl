#version 410

uniform mat4 matrProj;
uniform int texnumero;

layout(points) in;
layout(triangle_strip, max_vertices = 4) out;

in Attribs {
    vec4 couleur;
    float tempsDeVieRestant;
    float sens;
} AttribsIn[];

out Attribs {
    vec4 couleur;
	vec2 texCoord;
} AttribsOut;

void main()
{
    gl_PointSize = gl_in[0].gl_PointSize;
	AttribsOut.couleur = AttribsIn[0].couleur;

	vec2 coins[4];
	coins[0] = vec2(-0.5, 0.5);
	coins[1] = vec2(-0.5, -0.5);
	coins[2] = vec2(0.5, 0.5);
	coins[3] = vec2(0.5, -0.5);

	for ( int i = 0 ; i < 4 ; i++ ) 
	{
		float fact = gl_in[0].gl_PointSize / 50;
        vec2 decalage = coins[i];
		AttribsOut.texCoord = coins[i] + vec2(0.5, 0.5);

		if (texnumero == 1) // etincelle
		{
			// +lifetime -> +vitesse
			float angle = 6.0 * AttribsIn[0].tempsDeVieRestant;
			mat2 rotation = mat2( cos(angle), -sin(angle),
								  sin(angle), cos(angle));
			decalage = rotation * decalage;
		}
		else if (texnumero == 2) // oiseau
		{
			// quelle ieme sous-texture pour diviser. +lifetime -> +battement
			int num = int( mod( 18.0 * AttribsIn[0].tempsDeVieRestant , 16.0 ) );
			// comme un atlas de texture?
			AttribsOut.texCoord.x = ( AttribsOut.texCoord.x + num ) / 16.0;
            if(texnumero == 2 && AttribsIn[0].sens < 0.0) 
			{	
				// s'il se deplace a droite ou a gauche.. inverser les coord en x
				// le sens depend de la vitesse en x tel qu'etabli dans le vertex shader
                AttribsOut.texCoord.x *= -1;
            }
		}

		vec4 pos =  vec4( gl_in[0].gl_Position.xy + fact * decalage, gl_in[0].gl_Position.zw );
		gl_Position = matrProj * pos;
		EmitVertex();
	}
}
