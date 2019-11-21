#version 410

uniform vec3 bDim, posPuits;
uniform float temps, dt, tempsDeVieMax, gravite;

layout(location=6) in vec3 position;
layout(location=7) in vec4 couleur;
layout(location=8) in vec3 vitesse;
layout(location=9) in float tempsDeVieRestant;

out vec3 positionMod;
out vec4 couleurMod;
out vec3 vitesseMod;
out float tempsDeVieRestantMod;

uint randhash( uint seed )
{
    uint i=(seed^12345391u)*2654435769u;
    i ^= (i<<6u)^(i>>26u);
    i *= 2654435769u;
    i += (i<<5u)^(i>>12u);
    return i;
}
float myrandom( uint seed )
{
    const float UINT_MAX = 4294967295.0;
    return float(randhash(seed)) / UINT_MAX;
}

void main( void )
{
    if ( tempsDeVieRestant <= 0.0 )
    {
        uint seed = uint(temps * 1000.0) + uint(gl_VertexID);

        positionMod = posPuits;

        vitesseMod = vec3( mix( -0.5, 0.5, myrandom(seed++) ), 
                           mix( -0.5, 0.5, myrandom(seed++) ),
                           mix(  0.5, 1.0, myrandom(seed++) ) ); 

        tempsDeVieRestantMod = mix(0.0, tempsDeVieMax, myrandom(seed++));

        const float COULMIN = 0.2;
        const float COULMAX = 0.9;
        couleurMod = vec4( mix( COULMIN, COULMAX, myrandom(seed++) ),
                           mix( COULMIN, COULMAX, myrandom(seed++) ),
                           mix( COULMIN, COULMAX, myrandom(seed++) ),
                           1.0 );
    }
    else
    {
        positionMod = position + dt * vitesse;
        vitesseMod = vitesse;

        tempsDeVieRestantMod = tempsDeVieRestant - dt;

        couleurMod = couleur;

        vec3 posSphUnitaire = positionMod / bDim;
        vec3 vitSphUnitaire = vitesseMod * bDim;

        float  dist = length( posSphUnitaire );
        if ( dist  >= 1.0 )
        {
            positionMod = ( 2.0 - dist ) * positionMod;
            vec3 N = posSphUnitaire / dist;
            vec3 vitReflechieSphUnitaire = reflect( vitSphUnitaire , N );
            vitesseMod = vitReflechieSphUnitaire / bDim;
        }

        vitesseMod.z = vitesse.z - gravite*dt;
		if (positionMod.z <= posPuits.z)
		{
            vitesseMod.z *= -1;
		}
    }
}
